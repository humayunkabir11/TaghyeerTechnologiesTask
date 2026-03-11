import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taghyeer_task/features/posts/presentation/pages/posts_page.dart';
import 'package:taghyeer_task/features/settings/presentation/pages/settings_page.dart';
import 'package:taghyeer_task/features/products/presentation/pages/products_page.dart';


import 'package:taghyeer_task/features/main/presentation/controllers/navigation_controller.dart';

class MainPage extends GetView<NavigationController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ProductsPage(),
      const PostsPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Products'),
              BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Posts'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          )),
    );
  }
}
