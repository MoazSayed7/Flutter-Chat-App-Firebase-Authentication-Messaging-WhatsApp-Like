import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class TextStyles {
  static TextStyle font16Grey400Weight = TextStyle(
    fontWeight: FontWeight.w400,
    color: ColorsManager.gray400,
    fontSize: 16.sp,
  );

  static TextStyle font16White600Weight = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle font24White600Weight = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle font15Green500Weight = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.greenPrimary,
  );
  static TextStyle font18White500Weight = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle font14Grey400Weight = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: const Color.fromARGB(255, 163, 163, 163),
  );

  static TextStyle font14DarkBlue500Weight = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.darkBlue,
  );

  static TextStyle font15DarkBlue500Weight = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.darkBlue,
  );

  static TextStyle font11Green500Weight = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.greenPrimary,
  );

  static TextStyle font11MediumLightShadeOfGray400Weight = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.mediumLightShadeOfGray,
  );

  static TextStyle font13MediumLightShadeOfGray400Weight = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.mediumLightShadeOfGray,
  );
}
