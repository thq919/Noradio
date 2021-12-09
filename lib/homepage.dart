import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:telematch/GUI/customBottomSheet.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '/YT/youtubeHandler.dart';
import 'GUI/videoSingleShelf.dart';

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
  State<WidgetList> createState() => WidgetListState();
}

class WidgetListState extends State<WidgetList> {
  final MainPlayer player = MainPlayer();

  late SearchList searchList;
  late Video currentVideo;
  late int currentVideoIndex;

  bool listExist = false;
  bool videoIsPicked = false;

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
                      child: buildVideoSingleShelfList(pos));
                }))
      else
        Text('Попробуйте ввести что нибудь в поиск'),
      if (videoIsPicked) CustomBottomSheet(currentVideo, currentVideoIndex)
    ]);
  }

  void setCurrentAudioAndPlay(int pos) {
    currentVideoIndex = pos;
    currentVideo = searchList.elementAt(pos);
    videoIsPicked = true;
    player.playAudio(currentVideo.id.toString());
    setState(() {
      currentVideoIndex;
      currentVideo;
      videoIsPicked;
    });
  }

  VideoSingleShelf buildVideoSingleShelfList(int pos) {
    if (pos == searchList.length - 1) {
      searchList.nextPage().then((list) {
        if (list != null) {
          setState(() {
            searchList.addAll(list);
          });
        }
      });
    }
    return VideoSingleShelf(searchList.elementAt(pos));
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
