import 'package:flutter/material.dart';

class ServerList extends StatelessWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("test click");
      },
      child: Text("test")
    );
  }
}