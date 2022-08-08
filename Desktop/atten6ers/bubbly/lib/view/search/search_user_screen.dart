import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/search/search_user.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/costumview/data_not_found.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/view/search/item_search_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchUserScreen extends StatefulWidget {
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  String keyWord = '';
  ApiService apiService = ApiService();

  int start = 0;
  var _streamController = StreamController<List<SearchUserData>>();
  ScrollController _scrollController = ScrollController();

  List<SearchUserData> searchUserList = [];

  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = true;
          callApiForSearchUsers();
        }
      }
    });
    // callApiForSearchUsers();
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
            searchUserList = [];
            callApiForSearchUsers();
            return Container();
          },
        ),
        Expanded(
          child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              List<SearchUserData> searchUser = [];
              if (snapshot.data != null) {
                searchUser = (snapshot.data as List<SearchUserData>);
                searchUserList.addAll(searchUser);
              }
              return searchUserList == null || searchUserList.isEmpty
                  ? DataNotFound()
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      padding: EdgeInsets.only(left: 10, bottom: 20),
                      children: List.generate(
                        searchUserList.length,
                        (index) => ItemSearchUser(searchUserList[index]),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  void callApiForSearchUsers() {
    apiService.client.close();

    apiService
        .getSearchUser(start.toString(), Const.count.toString(), keyWord)
        .then((value) {
      start += Const.count;
      isLoading = false;
      _streamController.add(value.data);
    });
  }
}
