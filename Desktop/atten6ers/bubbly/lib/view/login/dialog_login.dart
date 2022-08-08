import 'dart:collection';
import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class DialogLogin extends StatelessWidget {
  final SessionManager sessionManager = SessionManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    int _type = 0;
    initData();
    return Container(
      height: MediaQuery.of(context).size.height * 0.964,
      decoration: BoxDecoration(
        color: colorPrimaryDark,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image(
                  image: AssetImage(icLogo),
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sign Up for Shortzz',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: fNSfUiSemiBold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Create a profile, follow other creators\nbuild your fan following by creating\nyour own videos and earn reward !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorTextLight,
                    fontFamily: fNSfUiLight,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      signInWithApple(scopes: [Scope.email, Scope.fullName])
                          .then((value) {
                        callApiForLogin(value, _type, context);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: colorPink,
                            blurRadius: 10,
                            offset: Offset(1, 1),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      height: 45,
                      width: 200,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Image(
                            image: AssetImage(icApple),
                            height: 23,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'With Apple',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: fNSfUiSemiBold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () {
                    signInWithFacebook().then((value) {
                      _type = 1;
                      callApiForLogin(value.user, _type, context);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: colorPink,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    height: 45,
                    width: 200,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Image(
                          image: AssetImage(icFb),
                          height: 22,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'With Facebook',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: fNSfUiSemiBold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  onTap: () {
                    signInWithGoogle().then((value) {
                      _type = 3;
                      callApiForLogin(value, _type, context);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: colorPink,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    height: 45,
                    width: 200,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Image(
                          image: AssetImage(icGoogle),
                          height: 22,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'With Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: fNSfUiSemiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                ),
                Text(
                  'By continuing, you agree to  Bubbly\'s terms of use\nand confirm that you have read our privacy policy.',
                  style: TextStyle(
                    color: colorTextLight,
                    fontSize: 12,
                    fontFamily: fNSfUiLight,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Text('Term of use'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(2),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      child: Text('Privacy Policy'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(3),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
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
                  color: colorTextLight,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    return user;
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final userCredential = await _auth.signInWithCredential(credential);
        final firebaseUser = userCredential.user;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  void callApiForLogin(User value, int type, BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (context) => LoaderDialog(),
    // );
    HashMap<String, String> params = new HashMap();
    params[Const.deviceToken] = sessionManager.getString(Const.deviceToken);
    params[Const.userEmail] = value.email ??
        value.displayName.split('@')[value.displayName.split('@').length - 1] +
            '@fb.com';
    params[Const.fullName] = value.displayName;
    params[Const.loginType] =
        type == 0 ? 'apple' : (type == 1 ? 'facebook' : 'google');
    params[Const.userName] =
        value.email != null ? value.email.split('@')[0] : value.uid;
    params[Const.identity] = value.email ?? value.uid;
    params[Const.platform] = Platform.isAndroid ? "1" : "2";
    print(params);
    ApiService().registerUser(params).then((value) {
      Provider.of<MyLoading>(context, listen: false).setSelectedItem(0);
      Provider.of<MyLoading>(context, listen: false).setUser(value);
      // Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void initData() async {
    await sessionManager.initPref();
  }
}
