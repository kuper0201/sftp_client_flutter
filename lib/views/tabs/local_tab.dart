import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/local_vm.dart';
import 'package:sftp_flutter/views/list_item.dart';

class LocalTab extends StatelessWidget {
  const LocalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalViewModel>(
      builder: (context, viewModel, child) {
        if(viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if(viewModel.onError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Listing error!\n${viewModel.onError}'),
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

        return Column(
          children: [
            Text('${viewModel.path}'),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.entries.length,
                itemBuilder: (context, index) {
                  final item = viewModel.entries[index];
                  return ListItem(item: item, onTap: () { viewModel.navigateTo(item.name); },);
                },
              )
            )
          ],
        );
      }
    ); 
  }
}