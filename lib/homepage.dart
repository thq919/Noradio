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
  String? searchQue;
  late WidgetList list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Wrap(children: [
        buildTextFieldSearch(),
        if (searchQue != null) buildTree(),
      ]),
    );
  }

  TextField buildTextFieldSearch() {
    return TextField(onChanged: (value) {
      setState(() {
        searchQue = value;
      });
    });
  }

  FutureBuilder<SearchList?> buildTree() {
    return FutureBuilder(
      future: fillTheList(searchQue),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          searchQue = null;
          list = WidgetList(player: player, search: snapshot.data!);
          return list;
        }
        if (snapshot.hasError) {
          return Text('ощибка');
        } else
          return CircularProgressIndicator();
      },
    );
  }

  Future<SearchList?> fillTheList(String? value) async {
    if (value!.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500));
    }
    if (value.isNotEmpty) {
      searchQue = value;
      return player.searchAudio(value);
    }
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
    //  ErrorSummary('Vertical viewport was given unbounded height.'),
    //  ErrorDescription(
    //  'Viewports expand in the scrolling direction to fill their container. '
    //  'In this case, a vertical viewport was given an unlimited amount of '
    //  'vertical space in which to expand. This situation typically happens '
    //  'when a scrollable widget is nested inside another scrollable widget.',
    //  ),
    //  ErrorHint(
    //  'If this widget is always nested in a scrollable widget there '
    //  'is no need to use a viewport because there will always be enough '
    //  'vertical space for the children. In this case, consider using a '
    //  'Column instead. Otherwise, consider using the "shrinkWrap" property '
    //  '(or a ShrinkWrappingViewport) to size the height of the viewport '
    //  'to the sum of the heights of its children.',
    return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int position) {
          return ListTile(
            onTap: () =>
                {mainPlayer.playAudio(searchList.elementAt(position).url)},
            title: Video_single_shelf(searchList.elementAt(position)),
          );
        });
  }
}

class MyController extends ScrollController {}
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
