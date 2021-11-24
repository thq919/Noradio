import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/material.dart';
import 'GUI/video_single_shelf.dart';
import 'YT/yt_api_handler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  late YoutubeExplode player;
  var title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MainPlayer player = MainPlayer();
  SearchList? list;
  bool isSearchListExist = false;
  late String searchQue;

  @override
  void initState() {
    super.initState();
  }

  void _searchForVideo(String searchQuery) async {
    try {
      await player.searchVideos(searchQuery).then((value) => list = value).whenComplete(() => isSearchListExist = true);
      setState(() {});
    } catch (e) {
      print(e);
      print('pizdec');
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextField(onSubmitted: (value) async {
          searchQue = value;
          _searchForVideo(searchQue);
        }),

      ]),
    );
  }
}

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black54,
//         appBar: AppBar(
//           title: Text('TeleMatch Login'),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                     'Telematcher'),
//                 Container(
//                   height: 20,
//                 ),
//                 Container(
//                   child: TextField(),
//                   width: (500),
//                 ),
//                 Container(
//                   height: 20,
//                 ),
//                 Container(
//                   child: TextField(),
//                   width: (500),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
// Как меня заебала эта срань просто пиздец, я не понимаю где я нахожусб
