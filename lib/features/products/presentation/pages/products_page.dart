import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taghyeer_task/features/products/presentation/controllers/products_controller.dart';
import 'package:taghyeer_task/features/products/data/models/product_model.dart';
import 'package:taghyeer_task/features/products/presentation/pages/product_detail_page.dart';

class ProductsPage extends GetView<ProductsController> {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty && controller.products.isEmpty) {
          return Center(child: Text(controller.error.value));
        }
        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.products.length + (controller.isPaginationLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.products.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final product = controller.products[index];
            return ListTile(
              leading: CachedNetworkImage(imageUrl: product.thumbnail, width: 50.w),
              title: Text(product.title),
              subtitle: Text('\$${product.price}'),
              onTap: () => Get.to(() => ProductDetailPage(product: product)),
            );
          },
        );
      }),
    );
  }
}
