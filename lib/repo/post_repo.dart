import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/post.dart';


class PostRepository {
  final String postsUrl;

  PostRepository({required this.postsUrl});

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(postsUrl));

    if (response.statusCode == 200) {
       final List<dynamic> jsonPostsDynamic = json.decode(response.body);
      final List<Map<String, dynamic>> jsonPosts =
          jsonPostsDynamic.cast<Map<String, dynamic>>();
      return jsonPosts.map((jsonPost) => Post.fromJson(jsonPost)).toList();
    } else {
      return [];
    }
  }
}
