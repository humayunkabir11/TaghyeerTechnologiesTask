import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:taghyeer_task/core/error/failures.dart';
import 'package:taghyeer_task/features/products/domain/repositories/products_repository.dart';
import 'package:taghyeer_task/features/products/data/models/product_model.dart';

class ProductsController extends GetxController {
  final ProductsRepository productsRepository;
  
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isPaginationLoading = false.obs;
  final failure = Rxn<Failure>();
  
  final scrollController = ScrollController();
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;

  ProductsController(this.productsRepository);

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
      final response = await productsRepository.getProducts(limit: _limit, skip: _skip);
      if (response.products.isEmpty) {
        _hasMore = false;
      } else {
        products.addAll(response.products);
        _skip += _limit;
        if (products.length >= response.total) _hasMore = false;
      }
    } on DioException catch (e) {
      if (e.error is Failure) {
        failure.value = e.error as Failure;
      } else {
        failure.value = Failure(message: 'Failed to load products: ${e.message}');
      }
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
