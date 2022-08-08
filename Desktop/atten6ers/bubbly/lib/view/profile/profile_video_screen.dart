import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/uservideo/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/costumview/data_not_found.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/view/dialog/simple_dialog.dart';
import 'package:bubbly/view/profile/item_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileVideoScreen extends StatefulWidget {
  final int type;
  final String userId;
  final bool isMyProfile;

  ProfileVideoScreen(this.type, this.userId, this.isMyProfile);

  @override
  _ProfileVideoScreenState createState() => _ProfileVideoScreenState();
}

class _ProfileVideoScreenState extends State<ProfileVideoScreen>
    with AutomaticKeepAliveClientMixin {
  var _streamController = StreamController<List<Data>>();
  List<Data> data = [];

  bool isLoading = true;

  int start = 0;

  @override
  void initState() {
    callApi();
    print('UserId :' + widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Consumer<MyLoading>(
          builder: (context, value, child) {
            if (value.isScrollProfileVideo &&
                value.getProfilePageIndex == widget.type) {
              if (!isLoading) {
                isLoading = true;
                callApi();
              }
            }
            return Container(
              height: 0,
            );
          },
        ),
        Expanded(
          child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              List<Data> userVideo = [];
              if (snapshot.data != null) {
                userVideo = (snapshot.data as List<Data>);
                data.addAll(userVideo);
                _streamController.add([]);
              }
              return data == null ||
                      snapshot.connectionState == ConnectionState.waiting
                  ? Container(
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1 / 1.3,
                        ),
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(left: 10, bottom: 20),
                        children: List.generate(
                          6,
                          (index) => Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.2),
                            highlightColor: colorLightWhite.withOpacity(0.2),
                            direction: ShimmerDirection.ltr,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: colorPrimaryDark,
                              ),
                              margin: EdgeInsets.only(top: 10, right: 10),
                            ),
                          ),
                        ),
                      ),
                    )
                  : (data.isEmpty
                      ? DataNotFound()
                      : GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 1.3,
                          ),
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 10, bottom: 20),
                          children: List.generate(
                            data.length,
                            (index) => InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onLongPress: () {
                                if (widget.type == 0 && widget.isMyProfile)
                                  showDialog(
                                    context: context,
                                    builder: (context) => SimpleCustomDialog(
                                      title: 'Remove post',
                                      message:
                                          'Are you sure \nwant to remove post ?',
                                      negativeText: 'Cancel',
                                      positiveText: 'Delete',
                                      onButtonClick: (clickType) {
                                        if (clickType == 1) {
                                          ApiService()
                                              .deletePost(
                                                  data[index].postId.toString())
                                              .then((value) {
                                            data.remove(data[index]);
                                            setState(() {});
                                          });
                                        }
                                      },
                                    ),
                                  );
                              },
                              child: ItemPost(
                                data: data[index],
                                list: data,
                                type: widget.type + 1,
                                userId: widget.userId,
                              ),
                            ),
                          ),
                        ));
            },
          ),
        ),
      ],
    );
  }

  void callApi() {
    ApiService()
        .getUserVideos(start.toString(), Const.count.toString(), widget.userId,
            widget.type)
        .then((value) {
      start += Const.count;
      isLoading = false;
      _streamController.add(value.data);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
