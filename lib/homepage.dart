import 'dart:async';

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
            child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchList.length,
                itemBuilder: (context, int pos) {
                  return InkWell(
                      onTap: () => setCurrentAudioAndPlay(pos),
                      child: rebuildVideoSingleShelfList(pos));
                     // child: rebuildVideoSingleShelfList(pos));
                }))
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

  VideoSingleShelf? rebuildVideoSingleShelfList(int pos) {
    int posCheck = 20;
    if (pos -1 == posCheck) {
      posCheck = posCheck + 20;
      searchList.nextPage().then((list) {
        if (list != null) {
          setState(() {
            searchList = list;
          });
        }
      });

    }
    if (searchList.indexOf(searchList.last) >= pos ) {
      return VideoSingleShelf(searchList.elementAt(pos));
    } else {
      return null;
    }
  }

  void fillListAndSetState(String searchQue) {
    player.searchAudio(searchQue).then((list) => setState(() {
          if (list.runtimeType == SearchList && list != null) {
            searchList = list;
            searchList.length;
            listExist = true;
          }
        }));
  }
}
