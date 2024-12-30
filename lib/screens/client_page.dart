import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/widgets/custom_expandable_fab.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';
import 'package:sftp_flutter/widgets/tab_widget.dart';
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
              if(viewModel.selectedEntries.length == 1) IconButton(onPressed: viewModel.onRename, icon: Icon(Icons.drive_file_rename_outline)),
              IconButton(onPressed: viewModel.onDelete, icon: Icon(Icons.delete)),
              IconButton(onPressed: viewModel.onCopy, icon: Icon(Icons.copy)),
              IconButton(onPressed: viewModel.onCut, icon: Icon(Icons.cut)),
              if(viewModel is RemoteViewModel) IconButton(onPressed: () => {}, icon: Icon(Icons.download))
              else IconButton(onPressed: () => {}, icon: Icon(Icons.upload)),
            ] : null,
            title: Column(
              children: [
                Text("${viewModel.serverName}"),
                Text("${viewModel.path}", style: TextStyle(color: Colors.blueGrey, fontSize: 17),),
              ]
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.cloud)),
                Tab(icon: Icon(Icons.devices))
              ]
            ),
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: CustomExpandableFab(newDirCallBack: viewModel.newDirectory),
          body: TabBarView(
            controller: _tabController,
            children: [
              ClientTab<RemoteViewModel>(),
              ClientTab<LocalViewModel>()
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