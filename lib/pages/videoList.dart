import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noradio/main.dart';
// import 'package:noradio/widgets/searchBar/searchbarprovider.dart';
// import 'package:noradio/widgets/searchBar/searchBar.dart';
import 'package:noradio/widgets/video/videoSingleShelf.dart';
// import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../YT/mainPlayer.dart';
import '../utils.dart';
import '../widgets/bottom_menu/customBottomSheet.dart';
import '../listVideoProvider/listVideoProvider.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key, required this.fromSaved, required this.model})
      : super(key: key);

  final bool fromSaved;
  final ListVideoProviderModel model;

  @override
  State<VideoList> createState() => VideoListState();
}

class VideoListState extends State<VideoList> {
  String screenMessage = "Попробуйте ввести что нибудь в поиск";

  MainPlayer player = MainPlayer();

  // ignore: prefer_typing_uninitialized_variables
  var streamSubscription;
  bool _streamStatesListened = false;

  late SearchList searchList;
  late Video currentVideo;
  late int currentVideoIndex;
  late AudioOnlyStreamInfo audioInfo;

  bool _listExist = false;
  bool _videoIsPicked = false;
  bool _audioInfoIsCreated = false;

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
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //create own searchbar
      TextFormField(
          enableSuggestions: true,
          onFieldSubmitted: (searchQue) {
            if (widget.fromSaved == true) {
              fillListFromSavedAndSetState();
            } else {
              _fillListAndSetState(searchQue);
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
              itemCount: searchList.length,
              itemBuilder: (context, int pos) {
                return InkWell(
                    onLongPress: () => seeVideoDescription(pos),
                    onTap: () => _setCurrentAudioAndPlay(pos),
                    child: _buildVideoSingleShelfList(pos));
              }),
        ))
      else
        Text(screenMessage),
      if (_videoIsPicked && _audioInfoIsCreated)
        //CustomBottomSheet(currentVideo, currentVideoIndex, audioInfo)
        const CustomBottomSheet(showVideoShelf: true)
    ]);
  }

  void seeVideoDescription(int pos) {
    Video video = searchList.elementAt(pos);
    // widget.model.setVideo(video);
    // widget.model.setVideoIndex(pos);

    Navigator.pushNamed(context, '/videoDescription',
        arguments: {'videoDescriptionOf': video});
  }

  void _setCurrentAudioAndPlay(int pos) {
    currentVideoIndex = pos;
    _videoIsPicked = true;
    model.setVideo(searchList.elementAt(pos));
    model.setVideoIndex(pos);
    player.playAudio(pos).then((_) {
      currentVideo = player.currentVideo;
      audioInfo = player.audioInfo;
      _audioInfoIsCreated = true;
      setState(() {
        model;
        player;
        currentVideoIndex;
        audioInfo;
        currentVideo;
        _videoIsPicked;
        _audioInfoIsCreated;
      });
      _listenStreamStateAndPlayNextOnDone();
    });
  }

  VideoSingleShelf _buildVideoSingleShelfList(int pos) {
    return VideoSingleShelf(searchList.elementAt(pos));
  }

  void _listenStreamStateAndPlayNextOnDone() {
    if (_streamStatesListened == false) {
      _streamStatesListened = true;
      streamSubscription = player.getPlayerStateStream().listen((state) {
        if (state == ProcessingState.completed &&
            currentVideoIndex - 1 <= searchList.length &&
            currentVideoIndex - 1 >= 0) {
          try {
            streamSubscription.cancel();
            _streamStatesListened = false;
            _setCurrentAudioAndPlay(currentVideoIndex - 1);
          } catch (error) {
            print(error);
          }
        }
      });
    }
  }

  void _fillListAndSetState(String searchQue) {
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
