// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/widgets/login_and_signup_form.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../themes/styles.dart';

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
      body: SafeArea(
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
                        'Create Password',
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
      ),
    );
  }
}
