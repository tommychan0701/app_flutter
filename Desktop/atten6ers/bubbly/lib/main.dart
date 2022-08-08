import 'dart:async';

import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const.dart';
import 'package:bubbly/utils/myloading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'api/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return ChangeNotifierProvider<MyLoading>(
      create: (context) => MyLoading(),
      child: MaterialApp(
        title: 'Shortzz',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          primaryColorDark: colorPrimaryDark,
          scaffoldBackgroundColor: colorPrimaryDark,
          // accentColor: colorTheme,
          colorScheme: ColorScheme(
            primary: colorPrimary,
            onBackground: colorPrimary,
            error: colorTheme,
            brightness: Brightness.light,
            surface: colorPrimary,
            secondary: colorTheme,
            onSurface: colorPrimary,
            onSecondary: colorPrimaryDark,
            onPrimary: colorPrimary,
            background: Colors.transparent,
            // inverseSurface: Colors.transparent,
            onError: Colors.red,
          ),

          toggleableActiveColor: colorIcon,
          fontFamily: fNSfUiRegular,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              color: Colors.white,
            ),
            button: TextStyle(color: Colors.white),
          ),
        ),
        home: MyBubblyApp(),
      ),
    );
  }
}

class MyBubblyApp extends StatefulWidget {
  @override
  _MyBubblyAppState createState() => _MyBubblyAppState();
}

class _MyBubblyAppState extends State<MyBubblyApp> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  SessionManager _sessionManager = SessionManager();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    saveTokenUpdate();
    getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: Stack(
        children: [
          Center(
            child: Image(
              width: 225,
              image: AssetImage(icLogoHorizontal),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                byFlutterMaster.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: colorTextLight,
                  fontFamily: fNSfUiLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveTokenUpdate() async {
    await _sessionManager.initPref();
    firebaseMessaging
        .getToken()
        .then((value) => _sessionManager.saveString(Const.deviceToken, value));
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      FlutterLocalNotificationsPlugin().initialize(initializationSettings);
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      AppleNotification apple = message.notification?.apple;

      if (notification != null && apple != null) {
        flutterLocalNotificationsPlugin.show(
            1,
            notification.title,
            notification.body,
            NotificationDetails(iOS: IOSNotificationDetails()));
      }

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            1,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                // other properties...
              ),
            ));
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void getUserData() async {
    await _sessionManager.initPref();
    if (_sessionManager.getUser() != null &&
        _sessionManager.getUser().data != null) {
      SessionManager.userId = _sessionManager.getUser().data.userId ??
          _sessionManager.getUser().data.userId;
      SessionManager.accessToken = _sessionManager.getUser().data.token ??
          _sessionManager.getUser().data.token;
    }
    Timer(
      Duration(seconds: 2),
      () {
        Provider.of<MyLoading>(context, listen: false)
            .setUser(_sessionManager.getUser());
        Provider.of<MyLoading>(context, listen: false).setSelectedItem(0);
        ApiService().getNotificationList("0", "100").then((value) {
          if (value != null && value.status == 401) {
            ApiService().logoutUser();
          }
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (Route<dynamic> route) => false);
      },
    );
  }
}
