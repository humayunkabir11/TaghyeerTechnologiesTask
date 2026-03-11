import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taghyeer_task/features/products/presentation/controllers/products_controller.dart';
import 'package:taghyeer_task/features/products/presentation/widget/product_card.dart';
import 'package:taghyeer_task/features/products/presentation/pages/product_detail_page.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          
           ///------------------------- Handle empty state
           if (controller.products.isEmpty) {
              return const Center(
                  child: Text(
                      "No Data Found",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                      ),
                  ),
              );
           }

    ///- ----------------------- product list
          return GridView.builder(
            controller: controller.scrollController,
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.products.length +
                (controller.isPaginationLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.products.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final product = controller.products[index];
              ///---------------- product card
              return ProductCard(
                product: product,
                onTap: () => Get.to(() => ProductDetailPage(product: product)),
              );
            },
          );
        }),
      );
    });
  }
}



