import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details"),centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(tag: 'product-${product.id ?? 0}', child: CachedNetworkImage(imageUrl: product.thumbnail ?? '')),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title ?? '', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  Text('\$${product.price ?? 0.0}', style: TextStyle(fontSize: 18.sp, color: Colors.blue)),
                  SizedBox(height: 10.h),
                  Text(product.description ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
