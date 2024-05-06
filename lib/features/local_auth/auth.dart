import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/extensions.dart';
import '../../router/routes.dart';
import '../../themes/styles.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  late List<BiometricType> availableBiometric;
  String _text1 = '';

  final LocalAuthentication auth = LocalAuthentication();
  Timer? _timer;
  int _start = 31;
  Color fingColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff111B21),
        child: ListView(
          padding: const EdgeInsets.only(top: 60),
          physics: const BouncingScrollPhysics(),
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
                  context.tr('appLocked'),
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
                  style: TextStyles.font16Grey400Weight.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Gap(10.h),
                Text(
                  _start != 0 || _start < 31
                      ? context.tr('disableFingerprint')
                      : '',
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await auth.getAvailableBiometrics().then((value) async {
        availableBiometric = value;
        if (value.isEmpty) {
          if (!mounted) return;
          context.pushReplacementNamed(Routes.homeScreen);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_screen_enabled');
        } else {
          _authenticate();
        }
      });
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
          _text1 =
              ' ${context.tr('tooManyAttempts', args: [_start.toString()])}';
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
        localizedReason: context.tr('enterFingerprint'),
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } finally {
      setState(() {
        fingColor = Colors.red;
        authenticated
            ? context.pushReplacementNamed(Routes.homeScreen)
            : restart();
      });
    }
  }
}
