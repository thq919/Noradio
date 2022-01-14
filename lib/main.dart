import 'package:flutter/material.dart';
import 'pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeleMatch',
      theme: MainTheme(),
      home: HomePage(title: 'TeleMatch main screen'),

    );
  }
}

ThemeData MainTheme() {
  return ThemeData(
    primarySwatch: Colors.deepPurple,
    backgroundColor: Colors.black54
    );
}