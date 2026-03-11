import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hrx/core/common/widgets/appbar/custom_appbar.dart';
import 'package:hrx/core/common/widgets/button/elevated_custome_button.dart';
import 'package:hrx/core/common/widgets/field/custom_text_field.dart';
import 'package:hrx/core/custom_assets/assets.gen.dart';
import 'package:hrx/features/Home/presentation/controller/Home_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/common/widgets/button/notification_button.dart';
import '../../data/models/employee_model.dart';
import '../widget/pick_image_bottom_sheet.dart';

class EditBasicInfoPage extends StatefulWidget {
  final EmployeeModel? employee;
  const EditBasicInfoPage({super.key, this.employee});

  @override
  State<EditBasicInfoPage> createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage> {
  @override
  void initState() {
    super.initState();
    // Populate fields with current employee data
    final controller = Get.find<HomeController>();
    final employee = controller.employee.value;

    
    if (employee != null) {
      controller.nameController.text = employee.name ?? '';
      controller.emailController.text = employee.email ?? '';
      
      // Parse phone number - remove country code if present
      String phone = employee.phone ?? '';
      if (phone.startsWith('+88')) {
        phone = phone.substring(3);
      } else if (phone.startsWith('88')) {
        phone = phone.substring(2);
      }
      controller.phoneController.text = phone;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 60,
        backgroundColor: Color(0xffF9F9F8),
        title: Text("Edit Basic Info"),
        centerTitle: true,
        actions: [NotificationButton(onTap: () {})],
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<HomeController>(
        assignId: true,
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image Section
                      _buildLabel('Profile Image', isRequired: true),
                      const SizedBox(height: 12),
                      Center(
                        child: Stack(
                          children: [
                            Obx(() {
                              // Determine which image to show
                              ImageProvider imageProvider;
                              bool hasError = false;
                              
                              if (controller.profileImage.value != null) {
                                // Show newly picked image
                                imageProvider = FileImage(controller.profileImage.value!);
                              } else {
                                // Try to show employee photo
                                final photo = controller.employee.value?.photo;
                                
                                if (photo != null && photo.toString().trim().isNotEmpty && photo.toString() != 'null') {
                                  imageProvider = NetworkImage(photo.toString());
                                } else {
                                  // Fallback to placeholder
                                  imageProvider = const NetworkImage('https://www.rootinc.com/wp-content/uploads/2022/11/placeholder-1-1024x683.png');
                                }
                              }
                              
                              return Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image(
                                        image: imageProvider,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.person,
                                                size: 80,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  // Loading overlay for upload
                                  if (controller.isUploading.value)
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }),

                            Obx(() {
                              return  controller.profileImage.value==null?SizedBox() :Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.profileImage.value = null;
                                    controller.uploadedImageUrl.value = null;
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,

                                    ),
                                    child: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              );
                            }),

                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () {
                                  pickImageBottomSheet(
                                      context, controller: controller);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF444444),
                                    shape: BoxShape.circle,

                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Color(0xff00C6AE),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildLabel('Employee Name', isRequired: true),
                      const SizedBox(height: 8),

                      CustomTextField(
                        controller: controller.nameController,
                        hintText: "Enter your name",
                        borderEnable: true,
                        contentPadding: EdgeInsets.all(0),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter employee name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Email Address Field
                      _buildLabel('Email Address', isRequired: true),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: "Enter your email address",
                        borderEnable: true,
                        contentPadding: EdgeInsets.all(0),
                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
                            return 'Please enter email address';
                          }

                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Invalid email address';
                          }

                          return null;
                        },

                      ),
                      const SizedBox(height: 20),

                      // Phone Number Field
                      _buildLabel('Phone Number', isRequired: true),
                      const SizedBox(height: 8),
                      CustomTextField(
                        contentPadding: EdgeInsets.all(0),
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),

                        ],

                        prefixIcon: Obx(() {
                          return PopupMenuButton<String>(
                            initialValue: controller.selectedCountryCode.value.isEmpty?"+88" : controller.selectedCountryCode.value,
                            onSelected: controller.changeCountryCode,
                            child: Container(
                              width: 60,
                              margin: const EdgeInsets.only(
                                  left: 12, top: 4, bottom: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(controller.selectedCountryCode.value),
                                  Gap(4),
                                  Assets.icons.icArrowDown.svg(),
                                ],
                              ),
                            ),
                            itemBuilder: (_) =>
                                [
                                  '+88',
                                  // '+1',
                                  // '+44',
                                  // '+91',
                                  // '+92',
                                  // '+93',
                                  // '+94',
                                  // '+95'
                                ]
                                    .map(
                                      (code) =>
                                      PopupMenuItem(
                                        value: code,
                                        child: Text(code),
                                      ),
                                )
                                    .toList(),
                          );
                        }),

                        hintText: "Enter your phone number",
                        borderEnable: true,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }

                          if (!value.startsWith('01')) {
                            return 'Phone number must start with 01';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 40),

                      // Save Button
                      Obx(() {
                        return CustomElevatedButton(
                          onPressed: controller.isUpdatingProfile.value
                              ? null
                              : () => controller.updateUserProfile(context),
                          titleText: controller.isUpdatingProfile.value
                              ? 'Saving...'
                              : 'Save',
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCountryName(String code) {
    switch (code) {
      case '+88':
        return 'Bangladesh';
      case '+1':
        return 'United States';
      case '+44':
        return 'United Kingdom';
      case '+91':
        return 'India';
      case '+92':
        return 'Pakistan';
      case '+93':
        return 'Afghanistan';
      case '+94':
        return 'Sri Lanka';
      case '+95':
        return 'Myanmar';
      default:
        return '';
    }
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: const Color(0xFF444444),
            fontSize: 14,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              color: const Color(0xFFFF255C),
              fontSize: 14,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
