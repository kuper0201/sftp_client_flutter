import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/servers_vm.dart';
import 'package:sftp_flutter/widgets/add_server_dialog.dart';

class LongClickDialog extends StatelessWidget {
  final String name;
  final String host;
  final String userName;
  final String password;
  final int port;

  const LongClickDialog({super.key, required this.name, required this.host, required this.userName, required this.password, required this.port});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ServersViewModel>(context, listen: false);

    return AlertDialog(
      title: Text(name),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Edit'),
              onTap: () async {
                Navigator.pop(context);
                await showDialog(
                  context: context,
                  builder: (context) => AddServerDialog(isEdit: true, initialName: name, initialHost: host, initialUserName: userName, initialPassword: password, initialPort: port,)
                );
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