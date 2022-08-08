import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/uservideo/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/home/item_following.dart';
import 'package:bubbly/view/video/item_video.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen>
    with AutomaticKeepAliveClientMixin {
  List<Widget> mList = [];
  PageController pageController = PageController();
  bool isFollowingDataEmpty = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isFollowingDataEmpty
        ? Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Image(
                height: 70,
                image: AssetImage(icLogo),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Popular Creator',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fNSfUiSemiBold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Follow some creators to\n watch their videos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: colorTextLight,
                  fontFamily: fNSfUiRegular,
                ),
              ),
              Expanded(
                child: Container(
                  height: 390,
                  margin: EdgeInsets.only(top: 30),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      scrollPhysics: BouncingScrollPhysics(),
                      height: MediaQuery.of(context).size.width +
                          (MediaQuery.of(context).size.width / 100),
                      enableInfiniteScroll: false,
                      viewportFraction: 0.65,
                    ),
                    items: mList,
                  ),
                ),
              ),
            ],
          )
        : PageView(
            physics: BouncingScrollPhysics(),
            controller: pageController,
            pageSnapping: true,
            onPageChanged: (value) {
              print(value);
              if (value == mList.length - 1) {
                callApiFollowing();
              }
            },
            scrollDirection: Axis.vertical,
            children: mList,
          );
  }

  int start = 0;

  @override
  void initState() {
    callApiFollowing();
    super.initState();
  }

  void callApiFollowing() {
    ApiService()
        .getPostList(start.toString(), Const.count.toString(),
            SessionManager.userId.toString(), Const.following)
        .then(
      (value) {
        if (value != null && value.data != null && value.data.isNotEmpty) {
          if (mList.isEmpty) {
            mList = List<Widget>.generate(
              value.data.length,
              (index) {
                return ItemVideo(value.data[index]);
              },
            );
            setState(() {});
          } else {
            for (Data data in value.data) {
              mList.add(ItemVideo(data));
            }
          }
          start += Const.count;
          print(mList.length);
        } else {
          start = 0;
          isFollowingDataEmpty = true;
          callApiForYou();
        }
      },
    );
  }

  void callApiForYou() {
    ApiService()
        .getPostList(
            start.toString(), Const.count.toString(), "2", Const.trending)
        .then(
      (value) {
        if (value != null && value.data != null && value.data.isNotEmpty) {
          if (mList.isEmpty) {
            mList = List<Widget>.generate(
              value.data.length,
              (index) {
                return ItemFollowing(value.data[index]);
              },
            );
            setState(() {});
          } else {
            for (Data data in value.data) {
              mList.add(ItemFollowing(data));
            }
          }
          start += Const.count;
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
