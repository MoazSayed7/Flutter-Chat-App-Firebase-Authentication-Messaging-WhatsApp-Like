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
            text: 'By logging, you agree to our',
            style: TextStyles.font11MediumLightShadeOfGray400Weight,
          ),
          TextSpan(
            text: ' Terms & Conditions',
            style: TextStyles.font11Green500Weight,
          ),
          TextSpan(
            text: ' and',
            style: TextStyles.font11MediumLightShadeOfGray400Weight
                .copyWith(height: 4.h),
          ),
          TextSpan(
            text: ' PrivacyPolicy.',
            style: TextStyles.font11Green500Weight,
          ),
        ],
      ),
    );
  }
}
