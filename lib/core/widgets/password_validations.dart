import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../themes/colors.dart';
import '../../themes/styles.dart';

class PasswordValidations extends StatelessWidget {
  final bool hasMinLength;
  const PasswordValidations({super.key, required this.hasMinLength});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 2.5,
          backgroundColor: ColorsManager.gray,
        ),
        Gap(6.w),
        Text(
          context.tr('passwordValidation'),
          style: TextStyles.font14DarkBlue500Weight.copyWith(
            decoration: hasMinLength ? TextDecoration.lineThrough : null,
            decorationColor: ColorsManager.greenPrimary,
            decorationThickness: 2,
            color: hasMinLength
                ? ColorsManager.mediumLightShadeOfGray
                : ColorsManager.lightShadeOfGray,
          ),
        )
      ],
    );
  }
}
