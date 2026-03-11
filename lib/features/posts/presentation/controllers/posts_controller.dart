import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taghyeer_task/core/error/failures.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecase/get_posts_usecase.dart';


class PostsController extends GetxController {
  final GetPostsUseCase getPostsUseCase;
  
  final posts = <PostEntity>[].obs;
  final isLoading = false.obs;
  final isPaginationLoading = false.obs;
  final failure = Rxn<Failure>();
  
  final scrollController = ScrollController();
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;

  PostsController(this.getPostsUseCase);

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
      final result = await getPostsUseCase.call(
        GetPostsParams(limit: _limit, skip: _skip),
      );

      result.fold(
        (l) {
          failure.value = l;
        },
        (r) {
          if ((r.posts ?? []).isEmpty) {
            _hasMore = false;
          } else {
            posts.addAll(r.posts ?? []);
            _skip += _limit;
            if (posts.length >= (r.total ?? 0)) _hasMore = false;
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
