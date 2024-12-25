import 'package:flutter/material.dart';
import 'package:sftp_flutter/data/entry_data.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';

class RemoteViewModel with ChangeNotifier {
  final SFTPRepo sftpRepo;
  
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

  RemoteViewModel({required this.sftpRepo});

  Future<void> fetchFiles() async {
    _isLoading = true;
    _onError = null;
    _entries = [];
    notifyListeners();

    try {
      // Load file entries from server
      final entries = await sftpRepo.fetchEntries(path);
      entries.sort((a, b) => a.filename.compareTo(b.filename));
      entries.removeAt(0);

      // Convert from sftpname to EntryData
      _entries = entries.map((entry) {
        return EntryData(name: entry.filename, type: (entry.attr.isFile) ? Type.file : Type.directory, size: entry.attr.size, modifyTime: entry.attr.modifyTime, accesstime: entry.attr.accessTime);
      }).toList();
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

  void _navigateTo(EntryData entry) {
    if(entry.name == '..') {
      _currentPath.removeLast();
    } else {
      _currentPath.add(entry.name);
    }

    fetchFiles();
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

  void disconnect() {
    sftpRepo.disconnect();
  }

  @override
  void dispose() {
    sftpRepo.disconnect();
    super.dispose();
  }
}