import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/widgets/list_item.dart';

class ClientTab<T> extends StatelessWidget {
  const ClientTab({super.key});

  void showErrorDialog(T viewModel, context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        // viewModel.disconnect();
        return AlertDialog(
          title: Text('Error on fetching files'),
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
    return Consumer<T>(
      builder: (context, viewModel, _) {
        if(viewModel is dynamic) {
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

        return Center(child: Text("Unexpected Error"));
      }
    ); 
  }
}