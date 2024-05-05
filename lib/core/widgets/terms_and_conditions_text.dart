import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../themes/styles.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: context.tr('terms1'),
            style: TextStyles.font11MediumLightShadeOfGray400Weight,
          ),
          TextSpan(
            text: ' ${context.tr('terms2')}',
            style: TextStyles.font11Green500Weight,
          ),
          TextSpan(
            text: ' ${context.tr('terms3')}',
            style: TextStyles.font11MediumLightShadeOfGray400Weight
                .copyWith(height: 4.h),
          ),
          TextSpan(
            text: ' ${context.tr('terms4')}',
            style: TextStyles.font11Green500Weight,
          ),
        ],
      ),
    );
  }
}
