import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/servers_vm.dart';
import 'package:sftp_flutter/screens/client_page.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';

class ServerListPage extends StatelessWidget {
  const ServerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServersViewModel>(
      builder: (context, model, _) {
        return ListView.builder(
          itemCount: model.servers.length,
          itemBuilder:(context, index) {
            String host = model.servers[index].host;
            String userName = model.servers[index].userName;
            String password = model.servers[index].password;
            int port = model.servers[index].port;

            return Card(
              child: ListTile(
                title: Text(host),
                subtitle: Text(userName),
                onTap: () {
                  final remoteRepo = SFTPRepo(host: host, userName: userName, password: password, port: port);
                  final localRepo = LocalRepo();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClientPage(remoteRepo: remoteRepo, localRepo: localRepo,)));
                },
              ),
            );
          }
        );      
      },
    );
  }
}