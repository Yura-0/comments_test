import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/comment.dart';


class CommentRepository {
  final String commentsUrl;

  CommentRepository({required this.commentsUrl});

  Future<List<Comment>> fetchComments() async {
    final response = await http.get(Uri.parse(commentsUrl));

    if (response.statusCode == 200) {
           final List<dynamic> jsonCommentsDynamic = json.decode(response.body);
      final List<Map<String, dynamic>> jsonComments =
          jsonCommentsDynamic.cast<Map<String, dynamic>>();
      return jsonComments.map((jsonComment) => Comment.fromJson(jsonComment)).toList();
    } else {
      return [];
    }
  }
}
