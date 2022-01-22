import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:noradio/YT/mainPlayer.dart';
// import 'package:permission_handler/permission_handler.dart';

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
      String mimetype = player.audioInfo.codec.mimeType.replaceAll('audio/', '');
      File file = await File(path! + '/Videos' + '/' + nameForFile + '.' + mimetype).create(recursive: true);
      IOSink fileStream = file.openWrite(mode: FileMode.write);
      player.getCurrentAudioStreamToFile().pipe(fileStream).then((_) => fileStream.flush());
    }
  } catch (exception) {
    noError = false;
    saveOrDownloadErrorMessage = exception.toString();
  } finally {
    return noError;
  }
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
// Permission per = Permission.manageExternalStorage;
// Future<bool> requestPermission() async {
//   if (await per.isGranted) {
//     return true;
//   } else {
//     PermissionStatus result = await per.request();
//     return result.isGranted;
//   }
// }
