import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";

class CustomTagTabWidget extends StatelessWidget {
  const CustomTagTabWidget({
    Key? key,
    required this.title,
    required this.selected,
    this.offstage = true,
  }) : super(key: key);
  final String title;
  final bool offstage;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Text(
          Config.checkOverFlow ? Const.OVERFLOW : title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: Dimens.space14.sp,
                fontWeight: FontWeight.normal,
                color: selected
                    ? CustomColors.mainColor
                    : CustomColors.textTertiaryColor,
                fontFamily: Config.manropeSemiBold,
                fontStyle: FontStyle.normal,
              ),
        ),
      ),
    );
  }
}
