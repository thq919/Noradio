import 'package:flutter/material.dart';

class Video_single_shelf extends StatefulWidget {

  @override
  State<Video_single_shelf> createState() => Video_single_shelf_state();


}
class Video_single_shelf_state extends State<Video_single_shelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Row(
           children: [
            Placeholder()
           ],
          )
        ],
      )
    );
  }

}