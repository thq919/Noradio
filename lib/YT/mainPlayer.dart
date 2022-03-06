// ignore_for_file: unnecessary_this

import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:noradio/main.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

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
  late int currentIndex;
  late AudioSource source;
  late int contentLength;
  late int streamLength;

  // current search list returned by search request from YouTubeExplode
  late String searchQuery;
  late SearchList currentSearchList;
  bool searchListIsCreated = false;

  // comments of selected Video choosed to get comments
  late CommentsList commentsList;

  // stream ticker for handling current time played track
  late Stream<Duration> streamTicker;
  bool _streamTickerExist = false;

  // stream for
  late Stream streamStates;

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
      this.currentSearchList = list;
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

  Video getCurrentVideo() => currentVideo;

  void setCurrentVideo(Video currentVideo, [int? pos]) async {
    this.currentVideo = currentVideo;
    if (pos != null) {
      model.setVideoIndex(pos);
      this.currentIndex = pos;
    }
    streamManifest = await youHandler.videos.streamsClient.getManifest(videoID);
    audioInfo = streamManifest.audioOnly.withHighestBitrate();
    model.setAudioStreamInfo(audioInfo);

    model.setVideo(currentVideo);
  }

  Future<void> playAudio(int pos) async {
    this.videoID = currentSearchList.elementAt(pos).id.toString();
    this.currentIndex = pos;

    streamManifest = await youHandler.videos.streamsClient.getManifest(videoID);

    audioInfo = streamManifest.audioOnly.withHighestBitrate();
    model.setAudioStreamInfo(audioInfo);
    Video currentVideo = currentSearchList.elementAt(pos);
    this.currentVideo = currentVideo;
    await audioPlayer
        .setUrl(audioInfo.url.toString(), preload: true)
        .then((videoDuration) => this.videoDuration = videoDuration);
    setCurrentVideo(currentVideo);

    model.setVideoIndex(pos);
    model.setVideo(currentVideo);

    audioPlayer.play();
  }

  Stream<ProcessingState> getPlayerStateStream() {
    return streamStates = audioPlayer.processingStateStream.asBroadcastStream();
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

  Future<CommentsList?> getComments(Video video) {
    return youHandler.videos.comments.getComments(video);
  }

  Future<CommentsList?> getCommentaryNextPage(CommentsList commnestList) async {
    CommentsList? list = await commnestList.nextPage();
    if (list.runtimeType == CommentsList && list!.isNotEmpty) {
      this.commentsList = list;
      return list;
    } else {
      return null;
    }
  }
}

// example of internal source playing
// stream = youHandler.videos.streamsClient.get(audioInfo).asBroadcastStream().publishReplay();
// int  streamLength = audioInfo.bitrate.bitsPerSecond * currentVideo.duration!.inSeconds;
// source = StreamAudio(
//     stream: stream,
//     streamLength: streamLength,
//     contentLength: audioInfo.size.totalBytes,
//     contentType: audioInfo.codec.toString(),
//     uri: audioInfo.url);
// videoDuration = await audioPlayer.setAudioSource(source, preload: true);
