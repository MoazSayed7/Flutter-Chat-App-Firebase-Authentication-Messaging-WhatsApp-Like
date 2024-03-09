import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'router/app_routes.dart';
import 'router/routes.dart';
import 'themes/colors.dart';

Future<void> main() async {
  final logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen(
    (user) async {
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
    },
  );

  //Request notification permission
  late final message = FirebaseMessaging.instance;
  await message.requestPermission();

  // listen for messages when the app is in the background or terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await ScreenUtil.ensureScreenSize();
  message.onTokenRefresh.listen(
    (fcmToken) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'mtoken': fcmToken});
    },
  ).onError(
    (err) {
      logger.e(err);
    },
  );
  runApp(MyApp(appRoute: AppRoute()));
}

late String? initialRoute;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class MyApp extends StatefulWidget {
  final AppRoute appRoute;
  const MyApp({
    super.key,
    required this.appRoute,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          useMaterial3: true,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: ColorsManager.greenPrimary,
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: ColorsManager.greenPrimary,
          ),
          scaffoldBackgroundColor: ColorsManager.backgroundDefaultColor,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.white,
            backgroundColor: ColorsManager.appBarBackgroundColor,
          ),
        ),
        onGenerateRoute: widget.appRoute.onGenerateRoute,
        initialRoute: initialRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
