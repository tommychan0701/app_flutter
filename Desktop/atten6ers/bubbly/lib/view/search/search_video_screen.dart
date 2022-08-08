import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/uservideo/user_video.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/costumview/data_not_found.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_search_video.dart';

class SearchVideoScreen extends StatefulWidget {
  @override
  _SearchVideoScreenState createState() => _SearchVideoScreenState();
}

class _SearchVideoScreenState extends State<SearchVideoScreen> {
  String keyWord = '';
  ApiService apiService = ApiService();

  int start = 0;
  var _streamController = StreamController<List<Data>>();
  ScrollController _scrollController = ScrollController();

  List<Data> searchPostList = [];

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiForPostList();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<MyLoading>(
          builder: (context, value, child) {
            start = 0;
            keyWord = value.getSearchText;
            searchPostList = [];
            callApiForPostList();
            return Container();
          },
        ),
        Expanded(
          child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              List<Data> searchVideo = [];
              if (snapshot.data != null) {
                searchVideo = (snapshot.data as List<Data>);
                searchPostList.addAll(searchVideo);
              }
              return searchPostList == null || searchPostList.isEmpty
                  ? DataNotFound()
                  : GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.4,
                      ),
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(left: 10, bottom: 20),
                      children: List.generate(
                        searchPostList.length,
                        (index) => ItemSearchVideo(
                          videoData: searchPostList[index],
                          postList: searchPostList,
                          type: 5,
                          keyWord: keyWord,
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  void callApiForPostList() {
    apiService.client.close();
    apiService
        .getSearchPostList(start.toString(), Const.count.toString(),
            SessionManager.userId.toString(), keyWord)
        .then(
      (value) {
        print(value.data.length);
        start += Const.count;
        isLoading = false;
        _streamController.add(value.data);
      },
    );
  }
}
