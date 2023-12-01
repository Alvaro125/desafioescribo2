import 'package:desafioescribo2/homepage.dart';
import 'package:desafioescribo2/repository/book_repository.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      color: Colors.indigo,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
