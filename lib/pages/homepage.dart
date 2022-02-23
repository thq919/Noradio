import 'package:flutter/material.dart';
import 'package:noradio/pages/videoList.dart';

class HomePage extends StatelessWidget {
  const HomePage(
      {Key? key, required this.title, this.model})
      : super(key: key);

  final title;
  final model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: VideoList(fromSaved: false, model: model),
      // bottomSheet: bottom,
    );
  }
}
