import 'package:flutter/material.dart';

import '../../../../helpers/extensions.dart';
import '../../../../router/routes.dart';
import '../../../../themes/styles.dart';

class DoNotHaveAccountText extends StatelessWidget {
  const DoNotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.signupScreen);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account yet?',
              style: TextStyles.font11MediumLightShadeOfGray400Weight,
            ),
            TextSpan(
              text: ' Sign Up',
              style: TextStyles.font11Green500Weight,
            ),
          ],
        ),
      ),
    );
  }
}
