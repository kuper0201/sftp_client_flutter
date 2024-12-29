import 'dart:io';

class LocalRepo {
  Future<List<FileSystemEntity>> fetchEntries(String path) async {
    List<FileSystemEntity> entries;
    
    try {
      final dir = Directory(path);
      // entries = await dir.list().toList();
      entries = dir.listSync().toList();
    } catch (e) {
      print('fetch entry error: $e');
      rethrow;
    }

    return entries;
  }

  void newDirectory(String totalPath) {
    try {
      final dir = Directory(totalPath);
      dir.createSync();
    } catch (e) {
      print('Error on new directory: $e');
      rethrow;
    }
  }
}