import 'package:dartssh2/dartssh2.dart';
import 'package:sftp_flutter/data/entry_data.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';
import 'package:sftp_flutter/view_models/base_vm.dart';

class RemoteViewModel extends BaseViewModel {
  final SFTPRepo sftpRepo;

  RemoteViewModel({required this.sftpRepo});

  @override
  Future<void> fetchFiles() async {
    isLoading = true;
    onError = null;
    entries = [];
    notifyListeners();

    try {
      // Load file entries from server
      List<SftpName> _entries = await sftpRepo.fetchEntries(path);
      _entries.sort((a, b) => a.filename.compareTo(b.filename));
      _entries.removeAt(0);

      // Convert from sftpname to EntryData
      entries = _entries.map((entry) {
        return EntryData(name: entry.filename, type: (entry.attr.isFile) ? Type.file : Type.directory, size: entry.attr.size, modifyTime: entry.attr.modifyTime, accesstime: entry.attr.accessTime);
      }).toList();
    } catch (e) {
      onError = e.toString();
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
      currentPath.add(entry.name);
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

  @override
  void newDirectory(String name) async {
    await sftpRepo.newDirectory("$path/$name");
    await fetchFiles();
  }

  @override
  void onDelete() async {
    for(final entry in selectedEntries) {
      final totalPath = "$path/${entry.name}";
      await sftpRepo.remove(totalPath, entry.type == Type.file);
    }

    super.onDelete();
  }

  @override
  void onCopy() {
    print("remote copy");
  }

  @override
  void onCut() {
    print("remote cut");
  }

  @override
  void onRename(String newName) {
    for(final entry in selectedEntries) {
      final totalPath = "$path/${entry.name}";
      final newNameTotalPath = "$path/$newName";
      sftpRepo.rename(totalPath, newNameTotalPath);
    }

    super.onRename(newName);
  }
  
  void downloadFile(String downloadPath) {
    for(final entry in selectedEntries) {
      final origin = '$path/${entry.name}';
      sftpRepo.download(origin, "$downloadPath/${entry.name}");
    }
  }

  void uploadFile(Set<EntryData> entries, String localPath) {
    for(final entry in entries) {
      final originPath = "$path/${entry.name}";
      final localFilePath = "$localPath/${entry.name}";
      sftpRepo.upload(originPath, localFilePath);
    }
  }
}