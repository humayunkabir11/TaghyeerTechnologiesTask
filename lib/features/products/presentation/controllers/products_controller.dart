import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taghyeer_task/core/error/failures.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecase/get_products_usecase.dart';


class ProductsController extends GetxController {
  final GetProductsUseCase getProductsUseCase;
  
  final products = <ProductEntity>[].obs;
  final isLoading = false.obs;
  final isPaginationLoading = false.obs;
  final failure = Rxn<Failure>();
  
  final scrollController = ScrollController();
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;

  ProductsController(this.getProductsUseCase);

  @override
  void onInit() {
    super.onInit();
    getProducts();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!_hasMore || isPaginationLoading.value || isLoading.value) return;
        getProducts(isPagination: true);
      }
    });
  }

  Future<void> getProducts({bool isPagination = false}) async {
    if (!isPagination) {
      isLoading.value = true;
      _skip = 0;
      products.clear();
      _hasMore = true;
    } else {
      isPaginationLoading.value = true;
    }
    failure.value = null;

    try {
      final result = await getProductsUseCase.call(
        GetProductsParams(limit: _limit, skip: _skip),
      );

      result.fold(
        (l) {
          failure.value = l;
        },
        (r) {
          if ((r.products ?? []).isEmpty) {
            _hasMore = false;
          } else {
            products.addAll(r.products ?? []);
            _skip += _limit;
            if (products.length >= (r.total ?? 0)) _hasMore = false;
          }
        },
      );
    } catch (e) {
      failure.value = Failure(message: 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }


  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
