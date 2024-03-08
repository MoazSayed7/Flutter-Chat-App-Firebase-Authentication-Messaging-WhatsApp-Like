import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../helpers/app_regex.dart';
import '../../../../../themes/styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          emailField(),
          Gap(30.h),
          resetButton(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  AppTextFormField emailField() {
    return AppTextFormField(
      hint: 'Email',
      validator: (value) {
        if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
          return 'Please enter a valid email';
        }
      },
      controller: emailController,
    );
  }

  AppTextButton resetButton(BuildContext context) {
    return AppTextButton(
      buttonText: 'Reset',
      textStyle: TextStyles.font15DarkBlue500Weight,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailController.text);
            if (!context.mounted) return;

            AwesomeDialog(
              context: context,
              dialogType: DialogType.info,
              animType: AnimType.rightSlide,
              title: 'Reset Password',
              desc:
                  'Link to Reset password send to your email, please check inbox messages.',
            ).show();
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc: 'Email not found',
              ).show();
            } else {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc: e.message,
              ).show();
            }
          }
        }
      },
    );
  }
}
