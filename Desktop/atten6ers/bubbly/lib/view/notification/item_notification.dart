import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/notificaion/notification.dart';
import 'package:bubbly/modal/uservideo/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/view/dialog/loader_dialog.dart';
import 'package:bubbly/view/profile/proifle_screen.dart';
import 'package:bubbly/view/video/video_list_screen.dart';
import 'package:flutter/material.dart';

class ItemNotification extends StatelessWidget {
  final NotificationData notificationData;

  ItemNotification(this.notificationData);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (notificationData.notificationType >= 4) {
          return;
        }
        if (notificationData.notificationType == 1 ||
            notificationData.notificationType == 2) {
          ///Video Screen
          showDialog(
            context: context,
            builder: (context) => LoaderDialog(),
          );
          ApiService()
              .getPostByPostId(notificationData.itemId.toString())
              .then((value) {
            List<Data> list = List<Data>.generate(
                1, (index) => Data.fromJson(value.data.toJson()));
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoListScreen(
                  list: list,
                  index: 0,
                  type: 6,
                ),
              ),
            );
          });
        } else {
          ///User Screen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(1, notificationData.itemId.toString())),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  padding: EdgeInsets.all(1),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Image(
                          image: AssetImage(icUserPlaceHolder),
                          color: colorTextLight,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        color: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(
                            Const.itemBaseUrl +
                                (notificationData != null &&
                                        notificationData.userProfile != null
                                    ? notificationData.userProfile
                                    : ''),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (notificationData.notificationType >= 4
                            ? 'Admin'
                            : notificationData != null &&
                                    notificationData.fullName != null
                                ? notificationData.fullName
                                : ''),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: fNSfUiSemiBold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        (notificationData != null &&
                                notificationData.message != null
                            ? notificationData.message
                            : ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorTextLight,
                          fontFamily: fNSfUiLight,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image:
                        AssetImage(getIcon(notificationData.notificationType)),
                    height: 28,
                    color: colorTextLight,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 0.2,
              color: colorTextLight,
            ),
          ],
        ),
      ),
    );
  }

  String getIcon(int notificationType) {
    if (notificationType == 1) {
      return icNotiLike;
    }
    if (notificationType == 2) {
      return icNotiComment;
    }
    if (notificationType == 3) {
      return icNotiFollowing;
    }
    if (notificationType == 4) {
      return icLogo;
    }
    return icLogo;
  }
}
