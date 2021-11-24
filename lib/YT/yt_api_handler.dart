import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class StreamAudio extends StreamAudioSource {
  Stream<List<int>> stream;
  int contentLength;
  int streamlenght;

  StreamAudio({
    required this.stream,
    required this.contentLength,
    required this.streamlenght
  });

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
        stream: stream,
        contentType: 'mp4',
        contentLength: contentLength,
        sourceLength: streamlenght,
        offset: 0);
  }
}

class MainPlayer {

  static final YoutubeExplode _youhandler = YoutubeExplode();
  static final AudioPlayer _audioPlayer = AudioPlayer();

  late StreamManifest streamManifest;
  late Stream<List<int>> stream;
  late AudioOnlyStreamInfo streamInfo;

  AudioPlayer get audioPlayer => _audioPlayer;
  YoutubeExplode get youhandler => _youhandler;


  Future<SearchList?> searchVideos(String searchQuery) async {

    try {
      SearchList list = await youhandler.search.getVideos(searchQuery);
      return list;
    }
    catch(error) {
      print('Возникла ошибка в методе MainPlayer.searchVideos');
      print(error);}
    }

  Image getVideoThumbnail(String videoID) {
      return Image.network("https://img.youtube.com/vi/" + videoID + "/0.jpg");
    }

  void playVideo(String videoID) async {

    streamManifest = await youhandler.videos.streamsClient.getManifest(videoID);
    streamInfo = streamManifest.audioOnly.withHighestBitrate();
    stream = youhandler.videos.streamsClient.get(streamInfo);
   

    AudioSource source = StreamAudio(
        stream: stream,
        streamlenght: streamInfo.size.totalBytes,
        contentLength: streamInfo.size.totalBytes);

    audioPlayer.setAudioSource(source);
    audioPlayer.play();
  }
}





