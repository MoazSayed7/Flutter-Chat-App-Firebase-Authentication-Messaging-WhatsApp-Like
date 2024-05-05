import 'package:awesome_dialog/awesome_dialog.dart';
import 'database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helpers/extensions.dart';
import '../router/routes.dart';

class GoogleSignin {
  static final _auth = FirebaseAuth.instance;
  late final notificationSettings = FirebaseMessaging.instance;
  static Future<String> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken!;
  }

  static Future signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      if (authResult.additionalUserInfo!.isNewUser) {
        await _auth.currentUser!.delete();
        if (!context.mounted) return;
        context.pushNamedAndRemoveUntil(
          Routes.createPassword,
          predicate: (route) => false,
          arguments: [googleUser, credential],
        );
      } else {
        await DatabaseMethods.addUserDetails(
          {
            'name': _auth.currentUser!.displayName,
            'email': _auth.currentUser!.email,
            'profilePic': _auth.currentUser!.photoURL,
            'uid': _auth.currentUser!.uid,
            'mtoken': await getToken(),
            'isOnline': 'true',
          },
          SetOptions(merge: true),
        );

        if (!context.mounted) return;
        context.pushNamedAndRemoveUntil(
          Routes.homeScreen,
          predicate: (route) => false,
        );
      }
    } catch (e) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: context.tr('somethingWentWrong'),
        desc: e.toString(),
      ).show();
    }
  }
}
