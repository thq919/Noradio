
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'GUI/video_single_shelf.dart';
import 'YT/yt_api_handler.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  var title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: WidgetList());
  }
}

class WidgetList extends StatefulWidget {
  WidgetList({Key? key}) : super(key: key);

  @override
  State<WidgetList> createState() => _WidgetListState();
}

class _WidgetListState extends State<WidgetList> {
  MainPlayer player = MainPlayer();
  late SearchList searchList;
  bool listExist = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
          enableSuggestions: true,
          onFieldSubmitted: (searchQue) {
            fillListAndSetState(searchQue);
          }),
      // isListArrived ? wid() : Text('Поиск..')
      listExist
          ? Expanded(
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchList.length,
                  itemBuilder: (context, int pos) =>
                      Video_single_shelf(searchList.elementAt(pos))))
          : Text('Попробуйте ввести что нибудь в поиск')
    ]);
  }

  void fillListAndSetState(String searchQue) {
    var listToGo = player.searchAudio(searchQue);
    listToGo.then((list) => setState(() {
          if (list.runtimeType == SearchList && list != null) {
            searchList = list;
            listExist = true;
          }
        }));
  }
}
