import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatchat.dart';
import 'firebase_options.dart';
import 'router/app_routes.dart';
import 'router/routes.dart';
import 'services/database.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize App
  await initApp();

  // Initialize ScreenUtil
  await ScreenUtil.ensureScreenSize();

  // Run App
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      startLocale: const Locale('ar'),
      child: ChatChat(
        appRoute: AppRoute(),
      ),
    ),
  );
}

late String? initialRoute;

Future<void> initApp() async {
  // Compare Versions
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  DocumentSnapshot newestVersionDetails = await FirebaseFirestore.instance
      .collection('version')
      .doc('newest')
      .get();
  Version newestVersion = Version.parse(newestVersionDetails['version']);
  Version currentVersion = Version.parse(packageInfo.version);
  int compareResult = newestVersion.compareTo(currentVersion);

  // handle initial route
  FirebaseAuth.instance.authStateChanges().listen(
    (user) async {
      if (compareResult == 0) {
        if (user == null || !user.emailVerified) {
          initialRoute = Routes.loginScreen;
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          bool? localAuth = prefs.getBool('auth_screen_enabled') ?? false;
          if (localAuth == true) {
            initialRoute = Routes.authScreen;
          }
          if (localAuth == false) {
            initialRoute = Routes.homeScreen;
          }
        }
      } else {
        initialRoute = Routes.updateScreen;
      }
    },
  );

  //Request notification permission
  late final message = FirebaseMessaging.instance;
  await message.requestPermission();

  // listen for messages when the app is in the background or terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  message.onTokenRefresh.listen((fcmToken) async {
    await DatabaseMethods.updateUserDetails({'mtoken': fcmToken});
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
