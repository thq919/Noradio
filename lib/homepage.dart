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

  bool listExist = false;
  bool videoIsPicked = false;
  bool streamInfoIsCreated = false;

  late ScrollController _scrollController;
  _scrollListener () {

    if (_scrollController.offset  > _scrollController.position.maxScrollExtent  && !_scrollController.position.outOfRange) {
      player.getNextPage(searchList).then((newList) {

        setState(() {

          searchList = newList!;
          _scrollController.jumpTo(0);
        });
      });
    }
  }
  //DEBUG
  late String errorOnCreatingSearchList;

  @override
  void initState() {
    _scrollController = ScrollController();
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
      if (listExist)
        Expanded(
            child: NotificationListener<ScrollNotification>(

              child: ListView.builder(
                  controller: _scrollController,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchList.length,
                  itemBuilder: (context, int pos) {
                    return InkWell(
                        onTap: () => setCurrentAudioAndPlay(pos),
                        child: buildVideoSingleShelfList(pos));
                    // child: rebuildVideoSingleShelfList(pos));
                  }),
            ))
      else
        const Text('Попробуйте ввести что нибудь в поиск'),
      if (videoIsPicked && streamInfoIsCreated)
        CustomBottomSheet(currentVideo, currentVideoIndex, streamInfo)
    ]);
  }

  void setCurrentAudioAndPlay(int pos) {
    currentVideoIndex = pos;
    currentVideo = searchList.elementAt(pos);
    videoIsPicked = true;
    player.playAudio(currentVideo.id.toString()).then((_) {
      streamInfo = player.streamInfo;
      streamInfoIsCreated = true;
      player.setVideoDuration(currentVideo.duration!);
      player.setCurrentVideo(currentVideo);
      setState(() {
        currentVideoIndex;
        streamInfo;
        currentVideo;
        videoIsPicked;
        streamInfoIsCreated;
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
          listExist = true;
        });
    });
  }
}
