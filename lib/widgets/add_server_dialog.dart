import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sftp_flutter/view_models/servers_vm.dart';

class AddServerDialog extends StatelessWidget {
  final bool isEdit;
  final String? initialName;
  final String? initialHost;
  final int? initialPort;
  final String? initialUserName;
  final String? initialPassword;

  const AddServerDialog({
    super.key,
    this.isEdit = false,
    this.initialName,
    this.initialHost,
    this.initialPort,
    this.initialUserName,
    this.initialPassword
  });

  Widget _buildTextField({required TextEditingController controller, required String label, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ServersViewModel>(context, listen: false);

    final TextEditingController nameTc = TextEditingController(text: initialName ?? "");
    final TextEditingController hostTc = TextEditingController(text: initialHost ?? "");
    final TextEditingController portTc = TextEditingController(text: initialPort?.toString() ?? "");
    final TextEditingController userNameTc = TextEditingController(text: initialUserName ?? "");
    final TextEditingController passwordTc = TextEditingController(text: initialPassword ?? "");

    final ValueNotifier<bool> _isObscure = ValueNotifier<bool>(true);

    return AlertDialog(
      title: Text("New Server"),
      content: SingleChildScrollView(
        child: Column(
          spacing: 10.0,
          children: [
            _buildTextField(controller: nameTc, label: 'Server Name'),
            Row(
              spacing: 10.0,
              children: [
                Flexible(
                  flex: 4,
                  child: _buildTextField(controller: hostTc, label: 'Server Host')
                ),
                Flexible(
                  flex: 2,
                  child: _buildTextField(controller: portTc, label: 'Port', keyboardType: TextInputType.number, inputFormatters: <TextInputFormatter>[ FilteringTextInputFormatter.digitsOnly ],)
                ),
              ],
            ),
            _buildTextField(controller: userNameTc, label: 'User Name'),
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
            if(isEdit) {
              await model.updateServer(initialName!, nameTc.text, hostTc.text, userNameTc.text, passwordTc.text, int.parse(portTc.text));
            } else {
              await model.addServer(nameTc.text, hostTc.text, userNameTc.text, passwordTc.text, int.parse(portTc.text));
            }

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