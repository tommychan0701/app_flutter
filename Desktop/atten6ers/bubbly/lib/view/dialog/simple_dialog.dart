import 'dart:ui';

import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:flutter/material.dart';

class SimpleCustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;

  //onButtonClick 0=Negative, 1=Positive
  final Function onButtonClick;

  SimpleCustomDialog({
    @required this.title,
    @required this.message,
    @required this.negativeText,
    @required this.positiveText,
    @required this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: Center(
              child: Container(
                height: 300,
                width: 275,
                decoration: BoxDecoration(
                  color: colorPrimaryDark,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: fNSfUiSemiBold,
                        decoration: TextDecoration.none,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image(
                      image: AssetImage(icLogo),
                      height: 80,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: fNSfUiLight,
                            decoration: TextDecoration.none,
                            color: colorTextLight,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                onButtonClick(0);
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  negativeText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: fNSfUiLight,
                                    decoration: TextDecoration.none,
                                    color: colorTextLight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                Navigator.pop(context);
                                onButtonClick(1);
                              },
                              child: Center(
                                child: Text(
                                  positiveText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: fNSfUiLight,
                                    decoration: TextDecoration.none,
                                    color: colorIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
