import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class UserRepository {
  final String usersUrl;

  UserRepository({required this.usersUrl});

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(usersUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonUsersDynamic = json.decode(response.body);
      final List<Map<String, dynamic>> jsonUsers =
          jsonUsersDynamic.cast<Map<String, dynamic>>();

      return jsonUsers.map((jsonUser) => User.fromJson(jsonUser)).toList();
    } else {
      return [];
    }
    }
    catch (e) {
      return [];
    }
  }
}
