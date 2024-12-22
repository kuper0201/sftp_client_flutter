import 'package:flutter/material.dart';
import 'package:sftp_flutter/views/client_page.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';

class ServerListPage extends StatelessWidget {
  const ServerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteRepo = SFTPRepo(
      host: 'localhost',
      userName: '정준수',
      password: '0802'
    );

    final localRepo = LocalRepo();
    
    return ListView.builder(
      itemCount: 1,
      itemBuilder:(context, index) {
        return Card(
          child: ListTile(
            title: Text('localhost:22'),
            subtitle: Text('username'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ClientPage(remoteRepo: remoteRepo, localRepo: localRepo,)));
            },
          ),
        );
      }
    );
  }
}