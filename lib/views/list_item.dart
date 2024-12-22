import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/models/entry_data.dart';
import 'package:sftp_flutter/view_models/remote_viewmodel.dart';

class ListItem extends StatelessWidget {
  final EntryData item;
  final onTap;
  ListItem({required this.item, required this.onTap}) : super(key: Key(item.name));

  @override
  Widget build(BuildContext context) {
    bool isFile = (item.type == Type.file);
    return ListTile(
      leading: Icon(isFile ? Icons.description : Icons.folder),
      title: Text(item.name),
      subtitle: (isFile) ? Text(item.size.toString()) : null,
      onTap: (isFile) ? null : onTap,
    );
  }
}