import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/dialog/loader_dialog.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hashtagable/hashtagable.dart';

class UploadScreen extends StatefulWidget {
  final String postVideo;
  final String thumbNail;
  final String sound;
  final String soundId;

  UploadScreen({this.postVideo, this.thumbNail, this.sound, this.soundId});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  ValueNotifier<int> textSize = ValueNotifier<int>(0);
  String postDes = '';
  String currentHashTag = '';
  List<String> hashTags = [];
  SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      'Upload Video',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Image(
                    height: 160,
                    width: 110,
                    fit: BoxFit.cover,
                    image: FileImage(File(widget.thumbNail)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Describe',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding: EdgeInsets.only(left: 15, right: 15),
                        height: 130,
                        child: HashTagTextField(
                          decoratedStyle: TextStyle(
                            fontFamily: fNSfUiBold,
                            letterSpacing: 0.6,
                            fontSize: 13,
                          ),
                          basicStyle: TextStyle(
                            fontFamily: fNSfUiRegular,
                            letterSpacing: 0.6,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(175),
                          ],
                          enableSuggestions: false,
                          maxLines: 8,
                          onChanged: (value) {
                            textSize.value = value.length;
                            postDes = value;
                          },
                          onDetectionTyped: (text) {
                            currentHashTag = text.split("#")[1];
                          },
                          onDetectionFinished: () {
                            if (currentHashTag.isNotEmpty) {
                              hashTags.add(currentHashTag);
                              currentHashTag = '';
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Awesome caption',
                            hintStyle: TextStyle(
                              color: colorTextLight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: ValueListenableBuilder(
                  valueListenable: textSize,
                  builder: (context, value, child) => Text(
                    '$value/175',
                    style: TextStyle(
                      color: colorTextLight,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  if (currentHashTag.isNotEmpty) {
                    hashTags.add(currentHashTag);
                    currentHashTag = '';
                  }
                  showDialog(
                    context: context,
                    builder: (context) => LoaderDialog(),
                  );
                  print(hashTags.join(","));
                  if (widget.soundId != null) {
                    ApiService()
                        .addPost(
                      postVideo: File(widget.postVideo),
                      thumbnail: File(widget.thumbNail),
                      duration: '1',
                      isOrignalSound: '0',
                      postDescription: postDes,
                      postHashTag: hashTags.join(","),
                      soundId: widget.soundId,
                    )
                        .then(
                      (value) {
                        if (value.status == 200) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showToast('Post Upload Successfully');
                        } else {
                          showToast('Failed to Add');
                        }
                      },
                    );
                  } else {
                    ApiService()
                        .addPost(
                      postVideo: File(widget.postVideo),
                      thumbnail: File(widget.thumbNail),
                      postSound: File(widget.sound),
                      duration: '1',
                      isOrignalSound: widget.soundId != null ? '0' : '1',
                      postDescription: postDes,
                      postHashTag: hashTags.join(","),
                      singer: _sessionManager?.getUser()?.data?.fullName,
                      soundImage: File(widget.thumbNail),
                      soundTitle: 'Original Sound',
                      soundId: widget.soundId,
                    )
                        .then(
                      (value) {
                        if (value.status == 200) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showToast('Post Upload Successfully');
                        } else {
                          showToast('Failed to Add');
                        }
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorTheme,
                        colorPink,
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 150,
                  height: 40,
                  child: Center(
                    child: Text(
                      'Publish'.toUpperCase(),
                      style: TextStyle(
                        fontFamily: fNSfUiBold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'By continuing, you agree to our terms of use\nand confirm that you have read our privacy policy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontFamily: fNSfUiLight,
                color: colorTextLight,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(3),
                ),
              ),
              child: Text(
                'Policy center',
                style: TextStyle(
                  color: colorTheme,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  void initSessionManager() async {
    await _sessionManager.initPref();
  }
}
