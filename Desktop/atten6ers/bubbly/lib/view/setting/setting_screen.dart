import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/main.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/dialog/simple_dialog.dart';
import 'package:bubbly/view/qrcode/my_qr_code_screen.dart';
import 'package:bubbly/view/verification/verification_screen.dart';
import 'package:bubbly/view/wallet/wallet_screen.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Settings',
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorIcon,
                        radius: 5,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            children: [
                              Image.asset(
                                icNotificationBorder,
                                height: 17,
                                color: colorIcon,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Notify me',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorTextLight,
                                ),
                              ),
                              Expanded(child: Container()),
                              NotificationSwitch()
                            ],
                          ),
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => shareLink(context),
                          child: ItemSetting('Share profile', icShareBorder),
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyQrScanCodeScreen(),
                            ),
                          ),
                          child: ItemSetting('My QR Code', icQrCode),
                        ),
                        InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WalletScreen(),
                                  ),
                                ),
                            child: ItemSetting('Bubble wallet', icWallet)),
                        Visibility(
                          visible:
                              Provider.of<MyLoading>(context, listen: false)
                                      .getUser
                                      .data
                                      .isVerify ==
                                  0,
                          child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VerificationScreen(),
                                    ),
                                  ),
                              child: ItemSetting(
                                  'Request verification', icVerified)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorIcon,
                        radius: 5,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'General',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(1),
                                  ),
                                ),
                            child: ItemSetting('Help', icHelp)),
                        InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(2),
                                  ),
                                ),
                            child: ItemSetting('Terms of use', icTerms)),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(3),
                            ),
                          ),
                          child: ItemSetting('Privacy policy', icPrivacy),
                        ),
                        InkWell(
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (contex) => SimpleCustomDialog(
                                title: 'Are You Sure',
                                message:
                                    'All of your data: including Posts,\n Likes, Follows and everything which is\n connected to your identity, will be deleted \nfrom our platform. This actions can\'t be undone.',
                                negativeText: 'Cancel',
                                positiveText: 'Confirm',
                                onButtonClick: (clickType) {
                                  if (clickType == 1) {
                                    ApiService().deleteAccount().then((value) {
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyBubblyApp()),
                                          (Route<dynamic> route) => false);
                                    });
                                  } else {}
                                },
                              ),
                            );
                          },
                          child: ItemSetting('Delete Account', icRemoveAccount),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Center(
              child: Container(
                width: 130,
                margin: EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (contex) => SimpleCustomDialog(
                        title: 'Are You Sure',
                        message: 'Do yo really \nwant to log out ?',
                        negativeText: 'Cancel',
                        positiveText: 'Confirm',
                        onButtonClick: (clickType) {
                          if (clickType == 1) {
                            ApiService().logoutUser().then((value) {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyBubblyApp()),
                                  (Route<dynamic> route) => false);
                            });
                          } else {}
                        },
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(colorPrimary),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.power_settings_new,
                            color: colorPrimary,
                            size: 15,
                          ),
                          backgroundColor: colorIcon,
                          radius: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Log Out'.toUpperCase(),
                          style: TextStyle(
                            color: colorIcon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void shareLink(BuildContext context) async {
    User user = Provider.of<MyLoading>(context, listen: false).getUser;
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: user.data.userName,
        imageUrl: Const.itemBaseUrl + user.data.userProfile,
        contentDescription: '',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('user_id', user.data.userId));
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      Share.share(
        'Check out my profile ${response.result} 😋😋',
        subject: 'Look ${user.data.userName}',
      );
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }
}

class NotificationSwitch extends StatefulWidget {
  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  var currentValue = true;
  SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (value) {
        currentValue = value;
        ApiService().setNotificationSettings(currentValue
            ? _sessionManager.getString(Const.deviceToken)
            : 'destroy');
        setState(() {});
      },
      value: currentValue,
    );
  }

  void initSessionManager() async {
    await _sessionManager.initPref();
  }
}

class ItemSetting extends StatelessWidget {
  final String image;
  final String text;

  ItemSetting(this.text, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 16,
            color: colorIcon,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontFamily: fNSfUiMedium,
              color: colorTextLight,
            ),
          ),
        ],
      ),
    );
  }
}
