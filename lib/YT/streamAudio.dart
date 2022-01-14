import 'package:just_audio/just_audio.dart';

class StreamAudio extends StreamAudioSource {
  Stream<List<int>> stream;
  int contentLength;
  int streamLength;
  String contentType;

  StreamAudio(
      {required this.stream,
        required this.contentLength,
        required this.streamLength, required this.contentType});

  int getStreamLength() => streamLength;
  int getContentLength() => contentLength;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
        stream: stream,
        contentType: contentType,
        contentLength: contentLength,
        sourceLength: streamLength,
        rangeRequestsSupported: true,
        offset: start);
  }
}