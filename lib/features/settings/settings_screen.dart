import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../themes/styles.dart';

const bool keyAuthScreenDefaultValue = false;

const String keyAuthScreenEnabled = "auth_screen_enabled";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAuthScreenEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Unlock App",
                      style: TextStyles.font24White600Weight.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                    Gap(
                      10.h,
                    ),
                    Text(
                      "When enabled, you'll need to use\nfingerprint or face ID to open Chat App.",
                      style: TextStyles.font14Grey400Weight,
                    ),
                  ],
                ),
                CupertinoSwitch(
                  value: _isAuthScreenEnabled,
                  onChanged: (value) {
                    setState(
                      () {
                        if (_supportState != _SupportState.supported) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            headerAnimationLoop: false,
                            animType: AnimType.topSlide,
                            showCloseIcon: true,
                            closeIcon: const Icon(Icons.close_rounded),
                            title: 'Warning',
                            desc:
                                'This device does not have a locked screen. Please enable a fingerprint, or face ID for added security.',
                          ).show();
                        } else {
                          _isAuthScreenEnabled = value;
                          _setAuthScreenPreference(value);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _SupportState _supportState = _SupportState.unknown;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(
            () => _supportState = isSupported
                ? _SupportState.supported
                : _SupportState.unsupported,
          ),
        );
    _loadAuthScreenPreference();
  }

  Future<void> _loadAuthScreenPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isAuthScreenEnabled =
        prefs.getBool(keyAuthScreenEnabled) ?? keyAuthScreenDefaultValue;
    setState(() {});
  }

  Future<void> _setAuthScreenPreference(bool value) async {
    if (_supportState != _SupportState.supported) {
      return;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyAuthScreenEnabled, value);
    }
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
