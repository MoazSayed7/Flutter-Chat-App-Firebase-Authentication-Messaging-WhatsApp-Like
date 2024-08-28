import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restart_app/restart_app.dart';

import '../../helpers/extensions.dart';
import '../../themes/colors.dart';
import '../../themes/styles.dart';

class ModalFit extends StatefulWidget {
  const ModalFit({super.key});

  @override
  State<ModalFit> createState() => _ModalFitState();
}

class _ModalFitState extends State<ModalFit> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('عربي'),
            titleTextStyle: TextStyles.font16White600Weight,
            leading: const Icon(
              Icons.language_rounded,
              color: Colors.white,
            ),
            tileColor: ColorsManager.appBarBackgroundColor,
            onTap: () async {
              await AwesomeDialog(
                dismissOnBackKeyPress: true,
                dismissOnTouchOutside: true,
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.scale,
                title: 'اعادة التشغيل مطلوبة',
                desc:
                    'لتطبيق تغيير اللغة إلى العربية، يحتاج التطبيق إلى إعادة التشغيل. يرجى إعادة تشغيل التطبيق الآن.',
                btnCancelText: 'الغاء',
                btnCancelOnPress: () => context.pop(),
                btnOkText: 'إعادة التشغيل',
                btnOkOnPress: () async {
                  await context.setLocale(const Locale("ar"));
                  await Restart.restartApp();
                },
              ).show();
            },
          ),
          Container(
            color: ColorsManager.gray400,
            height: 0.5.h,
            width: double.infinity,
          ),
          ListTile(
            title: const Text('English'),
            titleTextStyle: TextStyles.font16White600Weight,
            tileColor: ColorsManager.appBarBackgroundColor,
            leading: const Icon(
              Icons.language_rounded,
              color: Colors.white,
            ),
            onTap: () async {
              await AwesomeDialog(
                dismissOnBackKeyPress: true,
                dismissOnTouchOutside: true,
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.scale,
                title: 'Restart Required',
                desc:
                    'To apply the language change to English, the app needs to restart. Please restart the app now.',
                btnCancelText: 'Cancel',
                btnCancelOnPress: () => context.pop(),
                btnOkText: 'Restart',
                btnOkOnPress: () async {
                  await context.setLocale(const Locale("en"));
                  Restart.restartApp();
                },
              ).show();
            },
          ),
        ],
      ),
    );
  }
}
