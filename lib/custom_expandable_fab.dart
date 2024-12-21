import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class CustomExpandableFab extends StatelessWidget {
  const CustomExpandableFab({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up,
      distance: 70,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        shape: const CircleBorder(),
      ),
      children: [
        Row(
          children: [
            Text('Upload'),
            SizedBox(width: 10),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.upload),
            ),
          ],
        ),
        Row(
          children: [
            Text('New Folder'),
            SizedBox(width: 10),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: ((context) {
                    TextEditingController tc = TextEditingController();
                    return AlertDialog(
                      title: Text("New Directory"),
                      content: TextField(
                        autofocus: true,
                        controller: tc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Directory Name',
                          hintText: 'Enter new directory name',
                        )
                      ),
                      actions: <Widget>[
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context, true);
                            },
                            child: Text("OK"),
                          ),
                        ),
                      ],
                    );
                  }),
                );
                // _sftp?.mkdir('path');
              },
              child: Icon(Icons.create_new_folder),
            ),
          ],
        ),
      ],
    );
  }
}