import 'package:flutter/material.dart';
import 'package:sftp_flutter/data/entry_data.dart';

abstract class BaseViewModel with ChangeNotifier {
  List<EntryData> _entries = [];
  List<EntryData> get entries => _entries;
  set entries(List<EntryData> val) => _entries = val;

  final List<String> _currentPath = [];
  List<String> get currentPath => _currentPath;
  String get path => "/${_currentPath.join('/')}";

  final Set<EntryData> _selectedEntries = {};
  Set<EntryData> get selectedEntries => _selectedEntries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) => _isLoading = val;

  bool _isSelectMode = false;
  bool get isSelectMode => _isSelectMode;
  set isSelectMode(bool val) => _isSelectMode = val;

  String? _onError;
  String? get onError => _onError;
  set onError(String? val) => _onError = val;

  String _serverName = "Local";
  String get serverName => _serverName;
  set serverName(String val) => _serverName = val;

  Future<void> fetchFiles();

  void onTap(int index) {
    final entry = _entries[index];

    if(!_isSelectMode && (entry.type == Type.directory)) {
      navigateTo(_entries[index]);
    }

    if(_isSelectMode) {
      _selectEntry(entry);
    }
  }

  void onLongPress(int index) {
    _selectEntry(entries[index]);
  }

  void navigateTo(EntryData entry);
  
  void _selectEntry(EntryData entry) {
    if(selectedEntries.contains(entry)) {
      entry.isSelected = false;
      selectedEntries.remove(entry); 
    } else {
      entry.isSelected = true;
      selectedEntries.add(entry);
    }

    isSelectMode = selectedEntries.isNotEmpty;
    
    notifyListeners();
  }
  
  void unselectAll() {
    for(final entry in selectedEntries) {
      entry.isSelected = false;
    }

    selectedEntries.clear();
    isSelectMode = selectedEntries.isNotEmpty;

    notifyListeners();
  }

  void newDirectory(String name);
  void onDelete();
  void onCopy();
  void onCut();
  void onRename();
}