import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";

class FeedbackDialog extends StatelessWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width.w * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        padding: EdgeInsets.fromLTRB(Dimens.space32.w, Dimens.space26.h,
            Dimens.space32.w, Dimens.space26.h),
        child: Text(
          Config.checkOverFlow
              ? Const.OVERFLOW
              : Utils.getString("thankForFeedback"),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: CustomColors.textSecondaryColor,
                fontFamily: Config.manropeRegular,
                fontSize: Dimens.space18.sp,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
        ),
      ),
    );
  }
}
