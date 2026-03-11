import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:taghyeer_task/core/error/failures.dart';
import 'package:taghyeer_task/features/posts/domain/repositories/posts_repository.dart';
import 'package:taghyeer_task/features/posts/data/models/post_model.dart';

class PostsController extends GetxController {
  final PostsRepository postsRepository;
  
  final posts = <PostModel>[].obs;
  final isLoading = false.obs;
  final isPaginationLoading = false.obs;
  final failure = Rxn<Failure>();
  
  final scrollController = ScrollController();
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;

  PostsController(this.postsRepository);

  @override
  void onInit() {
    super.onInit();
    getPosts();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!_hasMore || isPaginationLoading.value || isLoading.value) return;
        getPosts(isPagination: true);
      }
    });
  }

  Future<void> getPosts({bool isPagination = false}) async {
    if (!isPagination) {
      isLoading.value = true;
      _skip = 0;
      posts.clear();
      _hasMore = true;
    } else {
      isPaginationLoading.value = true;
    }
    failure.value = null;

    try {
      final response = await postsRepository.getPosts(limit: _limit, skip: _skip);
      if (response.posts.isEmpty) {
        _hasMore = false;
      } else {
        posts.addAll(response.posts);
        _skip += _limit;
        if (posts.length >= response.total) _hasMore = false;
      }
    } on DioException catch (e) {
      if (e.error is Failure) {
        failure.value = e.error as Failure;
      } else {
        failure.value = Failure(message: 'Failed to load posts: ${e.message}');
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
