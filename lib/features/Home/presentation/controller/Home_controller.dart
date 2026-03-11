import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hrx/core/Location/location_config.dart';
import 'package:hrx/core/routes/route_path.dart';
import 'package:hrx/core/routes/routes.dart';
import 'package:hrx/core/utils/dev_log.dart';
import 'package:hrx/core/utils/show_toast.dart';
import 'package:hrx/dependenci__injection/init_dependencies.dart';
import 'package:hrx/features/Main/presentation/controller/shift_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart' show Logger;

import '../../../../core/local_db_helper/local_bd_isar.dart';
import '../../../Attandencee/presentation/controller/Attandencee_controller.dart';
import '../../data/models/employee_model.dart';
import '../../domain/usecase/Home_use_case.dart';
import '../../../Leave/domain/usecase/Leave_use_case.dart';
import '../../../Leave/data/models/leave_data.dart';

class HomeController extends GetxController implements GetxService {
  final HomeUseCase homeUseCase;


  HomeController({required this.homeUseCase});

  // Employee data
  final Rx<EmployeeModel?> employee = Rx<EmployeeModel?>(null);
  final isLoadingEmployee = false.obs;
  final controller = Get.put(AttandenceeController());

  @override
  void onInit() {
    super.onInit();
    loadEmployeeProfile();
    update();
    loadPendingLeaveApplications();
  }

