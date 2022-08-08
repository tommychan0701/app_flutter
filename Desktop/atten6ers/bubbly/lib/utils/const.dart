import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const PrivacyUrl = 'https://flutter.io';
const isNotificationOn = 'is_notification_on';

//FontName
const fNSfUiBold = 'SfUiBold';
const fNSfUiRegular = 'SfUiRegular';
const fNSfUiMedium = 'SfUiMedium';
const fNSfUiLight = 'SfUiLight';
const fNSfUiSemiBold = 'SfUiSemiBold';
const fNSfUiHeavy = 'SfUiHeavy';

//Strings
const byFlutterMaster = 'By FlutterMaster';
const following = 'Following';
const forYou = 'For You';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'bubbly', // id
  'Notification', // title
  // 'This channel is used for bubbly notifications.', // description
  importance: Importance.max,
);

class Const {
  static final String baseUrl = 'http://-----/api/';

  static final String itemBaseUrl = 'http://--------/';

  ///RegisterUser
  static final String registerUser = baseUrl + 'User/Registration';
  static final String deviceToken = 'device_token';
  static final String userEmail = 'user_email';
  static final String fullName = 'full_name';
  static final String loginType = 'login_type';
  static final String userName = 'user_name';
  static final String identity = 'identity';
  static final String platform = 'platform';

  ///getUserVideos getUserLikesVideos
  static final String getUserVideos = baseUrl + 'Post/getUserVideos';
  static final String getUserLikesVideos = baseUrl + 'Post/getUserLikesVideos';
  static final String start = 'start';
  static final String limit = 'limit';
  static final String userId = 'user_id';
  static final String myUserId = 'my_user_id';

  /// getPostList
  ///type following and related
  static final String getPostList = baseUrl + 'Post/getPostList';
  static final String type = 'type';
  static final String following = 'following';
  static final String trending = 'trending';
  static final String related = 'related';

  ///LikeUnlikeVideo
  static final String likeUnlikePost = baseUrl + 'Post/LikeUnlikePost';
  static final String postId = 'post_id';

  ///CommentListByPostId
  static final String getCommentByPostId = baseUrl + 'Post/getCommentByPostId';

  ///addComment
  static final String addComment = baseUrl + 'Post/addComment';
  static final String comment = 'comment';

  ///deleteComment
  static final String deleteComment = baseUrl + 'Post/deleteComment';
  static final String commentId = 'comments_id';

  ///getVideoByHashTag
  static final String videosByHashTag =
      baseUrl + 'Post/getSingleHashTagPostList';
  static final String hashTag = 'hash_tag';

  ///getVideoBySoundId
  static final String getPostBySoundId = baseUrl + 'Post/getPostBySoundId';
  static final String soundId = 'sound_id';

  ///sendCoin
  static final String sendCoin = baseUrl + 'Wallet/sendCoin';
  static final String coin = 'coin';
  static final String toUserId = 'to_user_id';

  ///getExploreHashTag
  static final String getExploreHashTag =
      baseUrl + 'Post/getExploreHashTagPostList';

  ///getUserSearchPostList
  static final String getUserSearchPostList =
      baseUrl + 'Post/getUserSearchPostList';
  static final String keyWord = 'keyword';

  ///getSearchPostList
  static final String getSearchPostList = baseUrl + 'Post/getSearchPostList';

  ///getNotificationList
  static final String getNotificationList =
      baseUrl + 'User/getNotificationList';

  ///setNotificationSettings
  static final String setNotificationSettings =
      baseUrl + 'User/setNotificationSettings';

  ///getCoinRateList
  static final String getCoinRateList = baseUrl + 'Wallet/getCoinRateList';

  ///getRewardingActionList
  static final String getRewardingActionList =
      baseUrl + 'Wallet/getRewardingActionList';

  ///getMyWalletCoin
  static final String getMyWalletCoin = baseUrl + 'Wallet/getMyWalletCoin';

