import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../features/camera/camera.dart';
import '../features/chat/ui/chat_page.dart';
import '../features/create_password/ui/create_password.dart';
import '../features/forget/ui/forget_screen.dart';
import '../features/home/home_screen.dart';
import '../features/linkeddevices/ui/linked_devices_screen.dart';
import '../features/local_auth/auth.dart';
import '../features/login/ui/login_screen.dart';
import '../features/newbroadcast/ui/new_boardcast_screen.dart';
import '../features/newgroup/ui/new_group_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/signup/ui/sign_up_sceen.dart';
import '../features/starredMessages/starred_messages.dart';
import '../features/update/ui/update.dart';
import 'routes.dart';

class AppRoute {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.authScreen:
        return MaterialPageRoute(
          builder: (context) => const Auth(),
        );

      case Routes.updateScreen:
        return MaterialPageRoute(
          builder: (context) => const UpdateScreen(),
        );

      case Routes.chatScreen:
        final arguments = routeSettings.arguments;
        if (arguments is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => ChatScreen(
              receivedUserName: arguments['name'],
              receivedUserID: arguments['uid'],
              receivedMToken: arguments['mtoken'],
              receivedUserProfilePic: arguments['profilePic'],
            ),
          );
        }

      case Routes.forgetScreen:
        return MaterialPageRoute(
          builder: (context) => const ForgetScreen(),
        );

      case Routes.starredMessagesScreen:
        return MaterialPageRoute(
          builder: (context) => const StarredMessagesScreen(),
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );

      case Routes.createPassword:
        final arguments = routeSettings.arguments;
        if (arguments is List) {
          return MaterialPageRoute(
            builder: (_) => CreatePassword(
              googleUser: arguments[0],
              credential: arguments[1],
            ),
          );
        }

      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        );

      case Routes.newGroupScreen:
        return MaterialPageRoute(
          builder: (context) => const NewGroupScreen(),
        );

      case Routes.newBroadCastScreen:
        return MaterialPageRoute(
          builder: (context) => const NewBroadCastScreen(),
        );

      case Routes.takePictureScreen:
        final argument = routeSettings.arguments;
        return MaterialPageRoute(
          builder: (context) => TakePictureScreen(
            firstCamera: argument as CameraDescription,
          ),
        );

      case Routes.displayPictureScreen:
        final argument = routeSettings.arguments;
        return MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            image: argument as XFile,
          ),
        );

      case Routes.linkedDevicesScreen:
        return MaterialPageRoute(
          builder: (context) => const LinkedDevicesScreen(),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
    }
    return null;
  }
}
