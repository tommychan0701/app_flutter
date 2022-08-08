import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:bubbly/modal/comment/comment.dart';
import 'package:bubbly/modal/explore/explore_hash_tag.dart';
import 'package:bubbly/modal/followers/follower_following_data.dart';
import 'package:bubbly/modal/notificaion/notification.dart';
import 'package:bubbly/modal/plan/coin_plans.dart';
import 'package:bubbly/modal/profileCategory/profile_category.dart';
import 'package:bubbly/modal/rest/rest_response.dart';
import 'package:bubbly/modal/search/search_user.dart';
import 'package:bubbly/modal/single/single_post.dart';
import 'package:bubbly/modal/sound/fav/favourite_music.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/modal/uservideo/user_video.dart';
import 'package:bubbly/modal/wallet/coin_rate.dart';
import 'package:bubbly/modal/wallet/my_wallet.dart';
import 'package:bubbly/modal/wallet/rewarding_actions.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:firebase_auth/firebase_auth.dart' as FireBaseAuth1;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class ApiService {
  var client = http.Client();
  final apiKey = 'https://atten6ers.com/api';

  Future<User> registerUser(HashMap<String, String> params) async {
    final response = await client.post(
      Uri.parse(Const.registerUser),
      body: params,
      headers: {Const.uniqueKey: apiKey},
    );
    final responseJson = jsonDecode(response.body);
    SessionManager sessionManager = SessionManager();
    await sessionManager.initPref();
    print(jsonEncode(User.fromJson(responseJson)));
    sessionManager.saveUser(jsonEncode(User.fromJson(responseJson)));
    return User.fromJson(responseJson);
  }

  Future<UserVideo> getUserVideos(
      String star, String limit, String userId, int type) async {
    final response = await client.post(
      Uri.parse(type == 0 ? Const.getUserVideos : Const.getUserLikesVideos),
      body: {
        Const.start: star,
        Const.limit: limit,
        Const.userId: userId,
        Const.myUserId: SessionManager.userId.toString()
      },
      headers: {Const.uniqueKey: apiKey},
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }

  Future<UserVideo> getPostList(
      String start, String limit, String userId, String type) async {
    final response = await client.post(
      Uri.parse(Const.getPostList),
      body: {
        Const.start: start,
        Const.limit: limit,
        Const.userId: userId,
        Const.type: type,
      },
      headers: {Const.uniqueKey: apiKey},
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }

  Future<RestResponse> likeUnlikePost(String postId) async {
    print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(Const.likeUnlikePost),
      body: {
        Const.postId: postId,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return RestResponse.fromJson(responseJson);
  }

  Future<Comment> getCommentByPostId(
      String start, String limit, String postId) async {
    final response = await client.post(
      Uri.parse(Const.getCommentByPostId),
      body: {
        Const.postId: postId,
        Const.start: start,
        Const.limit: limit,
      },
      headers: {
        Const.uniqueKey: apiKey,
      },
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return Comment.fromJson(responseJson);
  }

  Future<RestResponse> addComment(String comment, String postId) async {
    final response = await client.post(
      Uri.parse(Const.addComment),
      body: {
        Const.postId: postId,
        Const.comment: comment,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> deleteComment(String commentID) async {
    final response = await client.post(
      Uri.parse(Const.deleteComment),
      body: {
        Const.commentId: commentID,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<UserVideo> getPostByHashTag(
      String start, String limit, String hashTag) async {
    print(hashTag);
    final response = await client.post(
      Uri.parse(Const.videosByHashTag),
      body: {
        Const.start: start,
        Const.limit: limit,
        Const.userId: SessionManager.userId.toString(),
        Const.hashTag: hashTag,
      },
      headers: {
        Const.uniqueKey: apiKey,
      },
    );
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return UserVideo.fromJson(responseJson);
  }

  Future<UserVideo> getPostBySoundId(
      String start, String limit, String soundId) async {
    final response = await client.post(
      Uri.parse(Const.getPostBySoundId),
      body: {
        Const.start: start,
        Const.limit: limit,
        Const.userId: SessionManager.userId.toString(),
        Const.soundId: soundId,
      },
      headers: {
        Const.uniqueKey: apiKey,
      },
    );
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return UserVideo.fromJson(responseJson);
  }

  Future<RestResponse> sendCoin(String coin, String toUserId) async {
    final response = await client.post(
      Uri.parse(Const.sendCoin),
      body: {
        Const.coin: coin,
        Const.toUserId: toUserId,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }

  Future<ExploreHashTag> getExploreHashTag(String start, String limit) async {
    final response = await client.post(
      Uri.parse(Const.getExploreHashTag),
      body: {
        Const.start: start,
        Const.limit: limit,
      },
      headers: {
        Const.uniqueKey: apiKey,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return ExploreHashTag.fromJson(responseJson);
  }

  Future<SearchUser> getSearchUser(
      String start, String limit, String keyWord) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(Const.getUserSearchPostList),
      body: {
        Const.start: start,
        Const.limit: limit,
        Const.keyWord: keyWord,
      },
      headers: {
        Const.uniqueKey: apiKey,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return SearchUser.fromJson(responseJson);
  }

  Future<UserVideo> getSearchPostList(
      String start, String limit, String userId, String keyWord) async {
    client = http.Client();
    print(
        'UserId : $userId, Start : $start, Limit : $limit, Keyword : $keyWord');
    final response = await client.post(
      Uri.parse(Const.getSearchPostList),
      body: {
        Const.start: start,
        Const.limit: limit,
        Const.userId: userId,
        Const.keyWord: keyWord,
      },
      headers: {Const.uniqueKey: apiKey},
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return UserVideo.fromJson(responseJson);
  }

  Future<UserNotifications> getNotificationList(
      String start, String limit) async {
    client = http.Client();
    print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(Const.getNotificationList),
      body: {
        Const.start: start,
        Const.limit: limit,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return UserNotifications.fromJson(responseJson);
  }

  Future<RestResponse> setNotificationSettings(String deviceToken) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(Const.setNotificationSettings),
      body: {
        Const.deviceToken: deviceToken,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<CoinRate> getCoinRateList() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(Const.getCoinRateList),
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    final responseJson = jsonDecode(response.body);
    return CoinRate.fromJson(responseJson);
  }

  Future<RewardingActions> getRewardingActions() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(Const.getRewardingActionList),
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return RewardingActions.fromJson(responseJson);
  }

  Future<MyWallet> getMyWalletCoin() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(Const.getMyWalletCoin),
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    final responseJson = jsonDecode(response.body);
    return MyWallet.fromJson(responseJson);
  }

  Future<RestResponse> redeemRequest(String amount, String redeemRequestType,
      String account, String coin) async {
    client = http.Client();
    final response = await client.post(
      Uri.parse(Const.redeemRequest),
      body: {
        Const.amount: amount,
        Const.redeemRequestType: redeemRequestType,
        Const.account: account,
        Const.coin: coin,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> verifyRequest(String idNumber, String name,
      String address, File photoIdImage, File photoWithIdImage) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(Const.verifyRequest),
    );
    request.headers[Const.uniqueKey] = apiKey;
    request.headers[Const.authorization] = SessionManager.accessToken;
    request.fields[Const.idNumber] = idNumber;
    request.fields[Const.name] = name;
    request.fields[Const.address] = address;
    if (photoIdImage != null) {
      request.files.add(
        http.MultipartFile(Const.photoIdImage,
            photoIdImage.readAsBytes().asStream(), photoIdImage.lengthSync(),
            filename: photoIdImage.path.split("/").last),
      );
    }
    if (photoWithIdImage != null) {
      request.files.add(
        http.MultipartFile(
            Const.photoWithIdImage,
            photoWithIdImage.readAsBytes().asStream(),
            photoWithIdImage.lengthSync(),
            filename: photoWithIdImage.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(jsonDecode(respStr));
  }

  Future<User> getProfile(String userId) async {
    final response = await client.post(
      Uri.parse(Const.getProfile),
      body: {
        Const.myUserId: SessionManager.userId.toString(),
        Const.userId: userId,
      },
      headers: {Const.uniqueKey: apiKey},
    );
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    if (userId == SessionManager.userId.toString()) {
      SessionManager sessionManager = SessionManager();
      await sessionManager.initPref();
      print(response.body);
      User user = User.fromJson(responseJson);
      if (SessionManager.accessToken != null &&
          SessionManager.accessToken.isNotEmpty) {
        user.data.setToken(SessionManager.accessToken);
      }
      sessionManager.saveUser(jsonEncode(user));
    }
    return User.fromJson(responseJson);
  }

  Future<ProfileCategory> getProfileCategoryList() async {
    client = http.Client();
    final response = await client.get(
      Uri.parse(Const.getProfileCategoryList),
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    return ProfileCategory.fromJson(responseJson);
  }

  Future<User> updateProfile(
    String fullName,
    String userName,
    String userEmail,
    String bio,
    String fbUrl,
    String instaUrl,
    String youtubeUrl,
    String profileCategory,
    File profileImage,
  ) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(Const.updateProfile),
    );
    request.headers[Const.uniqueKey] = apiKey;
    request.headers[Const.authorization] = SessionManager.accessToken;
    request.fields[Const.fullName] = fullName;
    request.fields[Const.userName] = userName;
    request.fields[Const.userEmail] = userEmail;
    request.fields[Const.bio] = bio;
    request.fields[Const.fbUrl] = fbUrl;
    request.fields[Const.instaUrl] = instaUrl;
    request.fields[Const.youtubeUrl] = youtubeUrl;
    if (profileCategory.isNotEmpty) {
      request.fields[Const.profileCategory] = profileCategory;
    }
    if (profileImage != null) {
      request.files.add(
        http.MultipartFile(Const.userProfile,
            profileImage.readAsBytes().asStream(), profileImage.lengthSync(),
            filename: profileImage.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    User user = User.fromJson(jsonDecode(respStr));
    if (user.data.userId.toString() == SessionManager.userId.toString()) {
      SessionManager sessionManager = SessionManager();
      print(respStr);
      await sessionManager.initPref();
      if (SessionManager.accessToken != null &&
          SessionManager.accessToken.isNotEmpty) {
        user.data.setToken(SessionManager.accessToken);
      }
      sessionManager.saveUser(jsonEncode(user));
    }
    return User.fromJson(jsonDecode(respStr));
  }

  Future<RestResponse> followUnFollowUser(String toUserId) async {
    final response = await client.post(
      Uri.parse(Const.followUnFollowPost),
      body: {
        Const.toUserId: toUserId,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return RestResponse.fromJson(responseJson);
  }

  Future<FollowerFollowingData> getFollowersList(
      String userId, String start, String count, int type) async {
    final response = await client.post(
      Uri.parse(type == 0 ? Const.getFollowerList : Const.getFollowingList),
      body: {
        Const.userId: userId,
        Const.start: start,
        Const.limit: count,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return FollowerFollowingData.fromJson(responseJson);
  }

  Future<Sound> getSoundList() async {
    final response = await client.get(
      Uri.parse(Const.getSoundList),
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return Sound.fromJson(responseJson);
  }

  Future<FavouriteMusic> getFavouriteSoundList() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(Const.getFavouriteSoundList),
      body: jsonEncode(<String, List<String>>{
        'sound_ids': sessionManager.getFavouriteMusic(),
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return FavouriteMusic.fromJson(responseJson);
  }

  Future<RestResponse> addPost({
    String postDescription,
    String postHashTag,
    String isOrignalSound,
    String soundTitle,
    String duration,
    String singer,
    String soundId,
    File postVideo,
    File thumbnail,
    File postSound,
    File soundImage,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(Const.addPost),
    );
    request.headers[Const.uniqueKey] = apiKey;
    request.headers[Const.authorization] = SessionManager.accessToken;
    request.fields[Const.postDescription] = postDescription;
    request.fields[Const.postHashTag] =
        postHashTag == null || postHashTag.isEmpty ? 'bubbletok' : postHashTag;
    request.fields[Const.isOrignalSound] = isOrignalSound;
    if (isOrignalSound == '1') {
      request.fields[Const.soundTitle] = soundTitle;
      request.fields[Const.duration] = duration;
      request.fields[Const.singer] = singer;
      if (postSound != null) {
        request.files.add(
          http.MultipartFile(Const.postSound,
              postSound.readAsBytes().asStream(), postSound.lengthSync(),
              filename: postSound.path.split("/").last),
        );
      }
      if (soundImage != null) {
        request.files.add(
          http.MultipartFile(Const.soundImage,
              soundImage.readAsBytes().asStream(), soundImage.lengthSync(),
              filename: soundImage.path.split("/").last),
        );
      }
    } else {
      request.fields[Const.soundId] = soundId;
    }
    if (postVideo != null) {
      request.files.add(
        http.MultipartFile(Const.postVideo, postVideo.readAsBytes().asStream(),
            postVideo.lengthSync(),
            filename: postVideo.path.split("/").last),
      );
    }
    if (thumbnail != null) {
      request.files.add(
        http.MultipartFile(Const.postImage, thumbnail.readAsBytes().asStream(),
            thumbnail.lengthSync(),
            filename: thumbnail.path.split("/").last),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    final responseJson = jsonDecode(respStr);
    print(responseJson);
    addCoin();
    return RestResponse.fromJson(responseJson);
  }

  Future<FavouriteMusic> getSearchSoundList(String keyword) async {
    client = http.Client();
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(Const.getSearchSoundList),
      body: {
        Const.keyWord: keyword,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return FavouriteMusic.fromJson(responseJson);
  }

  Future<UserVideo> getPostsByType({
    @required int pageDataType,
    @required String start,
    @required String limit,
    String userId,
    String soundId,
    String hashTag,
    String keyWord,
  }) {
    ///PagedDataType
    ///1 = UserVideo
    ///2 = UserLikesVideo
    ///3 = PostsBySound
    ///4 = PostsByHashTag
    ///5 = PostsBySearch
    switch (pageDataType) {
      case 1:
        return getUserVideos(start, limit, userId, 0);
      case 2:
        return getUserVideos(start, limit, userId, 1);
      case 3:
        return getPostBySoundId(start, limit, soundId);
      case 4:
        return getPostByHashTag(start, limit, hashTag.replaceAll('#', ''));
      case 5:
        return getSearchPostList(start, limit, userId, keyWord);
    }
    return getPostByHashTag(start, limit, hashTag);
  }

  Future<RestResponse> logoutUser() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    await FireBaseAuth1.FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    FacebookAuth.instance.logOut();
    print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(Const.logoutUser),
      body: {
        Const.userId: SessionManager.userId.toString(),
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    sessionManager.clean();
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> deleteAccount() async {
    SessionManager sessionManager = new SessionManager();
    await sessionManager.initPref();
    await FireBaseAuth1.FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    FacebookAuth.instance.logOut();
    print(SessionManager.accessToken);
    final response = await client.post(
      Uri.parse(Const.deleteAccount),
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    sessionManager.clean();
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> deletePost(String postId) async {
    final response = await client.post(
      Uri.parse(Const.deletePost),
      body: {
        Const.postId: postId,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> reportUserOrPost(
    String reportType,
    String postIdOrUserId,
    String reason,
    String description,
    String contactInfo,
  ) async {
    final response = await client.post(
      Uri.parse(Const.reportPostOrUser),
      body: {
        Const.reportType: reportType,
        reportType == '1' ? Const.userId : Const.postId: postIdOrUserId,
        Const.reason: reason,
        Const.description: description,
        Const.contactInfo: contactInfo,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> blockUser(String userId) async {
    final response = await client.post(
      Uri.parse(Const.blockUser),
      body: {
        Const.userId: userId,
      },
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }

  Future<SinglePost> getPostByPostId(String postId) async {
    final response = await client.post(
      Uri.parse(Const.getPostListById),
      body: {
        Const.postId: postId,
      },
      headers: {
        Const.uniqueKey: apiKey,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return SinglePost.fromJson(responseJson);
  }

  Future<CoinPlans> getCoinPlanList() async {
    final response = await client.get(
      Uri.parse(Const.getCoinPlanList),
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return CoinPlans.fromJson(responseJson);
  }

  Future<CoinPlans> addCoin() async {
    final response = await client.post(
      Uri.parse(Const.addCoin),
      body: {Const.rewardingActionId: '3'},
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return CoinPlans.fromJson(responseJson);
  }

  Future<RestResponse> purchaseCoin(String coin) async {
    print(SessionManager.accessToken + coin);
    final response = await client.post(
      Uri.parse(Const.purchaseCoin),
      body: {Const.coin: coin},
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );
    print(response.body);
    final responseJson = jsonDecode(response.body);
    await getProfile(SessionManager.userId.toString());
    return RestResponse.fromJson(responseJson);
  }

  Future<RestResponse> increasePostViewCount(String postId) async {
    final response = await client.post(
      Uri.parse(Const.increasePostViewCount),
      body: {Const.postId: postId},
      headers: {
        Const.uniqueKey: apiKey,
        Const.authorization: SessionManager.accessToken,
      },
    );

    print(response.body);
    final responseJson = jsonDecode(response.body);
    return RestResponse.fromJson(responseJson);
  }
}
