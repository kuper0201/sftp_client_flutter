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

// class RemoteTab extends StatefulWidget {
//   const RemoteTab({super.key});

//   @override
//   State<StatefulWidget> createState() => RemoteTabState();
// }

// class RemoteTabState extends State<RemoteTab> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<RemoteViewModel>(
//       builder: (context, viewModel, child) {
//         if(viewModel.isLoading) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final items = viewModel.entries;
//         return ListView.builder(
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             return ListItem(item: items[index]);
//           },
//         );
//       }
//     ); 
//   }
// }