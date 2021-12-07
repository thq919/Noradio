import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'GUI/custom_bottom_sheet.dart';
import 'GUI/video_single_shelf.dart';
import 'YT/yt_api_handler.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  var title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WidgetList(),
      bottomSheet: Custom_bottom_sheet(),
    );
  }
}

class WidgetList extends StatefulWidget {
  WidgetList({Key? key}) : super(key: key);

  @override
  State<WidgetList> createState() => _WidgetListState();
}

class _WidgetListState extends State<WidgetList> {
  final MainPlayer player = MainPlayer();

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
                      build_Video_single_shelf_list(pos)))
          : Text('Попробуйте ввести что нибудь в поиск')
    ]);
  }

  Video_single_shelf build_Video_single_shelf_list(int pos) {
    if (pos == searchList.length - 1) {
      searchList.nextPage().then((list) {
        if (list != null) {
          setState(() {
            searchList.addAll(list);
          });
        }
      });
    }
    return Video_single_shelf(searchList.elementAt(pos));
  }

  void fillListAndSetState(String searchQue) {
    player.searchAudio(searchQue).then((list) => setState(() {
          if (list.runtimeType == SearchList && list != null) {
            searchList = list;
            listExist = true;
          }
        }));
  }
}
