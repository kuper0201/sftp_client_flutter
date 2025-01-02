import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/widgets/custom_expandable_fab.dart';
import 'package:sftp_flutter/repositories/local_repo.dart';
import 'package:sftp_flutter/repositories/remote_repo.dart';
import 'package:sftp_flutter/widgets/tab_widget.dart';
import 'package:sftp_flutter/view_models/local_vm.dart';
import 'package:sftp_flutter/view_models/remote_vm.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

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

  void _showCheckAgainDialog(Function() onDelete) {
    showDialog(
      context: context,
      builder:(context) {
        return AlertDialog(
          title: Text("Remove items?"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel")
            ),
            ElevatedButton(
              onPressed: () async {
                await onDelete();
                if(context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text("OK")
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(Function(String) onRename) {
    showDialog(
      context: context,
      builder:(context) {
        TextEditingController tc = TextEditingController();
        return AlertDialog(
          title: Text("Rename"),
          content: TextField(
            controller: tc,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Input new name",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel")
            ),
            ElevatedButton(
              onPressed: () async {
                await onRename(tc.text);
                if(context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text("OK")
            ),
          ],
        );
      },
    );
  }

  void _showDownloadDialog(viewModel, path) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: viewModel.selectedEntries.length, msg: "Downloading...");
    await viewModel.downloadFiles(path, (int idx) => pd.update(value: idx));
    if(!viewModel.isProcessing) {
      pd.close();
    }
  }

  void _showUploadDialog(remoteViewModel, selectedEntries, path) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: selectedEntries.length, msg: "Uploading...");
    await remoteViewModel.uploadFiles(selectedEntries, path, (int idx) => pd.update(value: idx));
    if(!remoteViewModel.isProcessing) {
      pd.close();
    }
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
              if(viewModel.selectedEntries.length == 1) IconButton(onPressed: () => _showRenameDialog(viewModel.onRename), icon: Icon(Icons.drive_file_rename_outline)),
              IconButton(onPressed: () => _showCheckAgainDialog(viewModel.onDelete), icon: Icon(Icons.delete)),
              IconButton(onPressed: viewModel.onCopy, icon: Icon(Icons.copy)),
              IconButton(onPressed: viewModel.onCut, icon: Icon(Icons.cut)),
              if(viewModel is RemoteViewModel) IconButton(onPressed: () => _showDownloadDialog(viewModel, context.read<LocalViewModel>().path), icon: Icon(Icons.download))
              else IconButton(onPressed: () => _showUploadDialog(context.read<RemoteViewModel>(), viewModel.selectedEntries, viewModel.path), icon: Icon(Icons.upload)),
              IconButton(onPressed: () => viewModel.fetchFiles(), icon: Icon(Icons.refresh))
            ] : [IconButton(onPressed: () => viewModel.fetchFiles(), icon: Icon(Icons.refresh))],
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