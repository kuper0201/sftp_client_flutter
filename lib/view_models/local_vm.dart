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

  final Set<EntryData> _selectedEntries = {};
  Set<EntryData> get selectedEntries => _selectedEntries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSelectMode = false;
  bool get isSelectMode => _isSelectMode;

  String? _onError;
  String? get onError => _onError;

  String _serverName = "Local";
  String get serverName => _serverName;

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

  void onTap(int index) {
    final entry = _entries[index];

    if(!_isSelectMode && (entry.type == Type.directory)) {
      _navigateTo(_entries[index]);
    }

    if(_isSelectMode) {
      _selectEntry(entry);
    }
  }

  void onLongPress(int index) {
    _selectEntry(_entries[index]);
  }

  void _selectEntry(EntryData entry) {
    if(_selectedEntries.contains(entry)) {
      entry.isSelected = false;
      _selectedEntries.remove(entry); 
    } else {
      entry.isSelected = true;
      _selectedEntries.add(entry);
    }

    _isSelectMode = _selectedEntries.isNotEmpty;
    
    notifyListeners();
  }

  void unselectAll() {
    for(final entry in _selectedEntries) {
      entry.isSelected = false;
    }

    _selectedEntries.clear();
    _isSelectMode = _selectedEntries.isNotEmpty;

    notifyListeners();
  }

  void _navigateTo(EntryData entry) {
    if(entry.name == '..') {
      _currentPath.removeLast();
    } else {
      final d = entry.name.split("/");

      _currentPath.add(d[d.length - 1]);
    }

    fetchFiles();
  }

  void onDelete() {
    print("local delete");
  }

  void onCopy() {
    print("local copy");
  }

  void onCut() {
    print("local cut");
  }

  void onRename() {
    print("local rename");
  }
}