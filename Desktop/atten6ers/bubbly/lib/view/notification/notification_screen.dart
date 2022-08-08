import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/notificaion/notification.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/costumview/data_not_found.dart';
import 'package:bubbly/view/notification/item_notification.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int start = 0;

  var _streamController = StreamController<List<NotificationData>>();

  ScrollController _scrollController = ScrollController();

  List<NotificationData> notificationList = [];

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiForNotificationList();
        }
      }
    });
    callApiForNotificationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
            child: Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontFamily: fNSfUiBold,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                List<NotificationData> notificationsData = [];
                if (snapshot.data != null) {
                  notificationsData = (snapshot.data as List<NotificationData>);
                  notificationList.addAll(notificationsData);
                }
                return notificationList == null || notificationList.isEmpty
                    ? DataNotFound()
                    : ListView(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        children: List.generate(
                            notificationList.length,
                            (index) =>
                                ItemNotification(notificationList[index])),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  void callApiForNotificationList() {
    ApiService()
        .getNotificationList(start.toString(), Const.count.toString())
        .then(
      (value) {
        start += Const.count;
        isLoading = false;
        _streamController.add(value.data);
      },
    );
  }
}
