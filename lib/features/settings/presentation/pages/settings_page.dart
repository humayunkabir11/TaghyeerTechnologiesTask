import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taghyeer_task/features/settings/presentation/controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'),centerTitle: true,),
      body: GetBuilder<SettingsController>(builder: (controller) {
        return ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            Obx(() {
              final user = controller.user.value;
              if (user == null) return const SizedBox.shrink();
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(user
                      .image)),
                  title: Text(user.fullName),
                  subtitle: Text(user.email),
                ),
              );
            }),
            SizedBox(height: 20.h),

            /// ------------------------  switchListTile
            Obx(() =>
                SwitchListTile(
                  title: controller.isDarkMode.value?const Text('Dark Mode') : const Text('Light Mode'),
                  value: controller.isDarkMode.value,
                  onChanged: (_) => controller.toggleTheme(),
                )),
            const Divider(),
            /// ----------------------------- Logout button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => controller.logout(),
            ),
          ],
        );
      }),
    );
  }
}
