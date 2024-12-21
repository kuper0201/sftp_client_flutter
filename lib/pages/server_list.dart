import 'package:flutter/material.dart';
import 'package:sftp_flutter/pages/remote_page.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RemotePage(title: 'Server1')));
      },
      child: Text("test")
    );
  }
}