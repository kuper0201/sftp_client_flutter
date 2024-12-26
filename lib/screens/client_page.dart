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

  Widget _buildLeading<T>(context, RemoteViewModel remoteViewModel, LocalViewModel localViewModel) {
    // if(DefaultTabController.of(context).index == 0) {
    //   return (remoteViewModel.isSelectMode) ? IconButton(onPressed: () => remoteViewModel.unselectAll(), icon: Icon(Icons.close)) : IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back));
    // } else {
    //   return (localViewModel.isSelectMode) ? IconButton(onPressed: () => localViewModel.unselectAll(), icon: Icon(Icons.close)) : IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back));
    // }

    return Container();
  }

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
      builder: (context, child) {
        final remoteViewModel = context.watch<RemoteViewModel>();
        final localViewModel = context.watch<LocalViewModel>();

        return DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: _buildLeading(context, remoteViewModel, localViewModel),
              actions: (remoteViewModel.isSelectMode) ? [
                Text("${remoteViewModel.selectedEntries.length} Items"),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                IconButton(onPressed: () {}, icon: Icon(Icons.copy)),
                IconButton(onPressed: () {}, icon: Icon(Icons.cut)),
                IconButton(onPressed: () {}, icon: Icon(Icons.drive_file_rename_outline)),
              ] : null,
              title: Text(remoteViewModel.sftpRepo.name),
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
      },
    );
  }
}