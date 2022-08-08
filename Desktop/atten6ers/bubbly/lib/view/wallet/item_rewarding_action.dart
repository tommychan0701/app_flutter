import 'package:bubbly/modal/wallet/rewarding_actions.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:flutter/material.dart';

class ItemRewardingAction extends StatelessWidget {
  final RewardingActionData rewardingAction;

  ItemRewardingAction(this.rewardingAction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(right: 15, left: 15),
      decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colorTheme,
            radius: 18,
            child: Text(
              rewardingAction.coin.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: fNSfUiSemiBold,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              rewardingAction.actionName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
