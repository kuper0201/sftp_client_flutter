import 'package:dartssh2/dartssh2.dart';

class RemoteModel {
  SSHClient? _client;
  SftpClient? _sftp;

  Future<void> _connectSSH() async {
    // SSH 연결 설정
    _client = SSHClient(
      await SSHSocket.connect('localhost', 22),
      username: '정준수',
      onPasswordRequest: () => '0802',
    );
  }

  Future<void> _connectSFTP() async {
    if(_client == null) {
      await _connectSSH();
    }
    _sftp = await _client!.sftp();
  }

  Future<List<SftpName>> fetchEntries(String path) async {
    if(_sftp == null) {
      await _connectSFTP();
    }
    
    return await _sftp!.listdir(path);
  }
}