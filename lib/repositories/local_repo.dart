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

  Future<void> remove(String totalPath, bool isFile) async {
    try {
      if(isFile) {
        final file = File(totalPath);
        return file.deleteSync();
      } else {
        final dir = Directory(totalPath);
        return dir.deleteSync();
      }
    } catch (e) {
      print('Error on remove: $e');
      rethrow;
    }
  }

  Future<void> rename(String totalPath, String newName, bool isFile) async {
    try {
      if(isFile) {
        final file = File(totalPath);
        file.renameSync(newName);
      } else {
        final dir = Directory(totalPath);
        dir.renameSync(newName);
      }
    } catch (e) {
      print('Error on rename: $e');
      rethrow;
    }
  }
}