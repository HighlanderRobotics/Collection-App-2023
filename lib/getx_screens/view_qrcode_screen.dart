import 'package:flutter/material.dart';
import 'package:frc_scouting/services/getx_business_logic.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  var pageNumber = 0.obs;
  late final List<String> matchQrCodes;
  var canPopScope = false;

  QrCodeScreen({
    required this.matchQrCodes,
    required this.canPopScope,
  });

  void nextPage() => pageNumber.value =
      (pageNumber.value < matchQrCodes.length - 1) ? pageNumber.value + 1 : 0;

  void previousPage() => pageNumber.value =
      (pageNumber.value > 0) ? pageNumber.value - 1 : matchQrCodes.length - 1;

  @override
  Widget build(BuildContext context) {
    controller.setPortraitOrientation();

    return Scaffold(
        appBar: AppBar(
          title: const Text("QR Code"),
          automaticallyImplyLeading: canPopScope,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => ListView(
              children: [
                SafeArea(
                  child: QrImage(
                    foregroundColor: Theme.of(context).colorScheme.onBackground,
                    data: matchQrCodes[pageNumber.value],
                    version: QrVersions.auto,
                    errorCorrectionLevel: QrErrorCorrectLevel.L,
                    gapless: false,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                        "Page ${pageNumber.value + 1} out of ${matchQrCodes.length}"),
                  ),
                ),
                if (matchQrCodes.length > 1)
                  ElevatedButton(
                    onPressed: nextPage,
                    child: const Text("Next Page"),
                  ),
                if (matchQrCodes.length > 1 || !canPopScope)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.closeCurrentSnackbar();
                        if (canPopScope) {
                          previousPage();
                        } else {
                          controller.reset();
                        }
                      },
                      child: Text(canPopScope ? "Back" : "Finish"),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
