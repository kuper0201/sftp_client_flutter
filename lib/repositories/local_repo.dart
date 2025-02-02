import 'dart:io';
import 'package:io/io.dart';

class LocalRepo {
  Future<List<FileSystemEntity>> fetchEntries(String path) async {
    try {
      final dir = Directory(path);
      return dir.listSync().toList();
    } catch (e) {
      print('Error on fetch entries: $e');
      rethrow;
    }
  }

  void newDirectory(String totalPath) {
    try {
      final dir = Directory(totalPath);
      dir.createSync();
    } catch (e) {
      print('Error on create directory: $e');
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
        return dir.deleteSync(recursive: true);
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

  Future<void> copy(String from, String to, bool isFile) async {
    try {
      if(isFile) {
        final file = File(from);
        file.copySync(to);
      } else {
        copyPathSync(from, to);
      }
    } catch (e) {
      print('Error on copy: $e');
      rethrow;
    }
  }
}