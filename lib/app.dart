import 'package:flutter/material.dart';

import 'features/home/home_page.dart';

class CommentsApp extends StatelessWidget {
  const CommentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(userId: 1,),
    );
  }
}

