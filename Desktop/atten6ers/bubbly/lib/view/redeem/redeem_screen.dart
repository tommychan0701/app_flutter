import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/wallet/my_wallet.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/dialog/loader_dialog.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RedeemScreen extends StatefulWidget {
  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  MyWalletData _myWalletData;
  String coinRate = '0';
  String noOfRedeemCoin = '';
  String selectMethod = 'Paypal';
  String account = '';

  @override
  void initState() {
    getCoinRate();
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
              height: 60,
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
                        Text(
                          'Redeem shortzz',
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
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                      // Align(
                      //   alignment: AlignmentDirectional.topStart,
                      //   child: Text(
                      //     'Numbers of shortzz',
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   height: 50,
                      //   margin: EdgeInsets.only(top: 10),
                      //   padding: EdgeInsets.symmetric(horizontal: 15),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(10)),
                      //     color: colorPrimary,
                      //   ),
                      //   child: TextField(
                      //     onChanged: (value) => noOfRedeemCoin = value,
                      //     decoration: InputDecoration(
                      //       border: InputBorder.none,
                      //       hintText: 'You want to redeem',
                      //       hintStyle: TextStyle(
                      //         color: colorTextLight,
                      //       ),
                      //     ),
                      //     keyboardType: TextInputType.number,
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Select Method',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colorPrimary,
                        ),
                        child: SelectMethodDropdown((value) {
                          selectMethod = value;
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colorPrimary,
                        ),
                        child: TextField(
                          onChanged: (value) => account = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mail / Mobile',
                            hintStyle: TextStyle(
                              color: colorTextLight,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          /* if (noOfRedeemCoin == null ||
                              noOfRedeemCoin.isEmpty) {
                            showToast('Please enter Numbers of shortzz...!');
                          } else*/
                          if (selectMethod == null || selectMethod.isEmpty) {
                            showToast('Please select payment method...!');
                          } else if (account == null || account.isEmpty) {
                            showToast('Please enter account...!');
                          } else {
                            double amount =
                                Provider.of<MyLoading>(context, listen: false)
                                        .getUser
                                        .data
                                        .myWallet *
                                    (double.parse(coinRate) / 1000);
                            showDialog(
                              context: context,
                              builder: (context) => LoaderDialog(),
                            );
                            ApiService()
                                .redeemRequest(amount.toString(), selectMethod,
                                    account, noOfRedeemCoin)
                                .then((value) {
                              if (value != null && value.status == 200) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gradient: LinearGradient(
                              colors: [
                                colorTheme,
                                colorPink,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Redeem'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: fNSfUiSemiBold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Redeem requests are processed with in 10 days\nand be prepared that your account comply with our\nterms and policy. you can check more below.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorTextLight,
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                            builder: (context) => WebViewScreen(3),
                          ),
                        ),
                        child: Text(
                          'Policy center',
                          style: TextStyle(
                            color: colorTheme,
                            fontSize: 12,
                          ),
                        ),
                      )
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
      if (value != null) {
        coinRate = value.data.usdRate;
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

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}

class SelectMethodDropdown extends StatefulWidget {
  final Function function;

  const SelectMethodDropdown(this.function);

  @override
  _SelectMethodDropdownState createState() => _SelectMethodDropdownState();
}

class _SelectMethodDropdownState extends State<SelectMethodDropdown> {
  String currentValue = 'Pay pal';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentValue,
      underline: Container(),
      isExpanded: true,
      elevation: 16,
      style: TextStyle(color: colorTextLight),
      dropdownColor: colorPrimary,
      onChanged: (String newValue) {
        currentValue = newValue;
        widget.function(currentValue);
        setState(() {});
      },
      items: <String>['Pay pal', 'Paytm', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
