import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/remote_viewmodel.dart';
import 'package:sftp_flutter/tabs/remote_tab.dart';

class ListItem extends StatefulWidget{
  final SftpName item;
  
  const ListItem({key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late SftpName item;
  
  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    bool isFile = (item.attr.type == SftpFileType.regularFile);
    return ListTile(
      leading: Icon(isFile ? Icons.description : Icons.folder),
      title: Text(item.filename),
      subtitle: Text(isFile ? item.attr.size.toString() : '-'),
      onTap: () {
        if(!isFile) {
          context.read<RemoteViewModel>().moveDirectory(item.filename);
        }
      },
    );
  }
}