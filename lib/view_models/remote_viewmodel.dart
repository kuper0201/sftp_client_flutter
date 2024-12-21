import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:sftp_flutter/models/remote_model.dart';

// ViewModel
class RemoteViewModel with ChangeNotifier {
  late RemoteModel model;
  
  List<SftpName> _entries = [];
  final List<String> _currentPath = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<SftpName> get entries => _entries;
  String get path => "/${_currentPath.join('/')}";

  RemoteViewModel() {
    model = RemoteModel();
    fetch();
  }

  void fetch() {
    _isLoading = true;
    notifyListeners();

    model.fetchEntries(path).then(
      (data) {
        _entries = data;
        _entries.sort((a, b) => a.filename.compareTo(b.filename));
        _entries.removeAt(0);
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
      }
    );
  }

  void moveDirectory(String dir) {
    if(!_isLoading) {
      _isLoading = true;
      if(dir == '..') {
        _currentPath.removeLast();
      } else {
        _currentPath.add(dir);
      }

      fetch();
    }
  }
}