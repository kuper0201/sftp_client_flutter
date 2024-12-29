import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/client_vm.dart';
import 'package:sftp_flutter/widgets/custom_expandable_fab.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';
import 'package:sftp_flutter/widgets/local_tab.dart';
import 'package:sftp_flutter/widgets/remote_tab.dart';
import 'package:sftp_flutter/view_models/local_vm.dart';
import 'package:sftp_flutter/view_models/remote_vm.dart';

class ClientPage extends StatefulWidget {
  final SFTPRepo remoteRepo;
  final LocalRepo localRepo;

  const ClientPage({super.key, required this.remoteRepo, required this.localRepo});

  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if(_tabController.index != _tabController.previousIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  Widget _buildLeading(viewModel) {
    return (viewModel.isSelectMode) ? IconButton(onPressed: () => viewModel.unselectAll(), icon: Icon(Icons.close)) : IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RemoteViewModel>(create: (_) => RemoteViewModel(sftpRepo: widget.remoteRepo)..fetchFiles()),
        ChangeNotifierProvider<LocalViewModel>(create: (_) => LocalViewModel(localRepo: widget.localRepo)..fetchFiles()),
      ],
      builder: (context, child) {
        final dynamic viewModel = (_currentIndex == 0) ? context.watch<RemoteViewModel>() : context.watch<LocalViewModel>();

        return Scaffold(
          appBar: AppBar(
            leading: _buildLeading(viewModel),
            actions: (viewModel.isSelectMode) ? [
              Text("${viewModel.selectedEntries.length} Items"),
              IconButton(onPressed: () {  }, icon: Icon(Icons.delete)),
              IconButton(onPressed: () {}, icon: Icon(Icons.copy)),
              IconButton(onPressed: () {}, icon: Icon(Icons.cut)),
              IconButton(onPressed: () {}, icon: Icon(Icons.drive_file_rename_outline)),
            ] : null,
            title: Text('test'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.cloud)),
                Tab(icon: Icon(Icons.devices))
              ]
            ),
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: CustomExpandableFab(),
          body: TabBarView(
            controller: _tabController,
            children: [
              RemoteTab(),
              LocalTab()
            ]
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}