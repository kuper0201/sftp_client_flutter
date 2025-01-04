import 'dart:io';

import 'package:dartssh2/dartssh2.dart';

class SFTPRepo {
  final String name;
  final String host;
  final String userName;
  final String password;
  final int port;

  SSHClient? _client;
  SftpClient? _sftp;

  SFTPRepo({required this.name, required this.host, this.port = 22, required this.userName, required this.password});

  Future<void> _connectSFTP() async {
    try {
      final socket = await SSHSocket.connect(host, port);
      
      _client = SSHClient(
        socket,
        username: userName,
        onPasswordRequest: () => password,
      );

      _sftp = await _client!.sftp();
    } catch (e) {
      print('connect sftp error: $e');
      rethrow;
    }
  }

  Future<List<SftpName>> fetchEntries(String path) async {
    try {
      if (_sftp == null) {
        await _connectSFTP();
      }
      return await _sftp!.listdir(path);
    } catch (e) {
      print('fetch entry error: $e');
      rethrow;
    }
  }

  Future<void> newDirectory(String totalPath) async {
    try {
      return await _sftp!.mkdir(totalPath);
    } catch (e) {
      print('Error on new directory: $e');
      rethrow;
    }
  }

  Future<void> remove(String totalPath, bool isFile) async {
    try {
      if(isFile) {
        return await _sftp!.remove(totalPath);
      } else {
        return await _sftp!.rmdir(totalPath);
      }
      
    } catch (e) {
      print('Error on remove: $e');
      rethrow;
    }
  }

  Future<void> rename(String totalPath, String newName) async {
    try {
      _sftp!.rename(totalPath, newName);
    } catch (e) {
      print('Error on rename: $e');
      rethrow;
    }
  }

  Future<void> download(String origin, String local) async {
    try {
      // 원격 파일 열기
      final remoteFile = await _sftp!.open(origin);

      // 로컬 파일 생성 및 스트림 준비
      final localFile = File(local);
      final localSink = localFile.openWrite();

      // 원격 파일 읽기 및 로컬 파일로 쓰기 (스트리밍)
      await for (var chunk in remoteFile.read()) {
        localSink.add(chunk);
      }

      // 스트림 닫기
      await localSink.close();
    } catch (e) {
      print('Error on download: $e');
      rethrow;
    }
  }

  Future<void> upload(String origin, String local) async {
    try {
      final file = await _sftp!.open(origin, mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
      await file.write(File(local).openRead().cast());
    } catch (e) {
      print('Error on upload: $e');
      rethrow;
    }
  }

  Future<void> copy(String from, String to) async {
    try {
      _client!.run('cp -r $from $to');
    } catch (e) {
      print('Error on copy: $e');
      rethrow;
    }
  }

  void disconnect() {
    // _sftp!.close();
    
  }
}