import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taghyeer_task/features/products/data/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details"),centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(tag: 'product-${product.id}', child: CachedNetworkImage(imageUrl: product.thumbnail)),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  Text('\$${product.price}', style: TextStyle(fontSize: 18.sp, color: Colors.blue)),
                  SizedBox(height: 10.h),
                  Text(product.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
