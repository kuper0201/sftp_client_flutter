import 'dart:io';

import 'package:sftp_flutter/data/entry_data.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/view_models/base_vm.dart';

class LocalViewModel extends BaseViewModel {
  final LocalRepo localRepo;

  LocalViewModel({required this.localRepo}) : super(serverName: "Local");

  @override
  Future<void> fetchFiles() async {
    await super.fetchFiles();
    
    isLoading = true;
    onError = null;
    entries = [];
    notifyListeners();

    try {
      List<FileSystemEntity> _entries = await localRepo.fetchEntries(path);
      if(_entries.isNotEmpty) {
        _entries.sort((a, b) => a.path.compareTo(b.path));
        _entries.removeAt(0);

        // Convert from FileSystemEntityType to EntryData
        entries = _entries.map((entry) {
          final spt = entry.path.split("/");
          final name = spt[spt.length - 1];
          return EntryData(name: name, absolutePath: entry.path, type: (entry.statSync().type == FileSystemEntityType.file) ? Type.file : Type.directory, size: entry.statSync().size);
        }).toList();
      }
      entries.insert(0, EntryData(name: "..", absolutePath: path, type: Type.directory));
    } catch (e) {
      onError = e.toString();
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void navigateTo(EntryData entry) {
    if(entry.name == '..') {
      currentPath.removeLast();
    } else {
      final d = entry.name.split("/");

      currentPath.add(d[d.length - 1]);
    }

    fetchFiles();
  }

  @override
  void newDirectory(String name) async {
    localRepo.newDirectory("$path/$name");
    await fetchFiles();
  }

  @override
  void onDelete() async {
    for(final entry in selectedEntries) {
      final totalPath = "$path/${entry.name}";
      await localRepo.remove(totalPath, entry.type == Type.file);
    }

    super.onDelete();
  }

  @override
  void onPaste() async {
    for(final entry in selectedEntries) {
      final toAbsolutePath = "$path/${entry.name}";
      await localRepo.copy(entry.absolutePath, toAbsolutePath, (entry.type == Type.file));
    }

    // await fetchFiles();
    super.onPaste();
  }

  @override
  void onCut() {
    print("local cut");
  }

  @override
  void onRename(String newName) {
    for(final entry in selectedEntries) {
      final totalPath = "$path/${entry.name}";
      final newNameTotalPath = "$path/$newName";
      localRepo.rename(totalPath, newNameTotalPath, entry.type == Type.file);
    }

    super.onRename(newName);
  }
}