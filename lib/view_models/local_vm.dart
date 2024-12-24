import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sftp_flutter/data/entry_data.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';

class LocalViewModel with ChangeNotifier {
  final LocalRepo localRepo;
  
  List<EntryData> _entries = [];
  List<EntryData> get entries => _entries;

  final List<String> _currentPath = [];
  String get path => "/${_currentPath.join('/')}";

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _onError;
  String? get onError => _onError;

  LocalViewModel({required this.localRepo});

  Future<void> fetchFiles() async {
    _isLoading = true;
    _onError = null;
    _entries = [];
    notifyListeners();

    try {
      final entries = await localRepo.fetchEntries(path);
      if(entries.isNotEmpty) {
        entries.sort((a, b) => a.path.compareTo(b.path));
        entries.removeAt(0);

        // Convert from FileSystemEntityType to EntryData
        _entries = entries.map((entry) {
          final spt = entry.path.split("/");
          final name = spt[spt.length - 1];
          return EntryData(name: name, type: (entry.statSync().type == FileSystemEntityType.file) ? Type.file : Type.directory, size: entry.statSync().size);
        }).toList();
      }
      _entries.insert(0, EntryData(name: "..", type: Type.directory));
    } catch (e) {
      _onError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateTo(String dir) {
    if(dir == '..') {
      _currentPath.removeLast();
    } else {
      final d = dir.split("/");

      _currentPath.add(d[d.length - 1]);
    }

    fetchFiles();
  }
}