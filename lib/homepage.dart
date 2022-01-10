// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:telematch/GUI/custom_bottom_sheet.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '/YT/youtube_handler.dart';
import 'GUI/video_single_shelf.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  var title;

  late SearchList searchList;

  // Custom_bottom_sheet bottom = Custom_bottom_sheet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WidgetList(),
      // bottomSheet: bottom,
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
  late Video currentVideo;
  late int currentVideoIndex;
  late AudioOnlyStreamInfo streamInfo;

  bool _listExist = false;
  bool _videoIsPicked = false;
  bool _streamInfoIsCreated = false;

  late ScrollController _scrollController;

  //later for any needs
  _scrollListener() {}

  Future<void> _refreshIndicator() async {
    player.getNextPage(searchList).then((newList) {
      _scrollController
          .jumpTo(_scrollController.positions.first.maxScrollExtent);
      setState(() {
        searchList = newList!;
      });
    });
  }

  //DEBUG
  late String errorOnCreatingSearchList;
  @override
  void initState() {
    _scrollController = ScrollController(
        //this is analogue of double.infinite but chinese version
        initialScrollOffset: 1000);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
          enableSuggestions: true,
          onFieldSubmitted: (searchQue) {
            fillListAndSetState(searchQue);
          }),
      if (_listExist)
        Expanded(
            child: RefreshIndicator(
          onRefresh: _refreshIndicator,
          child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              //physics: const ScrollPhysics(),
              // shrinkWrap: true,
              itemCount: searchList.length,
              itemBuilder: (context, int pos) {
                return InkWell(
                    onTap: () => setCurrentAudioAndPlay(pos),
                    child: buildVideoSingleShelfList(pos));
              }),
        ))
      else
        const Text('Попробуйте ввести что нибудь в поиск'),
      if (_videoIsPicked && _streamInfoIsCreated)
        CustomBottomSheet(currentVideo, currentVideoIndex, streamInfo)
    ]);
  }

  void setCurrentAudioAndPlay(int pos) {
    currentVideoIndex = pos;
    currentVideo = searchList.elementAt(pos);
    _videoIsPicked = true;
    player.playAudio(currentVideo.id.toString()).then((_) {
      streamInfo = player.streamInfo;
      _streamInfoIsCreated = true;
      player.setVideoDuration(currentVideo.duration!);
      player.setCurrentVideo(currentVideo);
      setState(() {
        currentVideoIndex;
        streamInfo;
        currentVideo;
        _videoIsPicked;
        _streamInfoIsCreated;
      });
    });
  }

  VideoSingleShelf buildVideoSingleShelfList(int pos) {
    return VideoSingleShelf(searchList.elementAt(pos));
  }

  void fillListAndSetState(String searchQue) {
    player.searchAudio(searchQue).then((list) {
      setState(() {
        searchList = list!;
        _listExist = true;
      });
    });
  }
}
