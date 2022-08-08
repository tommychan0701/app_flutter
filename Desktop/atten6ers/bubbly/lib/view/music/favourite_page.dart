import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/view/music/item_fav_music_screen.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  final Function onClick;

  FavouritePage({this.onClick});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<SoundList> favMusicList = [];

  @override
  void initState() {
    getFavouriteSoundList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: List<ItemFavMusicScreen>.generate(
        favMusicList.length,
        (index) => ItemFavMusicScreen(favMusicList[index], (soundUrl) {
          widget.onClick(soundUrl);
        }, 2),
      ),
    );
  }

  void getFavouriteSoundList() {
    ApiService().getFavouriteSoundList().then((value) {
      if (value != null) {
        favMusicList = value.data;
        setState(() {});
      }
    });
  }
}
