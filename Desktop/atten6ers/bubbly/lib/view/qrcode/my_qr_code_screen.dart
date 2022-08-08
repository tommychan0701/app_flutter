import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrScanCodeScreen extends StatelessWidget {
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
                      'My Code',
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
              margin: EdgeInsets.only(bottom: 10),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    RepaintBoundary(
                      key: screenshotKey,
                      child: Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: colorPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 25, bottom: 15),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      child: QrImage(
                                        backgroundColor: Colors.white,
                                        data: SessionManager.userId.toString(),
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                    ),
                                  ),
                                ),
                                ClipOval(
                                  child: Image(
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(Const.itemBaseUrl +
                                        Provider.of<MyLoading>(context,
                                                listen: false)
                                            .getUser
                                            .data
                                            .userProfile),
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '@${Provider.of<MyLoading>(context, listen: false).getUser.data.userName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Provider.of<MyLoading>(context, listen: false)
                                      .getUser
                                      .data
                                      .bio,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorTextLight,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Scan to follow me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorIcon,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image(
                                  image: AssetImage(icLogoHorizontal),
                                  height: 60,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => _takeScreenShot(),
                          child: Column(
                            children: [
                              ClipOval(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorTheme,
                                        colorPink,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Image(
                                      image: AssetImage(icDownload),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Save Code',
                                style: TextStyle(
                                  color: colorTextLight,
                                ),
                              )
                            ],
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     ClipOval(
                        //       child: Container(
                        //         height: 40,
                        //         width: 40,
                        //         decoration: BoxDecoration(
                        //           gradient: LinearGradient(
                        //             colors: [
                        //               colorTheme,
                        //               colorPink,
                        //             ],
                        //           ),
                        //         ),
                        //         child: Padding(
                        //           padding: EdgeInsets.all(12),
                        //           child: Image(
                        //             image: AssetImage(icShare),
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 5,
                        //     ),
                        //     Text(
                        //       'Share Code',
                        //       style: TextStyle(
                        //         color: colorTextLight,
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final GlobalKey screenshotKey = GlobalKey();

  void _takeScreenShot() async {
    RenderRepaintBoundary boundary =
        screenshotKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 10);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    convertImageToFile(pngBytes);
  }

  Future convertImageToFile(Uint8List image) async {
    if (Platform.isAndroid) {
      final file = File(
          '/storage/emulated/0/Download/${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(image);
    } else {
      var f = await getApplicationDocumentsDirectory();
      print(f);
      final file = File('${f.path}/myqrcode.png');
      await file.writeAsBytes(image);
      BubblyCamera.saveImage(file.path);
    }

    Fluttertoast.showToast(
      msg: 'File saved successfully...!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}
