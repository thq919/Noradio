import 'dart:io';

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
    required this.streamlenght,
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

Future<void> fun() async {
  try {
    var yt = YoutubeExplode();

    var streamManifest =
        await yt.videos.streamsClient.getManifest('Dpp1sIL1m5Q');
    var streamInfo = streamManifest.audioOnly.withHighestBitrate();
    var stream = yt.videos.streamsClient.get(streamInfo);


    var player = AudioPlayer();
    var audiosource = StreamAudio(
        stream: stream,
        streamlenght: streamInfo.size.totalBytes,
        contentLength: streamInfo.size.totalBytes);
    AudioSource source = audiosource;
    player.setAudioSource(source);
    player.play();

    // await audioPlayer.setUrl(file.path, preload: false);
    // await stream.pipe(fileStream).whenComplete(() => audioPlayer.play());

  } catch (e) {
    print('пиздец');
    print(e);
  }
}



