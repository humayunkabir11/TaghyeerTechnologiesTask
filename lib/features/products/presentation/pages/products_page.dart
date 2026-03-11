import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

          if (controller.failure.value != null && controller.products.isEmpty) {
            final failure = controller.failure.value!;
            
            // Show toast message if there is a failure and we have no data
            if (failure.isNoInternet) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                 Fluttertoast.showToast(msg: "No Internet Connection");
                });
            } else {
               WidgetsBinding.instance.addPostFrameCallback((_) {
                 Fluttertoast.showToast(msg: failure.message);
                });
            }
             
            // Show retry button
            return Center(
               child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      failure.isNoInternet ? "No Internet Connection" : failure.message,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => controller.getProducts(),
                      child: const Text("Retry"),
                    )
                  ],
                ),
            );
          }
          
           // Handle empty state
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



