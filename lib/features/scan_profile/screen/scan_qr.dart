import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/theme/pallete.dart';

class ScanQrToProfile extends ConsumerStatefulWidget {
  const ScanQrToProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScanQrToProfileState();
}

class _ScanQrToProfileState extends ConsumerState<ScanQrToProfile> {
  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    late final String userid;

    MobileScannerController cameraController = MobileScannerController();

    void cameraSwitch() {
      cameraController.switchCamera();
    }

    void toogleflash() {
      cameraController.toggleTorch();
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Scan QR code"),
          actions: [
            IconButton(
              onPressed: () => toogleflash(),
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
            ),
            IconButton(
              onPressed: () => cameraSwitch(),
              icon: const Icon(Icons.switch_camera),
            ),
          ]),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Move the camera to scan the QR code"),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code_scanner),
                      SizedBox(width: 10),
                      Text("Scan QR code"),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: currentTheme.brightness == Brightness.light
                    ? Colors.black
                    : Colors.tealAccent,
                strokeCap: StrokeCap.round,
                strokeWidth: 2,
                borderPadding: const EdgeInsets.all(23),
                padding: const EdgeInsets.all(34),
                dashPattern: const [5, 9],
                child: MobileScanner(
                  fit: BoxFit.fitWidth,
                  onScannerStarted: (arguments) {},
                  placeholderBuilder: (p0, p1) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  startDelay: true,
                  controller: cameraController,
                  onDetect: (capture) {
                    if (capture.barcodes.isNotEmpty) {
                      // cameraController.stop();
                      setState(() {
                        userid = capture.barcodes[0].rawValue!;
                      });
                      debugPrint(
                          'Barcode found! ${capture.barcodes[0].rawValue}');
                      cameraController.stop();
                      Routemaster.of(context).push('/u/$userid');
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Made with ❤️ by Sensei in Kolkata",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
