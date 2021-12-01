import 'dart:async';

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
  String? searchQue;

  Future<SearchList?> fillTheList(String? searchQuery) async {
    if (searchQuery!.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500));
    }
    if (searchQuery.isNotEmpty) {
      searchQue = searchQuery;
      return player.searchAudio(searchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      TextField(onSubmitted: (value) {
        setState(() {
          searchQue = value;
        });
      }),
      searchQue != null
          ? buildFutureBuilder()
          : Text('Введите что нибудь... сверху :)')
    ]);
  }

  FutureBuilder<SearchList?> buildFutureBuilder() {
    return FutureBuilder(
      future: fillTheList(searchQue),
      builder: (BuildContext context, AsyncSnapshot searchListFuture) {
        if (searchListFuture.hasData) {
          searchList = searchListFuture.data;
          return SingleChildScrollView(
            child: Column(children: <Widget>[
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int position) {
                    return Video_single_shelf(searchList.elementAt(position));
                  }),
            ]),
          );
        }
        if (searchListFuture.hasError) {
          return Text('ощибка');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
