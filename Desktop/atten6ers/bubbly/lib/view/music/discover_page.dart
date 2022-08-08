import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:flutter/material.dart';

import 'item_discover_screen.dart';

class DiscoverPage extends StatefulWidget {
  final Function onMoreClick;
  final Function onPlayClick;

  DiscoverPage({this.onMoreClick, this.onPlayClick});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<SoundData> soundCategoryList = [];

  @override
  void initState() {
    getDiscoverSound();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: List<ItemDiscoverScreen>.generate(
        soundCategoryList.length,
        (index) => ItemDiscoverScreen(soundCategoryList[index], (soundList) {
          widget.onMoreClick.call(soundList);
        }, widget.onPlayClick),
      ),
    );
  }

  ApiService _apiService = ApiService();

  void getDiscoverSound() {
    _apiService.getSoundList().then((value) {
      if (value != null) {
        soundCategoryList = value.data;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _apiService.client.close();
    super.dispose();
  }
}
