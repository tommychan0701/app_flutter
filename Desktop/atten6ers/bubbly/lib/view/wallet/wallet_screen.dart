import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/wallet/my_wallet.dart';
import 'package:bubbly/modal/wallet/rewarding_actions.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/redeem/redeem_screen.dart';
import 'package:bubbly/view/wallet/dialog_coins_plan.dart';
import 'package:flutter/material.dart';

import 'item_rewarding_action.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String coinRate = '0';
  List<RewardingActionData> rewardingActions = [];
  MyWalletData _myWalletData;

  @override
  void initState() {
    getCoinRate();
    getRewardingActions();
    getMyWalletData();
    super.initState();
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
                  Container(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(icWalletFill),
                          color: colorTheme,
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Wallet',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: fNSfUiMedium,
                          ),
                        ),
                      ],
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
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorPrimaryDark,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorPink,
                                      blurRadius: 40,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _myWalletData != null
                                        ? NumberFormatter.formatter(
                                            _myWalletData.myWallet.toString(),
                                          )
                                        : '0',
                                    style: TextStyle(
                                      fontFamily: fNSfUiBold,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  gradient: LinearGradient(
                                    colors: [
                                      colorTheme,
                                      colorPink,
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'shortzz you Have',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: fNSfUiSemiBold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        width: 160,
                        height: 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '1000 shortzz = $coinRate USD',
                        style: TextStyle(
                          color: colorTextLight,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => DialogCoinsPlan(),
                            backgroundColor: Colors.transparent,
                          ).then((value) {
                            getCoinRate();
                            getRewardingActions();
                            getMyWalletData();
                          });
                        },
                        child: Container(
                          height: 45,
                          width: 175,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: colorPink,
                                spreadRadius: 0.5,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Add shortzz'.toUpperCase(),
                              style: TextStyle(
                                fontFamily: fNSfUiSemiBold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1 / 0.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Earning',
                                        style: TextStyle(
                                          color: colorTextLight,
                                          fontFamily: fNSfUiSemiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _myWalletData != null
                                            ? NumberFormatter.formatter(
                                                _myWalletData.totalReceived
                                                    .toString(),
                                              )
                                            : '0',
                                        style: TextStyle(
                                          color: colorTheme,
                                          fontSize: 26,
                                          fontFamily: fNSfUiHeavy,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1 / 0.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Spending',
                                        style: TextStyle(
                                          color: colorTextLight,
                                          fontFamily: fNSfUiSemiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        _myWalletData != null
                                            ? _myWalletData.totalSend.toString()
                                            : '0',
                                        style: TextStyle(
                                          color: colorTheme,
                                          fontSize: 26,
                                          fontFamily: fNSfUiHeavy,
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
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Passbook',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: AspectRatio(
                      //         aspectRatio: 1 / 1,
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: colorPrimary,
                      //             borderRadius:
                      //                 BorderRadius.all(Radius.circular(20)),
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.black.withOpacity(0.5),
                      //                 blurRadius: 15,
                      //               ),
                      //             ],
                      //           ),
                      //           child: Container(
                      //             margin: EdgeInsets.symmetric(horizontal: 15),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   'shortzz',
                      //                   style: TextStyle(
                      //                     color: colorTextLight,
                      //                     fontFamily: fNSfUiSemiBold,
                      //                     fontSize: 20,
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 Text(
                      //                   _myWalletData != null
                      //                       ? _myWalletData.spenInApp.toString()
                      //                       : '0',
                      //                   style: TextStyle(
                      //                     color: colorTheme,
                      //                     fontSize: 40,
                      //                     fontFamily: fNSfUiHeavy,
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Text(
                      //                   'Time Spent in app',
                      //                   style: TextStyle(
                      //                     color: colorTextLight,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 20,
                      //     ),
                      //     Expanded(
                      //       child: AspectRatio(
                      //         aspectRatio: 1 / 1,
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: colorPrimary,
                      //             borderRadius:
                      //                 BorderRadius.all(Radius.circular(20)),
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.black.withOpacity(0.5),
                      //                 blurRadius: 15,
                      //               ),
                      //             ],
                      //           ),
                      //           child: Container(
                      //             margin: EdgeInsets.symmetric(horizontal: 15),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   'shortzz',
                      //                   style: TextStyle(
                      //                     color: colorTextLight,
                      //                     fontFamily: fNSfUiSemiBold,
                      //                     fontSize: 20,
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 10,
                      //                 ),
                      //                 Text(
                      //                   _myWalletData != null
                      //                       ? _myWalletData.checkIn.toString()
                      //                       : '0',
                      //                   style: TextStyle(
                      //                     color: colorTheme,
                      //                     fontSize: 40,
                      //                     fontFamily: fNSfUiHeavy,
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Text(
                      //                   'Daily Check-in',
                      //                   style: TextStyle(
                      //                     color: colorTextLight,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'shortzz',
                                        style: TextStyle(
                                          color: colorTextLight,
                                          fontFamily: fNSfUiSemiBold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _myWalletData != null
                                            ? NumberFormatter.formatter(
                                                _myWalletData.uploadVideo
                                                    .toString(),
                                              )
                                            : '0',
                                        style: TextStyle(
                                          color: colorTheme,
                                          fontSize: 40,
                                          fontFamily: fNSfUiHeavy,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Upload Video',
                                        style: TextStyle(
                                          color: colorTextLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'shortzz',
                                        style: TextStyle(
                                          color: colorTextLight,
                                          fontFamily: fNSfUiSemiBold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _myWalletData != null
                                            ? NumberFormatter.formatter(
                                                _myWalletData.fromFans
                                                    .toString(),
                                              )
                                            : '0',
                                        style: TextStyle(
                                          color: colorTheme,
                                          fontSize: 40,
                                          fontFamily: fNSfUiHeavy,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'From your fans',
                                        style: TextStyle(
                                          color: colorTextLight,
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
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          gradient: LinearGradient(
                            colors: [
                              colorTheme,
                              colorPink,
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                _myWalletData != null
                                    ? NumberFormatter.formatter(
                                        _myWalletData.purchased.toString(),
                                      )
                                    : '0',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: fNSfUiHeavy,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                'Purchased',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fNSfUiSemiBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Rewarding Actions',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        itemBuilder: (BuildContext context, int index) {
                          return ItemRewardingAction(rewardingActions[index]);
                        },
                        itemCount: rewardingActions == null
                            ? 0
                            : rewardingActions.length,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RedeemScreen(),
                            ),
                          ).then((value) {
                            getMyWalletData();
                          });
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: colorTheme,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Request Redeem',
                              style: TextStyle(
                                color: colorTheme,
                                fontSize: 16,
                                fontFamily: fNSfUiMedium,
                              ),
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
        ),
      ),
    );
  }

  void getCoinRate() {
    ApiService().getCoinRateList().then((value) {
      if (value != null && value.data != null) {
        coinRate = value.data.usdRate;
        setState(() {});
      }
    });
  }

  void getRewardingActions() {
    ApiService().getRewardingActions().then((value) {
      if (value != null) {
        rewardingActions = value.data;
        setState(() {});
      }
    });
  }

  void getMyWalletData() {
    ApiService().getMyWalletCoin().then((value) {
      if (value != null) {
        _myWalletData = value.data;
        setState(() {});
      }
    });
  }
}
