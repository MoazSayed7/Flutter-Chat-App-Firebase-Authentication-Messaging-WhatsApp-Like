// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/widgets/login_and_signup_form.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../themes/styles.dart';

class BuildCreatePasswordScreen extends StatelessWidget {
  final GoogleSignInAccount googleUser;

  final OAuthCredential credential;
  const BuildCreatePasswordScreen({
    super.key,
    required this.googleUser,
    required this.credential,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.h, top: 5.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('createPassword'),
                      style: TextStyles.font24White600Weight,
                    ),
                    Gap(10.h),
                    EmailAndPassword(
                      isPasswordPage: true,
                      googleUser: googleUser,
                      credential: credential,
                    ),
                  ],
                ),
              ),
            ),
            const TermsAndConditionsText(),
          ],
        ),
      ),
    );
  }
}

class CreatePassword extends StatelessWidget {
  late GoogleSignInAccount googleUser;
  late OAuthCredential credential;
  CreatePassword({
    super.key,
    required this.googleUser,
    required this.credential,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? BuildCreatePasswordScreen(
                  googleUser: googleUser, credential: credential)
              : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