  ///redeemRequest
  static final String redeemRequest = baseUrl + 'Wallet/redeemRequest';
  static final String amount = 'amount';
  static final String redeemRequestType = 'redeem_request_type';
  static final String account = 'account';

  ///verifyRequest
  static final String verifyRequest = baseUrl + 'User/verifyRequest';
  static final String idNumber = 'id_number';
  static final String name = 'name';
  static final String address = 'address';
  static final String photoIdImage = 'photo_id_image';
  static final String photoWithIdImage = 'photo_with_id_image';

  ///getProfile
  static final String getProfile = baseUrl + 'User/getProfile';

  ///getProfileCategoryList
  static final String getProfileCategoryList =
      baseUrl + 'User/getProfileCategoryList';

  ///updateProfile
  static final String updateProfile = baseUrl + 'User/updateProfile';
  static final String bio = 'bio';
  static final String fbUrl = 'fb_url';
  static final String instaUrl = 'insta_url';
  static final String youtubeUrl = 'youtube_url';
  static final String userProfile = 'user_profile';
  static final String profileCategory = 'profile_category';

  ///FollowUnFollowPost
  static final String followUnFollowPost = baseUrl + 'Post/FollowUnfollowPost';

  ///getFollowerList
  static final String getFollowerList = baseUrl + 'Post/getFollowerList';

  ///getFollowingList
  static final String getFollowingList = baseUrl + 'Post/getFollowingList';

  ///getSoundList
  static final String getSoundList = baseUrl + 'Post/getSoundList';

  ///getFavouriteSoundList
  static final String getFavouriteSoundList =
      baseUrl + 'Post/getFavouriteSoundList';

  ///getSearchSoundList
  static final String getSearchSoundList = baseUrl + 'Post/getSearchSoundList';

  ///addPost
  static final String addPost = baseUrl + 'Post/addPost';
  static final String postDescription = 'post_description';
  static final String postHashTag = 'post_hash_tag';
  static final String postVideo = 'post_video';
  static final String postImage = 'post_image';
  static final String isOrignalSound = 'is_orignal_sound';
  static final String postSound = 'post_sound';
  static final String soundTitle = 'sound_title';
  static final String duration = 'duration';
  static final String singer = 'singer';
  static final String soundImage = 'sound_image';

  ///Logout
  static final String logoutUser = baseUrl + 'User/Logout';

  ///DeleteAccount
  static final String deleteAccount = baseUrl + 'User/deleteMyAccount';

  ///DeletePost
  static final String deletePost = baseUrl + 'Post/deletePost';

  ///ReportPost
  static final String reportPostOrUser = baseUrl + 'Post/ReportPost';
  static final String reportType = 'report_type';
  static final String reason = 'reason';
  static final String description = 'description';
  static final String contactInfo = 'contact_info';

  ///BlockUser
  static final String blockUser = baseUrl + 'User/blockUser';

  ///getPostListById
  static final String getPostListById = baseUrl + 'Post/getPostListById';

  ///getCoinPlanList
  static final String getCoinPlanList = baseUrl + 'Wallet/getCoinPlanList';

  ///addCoin
  static final String addCoin = baseUrl + 'Wallet/addCoin';
  static final String rewardingActionId = 'rewarding_action_id';

  ///purchaseCoin
  static final String purchaseCoin = baseUrl + 'Wallet/purchaseCoin';

  ///IncreasePostViewCount
  static final String increasePostViewCount =
      baseUrl + 'Post/IncreasePostViewCount';

  static final String uniqueKey = 'unique-key';
  static final String authorization = 'Authorization';
  static final String favourite = 'favourite';
  static final int count = 10;

  static final String isLogin = 'is_login';

  static final String camera = '';

  static final String bubblyCamera = 'bubbly_camera';

  static final String isAccepted = 'is_accepted';

  static final String helpUrl = 'https://flutter.io';
  static final String privacyUrl = 'https://flutter.io';
  static final String termsOfUseUrl = 'https://flutter.io';
}
