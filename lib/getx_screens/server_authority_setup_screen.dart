import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/constants.dart';
import '../models/settings_screen_variables.dart';
import 'scan_qrcode_screen.dart';
import 'settings_screen.dart';

class ServerAuthoritySetupScreen extends StatelessWidget {
  final SettingsScreenVariables variables = Get.find();
  var serverAuthorityTxtController = TextEditingController();

  ServerAuthoritySetupScreen() {
    serverAuthorityTxtController.text = variables.serverAuthority.value;

    serverAuthorityTxtController.addListener(() {
      variables.serverAuthority.value = serverAuthorityTxtController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => TextField(
                controller: serverAuthorityTxtController,
                decoration: InputDecoration(
                    filled: true,
                    label: const Text("Server Authority"),
                    errorStyle:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                    errorMaxLines: 3,
                    errorText: Constants.shared.serverAuthorityRegex
                            .hasMatch(variables.serverAuthority.value)
                        ? null
                        : "Must be a valid domain not prefixed with \"http://\" or \"https://\""),
                onChanged: (value) {
                  variables.serverAuthority.value = value;
                },
                autocorrect: false,
                keyboardType: TextInputType.url,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "Ask your server manager if you don't know what to put here."),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Get.to(() => ScanQrCodeScreen());
                        if (result != null) {
                          serverAuthorityTxtController.text = result;
                        }
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text("Scan Server Authority QR Code"),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
