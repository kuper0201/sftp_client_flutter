import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/servers_vm.dart';

class LongClickDialog extends StatelessWidget {
  final String name;

  const LongClickDialog({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ServersViewModel>(context, listen: false);

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Edit'),
              onTap: () {

              },
            ),
            ListTile(
              title: Text('Remove'),
              onTap: () {
                model.removeServer(name);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () { Navigator.pop(context); },
          child: Text('Cancel')
        )
      ],
    );
  }
}