import 'package:flutter/material.dart';

import '../../model/comment.dart';
import '../../model/post.dart';
import '../../model/user.dart';
import '../../repo/comment_repo.dart';
import '../../repo/post_repo.dart';
import '../../repo/user_repo.dart';
import '../users/user_page.dart';
import 'post_list_widget.dart';

class HomePage extends StatefulWidget {
  final int userId;
  const HomePage({
    super.key,
    required this.userId,
  });

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            (users.isNotEmpty && posts.isNotEmpty && comments.isNotEmpty)
                ? users[widget.userId - 1].name
                : "Loading...",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/userIcon.png'),
            onPressed: () {
              if (users.isNotEmpty && posts.isNotEmpty && comments.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPage(
                      userId: widget.userId,
                      users: users,
                    ),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 46, 45, 45),
                    title: const Text(
                      'Check your internet connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: (users.isNotEmpty && posts.isNotEmpty && comments.isNotEmpty)
            ? PostListWidget(
                userId: widget.userId,
                posts: posts,
                comments: comments,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
