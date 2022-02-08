/*
import 'package:flutter/material.dart';
import 'package:noradio/YT/mainPlayer.dart';
import 'package:noradio/pages/videoList.dart';

class VideoList extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    ScrollController  _scrollController = ScrollController(
        //this is analogue of double.infinite but chinese version
        initialScrollOffset: 1000);
    _scrollController.addListener(_scrollListener);
    return Expanded(
              child: RefreshIndicator(
            onRefresh: _refreshIndicator,
            child: ListView.builder(
                reverse: true,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: getAnc(context)?.searchList.length,
                itemBuilder: (context, int pos) {
                  return InkWell(
                      onTap: () =>  getAnc(context)?.setCurrentAudioAndPlay(pos),
                      child:  getAnc(context)?.buildVideoSingleShelfList(pos));
                }),
          ))
  }
  Future<void> _refreshIndicator() async {
     MainPlayer().getNextPage(MainPlayer().currentSearchList).then((newList) {
      if (newList == null) {
        VideoList.returnToStart();
      } else {
        _scrollController
            .jumpTo(_scrollController.positions.first.maxScrollExtent);
        setState(() {
          searchList = newList;
        });
      }
    });
  }
  _scrollListener() {}
dynamic getAnc(BuildContext context) {
    return context.findAncestorStateOfType<VideoListState>();
  }
  
} */