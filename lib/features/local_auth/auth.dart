import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

import '../../helpers/extensions.dart';
import '../../router/routes.dart';
import '../../themes/styles.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  static late bool _canCheckBiometrics;

  String _text1 = '';
  String _text2 =
      'If the fingerprint sensor isn\'t working, disable it in\nyour device\'s settings.';
  final LocalAuthentication auth = LocalAuthentication();
  Timer? _timer;
  int _start = 31;
  var logger = Logger();
  Color fingColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: const Color(0xff111B21),
          child: ListView(
            padding: const EdgeInsets.only(top: 60),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    color: Colors.teal,
                    size: 50,
                  ),
                  Gap(15.h),
                  Text(
                    'Chat App Locked',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                    ),
                  ),
                  Gap(150.h),
                  Icon(
                    Icons.fingerprint_rounded,
                    color: fingColor,
                    size: 50,
                  ),
                  Gap(15.h),
                  Text(
                    _start != 0 || _start < 31 ? _text1 : '',
                    style:
                        TextStyles.font16Grey400Weight.copyWith(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Gap(10.h),
                  Text(
                    _start != 0 || _start < 31 ? _text2 : '',
                    style: TextStyles.font16Grey400Weight
                        .copyWith(fontSize: 14, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
     
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 2), () async {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometrics();
    });
  }

  restart() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _authenticate();
          });
        } else {
          _start--;
          _text1 = ' Too many attempts. Try again after $_start seconds.';
          setState(() {});
        }
      },
    );
    _start = 31;
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        closeIcon: const Icon(Icons.close_rounded),
        title: e.code,
        desc: e.message,
        onDismissCallback: (type) {
          logger.e('Dialog Dismiss from callback $type');
        },
      ).show();
      if (e.code == 'PermanentlyLockedOut') {
        context.pop();
        _text2 = '';
        _text1 = 'Too many attempts. Fingerprint sensor disabled.';
        setState(() {});
        return _authenticatePin();
      }
      fingColor = Colors.red;
      restart();
      return;
    }

    if (authenticated) {
      if (!mounted) return;

      context.pushReplacementNamed(Routes.homeScreen);
    } else {
      _authenticate();
    }
  }

  Future<void> _authenticatePin() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        closeIcon: const Icon(Icons.close_rounded),
        title: e.code,
        desc: e.message,
        onDismissCallback: (type) {
          logger.e('Dialog Dismiss from callback $type');
        },
      ).show();
      return;
    }

    if (authenticated) {
      if (!mounted) return;

      context.pushReplacementNamed(Routes.homeScreen);
    } else {
      _authenticatePin();
    }
  }

  Future<void> _checkBiometrics() async {
    try {
      _canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      _canCheckBiometrics = false;
      logger.e(e);
    } finally {
      setState(() {});
      if (_canCheckBiometrics) {
        _authenticate();
      } else {
        _authenticatePin();
      }
    }
  }
}
