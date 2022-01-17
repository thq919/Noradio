
import 'package:flutter/material.dart';
import 'package:noradio/pages/videoList.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: VideoList(fromSaved: false),
      // bottomSheet: bottom,
    );
  }
}


