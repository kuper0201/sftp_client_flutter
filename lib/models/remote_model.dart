import 'package:dartssh2/dartssh2.dart';

class RemoteModel {
  SSHClient? _client;
  SftpClient? _sftp;

  Future<void> _connectSSH() async {
    try {
      // SSH 연결 설정
      _client = SSHClient(
        await SSHSocket.connect('localhost', 22),
        username: '정준수',
        onPasswordRequest: () => '0802',
      );
    } catch (e) {
      print('SSH 연결 오류: $e');
      rethrow; // 필요시 호출자에게 예외를 전달
    }
  }

  Future<void> _connectSFTP() async {
    try {
      if (_client == null) {
        await _connectSSH();
      }
      _sftp = await _client!.sftp();
    } catch (e) {
      print('SFTP 연결 오류: $e');
      rethrow; // 필요시 호출자에게 예외를 전달
    }
  }

  Future<List<SftpName>> fetchEntries(String path) async {
    try {
      if (_sftp == null) {
        await _connectSFTP();
      }
      return await _sftp!.listdir(path);
    } catch (e) {
      print('SFTP 목록 가져오기 오류: $e');
      rethrow;
    }
  }
}
