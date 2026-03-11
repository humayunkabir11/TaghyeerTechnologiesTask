import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taghyeer_task/features/posts/presentation/controllers/posts_controller.dart';
import 'package:taghyeer_task/features/posts/data/models/post_model.dart';
import 'package:taghyeer_task/features/posts/presentation/pages/post_detail_page.dart';

class PostsPage extends GetView<PostsController> {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty && controller.posts.isEmpty) {
          return Center(child: Text(controller.error.value));
        }
        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.posts.length + (controller.isPaginationLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.posts.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final post = controller.posts[index];
            return ListTile(
              title: Text(post.title),
              subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: Text('#${post.id}'),
              onTap: () => Get.to(() => PostDetailPage(post: post)),
            );
          },
        );
      }),
    );
  }
}
