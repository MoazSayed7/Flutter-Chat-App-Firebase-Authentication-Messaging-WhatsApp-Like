import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../helpers/app_regex.dart';
import '../../../themes/styles.dart';
import '../../helpers/extensions.dart';
import '../../router/routes.dart';
import 'app_button.dart';
import 'app_text_form_field.dart';
import 'password_validations.dart';

// ignore: must_be_immutable
class EmailAndPassword extends StatefulWidget {
  final bool? isSignUpPage;
  final bool? isPasswordPage;
  late GoogleSignInAccount? googleUser;
  late OAuthCredential? credential;
  EmailAndPassword({
    super.key,
    this.isSignUpPage,
    this.isPasswordPage,
    this.googleUser,
    this.credential,
  });

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

  late final _auth = FirebaseAuth.instance;
  late final _fireStore = FirebaseFirestore.instance;

  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController passwordConfirmationController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          if (widget.isSignUpPage == true) nameField(),
          if (widget.isPasswordPage == null) emailField(),
          passwordField(),
          Gap(18.h),
          if (widget.isSignUpPage == true || widget.isPasswordPage == true)
            passwordConfirmationField(),
          if (widget.isSignUpPage == null && widget.isPasswordPage == null)
            forgetPasswordTextButton(context),
          Gap(10.h),
          PasswordValidations(
            hasLowerCase: hasLowercase,
            hasUpperCase: hasUppercase,
            hasSpecialCharacters: hasSpecialCharacters,
            hasNumber: hasNumber,
            hasMinLength: hasMinLength,
          ),
          Gap(20.h),
          loginOrSignUpOrPasswordButton(context),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();

    passwordConfirmationController.dispose();

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Column emailField() {
    return Column(
      children: [
        AppTextFormField(
          hint: 'Email',
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                !AppRegex.isEmailValid(value)) {
              return 'Please enter a valid email';
            }
          },
          controller: emailController,
        ),
        Gap(18.h),
      ],
    );
  }

  Widget forgetPasswordTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pushNamed(Routes.forgetScreen);
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'forget password?',
          style: TextStyles.font15Green500Weight,
        ),
      ),
    );
  }

  getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }

  @override
  void initState() {
    super.initState();
    setupPasswordControllerListener();
  }

  AppButton loginButton(BuildContext context) {
    return AppButton(
      buttonText: 'Login',
      textStyle: TextStyles.font15DarkBlue500Weight,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            final c = await _auth.signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            if (c.user!.emailVerified) {
              await _fireStore
                  .collection('users')
                  .doc(_auth.currentUser!.uid)
                  .set(
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
            } else {
              await _auth.signOut();
              if (!context.mounted) return;

              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                title: 'Email Not Verified',
                desc: 'Please check your email and verify your email.',
              ).show();
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'FireBase Error',
                desc: 'No user found for that email.',
              ).show();
            } else if (e.code == 'wrong-password') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc: 'Wrong password provided for that user.',
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

  loginOrSignUpOrPasswordButton(BuildContext context) {
    if (widget.isSignUpPage == true) {
      return signUpButton(context);
    }
    if (widget.isSignUpPage == null && widget.isPasswordPage == null) {
      return loginButton(context);
    }
    if (widget.isPasswordPage!) {
      return passwordButton(context);
    }
  }

  Column nameField() {
    return Column(
      children: [
        AppTextFormField(
          hint: 'Name',
          validator: (value) {
            if (value == null || value.isEmpty || value.startsWith(' ')) {
              return 'Please enter a valid name';
            }
          },
          controller: nameController,
        ),
        Gap(18.h),
      ],
    );
  }

  AppButton passwordButton(BuildContext context) {
    return AppButton(
      buttonText: 'Create Password',
      textStyle: TextStyles.font15DarkBlue500Weight,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            await _auth.createUserWithEmailAndPassword(
              email: widget.googleUser!.email,
              password: passwordController.text,
            );

            await _auth.currentUser!.linkWithCredential(widget.credential!);
            await _auth.currentUser!
                .updateDisplayName(widget.googleUser!.displayName);
            await _auth.currentUser!
                .updatePhotoURL(widget.googleUser!.photoUrl);
            await _fireStore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .set(
              {
                'name': widget.googleUser!.displayName,
                'profilePic': widget.googleUser!.photoUrl,
                'email': widget.googleUser!.email,
                'uid': _auth.currentUser!.uid,
                'mtoken': await getToken(),
                'isOnline': 'true',
              },
            );
            if (!context.mounted) return;
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Sign up Success',
              desc: 'You have successfully signed up.',
            ).show();

            if (!context.mounted) return;

            context.pushNamedAndRemoveUntil(
              Routes.homeScreen,
              predicate: (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc:
                    'This account already exists for that email go and login.',
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
          } catch (e) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error',
              desc: e.toString(),
            ).show();
          }
        }
      },
    );
  }

  Widget passwordConfirmationField() {
    return AppTextFormField(
      controller: passwordConfirmationController,
      hint: 'Password Confirmation',
      isObscureText: isObscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            isObscureText = !isObscureText;
          });
        },
        child: Icon(
          isObscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.white,
        ),
      ),
      validator: (value) {
        if (value != passwordController.text) {
          return 'Enter a matched passwords';
        }
        if (value == null ||
            value.isEmpty ||
            !AppRegex.isPasswordValid(value)) {
          return 'Please enter a valid password';
        }
      },
    );
  }

  AppTextFormField passwordField() {
    return AppTextFormField(
      controller: passwordController,
      hint: 'Password',
      isObscureText: isObscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            isObscureText = !isObscureText;
          });
        },
        child: Icon(
          isObscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.white,
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !AppRegex.isPasswordValid(value)) {
          return 'Please enter a valid password';
        }
      },
    );
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  AppButton signUpButton(BuildContext context) {
    return AppButton(
      buttonText: "Create Account",
      textStyle: TextStyles.font15DarkBlue500Weight,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          try {
            await _auth.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            await _auth.currentUser!.updateDisplayName(nameController.text);
            await _auth.currentUser!.sendEmailVerification();
            await _fireStore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .set(
              {
                'name': nameController.text,
                'email': emailController.text,
                'profilePic': '',
                'uid': _auth.currentUser!.uid,
                'mtoken': await getToken(),
                'isOnline': 'false',
              },
            );
            await _auth.signOut();
            if (!context.mounted) return;
            await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Sign up Success',
              desc: 'Don\'t forget to verify your email check inbox.',
            ).show();

            if (!context.mounted) return;

            context.pushNamedAndRemoveUntil(
              Routes.loginScreen,
              predicate: (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                title: 'Error',
                desc:
                    'This account already exists for that email go and login.',
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
          } catch (e) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error',
              desc: e.toString(),
            ).show();
          }
        }
      },
    );
  }
}
