import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// get the local Path on the device
Future<String> get _localPath async {
  //final directory = await getApplicationDocumentsDirectory();
  final directory = await (getExternalStorageDirectory());
  return directory?.path ?? '';
}

/// return a file defined by path and filename
Future<File> _localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName.txt');
}

/// read the file and return content as string
Future<List<String>> readContentLines(String fileName) async {
  try {
    final file = await _localFile(fileName);
    // Read the file
    List<String> contents = await file.readAsLines();
    // Returning the contents of the file
    return contents;
  } catch (e) {
    // If encountering an error, return
    return [];
  }
}

/// write all content as string to the file
Future<File> writeContent(String fileName, String data) async {
  final file = await _localFile(fileName);
  // Write the file
  return file.writeAsString(data);
}

/// atm only identity function
String formatFileName(String fileName, String name) {
  final List<String> fileNameList = fileName.split('/');
  return '${name}_${fileNameList[1]}_${fileNameList[2]}';
}

/// delete file and content
Future deleteContent(String fileName) async {
  final path = await _localPath;
  final dir = Directory('$path/$fileName.txt');
  try {
    dir.deleteSync(recursive: true);
  } on Exception catch (_) {
    print('File deletion not possible');
  }
}

Future<List<String>> listAllNamesInDir(Directory myDir) async {
  List<String> allMeasurementNames = [];
  await for (FileSystemEntity entity in myDir.list(followLinks: false)) {
    String localName = entity.path.split('/').last;
    allMeasurementNames.add(localName);
  }
  return allMeasurementNames;
}

int getFreeIntFromNameList(List<String> allMeasurementNames) {
  int freeInt = 0;
  while (checkFreeInt(freeInt, allMeasurementNames) == false) {
    freeInt += 1;
  }
  return freeInt;
}

bool checkFreeInt(int freeInt, List<String> allMeasurementNames) {
  for (String localName in allMeasurementNames) {
    if (localName.contains('$freeInt')) {
      return false;
    }
  }
  return true;
}

Future<Directory> checkOrCreateuserDir(String user) async {
  final path = await _localPath;
  final myDir = Directory('$path/$user');
  final bool exists = await myDir.exists();

  if (!exists) {
    await myDir.create();
  }

  return myDir;
}

Future<String> getPossibleMeasurementName(String user) async {
  Directory myDir = await checkOrCreateuserDir(user);

  final List<String> allMeasurementNames = await listAllNamesInDir(myDir);
  final int freeInt = getFreeIntFromNameList(allMeasurementNames);
  final String fileName = '$user/Messung_$freeInt';

  return fileName;
}
