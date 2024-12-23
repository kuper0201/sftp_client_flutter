import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';
import 'package:sftp_flutter/view_models/servers_vm.dart';
import 'package:sftp_flutter/screens/client_page.dart';

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
          builder: (context, model, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text("SFTP Client"),
              ),
              floatingActionButton: FloatingActionButton(
                shape: const CircleBorder(),
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController name_tc = TextEditingController();
                      TextEditingController host_tc = TextEditingController();
                      TextEditingController port_tc = TextEditingController();
                      TextEditingController user_name_tc = TextEditingController();
                      TextEditingController password_tc = TextEditingController();

                      return AlertDialog(
                        title: Text("New Server"),
                        content: SingleChildScrollView(
                          child: Column(
                            spacing: 10.0,
                            children: [
                              TextField(
                                controller: name_tc,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Server Name',
                                )
                              ),
                              Row(
                                spacing: 10.0,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: TextField(
                                      controller: host_tc,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Server Host',
                                      )
                                    )
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: TextField(
                                      controller: port_tc,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Port',
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              TextField(
                                controller: user_name_tc,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User Name',
                                )
                              ),
                              TextField(
                                controller: password_tc,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                )
                              )
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            child: Text("Cancel")
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await model.addServer(name_tc.text, host_tc.text, user_name_tc.text, password_tc.text, int.parse(port_tc.text));
                              if(context.mounted) {
                                Navigator.popUntil(context, (route) => route.isFirst);
                              }
                            },
                            child: Text("OK")
                          ),
                        ],
                      );
                    }
                  );
                }
              ),
              body: ListView.builder(
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
                      onLongPress: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Expanded(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('Edit'),
                                      onTap: () {

                                      },
                                    ),
                                    ListTile(
                                      title: Text('Remove'),
                                      onTap: () {
                                        
                                      },
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () { Navigator.pop(context); },
                                  child: Text('Cancel')
                                ),
                                ElevatedButton(
                                  onPressed: () { Navigator.pop(context); },
                                  child: Text('OK')
                                )
                              ],
                            );
                          }
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