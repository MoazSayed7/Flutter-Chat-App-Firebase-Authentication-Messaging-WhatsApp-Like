import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/extensions.dart';
import '../../themes/colors.dart';
import '../../themes/styles.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({super.key});

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
            onTap: () {
              context.setLocale(const Locale("ar"));
              context.pop();
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
            onTap: () {
              context.setLocale(const Locale("en"));
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
