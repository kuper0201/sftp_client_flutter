import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:sftp_flutter/custom_expandable_fab.dart';
import 'package:sftp_flutter/tabs/local_tab.dart';
import 'package:sftp_flutter/tabs/remote_tab.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key, required this.title});

  final String title;

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightGreen,
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(
              children: <Widget>[
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Rename"), icon: const Icon(Icons.drive_file_rename_outline))),
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Remove"), icon: const Icon(Icons.remove))),
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Copy"), icon: const Icon(Icons.drive_file_rename_outline))),
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Move"), icon: const Icon(Icons.drive_file_rename_outline))),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Server Name'),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.cloud)),
              Tab(icon: Icon(Icons.devices))
            ]
          ),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: CustomExpandableFab(),
        body: TabBarView(
          children: [
            RemoteTab(),
            LocalTab()
          ]
        ),
      )
    );
  }
}