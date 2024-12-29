import 'package:flutter/material.dart';
import 'package:sftp_flutter/view_models/local_vm.dart';
import 'package:sftp_flutter/view_models/remote_vm.dart';

class ClientViewModel with ChangeNotifier {
  final RemoteViewModel remoteViewModel;
  final LocalViewModel localViewModel;

  ClientViewModel({required this.remoteViewModel, required this.localViewModel});

  Future<void> download() async {
    print(remoteViewModel.selectedEntries);
    print(localViewModel.path);
  }

  Future<void> upload() async {
    print(localViewModel.selectedEntries);
    print(remoteViewModel.path);
  }

  void test() {
    print(localViewModel.path);
    print(remoteViewModel.path);
  }
}