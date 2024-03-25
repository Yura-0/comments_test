import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../injector.dart';
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
      SharedPreferences prefs = locator<SharedPreferences>();
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

      await saveDataToCache(prefs);

      if (users.isEmpty || posts.isEmpty || comments.isEmpty) {
        bool isLoad = await loadDataFromCache(prefs);
        if (!isLoad) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 46, 45, 45),
              title: const Text(
                'Check your internet connection, and restart app',
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
      }
    });
  }

  Future<void> saveDataToCache(SharedPreferences prefs) async {
    if (users.isNotEmpty && posts.isNotEmpty && comments.isNotEmpty) {
      await prefs.setString(
          'users', jsonEncode(users.map((user) => user.toJson()).toList()));
      await prefs.setString(
          'posts', jsonEncode(posts.map((post) => post.toJson()).toList()));
      await prefs.setString('comments',
          jsonEncode(comments.map((comment) => comment.toJson()).toList()));
    }
  }

  Future<bool> loadDataFromCache(SharedPreferences prefs) async {
    final String? usersData = prefs.getString('users');
    final String? postsData = prefs.getString('posts');
    final String? commentsData = prefs.getString('comments');
    if (usersData != null && postsData != null && commentsData != null) {
      setState(() {
        users = (jsonDecode(usersData) as List<dynamic>)
            .map((e) => User.fromJson(e))
            .toList();
        posts = (jsonDecode(postsData) as List<dynamic>)
            .map((e) => Post.fromJson(e))
            .toList();
        comments = (jsonDecode(commentsData) as List<dynamic>)
            .map((e) => Comment.fromJson(e))
            .toList();
      });
      return true;
    }
    return false;
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
                      'Check your internet connection, and restart app',
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
