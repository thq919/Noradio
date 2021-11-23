import 'package:flutter/material.dart';
import 'package:telematch/homepage.dart';

class Video_single_shelf extends StatefulWidget {

  @override
  State<Video_single_shelf> createState() => Video_single_shelf_state();
  var player;

}
class Video_single_shelf_state extends State<Video_single_shelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Row(
           children: const [
             // обложка видео
             // Image(image: ),
             // Название трека
             // Text(),
             // Имя исполнителя + время
             // Text(data),

           ],
          )
        ],
      )
    );
  }

}