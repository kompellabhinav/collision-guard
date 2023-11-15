import 'dart:core';

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class DataCollection {
  static Future<String> getExternalDocumentPath() async {
    // To check if storage permission is granted.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // We will not ask for permission
      print("Granting");
      await Permission.manageExternalStorage.request();
    }

    Directory directory = Directory("/storage/emulated/0/Collision_data");

    final exPath = directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath)
        .create(recursive: true); // Creates directory if it does not exist.
    return exPath;
  }

  static Future<String> get _localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<void> saveData(
    String fileName,
    List<double>? userAccelerometer,
    double latitude,
    double longitude,
    double speed,
    DateTime time,
  ) async {
    try {
      final path = await _localPath;
      File file = File('$path/$fileName');
      IOSink sink;
      // Open the file for appending
      sink = file.openWrite(mode: FileMode.append);

      // Write data to the file
      String data =
          '$time,${userAccelerometer![0]},${userAccelerometer[1]},${userAccelerometer[2]},$latitude,$longitude,$speed;';
      sink.writeln(data);
      // Close the file when you're done
      sink.close();

      print('File saved at: ${file.path}');
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}
