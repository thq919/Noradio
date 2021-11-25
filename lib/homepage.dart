import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
  SearchList? videoSearchList;
  bool isSearchListExist = false;
  late String searchQue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextField(onSubmitted: (value) async {
          searchQue = value;
          Future<SearchList?> list = player.searchAudio(value);
          await list.then((gotList) => {
                setState(() {
                  videoSearchList = gotList;
                  isSearchListExist = true;
                })
              });
        }),
        Container(
          constraints: BoxConstraints(maxHeight: 720),
          child: Builder(
            builder: (BuildContext context) {
              if (isSearchListExist) {
                return WidgetList(
                  player: player,
                  search: videoSearchList!,
                );
              } else {
                return Text('huy');
              }
            },
          ),
        )
      ]),
    );
  }
}

class WidgetList extends StatelessWidget {
  late MainPlayer mainPlayer;
  late SearchList searchList;

  WidgetList({Key? key, required MainPlayer player, required SearchList search})
      : super(key: key) {
    mainPlayer = player;
    searchList = search;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Container(
          child: Video_single_shelf(searchList.elementAt(index++)));
    });
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
