import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/already_have_account_text.dart';
import '../../../core/widgets/login_and_signup_form.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../core/widgets/or_sign_in_with_text.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../services/google_sign_in.dart';
import '../../../themes/styles.dart';

class BuildSignupScreen extends StatelessWidget {
  const BuildSignupScreen({
    super.key,
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
                      context.tr('createAccount'),
                      style: TextStyles.font24White600Weight,
                    ),
                    Gap(8.h),
                    Text(
                      context.tr('createAccountDesc'),
                      style: TextStyles.font14Grey400Weight,
                    ),
                    Gap(8.h),
                    EmailAndPassword(
                      isSignUpPage: true,
                    ),
                    Gap(10.h),
                    const SigninWithGoogleText(),
                    Gap(5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            await GoogleSignin.signInWithGoogle(context);
                          },
                          borderRadius: BorderRadius.circular(15.r),
                          child: SvgPicture.asset(
                            'assets/svgs/google.svg',
                            width: 40.w,
                            height: 40.h,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensure minimum height
                children: [
                  const TermsAndConditionsText(),
                  Gap(15.h),
                  const AlreadyHaveAccountText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              ? const BuildSignupScreen()
              : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
