import 'dart:ui';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/uservideo/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/myloading/costumview/send_coin_result.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/dialog/loader_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class DialogSendBubble extends StatelessWidget {
  final Data videoData;

  DialogSendBubble(this.videoData);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Container(
              height: 475,
              width: 300,
              decoration: BoxDecoration(
                color: colorPrimaryDark,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Send shortzz',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Image(
                    image: AssetImage(
                      icLogo,
                    ),
                    height: 75,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Creator will be notified\nabout your love',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorTextLight,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ItemSendBubble(5, videoData),
                  SizedBox(
                    height: 10,
                  ),
                  ItemSendBubble(10, videoData),
                  SizedBox(
                    height: 10,
                  ),
                  ItemSendBubble(15, videoData),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: colorTextLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ItemSendBubble extends StatelessWidget {
  final int bubblesCount;
  final Data videoData;
  final SessionManager sessionManager = new SessionManager();

  ItemSendBubble(this.bubblesCount, this.videoData);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyLoading>(context, listen: false).getUser;
    initPref();
    return GestureDetector(
      // focusColor: Colors.transparent,
      // hoverColor: Colors.transparent,
      // highlightColor: Colors.transparent,
      // overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (user.data.myWallet > bubblesCount) {
          showDialog(
            context: context,
            builder: (context) => LoaderDialog(),
          );
          ApiService()
              .sendCoin(
            bubblesCount.toString(),
            videoData.userId.toString(),
          )
              .then(
            (value) {
              Navigator.pop(context);
              Navigator.pop(context);
              Provider.of<MyLoading>(context, listen: false)
                  .setUser(sessionManager.getUser());
              showDialog(
                context: context,
                builder: (context) => SendCoinsResult(value.status == 200),
              );
            },
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Insufficient Balance',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0,
          );
        }
      },
      child: Container(
        height: 55,
        width: 175,
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              offset: Offset(1, 1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Image(
              image: AssetImage(icLogo),
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              '$bubblesCount Shortzz',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }

  void initPref() async {
    await sessionManager.initPref();
  }
}
