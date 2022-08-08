import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/view/home/following_screen.dart';
import 'package:bubbly/view/home/for_u_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(
        initialPage:
            Provider.of<MyLoading>(context, listen: false).isForYou ? 1 : 0,
        keepPage: true);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: BouncingScrollPhysics(),
            controller: controller,
            children: [
              FollowingScreen(),
              ForYouScreen(),
            ],
            onPageChanged: (value) {
              Provider.of<MyLoading>(context, listen: false)
                  .setIsForYouSelected(value == 1);
            },
          ),
          Consumer<MyLoading>(
            builder: (BuildContext context, myLoading, Widget child) {
              return Padding(
                padding: EdgeInsets.only(top: 55),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        controller.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInToLinear);
                      },
                      child: Text(
                        following,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: fNSfUiSemiBold,
                          color: !myLoading.isForYou
                              ? Colors.white
                              : Colors.white.withOpacity(0.7),
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              color: !myLoading.isForYou
                                  ? Colors.black54
                                  : Colors.transparent,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      height: 25,
                      width: 2,
                      color: colorTheme,
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        controller.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInToLinear);
                      },
                      child: Text(
                        forYou,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: fNSfUiSemiBold,
                          color: myLoading.isForYou
                              ? Colors.white
                              : colorTextLight,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              color: myLoading.isForYou
                                  ? Colors.black54
                                  : Colors.transparent,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
