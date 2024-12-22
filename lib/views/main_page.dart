import 'package:flutter/material.dart';
import 'package:sftp_flutter/views/server_list.dart';

class SFTPClient extends StatelessWidget {
  const SFTPClient({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SFTP Client',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text("SFTP Client"),
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            child: Icon(Icons.add),
            onPressed: () {

            }
          ),
          body: ServerListPage(),
        )
    );
  }
}