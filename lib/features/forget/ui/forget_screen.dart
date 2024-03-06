import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/already_have_account_text.dart';
import '../../../core/widgets/terms_and_conditions_text.dart';
import '../../../themes/styles.dart';
import 'widgets/password_reset.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

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
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reset',
                              style: TextStyles.font24White600Weight,
                            ),
                            Gap(10.h),
                            Text(
                              "Enter email to reset password",
                              style: TextStyles.font14Grey400Weight,
                            ),
                          ],
                        ),
                      ),
                      Gap(20.h),
                      const PasswordReset(),
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
                    Gap(24.h),
                    const AlreadyHaveAccountText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
