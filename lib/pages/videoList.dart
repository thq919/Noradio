import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noradio/widgets/searchBar/searchbarprovider.dart';
import 'package:noradio/widgets/searchBar/searchBar.dart';
import 'package:noradio/widgets/video/videoSingleShelf.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../YT/mainPlayer.dart';
import '../utils.dart';
import '../widgets/bottom_menu/customBottomSheet.dart';

class VideoList extends StatefulWidget {
  VideoList({Key? key, required this.fromSaved}) : super(key: key);
  bool fromSaved = false;

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
    return ChangeNotifierProvider(
      create: (context) => SearchBarModel(),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //create own searchbar
        const SearchBar(),
        //      TextFormField(
        //          enableSuggestions: true,
        //          onFieldSubmitted: (searchQue) {
        //            if (widget.fromSaved == true) {
        //              fillListFromSavedAndSetState();
        //            } else {
        //              fillListAndSetState(searchQue);
        //            }
        //          }),
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
                      onTap: () => setCurrentAudioAndPlay(pos),
                      child: buildVideoSingleShelfList(pos));
                }),
          ))
        else
          Text(screenMessage),
        if (_videoIsPicked && _audioInfoIsCreated)
          CustomBottomSheet(currentVideo, currentVideoIndex, audioInfo)
      ]),
    );
  }

  void setCurrentAudioAndPlay(int pos) {
    currentVideoIndex = pos;
    player.currentVideo = searchList.elementAt(pos);
    currentVideo = player.currentVideo;
    _videoIsPicked = true;
    player.playAudio(pos, currentVideo.id.toString()).then((_) {
      audioInfo = player.audioInfo;
      _audioInfoIsCreated = true;
      player.setVideoDuration(currentVideo.duration!);
      player.setCurrentVideo(currentVideo);
      setState(() {
        player;
        currentVideoIndex;
        audioInfo;
        currentVideo;
        _videoIsPicked;
        _audioInfoIsCreated;
      });
      listenStreamStateAndPlayNextOnDone();
    });
  }

  VideoSingleShelf buildVideoSingleShelfList(int pos) {
    return VideoSingleShelf(searchList.elementAt(pos));
  }

  void listenStreamStateAndPlayNextOnDone() {
    if (_streamStatesListened == false) {
      _streamStatesListened = true;
      streamSubscription = player.getPlayerStateStream().listen((state) {
        if (state == ProcessingState.completed &&
            currentVideoIndex - 1 <= searchList.length &&
            currentVideoIndex - 1 >= 0) {
          try {
            streamSubscription.cancel();
            _streamStatesListened = false;
            setCurrentAudioAndPlay(currentVideoIndex - 1);
          } catch (error) {
            print(error);
          }
        }
      });
    }
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
