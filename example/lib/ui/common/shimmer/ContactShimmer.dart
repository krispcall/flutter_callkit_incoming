import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";
import "package:shimmer/shimmer.dart";

class ContactShimmer extends StatelessWidget {
  const ContactShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: CustomColors.bottomAppBarColor!,
      period: const Duration(milliseconds: 1000),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space7.h,
                  Dimens.space0.w, Dimens.space7.h),
              alignment: Alignment.center,
              width: Dimens.space36.w,
              height: Dimens.space36.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space14.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                  Dimens.space10.w, Dimens.space0.h),
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
          ],
        ),
      ),
    );
  }
}

class ContactDetailHeaderShimmer extends StatelessWidget {
  const ContactDetailHeaderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: CustomColors.bottomAppBarColor!,
      period: const Duration(milliseconds: 1000),
      child: Container(
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space28.h,
            Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                  Dimens.space16.w, Dimens.space0.h),
              width: Dimens.space54.w,
              height: Dimens.space54.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space14.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space5.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  width: Utils.getScreenWidth(context) * 0.5,
                  height: Dimens.space14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.space14.r),
                    color: CustomColors.bottomAppBarColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space5.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  width: Utils.getScreenWidth(context) * 0.3,
                  height: Dimens.space14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.space14.r),
                    color: CustomColors.bottomAppBarColor,
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class ButtonShimmer extends StatelessWidget {
  const ButtonShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: CustomColors.bottomAppBarColor!,
      period: const Duration(milliseconds: 1000),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(Dimens.space22.w, Dimens.space6.h,
                  Dimens.space10.w, Dimens.space10.h),
              child: Container(
                alignment: Alignment.center,
                width: Dimens.space36.w,
                height: Dimens.space36.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.space14.r),
                  color: CustomColors.bottomAppBarColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              width: Utils.getScreenWidth(context) * 0.2,
              height: Dimens.space14.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.space14.r),
                color: CustomColors.bottomAppBarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactBarShimmer extends StatelessWidget {
  const ContactBarShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: CustomColors.bottomAppBarColor!,
      period: const Duration(milliseconds: 1000),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimens.space0, Dimens.space10.h, Dimens.space0, Dimens.space4.h),
        child: Container(
          width: Utils.getScreenWidth(context),
          height: Dimens.space26.w,
          color: CustomColors.bottomAppBarColor,
        ),
      ),
    );
  }
}

class ContactSearchShimmer extends StatelessWidget {
  const ContactSearchShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: CustomColors.bottomAppBarColor!,
      period: const Duration(milliseconds: 1000),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Dimens.space15.w, Dimens.space17.h,
            Dimens.space15.w, Dimens.space8.h),
        child: Container(
          width: Utils.getScreenWidth(context),
          height: Dimens.space52.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.space10.r),
            color: CustomColors.bottomAppBarColor,
          ),
        ),
      ),
    );
  }
}
