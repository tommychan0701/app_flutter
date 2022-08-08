import 'dart:io';

import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/view/profile/proifle_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodeScreen extends StatefulWidget {
  @override
  _ScanQrCodeScreenState createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  Barcode result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 55,
              child: Stack(
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Scan Qr Code',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.3,
              color: colorTextLight,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image(
                      image: AssetImage(icQrCode),
                      color: colorTheme,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Scan QR code to see profile',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      height: 250,
                      width: 250,
                      margin: EdgeInsets.only(top: 40, bottom: 50),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorTheme,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: colorPrimary,
                      ),
                      child: QRView(
                        onQRViewCreated: _onQRViewCreated,
                        key: qrKey,
                      ),
                    ),
                    Image(
                      width: 200,
                      image: AssetImage(icLogoHorizontal),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        this.controller.dispose();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(1, result.code)),
        );
      });
    });
  }
}
