import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/uservideo/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/costumview/data_not_found.dart';
import 'package:bubbly/view/search/item_search_video.dart';
import 'package:flutter/material.dart';

class VideosByHashTagScreen extends StatefulWidget {
  final String hashTag;

  VideosByHashTagScreen(this.hashTag);

  @override
  _VideosByHashTagScreenState createState() => _VideosByHashTagScreenState();
}

class _VideosByHashTagScreenState extends State<VideosByHashTagScreen> {
  var start = 0;
  var count = 0;

  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final StreamController _streamController = StreamController<List<Data>>();
  List<Data> postList = [];

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            callApiForGetPostsByHashTag();
          }
        }
      },
    );
    callApiForGetPostsByHashTag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      width: 40,
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Center(
                    child: Text(
                      widget.hashTag,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              height: 80,
              decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorTheme,
                          colorPink,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorPink,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#',
                        style: TextStyle(
                          fontFamily: fNSfUiBold,
                          fontSize: 45,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hashTag,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: fNSfUiBold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$count videos',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorTextLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  List<Data> userVideo = [];
                  if (snapshot.data != null) {
                    userVideo = (snapshot.data as List<Data>);
                    postList.addAll(userVideo);
                    _streamController.add(null);
                  }
                  print(postList.length);
                  return postList == null || postList.isEmpty
                      ? DataNotFound()
                      : GridView(
                          shrinkWrap: true,
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.4,
                          ),
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 10, bottom: 20),
                          children: List.generate(
                            postList.length,
                            (index) => ItemSearchVideo(
                              videoData: postList[index],
                              postList: postList,
                              type: 4,
                              hashTag: widget.hashTag,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callApiForGetPostsByHashTag() {
    ApiService()
        .getPostByHashTag(
      start.toString(),
      Const.count.toString(),
      widget.hashTag.replaceAll('#', ''),
    )
        .then(
      (value) {
        start += Const.count;
        isLoading = false;
        if (count == 0) {
          count = value.totalVideos;
          setState(() {});
        }
        _streamController.add(value.data);
      },
    );
  }
}
