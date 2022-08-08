import 'dart:io';

import 'package:bubbly/modal/plan/coin_plans.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/view/dialog/loader_dialog.dart';
import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:flutter/material.dart';

class ItemCoinPlan extends StatefulWidget {
  final CoinPlanData plan;
  final Function purchaseCoin;

  ItemCoinPlan(this.plan, this.purchaseCoin);

  @override
  State<ItemCoinPlan> createState() => _ItemCoinPlanState();
}

class _ItemCoinPlanState extends State<ItemCoinPlan> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Image(
                height: 35,
                image: AssetImage(
                  icLogo,
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Text(
                  '${widget.plan.coinAmount} Shortzz',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                height: 30,
                width: 85,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => LoaderDialog(),
                    );
                    widget.purchaseCoin(widget.plan.coinAmount);
                    await BubblyCamera.inAppPurchase(Platform.isAndroid
                        ? widget.plan.playstoreProductId
                        : widget.plan.appstoreProductId);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(colorTheme),
                  ),
                  child: Text(
                    '\$${widget.plan.coinPlanPrice}',
                    style: TextStyle(
                      fontFamily: fNSfUiSemiBold,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 0.3,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
