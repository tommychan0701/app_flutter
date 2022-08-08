import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/view/search/search_user_screen.dart';
import 'package:bubbly/view/search/search_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(
        initialPage:
            Provider.of<MyLoading>(context, listen: false).getSearchPageIndex);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: 35,
                      color: colorTextLight,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                    height: 45,
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: TextField(
                      controller: TextEditingController(
                          text: Provider.of<MyLoading>(context, listen: false)
                              .getSearchText),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: colorTextLight,
                          fontSize: 15,
                        ),
                      ),
                      onChanged: (value) {
                        Provider.of<MyLoading>(context, listen: false)
                            .setSearchText(value);
                      },
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
                              'Videos',
                              style: TextStyle(
                                color: value.getSearchPageIndex == 0
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
                              'Users',
                              style: TextStyle(
                                color: value.getSearchPageIndex == 1
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
              height: 5,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                children: [
                  SearchVideoScreen(),
                  SearchUserScreen(),
                ],
                onPageChanged: (value) {
                  Provider.of<MyLoading>(context, listen: false)
                      .setSearchPageIndex(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
