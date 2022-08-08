import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/explore/explore_hash_tag.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/costumview/data_not_found.dart';
import 'package:bubbly/view/explore/item_explore.dart';
import 'package:bubbly/view/qrcode/scan_qr_code_screen.dart';
import 'package:bubbly/view/search/search_screen.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int start = 0;

  var _streamController = StreamController<List<ExploreData>>();
  ScrollController _scrollController = ScrollController();

  List<ExploreData> exploreList = [];

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiExploreHashTag();
        }
      }
    });
    callApiExploreHashTag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 45,
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search',
                          style: TextStyle(
                            color: colorTextLight,
                            fontSize: 15,
                          ),
                        ),
                        Image(
                          height: 20,
                          image: AssetImage(icSearch),
                          color: colorTextLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanQrCodeScreen(),
                  ),
                ),
                child: Image(
                  height: 20,
                  image: AssetImage(icQrCode),
                  color: colorTextLight,
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                List<ExploreData> userVideo = [];
                if (snapshot.data != null) {
                  userVideo = (snapshot.data as List<ExploreData>);
                  exploreList.addAll(userVideo);
                }
                return exploreList == null || exploreList.isEmpty
                    ? DataNotFound()
                    : ListView(
                        padding: EdgeInsets.only(top: 15),
                        shrinkWrap: true,
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        children: List.generate(exploreList.length,
                            (index) => ItemExplore(exploreList[index])),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  void callApiExploreHashTag() {
    ApiService()
        .getExploreHashTag(start.toString(), Const.count.toString())
        .then((value) {
      start += Const.count;
      isLoading = false;
      _streamController.add(value.data);
    });
  }
}
