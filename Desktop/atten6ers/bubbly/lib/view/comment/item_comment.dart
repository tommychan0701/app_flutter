import 'package:bubbly/modal/comment/comment.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';

class ItemComment extends StatelessWidget {
  final CommentData commentData;
  final Function onRemoveClick;

  ItemComment(this.commentData, this.onRemoveClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(icUserPlaceHolder),
                scale: 1.5,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                Const.itemBaseUrl + commentData.userProfile,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container();
                },
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        commentData.fullName,
                        style: TextStyle(
                          fontFamily: fNSfUiMedium,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: commentData.userId == SessionManager.userId,
                      child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: () => onRemoveClick.call(),
                        child: Icon(
                          Icons.delete,
                          color: colorTextLight,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  commentData.comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorTextLight,
                    fontFamily: fNSfUiRegular,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 0.3,
                  color: colorTextLight.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
