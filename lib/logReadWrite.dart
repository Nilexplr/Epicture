import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LogRW {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/login.boss');
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;

      // Read the file.
      if ( !await file.exists()) {
        return null;
      }
      String contents = await file.readAsString();

      return contents;
    } on Error {
      return null;

    } on Exception {
      return null;

    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  Future<Null> deleteFile() async {
    final file = await _localFile;

    file.deleteSync();
  }

}