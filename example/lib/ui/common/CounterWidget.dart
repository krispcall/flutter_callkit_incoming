import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:percent_indicator/circular_percent_indicator.dart";

/*
 * *
 *  * Created by Kedar on 9/9/21 12:44 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 9/9/21 12:44 PM
 *  
 */

class CounterWidget extends StatelessWidget {
  final int characterCount;

  const CounterWidget({Key? key, this.characterCount = 161}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characterCount == 0) {
      return Container();
    } else {
      if (characterCount < 160) {
        return Container(
          width: Dimens.space36.w,
          height: Dimens.space24.w,
          alignment: Alignment.center,
          margin:
              EdgeInsets.only(bottom: Dimens.space0.h, right: Dimens.space5.w),
          child: CircularPercentIndicator(
            radius: Dimens.space20.r,
            lineWidth: 2.0,
            percent: _calculatePercentage(characterCount),
            center: const Text(Config.checkOverFlow ? Const.OVERFLOW : ""),
            progressColor: CustomColors.mainColor,
          ),
        );
      } else {
        return Container(
          width: Dimens.space24.w,
          height: Dimens.space24.w,
          alignment: Alignment.center,
          margin:
              EdgeInsets.only(bottom: Dimens.space0.h, right: Dimens.space5.w),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : "-${_calclateNegativeTextCounter(characterCount)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CustomColors.callDeclineColor,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space12.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
            ),
          ),
        );
      }
    }
  }

  int _calclateNegativeTextCounter(int characterCount) {
    if (characterCount < (1600 - 160)) {
      return characterCount - 160;
    } else {
      return 1600 - 160;
    }
  }

  double _calculatePercentage(int characterCount) {
    return (characterCount / 160).toDouble();
  }
}
