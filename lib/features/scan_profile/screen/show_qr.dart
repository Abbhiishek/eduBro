import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/theme/pallete.dart';

class ShowProfileQr extends ConsumerStatefulWidget {
  const ShowProfileQr({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowProfileQrState();
}

class _ShowProfileQrState extends ConsumerState<ShowProfileQr> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Profile QR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scan this QR code to add me as a friend',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            QrImage(
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
              ),
              gapless: true,
              foregroundColor: currentTheme.brightness == Brightness.dark
                  ? Pallete.navyColor
                  : Pallete.tealColor,
              data: user.uid,
              version: QrVersions.auto,
              size: 250.0,
            ),
            const SizedBox(
              height: 20,
            ),

            // add a button to navigate to the scan qr screen
            ElevatedButton(
              onPressed: () {
                Routemaster.of(context).push('/scan-qr');
              },
              child: const Text('Scan Someone\'s QR'),
            ),
          ],
        ),
      ),
    );
  }
}
