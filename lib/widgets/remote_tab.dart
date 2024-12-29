import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/widgets/list_item.dart';
import 'package:sftp_flutter/view_models/remote_vm.dart';

class RemoteTab extends StatelessWidget {
  const RemoteTab({super.key});

  void showErrorDialog(viewModel, context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        viewModel.disconnect();
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RemoteViewModel>(
      builder: (context, viewModel, _) {
        if(viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if(viewModel.onError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(viewModel, context);
          });
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.entries.length,
                itemBuilder: (context, index) {
                  final item = viewModel.entries[index];
                  return ListItem(
                    item: item,
                    isSelected: item.isSelected,
                    onTap: () => viewModel.onTap(index),
                    onLongPress: () => viewModel.onLongPress(index)
                  );
                },
              )
            )
          ],
        );
      }
    ); 
  }
}