import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/profileCategory/profile_category.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/view/dialog/loader_dialog.dart';
import 'package:bubbly/view/profile/dialog_profile_category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String profileImage = '';
  String fullName = '';
  String userName = '';
  String userEmail = '';
  String bio = '';
  String fbUrl = '';
  String instaUrl = '';
  String youtubeUrl = '';

  String profileCategory = '';
  String profileCategoryName = '';

  @override
  void initState() {
    User user = Provider.of<MyLoading>(context, listen: false).getUser;
    fullName = user.data.fullName != null ? user.data.fullName : '';
    userName = user.data.userName != null ? user.data.userName : '';
    bio = user.data.bio != null ? user.data.bio : '';
    fbUrl = user.data.fbUrl != null ? user.data.fbUrl : '';
    instaUrl = user.data.instaUrl != null ? user.data.instaUrl : '';
    youtubeUrl = user.data.youtubeUrl != null ? user.data.youtubeUrl : '';
    profileCategoryName = user.data.profileCategoryName != null
        ? user.data.profileCategoryName
        : '';
    userEmail = user.data.userEmail != null ? user.data.userEmail : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 55,
              child: Stack(
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: fNSfUiMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.3,
              color: colorTextLight,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ClipOval(
                      child: profileImage == null || profileImage.isEmpty
                          ? Container(
                              height: 100,
                              width: 100,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    icUserPlaceHolder,
                                    height: 100,
                                    fit: BoxFit.fill,
                                    width: 100,
                                    color: colorPrimary,
                                  ),
                                  Image(
                                    image: NetworkImage(
                                      Const.itemBaseUrl +
                                          (Provider.of<MyLoading>(context,
                                                              listen: false)
                                                          .getUser
                                                          .data
                                                          .userProfile !=
                                                      null &&
                                                  Provider.of<MyLoading>(
                                                          context,
                                                          listen: false)
                                                      .getUser
                                                      .data
                                                      .userProfile
                                                      .isNotEmpty
                                              ? Provider.of<MyLoading>(context,
                                                      listen: false)
                                                  .getUser
                                                  .data
                                                  .userProfile
                                              : ''),
                                    ),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container();
                                    },
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            )
                          : Image(
                              image: FileImage(
                                File(profileImage),
                              ),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 35,
                      width: 135,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(colorPrimary)),
                        onPressed: () {
                          ImagePicker()
                              .pickImage(
                                  source: ImageSource.gallery, imageQuality: 50)
                              .then((value) {
                            profileImage = value.path;
                            print(profileImage);
                            setState(() {});
                          });
                        },
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: colorIcon,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Profile Category',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: colorPrimary,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                profileCategoryName,
                                style: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                            ),
                            InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return DialogProfileCategory(
                                      (data) {
                                        ProfileCategoryData p = data;
                                        profileCategory =
                                            p.profileCategoryId.toString();
                                        profileCategoryName =
                                            p.profileCategoryName;
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: colorIcon,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: colorPrimary,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorPrimary,
                      ),
                      child: TextField(
                        controller: TextEditingController(text: fullName),
                        onChanged: (value) => fullName = value,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Full Name',
                          hintStyle: TextStyle(
                            color: colorTextLight,
                          ),
                        ),
                        style: TextStyle(
                          color: colorTextLight,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorPrimary,
                      ),
                      child: TextField(
                        controller: TextEditingController(text: userName),
                        onChanged: (value) => userName = value,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: colorTextLight,
                          ),
                        ),
                        style: TextStyle(
                          color: colorTextLight,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      height: 115,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorPrimary,
                      ),
                      child: TextField(
                        controller: TextEditingController(text: bio),
                        onChanged: (value) {
                          bio = value;
                          print(bio);
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Present yourself',
                          hintStyle: TextStyle(
                            color: colorTextLight,
                          ),
                        ),
                        style: TextStyle(
                          color: colorTextLight,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Social',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorPrimary,
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              color: colorIcon,
                              height: 22,
                              width: 22,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Image(
                                  image: AssetImage(icFaceBook),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: fbUrl),
                              onChanged: (value) => fbUrl = value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'facebook',
                                hintStyle: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                              style: TextStyle(
                                color: colorTextLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorPrimary,
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              color: colorIcon,
                              height: 22,
                              width: 22,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Image(
                                  image: AssetImage(icInstagram),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: instaUrl),
                              onChanged: (value) => instaUrl = value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'instagram',
                                hintStyle: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                              style: TextStyle(
                                color: colorTextLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: colorPrimary,
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              color: colorIcon,
                              height: 22,
                              width: 22,
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Image(
                                  image: AssetImage(icYouTube),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              controller:
                                  TextEditingController(text: youtubeUrl),
                              onChanged: (value) => youtubeUrl = value,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'youtube',
                                hintStyle: TextStyle(
                                  color: colorTextLight,
                                ),
                              ),
                              style: TextStyle(
                                color: colorTextLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => LoaderDialog(),
                        );
                        ApiService()
                            .updateProfile(
                                fullName,
                                userName,
                                userEmail,
                                bio,
                                fbUrl,
                                instaUrl,
                                youtubeUrl,
                                profileCategory,
                                profileImage.isNotEmpty
                                    ? File(profileImage)
                                    : null)
                            .then(
                          (value) {
                            if (value != null && value.status == 200) {
                              Provider.of<MyLoading>(context, listen: false)
                                  .setUser(value);

                              Navigator.pop(context);
                              Navigator.pop(context);
                              showToast('Update profile successfully..!');
                            }
                          },
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 165,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          gradient: LinearGradient(
                            colors: [
                              colorTheme,
                              colorPink,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: fNSfUiSemiBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
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
}
