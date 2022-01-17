import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:noradio/YT/mainPlayer.dart';
// import 'package:permission_handler/permission_handler.dart';


Future<bool> saveToDir(String nameForFile, Stream streamToFlush) async {
  bool noError = true;
  try {
    var directory = await getExternalStorageDirectory();
    var appDocPath = directory!.path;
    String mimetype =
        MainPlayer().streamInfo.codec.mimeType.replaceAll('audio/', '');
    var file =
        await File(appDocPath + '/Videos' + '/' + nameForFile + '.' + mimetype)
            .create(recursive: true);

    var fileStream = file.openWrite();
    await streamToFlush.pipe(fileStream);

    await fileStream.flush().catchError((error) {
      print(error + '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      noError = false;
    });
    await fileStream.done.then((value) async { await fileStream.close(); });
  } catch (exception) {
    print(exception.toString() + '!!!!!!!!!!!1');
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
// Permission per = Permission.manageExternalStorage;
// Future<bool> requestPermission() async {
//   if (await per.isGranted) {
//     return true;
//   } else {
//     PermissionStatus result = await per.request();
//     return result.isGranted;
//   }
// }