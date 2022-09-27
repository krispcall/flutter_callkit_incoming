import "package:flutter/material.dart";
import "package:flutter_screenutil/src/size_extension.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";
import "package:shimmer/shimmer.dart";

class MacrosTileShimmer extends StatelessWidget {
  const MacrosTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: CustomColors.bottomAppBarColor!,
      period: const Duration(milliseconds: 1000),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
            Dimens.space0.w, Dimens.space16.h),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h,
                  Dimens.space12.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              width: Utils.getScreenWidth(context).w * 0.5,
              height: Dimens.space14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space14.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space12.h,
                  Dimens.space12.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: Dimens.space12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space10.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space4.h,
                  Dimens.space12.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: Dimens.space12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space10.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space4.h,
                  Dimens.space12.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              width: Utils.getScreenWidth(context).w * 0.4,
              height: Dimens.space12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space10.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
