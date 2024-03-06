import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/login_and_signup_form.dart';
import '../../../core/widgets/no_internet.dart';
import '../../../core/widgets/or_sign_in_with_text.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../services/google_sign_in.dart';
import '../../../themes/colors.dart';
import '../../../themes/styles.dart';
import 'widgets/do_not_have_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          return connected ? _loginPage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: ColorsManager.greenPrimary,
          ),
        ),
      ),
    );
  }

  SafeArea _loginPage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.h, top: 5.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: TextStyles.font24White600Weight,
                          ),
                          Gap(10.h),
                          Text(
                            "Login To Continue Using The App",
                            style: TextStyles.font14Grey400Weight,
                          ),
                        ],
                      ),
                    ),
                    Gap(10.h),
                    EmailAndPassword(),
                    Gap(10.h),
                    const SigninWithGoogleText(),
                    Gap(5.h),
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
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensure minimum height
                children: [
                  const TermsAndConditionsText(),
                  Gap(15.h),
                  const DoNotHaveAccountText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
