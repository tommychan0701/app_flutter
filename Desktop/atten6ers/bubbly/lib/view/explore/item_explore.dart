import 'package:bubbly/modal/explore/explore_hash_tag.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/view/hashtag/videos_by_hashtag.dart';
import 'package:flutter/material.dart';

class ItemExplore extends StatefulWidget {
  final ExploreData exploreData;

  ItemExplore(this.exploreData);

  @override
  _ItemExploreState createState() => _ItemExploreState();
}

class _ItemExploreState extends State<ItemExplore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideosByHashTagScreen(widget.exploreData.hashTagName),
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorTheme,
                          colorPink,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Center(
                        child: Text(
                          "#",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: fNSfUiHeavy,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${widget.exploreData.hashTagName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: fNSfUiSemiBold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${widget.exploreData.hashTagVideosCount} Videos',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorTextLight,
                          fontFamily: fNSfUiLight,
                        ),
                      ),
                    ],
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
                      builder: (context) =>
                          VideosByHashTagScreen(widget.exploreData.hashTagName),
                    ),
                  ),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorTextLight,
                      fontFamily: fNSfUiLight,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            AspectRatio(
              aspectRatio: 1 / 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: colorPrimary,
                  child: Image(
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        Const.itemBaseUrl + widget.exploreData.hashTagProfile),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
