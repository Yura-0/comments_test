import 'package:flutter/material.dart';

import '../../model/user.dart';
import '../home/home_page.dart';

class UserPage extends StatelessWidget {
  final int userId;
  final List<User> users;
  const UserPage({
    super.key,
    required this.users,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            users[userId - 1].name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: users.length * 2 - 1,
          itemBuilder: (context, index) {
            if (index.isOdd) {
              return const Divider(height: 1, color: Colors.black);
            } else {
              final userIndex = index ~/ 2;
              final user = users[userIndex];
              return ListTile(
                  title: Text(
                    "${user.name}(${user.username})",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          userId: users[userIndex].id,
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
