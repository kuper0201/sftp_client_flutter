import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/list_item.dart';
import 'package:sftp_flutter/view_models/remote_viewmodel.dart';

class RemoteTab extends StatelessWidget {
  const RemoteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RemoteViewModel>(
      builder: (context, viewModel, child) {
        if(viewModel.onError) {
          if (viewModel.onError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Connection error!'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            });
          }
        }

        if(viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final items = viewModel.entries;
        return Column(
          children: [
            Text('${viewModel.path}'),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListItem(item: items[index]);
                },
              )
            )
          ],
        );
      }
    ); 
  }
}