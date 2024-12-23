import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServersModel {
  final storage = FlutterSecureStorage();
  final key_for_keys = 'sftp_keys';

  Future<List<dynamic>> getAllServerKeys() async {
    String? jsonString = await storage.read(key: key_for_keys);
    if(jsonString != null) {
      return jsonDecode(jsonString);
    }

    return [];
  }

  Future<void> updateAllServerKey(String key) async {
    String? jsonString = await storage.read(key: key_for_keys);
    
    List<dynamic> lst;
    if(jsonString != null) {
      lst = jsonDecode(jsonString);
    } else {
      lst = [];
    }

    if(lst.contains(key)) {
      print("contain");
    } else {
      lst.add(key);
    }

    await storage.write(key: key_for_keys, value: jsonEncode(lst));
  }

  /// JSON 데이터를 저장하는 함수
  Future<void> newServer(String key, Map<String, dynamic> jsonData) async {
    String jsonString = jsonEncode(jsonData);
    await storage.write(key: key, value: jsonString);
  }

  /// JSON 데이터를 읽는 함수
  Future<Map<String, dynamic>?> getServer(String key) async {
    String? jsonString = await storage.read(key: key);
    
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }
}