import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/servers_vm.dart';

class AddServerDialog extends StatelessWidget {
  final TextEditingController nameTc = TextEditingController();
  final TextEditingController hostTc = TextEditingController();
  final TextEditingController portTc = TextEditingController();
  final TextEditingController userNameTc = TextEditingController();
  final TextEditingController passwordTc = TextEditingController();

  final ValueNotifier<bool> _isObscure = ValueNotifier<bool>(true);
  
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ServersViewModel>(context, listen: false);
    
    return AlertDialog(
      title: Text("New Server"),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10.0,
          children: [
            TextField(
              controller: nameTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server Name',
              )
            ),
            Row(
              spacing: 10.0,
              children: [
                Flexible(
                  flex: 4,
                  child: TextField(
                    controller: hostTc,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Server Host',
                    )
                  )
                ),
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: portTc,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Port',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
              ],
            ),
            TextField(
              controller: userNameTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              )
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isObscure,
              builder: (context, isObscure, _) {
                return TextField(
                  controller: passwordTc,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _isObscure.value = !isObscure;
                      },
                      icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off)
                    )
                  )
                );
              }
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Text("Cancel")
        ),
        ElevatedButton(
          onPressed: () async {
            await model.addServer(nameTc.text, hostTc.text, userNameTc.text, passwordTc.text, int.parse(portTc.text));
            if(context.mounted) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          child: Text("OK")
        ),
      ],
    );
  }
}