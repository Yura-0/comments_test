import 'package:flutter/material.dart';

import '../../model/comment.dart';

class CommentPage extends StatelessWidget {
  final List<Comment> comments;
  const CommentPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            "Comments(${comments.isNotEmpty ? comments.length : 0})",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: comments.isNotEmpty
            ? ListView.builder(
                itemCount: comments.length * 2 - 1,
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return const Divider(height: 1, color: Colors.black);
                  } else {
                    final commentIndex = index ~/ 2;
                    final comment = comments[commentIndex];
                    return ListTile(
                        title: Text(
                          comment.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          comment.body,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 124, 121, 121),
                          ),
                        ),
                        onTap: () {});
                  }
                },
              )
            : const Text(
                "No comments",
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
