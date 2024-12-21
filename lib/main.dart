import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/custom_expandable_fab.dart';
import 'package:sftp_flutter/pages/server_list.dart';
import 'package:sftp_flutter/view_models/remote_viewmodel.dart';
import 'package:sftp_flutter/pages/client_page.dart';
import 'package:sftp_flutter/tabs/local_tab.dart';
import 'package:sftp_flutter/tabs/remote_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(home: ServerList());
    return ChangeNotifierProvider(
      create: (_) => RemoteViewModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: const ClientPage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}