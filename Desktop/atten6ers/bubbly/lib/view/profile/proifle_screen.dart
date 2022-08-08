import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/costumview/data_not_found.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/followers/follower_secreen.dart';
import 'package:bubbly/view/login/dialog_login.dart';
import 'package:bubbly/view/profile/edit_profile_screen.dart';
import 'package:bubbly/view/profile/profile_video_screen.dart';
import 'package:bubbly/view/report/report_screen.dart';
import 'package:bubbly/view/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final int type;
  final String userId;

  ProfileScreen(this.type, this.userId);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController scrollController = ScrollController();

  var _streamController = StreamController<User>();
  String userId;
  User _user;
  bool isMyProfile = true;
  PageController controller;
  bool isBlock = false;

  @override
  void initState() {
    if (widget.type == 0) {
      userId = SessionManager.userId.toString();
    } else {
      userId = widget.userId;
    }
    isMyProfile = userId.toString() == SessionManager.userId.toString();
    print(widget.userId);

    getUserProfile();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        Provider.of<MyLoading>(context, listen: false)
            .setScrollProfileVideo(true);
      }
    });
    controller = PageController(
        initialPage:
            Provider.of<MyLoading>(context, listen: false).getProfilePageIndex,
        keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          body: Container(
            color: colorPrimary,
            child: isBlock
                ? DataNotFound()
                : PageView(
                    controller: controller,
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (value) {
                      Provider.of<MyLoading>(context, listen: false)
                          .setProfilePageIndex(value);
                    },
                    children: [
                      ProfileVideoScreen(0, userId, isMyProfile),
                      ProfileVideoScreen(1, userId, isMyProfile),
                    ],
                  ),
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              StreamBuilder<User>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    _user = snapshot.data;
                  }
                  return SliverAppBar(
                    expandedHeight: getTotalHeight(
                        snapshot != null && snapshot.data != null
                            ? snapshot.data.data
                            : null),
                    floating: false,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: colorPrimaryDark,
                    title: Container(
                      height: 58,
                      color: colorPrimaryDark,
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              snapshot.data != null &&
                                      snapshot.data.data != null
                                  ? snapshot.data.data.fullName
                                  : '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: fNSfUiSemiBold,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.type == 2,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Align(
                            alignment: !isMyProfile
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                if (!isMyProfile) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SettingScreen();
                                      },
                                    ),
                                  );
                                }
                              },
                              child: !isMyProfile
                                  ? Icon(
                                      Icons.chevron_left_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : Image(
                                      width: 50,
                                      height: 20,
                                      color: Colors.white,
                                      image: AssetImage(icMenu),
                                    ),
                            ),
                          ),
                          Visibility(
                            visible: !isMyProfile,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton(
                                itemBuilder: (BuildContext context) {
                                  return List.generate(
                                      SessionManager.userId == -1 ? 2 : 3,
                                      (index) {
                                    return PopupMenuItem(
                                      value: index,
                                      child: Text(
                                        index == 0
                                            ? 'Share Profile'
                                            : index == 1
                                                ? 'Report User'
                                                : (isBlock
                                                    ? 'UnBlock User'
                                                    : 'Block User'),
                                        style: TextStyle(
                                          color: colorTextLight,
                                          fontFamily: fNSfUiMedium,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                onSelected: (value) {
                                  if (value == 0) {
                                    shareLink(context);
                                    return;
                                  }
                                  if (value == 1) {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          ReportScreen(2, widget.userId),
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                    );
                                    return;
                                  }
                                  if (value == 2) {
                                    ApiService()
                                        .blockUser(userId)
                                        .then((value) {
                                      isBlock = !isBlock;
                                      setState(() {});
                                    });
                                  }
                                },
                                color: colorPrimary,
                                child: Image(
                                  width: 50,
                                  height: 20,
                                  color: Colors.white,
                                  image: AssetImage(icMenu),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Container(
                        color: colorPrimaryDark,
                        child: snapshot.data == null
                            ? Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 64,
                                  ),
                                  Container(
                                    height: 72,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorPink,
                                          blurRadius: 15,
                                          offset: Offset(1, 1),
                                          spreadRadius: 1,
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(Const.itemBaseUrl +
                                            snapshot.data.data.userProfile),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            icUserPlaceHolder,
                                            color: colorLightWhite,
                                            width: 60,
                                            height: 60,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3),
                                      ),
                                    ),
                                    height: snapshot.data.data
                                            .profileCategoryName.isNotEmpty
                                        ? 20
                                        : 0,
                                    margin: EdgeInsets.only(
                                      bottom: 2,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Text(
                                      snapshot.data.data.profileCategoryName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: fNSfUiBold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.data.data.fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: fNSfUiSemiBold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '@${snapshot.data.data.userName}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: colorTextLight,
                                          fontFamily: fNSfUiRegular,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Image(
                                        image: AssetImage(icVerify),
                                        height: snapshot.data.data.isVerify == 1
                                            ? 15
                                            : 0,
                                        width: snapshot.data.data.isVerify == 1
                                            ? 15
                                            : 0,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: !((snapshot.data.data.fbUrl ==
                                                null ||
                                            snapshot.data.data.fbUrl.isEmpty) &&
                                        (snapshot.data.data.instaUrl == null ||
                                            snapshot
                                                .data.data.instaUrl.isEmpty) &&
                                        (snapshot.data.data.youtubeUrl ==
                                                null ||
                                            snapshot
                                                .data.data.youtubeUrl.isEmpty)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          onTap: () => _launchURL(
                                              snapshot.data.data.fbUrl),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image(
                                              image: AssetImage(
                                                icFaceBook,
                                              ),
                                              height:
                                                  snapshot.data.data.fbUrl !=
                                                              null &&
                                                          snapshot.data.data
                                                              .fbUrl.isNotEmpty
                                                      ? 16
                                                      : 0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          onTap: () => _launchURL(
                                              snapshot.data.data.instaUrl),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image(
                                              image: AssetImage(
                                                icInstagram,
                                              ),
                                              height:
                                                  snapshot.data.data.instaUrl !=
                                                              null &&
                                                          snapshot
                                                              .data
                                                              .data
                                                              .instaUrl
                                                              .isNotEmpty
                                                      ? 16
                                                      : 0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          onTap: () => _launchURL(
                                              snapshot.data.data.youtubeUrl),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image(
                                              image: AssetImage(
                                                icYouTube,
                                              ),
                                              height: snapshot.data.data
                                                              .youtubeUrl !=
                                                          null &&
                                                      snapshot.data.data
                                                          .youtubeUrl.isNotEmpty
                                                  ? 18
                                                  : 0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: snapshot.data.data.bio != null &&
                                        snapshot.data.data.bio.isNotEmpty,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 40),
                                      child: Text(
                                        snapshot.data.data.bio != null
                                            ? snapshot.data.data.bio
                                            : '',
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: colorTextLight,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 250,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Column(
                                            children: [
                                              Text(
                                                NumberFormatter.formatter(
                                                  snapshot.data.data.myPostLikes
                                                      .toString(),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontFamily: fNSfUiBold,
                                                ),
                                              ),
                                              Text(
                                                'Likes',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: colorTextLight,
                                                  fontFamily: fNSfUiMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          onTap: () {
                                            Provider.of<MyLoading>(context,
                                                    listen: false)
                                                .setFollowerPageIndex(0);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowerScreen(
                                                        snapshot.data.data),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                NumberFormatter.formatter(
                                                  snapshot
                                                      .data.data.followersCount
                                                      .toString(),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontFamily: fNSfUiBold,
                                                ),
                                              ),
                                              Text(
                                                'Followers',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: colorTextLight,
                                                  fontFamily: fNSfUiMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          onTap: () {
                                            Provider.of<MyLoading>(context,
                                                    listen: false)
                                                .setFollowerPageIndex(1);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FollowerScreen(
                                                        snapshot.data.data),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                NumberFormatter.formatter(
                                                  snapshot
                                                      .data.data.followingCount
                                                      .toString(),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontFamily: fNSfUiBold,
                                                ),
                                              ),
                                              Text(
                                                'Following',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: colorTextLight,
                                                  fontFamily: fNSfUiMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  !isMyProfile
                                      ? FollowUnFollowButton(
                                          snapshot.data,
                                          (isFollowing) {
                                            User _user = snapshot.data;
                                            if (isFollowing) {
                                              _user.data.addFollowerCount();
                                            } else {
                                              _user.data.removeFollowerCount();
                                            }
                                            _streamController
                                                .add(snapshot.data);
                                          },
                                        )
                                      : Container(
                                          width: 120,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              side: MaterialStateProperty.all(
                                                  BorderSide(
                                                width: 1,
                                                color: Colors.white,
                                              )),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfileScreen(),
                                                ),
                                              ).then((value) {
                                                getUserProfile();
                                              });
                                            },
                                            child: Text(
                                              'Edit Profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(Consumer<MyLoading>(
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  onTap: () {
                                    Provider.of<MyLoading>(context,
                                            listen: false)
                                        .setProfilePageIndex(0);
                                    controller.animateToPage(0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Image(
                                    height: 16,
                                    image: AssetImage(icCategory),
                                    color: value.getProfilePageIndex == 0
                                        ? Colors.white
                                        : colorTextLight,
                                  ),
                                ),
                              ),
                              Container(
                                height: 15,
                                width: 1,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: InkWell(
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  onTap: () {
                                    Provider.of<MyLoading>(context,
                                            listen: false)
                                        .setProfilePageIndex(1);

                                    controller.animateToPage(1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Image(
                                    height: 18,
                                    image: AssetImage(icHeart),
                                    color: value.getProfilePageIndex == 1
                                        ? Colors.white
                                        : colorTextLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 0.5,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ],
                    );
                  },
                )),
                pinned: true,
              ),
            ];
          },
        ),
      ),
    );
  }

  double getTotalHeight(Data data) {
    double height = 445;
    if (data != null) {
      if (data.profileCategoryName == null || data.profileCategoryName.isEmpty)
        height -= 20;
      if ((data.youtubeUrl == null || data.youtubeUrl.isEmpty) &&
          (data.fbUrl == null || data.fbUrl.isEmpty) &&
          (data.instaUrl == null || data.instaUrl.isEmpty)) height -= 30;
      if (data.bio == null || data.bio.isEmpty) height -= 40;
    }
    return height;
  }

  void getUserProfile() {
    if ((widget.userId.isNotEmpty && widget.userId != '-1') ||
        (SessionManager.userId != null && SessionManager.userId != -1)) {
      ApiService()
          .getProfile(widget.type == 0
              ? SessionManager.userId.toString()
              : widget.userId)
          .then((value) {
        if (value.status == 200) {
          if (widget.userId == SessionManager.userId.toString()) {
            Provider.of<MyLoading>(context, listen: false).setUser(value);
          }
          _streamController.add(value);
          _user = value;
          isBlock = _user.data.blockOrNot == 1;
          setState(() {});
        }
      });
    }
  }

  void _launchURL(String _url) async => await canLaunchUrl(Uri.parse(_url))
      ? await launchUrl(Uri.parse(_url))
      : {showToast('Invalid url')};

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colorPrimaryDark,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void shareLink(BuildContext context) async {
    User user = _user;

    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: user.data.userName,
        imageUrl: Const.itemBaseUrl + user.data.userProfile,
        contentDescription: '',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('user_id', user.data.userId));
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      Share.share(
        'Check out this amazing profile ${response.result} 😋😋',
        subject: 'Look ${user.data.userName}',
      );
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }
}

class FollowUnFollowButton extends StatefulWidget {
  final User data;
  final Function followClick;

  const FollowUnFollowButton(this.data, this.followClick);

  @override
  _FollowUnFollowButtonState createState() => _FollowUnFollowButtonState();
}

class _FollowUnFollowButtonState extends State<FollowUnFollowButton> {
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    isFollowing = widget.data.data.isFollowing == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (SessionManager.userId == -1) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return DialogLogin();
            },
          ).then((value) {
            Navigator.pop(context);
          });
          return;
        }
        isLoading = true;
        setState(() {});
        ApiService()
            .followUnFollowUser(widget.data.data.userId.toString())
            .then(
          (value) {
            if (value != null && value.status == 200) {
              isLoading = false;
              isFollowing = !isFollowing;
              setState(() {});
              widget.followClick(isFollowing);
            }
          },
        );
      },
      child: Container(
        width: 120,
        height: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [
                    colorPrimary,
                    colorPrimary,
                  ]
                : !isFollowing
                    ? [
                        colorTheme,
                        colorPink,
                      ]
                    : [
                        colorPrimary,
                        colorPrimary,
                      ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Center(
          child: isLoading
              ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  isFollowing ? 'UnFollow' : 'Follow',
                  style: TextStyle(fontFamily: fNSfUiMedium),
                ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  Consumer<MyLoading> consumer;

  _SliverAppBarDelegate(this.consumer);

  @override
  double get minExtent => 52;

  @override
  double get maxExtent => 52;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: colorPrimary,
      child: consumer,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
