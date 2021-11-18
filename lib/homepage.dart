

import 'package:flutter/material.dart';

import 'YT/YT_api_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _setHomePageState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    fun();
    return Scaffold(body: Column());
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          title: Text('TeleMatch Login'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Telematcher is simple dating app based on Telegram messneger. It`s absolutlly free without any microtransactions. Feel free too eplore'),
                Container(
                  height: 20,
                ),
                Container(
                  child: TextField(),
                  width: (500),
                ),
                Container(
                  height: 20,
                ),
                Container(
                  child: TextField(),
                  width: (500),
                ),
              ],
            ),
          ),
        ));
  }
}
// Как меня заебала эта срань просто пиздец, я не понимаю где я нахожусб

