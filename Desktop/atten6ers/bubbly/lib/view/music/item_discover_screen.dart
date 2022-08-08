import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/view/music/item_fav_music_screen.dart';
import 'package:flutter/material.dart';

class ItemDiscoverScreen extends StatelessWidget {
  final SoundData soundData;
  final Function onMoreClick;
  final Function onPlayClick;

  ItemDiscoverScreen(this.soundData, this.onMoreClick, this.onPlayClick);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  soundData.soundCategoryName,
                  style: TextStyle(
                    color: colorTheme,
                  ),
                ),
              ),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  onMoreClick.call(soundData.soundList);
                  // showModalBottomSheet(
                  //   context: context,
                  //   backgroundColor: colorPrimaryDark,
                  //   builder: (context) => SearchMusicScreen(
                  //     soundList: soundData.soundList,
                  //   ),
                  // );
                },
                child: Row(
                  children: [
                    Text(
                      'More',
                      style: TextStyle(
                        color: colorTextLight,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image(
                      width: 20,
                      image: AssetImage(icMenu),
                      color: colorTheme,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 290,
          child: GridView(
            scrollDirection: Axis.horizontal,
            primary: false,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 105 / MediaQuery.of(context).size.width,
            ),
            children: new List<Widget>.generate(
              soundData.soundList.length,
              (index) => ItemFavMusicScreen(
                soundData.soundList[index],
                (soundUrl) {
                  onPlayClick(soundUrl);
                },
                1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
