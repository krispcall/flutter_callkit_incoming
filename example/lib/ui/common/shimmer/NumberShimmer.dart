import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";
import "package:shimmer/shimmer.dart";

class NumberShimmer extends StatelessWidget {
  const NumberShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: CustomColors.bottomAppBarColor!,
      period: const Duration(milliseconds: 1000),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space16.h,
            Dimens.space20.w, Dimens.space16.h),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              width: Dimens.space40.w,
              height: Dimens.space40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space300.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space5.h),
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
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space5.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.centerLeft,
                  width: Utils.getScreenWidth(context).w * 0.3,
                  height: Dimens.space14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.space14.r),
                    color: CustomColors.bottomAppBarColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
