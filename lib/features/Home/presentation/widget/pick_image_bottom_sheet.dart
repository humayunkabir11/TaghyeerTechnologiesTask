

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hrx/features/Home/presentation/controller/Home_controller.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/widgets/button/elevated_custome_button.dart';

void pickImageBottomSheet(BuildContext context ,{required HomeController controller}){

    showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ----- Handle Bar -----
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 25),

            /// ----- Title -----
            const Text(
              "Change Profile Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 20,
                fontFamily: "Lato",
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 30),

            CustomElevatedButton(
              onPressed: () {
                controller.pickImage(ImageSource.camera);
                context.pop();
              },
              titleText: "Capture Photo",
            ),
             Gap(20),
            CustomElevatedButton(onPressed: (){
              controller.pickImage(ImageSource.gallery);
              context.pop();
            },
                borderColor: Color(0xff17598B),
                buttonColor: Colors.white,
                titleColor: Color(0xff17598B),

                titleText: "Upload Image"),
          ],
        ),
      ) ;
    },
  );
}