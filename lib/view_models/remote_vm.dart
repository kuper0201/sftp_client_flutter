import 'package:flutter/material.dart';
import 'package:sftp_flutter/data/entry_data.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';

class RemoteViewModel with ChangeNotifier {
  final SFTPRepo sftpRepo;
  
  List<EntryData> _entries = [];
  List<EntryData> get entries => _entries;

  final List<String> _currentPath = [];
  String get path => "/${_currentPath.join('/')}";

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  void navigateTo(String dir) {
    if(dir == '..') {
      _currentPath.removeLast();
    } else {
      _currentPath.add(dir);
    }

    fetchFiles();
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