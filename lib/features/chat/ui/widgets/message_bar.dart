import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../themes/colors.dart';
import '../../../../themes/styles.dart';

class CustomMessageBar extends StatelessWidget {
  final Function(String) onSend;
  final VoidCallback onShowOptions;
  const CustomMessageBar(
      {super.key, required this.onSend, required this.onShowOptions});

  @override
  Widget build(BuildContext context) {
    return MessageBar(
      messageBarHitText: context.tr('message'),
      messageBarHintStyle: TextStyles.font14Grey400Weight,
      messageBarTextStyle: TextStyles.font18White500Weight.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      messageBarColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 7.h,
      ),
      paddingTextAndSendButton: context.locale.toString() == 'en'
          ? EdgeInsets.only(left: 4.w)
          : EdgeInsets.only(right: 4.w),
      onSend: (message) async {
        await onSend(message);
      },
      sendButtonColor: ColorsManager.greenPrimary,
      actions: [
        Padding(
          padding: context.locale.toString() == 'ar'
              ? EdgeInsets.only(left: 4.w)
              : EdgeInsets.only(right: 4.w),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xff00a884),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 28,
              ),
              onPressed: onShowOptions,
            ),
          ),
        )
      ],
    );
  }
}