  /// Load employee profile with cache-first strategy
  /// Saves data to Isar for offline access
  Future<void> loadEmployeeProfile() async {
    isLoadingEmployee.value = true;
    try {
      // Get logged in user's userId from Isar DB
      final user = await IsarDBHelper().getUser();

      if (user == null || user.userId == null) {
        Get.snackbar(
          'Error',
          'User not found. Please login again',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final userId = user.userId!;

      print("userId ${user.organizationId}");
      final cachedEmployee = await IsarDBHelper().getEmployeeData(userId);

      if (cachedEmployee != null) {
        Logger().w("Call cache function - showing cached data");
        // We have cached data - show it immediately (no loading)
        employee.value = cachedEmployee;

        // Refresh data in background and update cache
        final result = await homeUseCase.getEmployeeProfile(
          GetEmployeeParams(userId: userId),
        );

        result.fold(
          (failure) {
            Logger().e("Failed to refresh employee data: ${failure.message}");
          },
          (employeeData) async {
            // Save refreshed data to Isar
            try {
              await _checkAttendanceEligibility(employeeData);

              final saved = await IsarDBHelper().saveEmployeeData(employeeData);
              if (saved) {
                employee.value = employeeData;
                Logger().i("Employee data refreshed and saved successfully");
              }
            } catch (e) {
              Logger().e("Employee data refreshed and saved failed: $e");
            } finally {
              loadPendingLeaveApplications();
              Get.find<ShiftController>().getAttendanceShift();
              Get.find<AttandenceeController>().getTodayAttendance();
              update();
            }
          },
        );
      } else {
        Logger().w("Call nocache function - fetching from API");
        // No cached data - show loading
        isLoadingEmployee.value = true;

        final result = await homeUseCase.getEmployeeProfile(
          GetEmployeeParams(userId: userId),
        );
        result.fold(
          (failure) {
            isLoadingEmployee.value = false;
            // Get.snackbar(
            //   'Error',
            //   failure.message,
            //   snackPosition: SnackPosition.BOTTOM,
            // );
          },
          (employeeData) async {
            isLoadingEmployee.value = false;
            // Save to Isar for offline access
            try {
              await _checkAttendanceEligibility(employeeData);

              final saved = await IsarDBHelper().saveEmployeeData(employeeData);
              if (saved) {
                employee.value = employeeData;
                Logger().i("Employee data fetched and saved successfully");
              } else {
                // Still show the data even if saving failed
                employee.value = employeeData;
                Logger().w(
                  "Employee data fetched but failed to save to local DB",
                );
              }
            } catch (e) {
              Logger().e("Employee data refreshed and saved failed: $e");
            } finally {
              loadPendingLeaveApplications();
              Get.find<ShiftController>().getAttendanceShift();
              Get.find<AttandenceeController>().getTodayAttendance();
            }
          },
        );
      }
    } catch (e) {
      showToast(message: "Something went wrong");
      // isLoadingEmployee.value = false;
      // Get.snackbar(
      //   'Error',
      //   'Failed to load employee data: ${e.toString()}',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } finally {
      isLoadingEmployee.value = false;

    }
  }

  final isGeoAttendance = false.obs;
  final distanceRadius = RxnDouble();
  Future<void> _checkAttendanceEligibility(EmployeeModel? emp) async {
    isGeoAttendance.value = false;
    distanceRadius.value = null;

    devLog(
      tag: "GEO FENCE",
      payload: {"is_geo_attendance": isGeoAttendance.value},
    );

    if (emp == null || emp.isGeoEnable != true) {
      isGeoAttendance.value = false;
      return;
    } else {
      isGeoAttendance.value = true;
    }

    final lat = double.parse(emp.latitude ?? "0");
    final lon = double.parse(emp.longitude ?? "0");

    ///get location distance
    final location = await serviceLocator<LocationConfig>().findNearestLocation(
      lat: lat,
      lon: lon,
    );
    distanceRadius.value = location?['distance']; //set distance

    isGeoAttendance.value = emp.outsideFenceAction?.toUpperCase() == "BLOCK_ATTENDANCE";

    devLog(
      tag: "GEO FENCE",
      payload: {"is_geo_attendance": isGeoAttendance.value, ...?location},
    );
  }

  /// Load pending leave applications for approval
  final RxList<LeaveData> pendingLeaveApplications = <LeaveData>[].obs;
  final isLoadingLeaveApplications = false.obs;
  Future<void> loadPendingLeaveApplications({String status = "PENDING"}) async {
    isLoadingLeaveApplications.value = true;
    pendingLeaveApplications.clear();

    try {
      // Get logged in user's userId from Isar DB
      final user = await IsarDBHelper().getUser();

      // Fetch leave applications where current user is the approver and status is PENDING
      final result = await leaveUseCase.getLeaveList(
        GetLeaveParams(query: {'approver_id': user?.userId, 'status': status}),
      );

      result.fold(
        (failure) {
          Logger().e('Failed to load leave applications: ${failure.message}');
        },
        (response) {
          if (response.data != null) {
            pendingLeaveApplications.assignAll(response.data?.data ?? []);
          }
        },
      );
    } catch (e) {
      Logger().e('Error loading leave applications: ${e.toString()}');
    } finally {
      isLoadingLeaveApplications.value = false;
    }
  }

  final approvingLeaveId = ''.obs;

  /// Approve a leave application
  Future<void> approveLeaveApplication(
    String leaveId,
    String approverId,
    String comment,
    BuildContext context,
  ) async {
    try {
      // isProcessingLeaveAction.value = true;
      approvingLeaveId.value = leaveId;
      final result = await leaveUseCase.approveLeave(
        GetLeaveParams(
          path: leaveId,
          body: {'approver_id': approverId, 'comment': comment},
        ),
      );

      // isProcessingLeaveAction.value = false;
      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (response) {
          Get.snackbar(
            'Success',
            'Leave application approved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          context.pop();
          loadPendingLeaveApplications();
        },
      );
    } catch (e) {
      // isProcessingLeaveAction.value = false;
      Get.snackbar(
        'Error',
        'Failed to approve leave: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      approvingLeaveId.value = '';
    }
  }

  /// Reject a leave application
  final rejectingLeaveId = ''.obs;
  Future<void> rejectLeaveApplication(
    String leaveId,
    String approverId,
    String comment,
    BuildContext context,
  ) async {
    try {
      // isProcessingLeaveAction.value = true;
      rejectingLeaveId.value = leaveId;
      final result = await leaveUseCase.rejectLeave(
        GetLeaveParams(
          path: leaveId,
          body: {'approver_id': approverId, 'comment': comment},
        ),
      );

      // isProcessingLeaveAction.value = false;
      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (response) {
          Get.snackbar(
            'Success',
            'Leave application rejected successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          context.pop();
          loadPendingLeaveApplications();
        },
      );
    } catch (e) {
      // isProcessingLeaveAction.value = false;
      Get.snackbar(
        'Error',
        'Failed to reject leave: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      rejectingLeaveId.value = '';
    }
  }
  /// edit profiles

  final formKey = GlobalKey<FormState>();

  /// Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  /// Country Code
  final selectedCountryCode = '+88'.obs;

  /// Image
  final profileImage = Rx<File?>(null);
  final ImagePicker picker = ImagePicker();
  
  final uploadedImageUrl = RxnString(); // network url after upload
  final isUploading = false.obs;
  final attachmentUrls = <String>[].obs;
  final uploadingImages = <String>[].obs;

  ///---------------------------------upload image
  Future<String?> uploadImage(File file) async {
    try {
      uploadingImages.add(file.path); // mark uploading
      isUploading.value = true;

      final response = await homeUseCase.uploadImage(file);

      return response.fold(
            (failure) {
          uploadingImages.remove(file.path);
          isUploading.value = false;
          // showToast(message: failure.message);  //no need already manage globally
          return null;
        },
            (success) {
          uploadingImages.remove(file.path);
          isUploading.value = false;

          if (success.imageUrl != null) {
            uploadedImageUrl.value = success.imageUrl!;
            attachmentUrls.add(success.imageUrl!);

            showToast(message: "Image uploaded successfully", isError: false);
          }

          return success.imageUrl;
        },
      );
    } catch (e) {
      uploadingImages.remove(file.path);
      isUploading.value = false;

      showToast(message: "Failed to upload image");
      return null;
    }
  }
  /// Save
  final isUpdatingProfile = false.obs;
  
  Future<void> updateUserProfile(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isUpdatingProfile.value = true;
    
    try {
      final user = await IsarDBHelper().getUser();
      
      if (user == null || user.userId == null) {
        showToast(message: 'User not found. Please login again');
        isUpdatingProfile.value = false;
        return;
      }

      // Use uploaded image URL if available, otherwise use existing photo
      final photoUrl = uploadedImageUrl.value ?? employee.value?.photo;

      // Prepare update body
      final body = {
        "name": nameController.text.trim(),
        "phone": "${selectedCountryCode.value}${phoneController.text.trim()}",
        "email": emailController.text.trim(),
        if (photoUrl != null) "photo": photoUrl,
      };

      // Call update API
      final result = await homeUseCase.updateEmployeeProfile(
        UpdateEmployeeParams(userId: user.userId!, body: body),
      );

      result.fold(
        (failure) {
        //  showToast(message: failure.message);
        },
        (updatedEmployee) {
          // Preserve relations that might be missing in the update response
          final mergedEmployee = updatedEmployee.copyWith(
            office: updatedEmployee.office ?? employee.value?.office,
            department: updatedEmployee.department ?? employee.value?.department,
            designation: updatedEmployee.designation ?? employee.value?.designation,
            organization: updatedEmployee.organization ?? employee.value?.organization,
            manager: updatedEmployee.manager ?? employee.value?.manager,
          );

          employee.value = mergedEmployee;
          IsarDBHelper().saveEmployeeData(mergedEmployee); // Ensure local DB is updated with full data
          
          showToast(message: 'Profile updated successfully', isError: false);
          context.pop();
        },
      );
    } catch (e) {
      showToast(message: 'Something went wrong');
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  /// Change Country Code
  void changeCountryCode(String code) {
    selectedCountryCode.value = code;
  }

  /// Pick Image
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        
        // Upload image immediately after picking
        await uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      showToast(message: 'Error picking image: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Refresh employee profile (for pull-to-refresh)
  Future<void> refreshFunc() async {
    loadEmployeeProfile();
    loadPendingLeaveApplications();
  }
}
