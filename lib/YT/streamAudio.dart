// import 'dart:io';

import 'package:just_audio/just_audio.dart';
// import 'package:noradio/utils.dart';

class StreamAudio extends LockCachingAudioSource {
  Stream<List<int>> stream;
  int contentLength;
  int streamLength;
  String contentType;

  StreamAudio(
      {required this.stream,
      required this.contentLength,
      required this.streamLength,
      required this.contentType,
      required uri})
      : super(uri);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
        stream: stream,
        contentType: contentType,
        contentLength: end.runtimeType == int ? end : contentLength,
        sourceLength: streamLength,
        rangeRequestsSupported: true,
        offset: start);
  }
}