import 'package:dartssh2/dartssh2.dart';

class SFTPRepo {
  final String name;
  final String host;
  final String userName;
  final String password;
  final int port;

  SftpClient? _sftp;

  SFTPRepo({required this.name, required this.host, this.port = 22, required this.userName, required this.password});

  Future<void> _connectSFTP() async {
    try {
      final socket = await SSHSocket.connect(host, port);
      
      SSHClient client = SSHClient(
        socket,
        username: userName,
        onPasswordRequest: () => password,
      );

      _sftp = await client.sftp();
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

  void disconnect() {
    // _sftp!.close();
  }
}