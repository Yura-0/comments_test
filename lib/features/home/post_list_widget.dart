import 'package:flutter/material.dart';

import '../../model/comment.dart';
import '../../model/post.dart';

class PostListWidget extends StatelessWidget {
  final int userId;
  final List<Post> posts;
  final List<Comment> comments;

  const PostListWidget({
    super.key,
    required this.userId,
    required this.posts,
    required this.comments,
  });

  List<Post> findPostsByUserId() {
    return posts.where((post) => post.userId == userId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Post> userPosts = findPostsByUserId();

    return ListView.builder(
  itemCount: userPosts.length * 2 - 1, 
  itemBuilder: (context, index) {
    if (index.isOdd) {
      return const Divider(height: 1, color: Colors.black); 
    } else {
      final postIndex = index ~/ 2;
      final post = userPosts[postIndex];
      return ListTile(
        title: Text(
          post.title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          post.body,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 124, 121, 121),
          ),
        ),
      );
    }
  },
);

  }
}
