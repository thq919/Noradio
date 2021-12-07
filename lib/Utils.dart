import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<bool> saveToDir(String nameForFile, Stream streamToFlush) async {
  try {
    var directory = await getApplicationDocumentsDirectory();
    var appDocPath = directory.path;
    var file = File(appDocPath + '/YTis' + '/' + nameForFile);
    var fileStream = file.openWrite();
    await streamToFlush.pipe(fileStream);
    await fileStream.flush();
    await fileStream.done;
  } catch (exception) {
    print(exception);
    return (false);
  } finally {
    return (true);
  }
}
