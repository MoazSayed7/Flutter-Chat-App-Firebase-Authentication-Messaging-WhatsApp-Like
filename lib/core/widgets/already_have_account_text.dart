import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../helpers/extensions.dart';
import '../../router/routes.dart';
import '../../themes/styles.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamedAndRemoveUntil(
          Routes.loginScreen,
          predicate: (route) => false,
        );
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: context.tr('alreadyHaveAccount'),
              style: TextStyles.font11MediumLightShadeOfGray400Weight,
            ),
            TextSpan(
              text: context.tr('login'),
              style: TextStyles.font11Green500Weight,
            ),
          ],
        ),
      ),
    );
  }
}
