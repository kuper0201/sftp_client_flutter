import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/widgets/custom_expandable_fab.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';
import 'package:sftp_flutter/widgets/local_tab.dart';
import 'package:sftp_flutter/widgets/remote_tab.dart';
import 'package:sftp_flutter/view_models/local_vm.dart';
import 'package:sftp_flutter/view_models/remote_vm.dart';

class ClientPage extends StatelessWidget {
  final SFTPRepo remoteRepo;
  final LocalRepo localRepo;

  const ClientPage({super.key, required this.remoteRepo, required this.localRepo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RemoteViewModel(sftpRepo: remoteRepo)..fetchFiles()
        ),
        ChangeNotifierProvider(
          create: (_) => LocalViewModel(localRepo: localRepo)..fetchFiles()
        ),
      ],
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Colors.lightGreen,
            child: Row(
              children: <Widget>[
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Rename"), icon: const Icon(Icons.drive_file_rename_outline))),
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Remove"), icon: const Icon(Icons.remove))),
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Copy"), icon: const Icon(Icons.drive_file_rename_outline))),
                Expanded(child: TextButton.icon(onPressed: () {}, label: Text("Move"), icon: const Icon(Icons.drive_file_rename_outline))),
              ],
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
      )
    );
  }
}