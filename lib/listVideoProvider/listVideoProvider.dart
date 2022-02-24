import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ListVideoProviderModel extends ChangeNotifier {
  Video? video;
  int? index;
  AudioOnlyStreamInfo? streamInfo;

  void setVideo(newVideo) {
    video = newVideo;
    if (video != newVideo) () => notifyListeners();
  }

  void setVideoIndex(int pos) {
    index = pos;
    if (index != pos) () => notifyListeners();
  }

  void setAudioStreamInfo(AudioOnlyStreamInfo info) {
    streamInfo = info;
    if (streamInfo != info) () => notifyListeners();
  }

  bool isVideoExist() {
    if (video == null) {
      return false;
    } else {
      return true;
    }
  }
}
