import 'package:flutter/material.dart';

import '../../model/comment.dart';
import '../../model/post.dart';
import '../../model/user.dart';
import '../../repo/comment_repo.dart';
import '../../repo/post_repo.dart';
import '../../repo/user_repo.dart';
import 'post_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  List<Post> posts = [];
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final List<User> loadedUsers = await UserRepository(
              usersUrl: "https://jsonplaceholder.typicode.com/users")
          .fetchUsers();
      setState(() {
        users = loadedUsers;
      });

      final List<Post> loadedPosts = await PostRepository(
              postsUrl: "https://jsonplaceholder.typicode.com/posts")
          .fetchPosts();
      setState(() {
        posts = loadedPosts;
      });

      final List<Comment> loadedComments = await CommentRepository(
              commentsUrl: "https://jsonplaceholder.typicode.com/comments")
          .fetchComments();
      setState(() {
        comments = loadedComments;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            (users.isNotEmpty && posts.isNotEmpty && comments.isNotEmpty)
                ? users[0].name
                : "Loading...",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: (users.isNotEmpty && posts.isNotEmpty && comments.isNotEmpty)
            ? PostListWidget(userId: 1, posts: posts, comments: comments,)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
