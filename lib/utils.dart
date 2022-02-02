import 'dart:io';

import 'package:noradio/YT/mainPlayer.dart';
import 'package:path_provider/path_provider.dart';

// debug

String? saveOrDownloadErrorMessage;
String? get UtilsDebugMessage => saveOrDownloadErrorMessage;

Future<bool> saveToDir(String nameForFile) async {
  bool noError = true;
  try {
    Directory? directory = await getExternalStorageDirectory();
    MainPlayer player = MainPlayer();
    String? path = directory?.path;
    if (path.runtimeType == String) {
      String mimetype =
          player.audioInfo.codec.mimeType.replaceAll('audio/', '');
      File file =
          await File(path! + '/Videos' + '/' + nameForFile + '.' + mimetype)
              .create(recursive: true);
      IOSink fileStream = file.openWrite(mode: FileMode.write);
      player
          .getCurrentAudioStreamToFile()
          .pipe(fileStream)
          .then((_) => fileStream.flush());
    }
  } catch (exception) {
    noError = false;
    saveOrDownloadErrorMessage = exception.toString();
  }
  return noError;
}

Future<List<File>> getAll() async {
  List<File> list = List.empty(growable: true);
  var directory = await getApplicationDocumentsDirectory();
  var appDocPath = directory.path;
  var fileVideos = Directory(appDocPath + '/Videos');
  fileVideos.list(recursive: true, followLinks: true).listen((event) {
    list.add(event as File);
  });
  return list;
}

Future<Uri?> getPathToSave() async {
  Directory? string = await getExternalStorageDirectory();
  String path = string!.path;
  return Uri.parse(path);
}
