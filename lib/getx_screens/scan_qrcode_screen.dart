import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/getx_business_logic.dart';

class ScanQrCodeScreen extends StatelessWidget {
  MobileScannerController cameraController = MobileScannerController();

  BusinessLogicController businessController = Get.find();

  var qrCodeSizeIsLarge = false.obs;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      qrCodeSizeIsLarge.toggle();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                return Icon(state == CameraFacing.back
                    ? Icons.camera_front
                    : Icons.camera_rear);
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            // allowDuplicates: false,
            controller: cameraController,
            onDetect: (BarcodeCapture barcodeCapture) {
              final barcode = barcodeCapture.barcodes.first;
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                HapticFeedback.lightImpact();
                final String code = barcode.rawValue!;
                Get.back(result: code);
              }
            },
          ),

          // SizedBox(
          //   width: Get.mediaQuery.size.width * 0.6,
          //   height: Get.mediaQuery.size.width * 0.6,
          //   child: SvgPicture.asset('assets/viewfinder.svg'),
          // ),

          Obx(
            () => AnimatedContainer(
              width: Get.mediaQuery.size.width *
                  (qrCodeSizeIsLarge.isTrue ? 0.8 : 0.7),
              height: Get.mediaQuery.size.width *
                  (qrCodeSizeIsLarge.isTrue ? 0.8 : 0.7),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutSine,
              onEnd: () => qrCodeSizeIsLarge.toggle(),
              child: SvgPicture.asset('assets/viewfinder.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
