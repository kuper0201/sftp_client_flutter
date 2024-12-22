import 'dart:io';

class LocalRepo {
  Future<List<FileSystemEntity>> fetchEntries(String path) async {
    List<FileSystemEntity> entries;
    
    try {
      final dir = Directory(path);
      entries = await dir.list().toList();
    } catch (e) {
      print(e);
      rethrow;
    }

    return entries;
  }
}