import 'package:flutter/material.dart';
import 'package:noradio/widgets/video/videoSingleShelf.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utils.dart';
import '../widgets/bottom_menu/customBottomSheet.dart';

import '../YT/mainPlayer.dart';

class VideoList extends StatefulWidget {
  VideoList({Key? key, required this.fromSaved}) : super(key: key);
  bool fromSaved = false;
  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  String screenMessage = "Попробуйте ввести что нибудь в поиск";
  final MainPlayer player = MainPlayer();

  late SearchList searchList;
  late Video currentVideo;
  late int currentVideoIndex;
  late AudioOnlyStreamInfo streamInfo;

  bool _listExist = false;
  bool _videoIsPicked = false;
  bool _streamInfoIsCreated = false;

  late ScrollController _scrollController;

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
      //create own searchbar
      TextFormField(
          enableSuggestions: true,
          onFieldSubmitted: (searchQue) {
            if (widget.fromSaved == true) {
              fillListFromSavedAndSetState();
            } else {
              fillListAndSetState(searchQue);
            }
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
        Text(screenMessage),
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
      if (list == null) {
        returnToStart();
      } else {
        setState(() {
          searchList = list;
          _listExist = true;
        });
      }
    });
  }

  Future<void> _refreshIndicator() async {
    player.getNextPage(searchList).then((newList) {
      if (newList == null) {
        returnToStart();
      } else {
        _scrollController
            .jumpTo(_scrollController.positions.first.maxScrollExtent);
        setState(() {
          searchList = newList;
        });
      }
    });
  }

  //later for any upcoming needs
  _scrollListener() {}

  void returnToStart() {
    setState(() {
      _listExist = false;
      screenMessage =
          "Кажется видео закончились, pogchamp. Попробуйте еще поискать что ли";
    });
  }

  Future<void> fillListFromSavedAndSetState() async {
    List<Video> list = await getAll() as List<Video>;
    if (list == null) {
      returnToStart();
    } else {
      setState(() {
        searchList = list as SearchList;
      });
    }
  }
}
