import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';
import 'package:sftp_flutter/view_models/servers_vm.dart';
import 'package:sftp_flutter/screens/client_page.dart';
import 'package:sftp_flutter/widgets/add_server_dialog.dart';
import 'package:sftp_flutter/widgets/long_click_dialog.dart';

class SFTPClient extends StatelessWidget {
  const SFTPClient({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServersViewModel()..getAllServers(),
      child: MaterialApp(
        title: 'SFTP Client',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: Consumer<ServersViewModel>(
          builder: (context, viewModel, _) {
            return Scaffold(
              appBar: AppBar(title: Text("SFTP Client")),
              floatingActionButton: FloatingActionButton(
                shape: const CircleBorder(),
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddServerDialog()
                  );
                }
              ),
              body: ListView.builder(
                itemCount: viewModel.servers.length,
                itemBuilder:(context, index) {
                  String name = viewModel.servers[index].name;
                  String host = viewModel.servers[index].host;
                  String userName = viewModel.servers[index].userName;
                  String password = viewModel.servers[index].password;
                  int port = viewModel.servers[index].port;

                  return Card(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(host),
                      onTap: () {
                        final remoteRepo = SFTPRepo(name: name, host: host, userName: userName, password: password, port: port);
                        final localRepo = LocalRepo();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ClientPage(remoteRepo: remoteRepo, localRepo: localRepo,)));
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => ServerLongClickDialog(name: name, host: host, userName: userName, password: password, port: port)
                        );
                      },
                    ),
                  );
                }
              )
            );
          }
        )
      )
    );
  }
}