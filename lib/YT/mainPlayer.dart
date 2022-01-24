import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// This is model for audio focused to play in stream&live mode

class MainPlayer {
  static final MainPlayer _mainPlayer = MainPlayer._privateConstructor();
  MainPlayer._privateConstructor();
  factory MainPlayer() => _mainPlayer;

  static final YoutubeExplode _youHandler = YoutubeExplode();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;
  YoutubeExplode get youHandler => _youHandler;

  // Youtube explode retrieved from and for YTexplode - data
  late StreamManifest streamManifest;
  late Stream<List<int>> stream;
  late AudioOnlyStreamInfo audioInfo;

  // current track info
  late String videoID;
  late Duration? videoDuration;
  late Video currentVideo;
  late AudioSource source;
  late int contentLength;
  late int streamLength;

  // current search list returned by search request from YouTubeExplode
  late String searchQuery;
  late SearchList currentSearchList;
  bool searchListIsCreated = false;

  // stream ticker for handling current time played track
  late Stream<Duration> streamTicker;
  bool _streamTickerExist = false;

  //Debug
  late String errorSearchAudio;

  Future<SearchList?> searchAudio(String searchQuery) async {
    currentSearchList = await youHandler.search.getVideos(searchQuery);
    try {
      if (currentSearchList.runtimeType == SearchList &&
          currentSearchList.isNotEmpty) {
        searchListIsCreated = true;
        return currentSearchList;
      }
    } catch (error) {
      errorSearchAudio = error.toString();
    }
  }

  Future<SearchList?> getNextPage(SearchList searchList) async {
    SearchList? list = await searchList.nextPage();
    if (list.runtimeType == SearchList && list!.isNotEmpty) {
      return list;
    } else {
      return null;
    }
  }

  Future<void> pause() => audioPlayer.pause();
  Future<void> play() => audioPlayer.play();
  Future<void> setVolume(double whatVolume) =>
      audioPlayer.setVolume(whatVolume);
  Duration? getVideoDuration() => videoDuration;
  void setVideoDuration(Duration whatDuration) => videoDuration = whatDuration;
  Video getCurrentVideo() => currentVideo;
  void setCurrentVideo(Video currentVideo) => this.currentVideo = currentVideo;

  Future<void> playAudio(String videoID) async {
    this.videoID = videoID;
    streamManifest = await youHandler.videos.streamsClient.getManifest(videoID);
    audioInfo = streamManifest.audioOnly.withHighestBitrate();
    // stream = youHandler.videos.streamsClient.get(audioInfo).asBroadcastStream().publishReplay();
    // int  streamLength = audioInfo.bitrate.bitsPerSecond * currentVideo.duration!.inSeconds;
    // source = StreamAudio(
    //     stream: stream,
    //     streamLength: streamLength,
    //     contentLength: audioInfo.size.totalBytes,
    //     contentType: audioInfo.codec.toString(),
    //     uri: audioInfo.url);
    audioPlayer.setUrl(audioInfo.url.toString(), preload: false);
    // videoDuration = await audioPlayer.setAudioSource(source, preload: true);
    audioPlayer.play();
  }

  Stream<List<int>> getCurrentAudioStreamToFile() {
    return stream = youHandler.videos.streamsClient.get(audioInfo);
  }

  void playPosition(int whatPosition) async {
    audioPlayer
        .pause()
        .then((_) => audioPlayer.seek(Duration(seconds: whatPosition)))
        .then((_) => audioPlayer.play());
  }

  Stream<Duration> getPositionedStream() {
    if (_streamTickerExist) {
      return streamTicker;
    } else {
      _streamTickerExist = true;
      return streamTicker = MainPlayer()
          .audioPlayer
          .createPositionStream(
              minPeriod: const Duration(seconds: 1),
              maxPeriod: const Duration(seconds: 1),
              steps: currentVideo.duration!.inSeconds)
          .asBroadcastStream();
    }
  }
}
