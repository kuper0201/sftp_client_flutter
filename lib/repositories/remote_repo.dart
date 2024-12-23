import 'package:dartssh2/dartssh2.dart';

class SFTPRepo {
  final String host;
  final String userName;
  final String password;
  final int port;

  SftpClient? _sftp;

  SFTPRepo({required this.host, this.port = 22, required this.userName, required this.password});

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

  void disconnect() {
    // _sftp!.close();
  }
}