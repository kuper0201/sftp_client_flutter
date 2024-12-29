import 'package:flutter/material.dart';
import 'package:sftp_flutter/data/entry_data.dart';

class ListItem extends StatelessWidget {
  final EntryData item;
  final bool isSelected;
  final Function() onTap;
  final Function() onLongPress;

  ListItem({required this.item, required this.isSelected, required this.onTap, required this.onLongPress}) : super(key: Key(item.name));

  String getSize(int size) {
    final unit = ["B", "KB", "MB", "GB", "TB", "PB"];
    double tmp = size.toDouble();
    int idx = 0;
    while(tmp >= 1024) {
      tmp /= 1024;
      idx++;
    }

    return "${tmp.toStringAsFixed(1)}${unit[idx]}";
  }

  @override
  Widget build(BuildContext context) {
    bool isFile = (item.type == Type.file);
    return ListTile(
      leading: Icon(isFile ? Icons.description : Icons.folder),
      title: Text(item.name),
      subtitle: (isFile) ? Text(getSize(item.size!)) : null,
      selected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}