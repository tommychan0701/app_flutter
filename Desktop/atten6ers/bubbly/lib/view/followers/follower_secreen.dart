import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/view/followers/item_followers_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FollowerScreen extends StatelessWidget {
  PageController _pageController;
  final Data userData;

  FollowerScreen(this.userData);

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(
        initialPage: Provider.of<MyLoading>(context, listen: false)
            .getFollowerPageIndex);
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
                  Center(
                    child: Wrap(
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            gradient: LinearGradient(
                              colors: [
                                colorTheme,
                                colorPink,
                              ],
                            ),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 110,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              ClipOval(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Image(
                                        image: AssetImage(icUserPlaceHolder),
                                        color: colorLightWhite,
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      width: 25,
                                      child: ClipOval(
                                        child: Image.network(
                                          Const.itemBaseUrl +
                                              userData.userProfile,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '@${userData.userName}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0,
              color: colorTextLight,
              margin: EdgeInsets.only(bottom: 5),
            ),
            Consumer<MyLoading>(
              builder: (BuildContext context, value, Widget child) {
                return Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          _pageController.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                              '${userData.followersCount} Followers',
                              style: TextStyle(
                                color: value.getFollowerPageIndex == 0
                                    ? colorTheme
                                    : colorTextLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                              '${userData.followingCount} Following',
                              style: TextStyle(
                                color: value.getFollowerPageIndex == 1
                                    ? colorTheme
                                    : colorTextLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                children: [
                  ItemFollowersPage(userData.userId, 0),
                  ItemFollowersPage(userData.userId, 1),
                ],
                onPageChanged: (value) {
                  Provider.of<MyLoading>(context, listen: false)
                      .setFollowerPageIndex(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
