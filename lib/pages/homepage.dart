
import 'package:flutter/material.dart';
import 'package:telematch/pages/videoList.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const VideoList(),
      // bottomSheet: bottom,
    );
  }
}


