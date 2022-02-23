import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ListVideoProviderModel extends ChangeNotifier {
  late Video video;
  late int index;
  late AudioOnlyStreamInfo streamInfo;

  void setVideo(newVideo) {
    video = newVideo;
    if(video!= newVideo) ()=> notifyListeners();
  }

  void setVideoIndex(int pos) {
    index = pos;
    notifyListeners();
  }

  void setAudioStreamInfo(AudioOnlyStreamInfo info) {
    streamInfo = info;
    if(streamInfo!= info) ()=> notifyListeners();
  }
}
