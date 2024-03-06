import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/already_have_account_text.dart';
import '../../../core/widgets/login_and_signup_form.dart';
import '../../../core/widgets/or_sign_in_with_text.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../services/google_sign_in.dart';
import '../../../themes/styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.h, top: 5.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyles.font24White600Weight,
                ),
                Gap(8.h),
                Text(
                  'Sign up now and start exploring all that our\napp has to offer. We\'re excited to welcome\nyou to our community!',
                  style: TextStyles.font14Grey400Weight,
                ),
                Gap(8.h),
                Column(
                  children: [
                    EmailAndPassword(
                      isSignUpPage: true,
                    ),
                    Gap(10.h),
                    const SigninWithGoogleText(),
                    Gap(5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            EvaIcons.google,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await GoogleSignin.signInWithGoogle(context);
                          },
                        ),
                      ],
                    ),
                    const TermsAndConditionsText(),
                    Gap(15.h),
                    const AlreadyHaveAccountText(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
