import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:functional_widget_annotation/functional_widget_annotation.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class NoSearchResultsFoundWidget extends StatelessWidget {
  const NoSearchResultsFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.60,
      child: Center(
        child: Container(
          width: Dimens.space274.w,
          height: Dimens.space130.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space8.w)),
            color: CustomColors.bottomAppBarColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlainAssetImageHolder(
                assetUrl: "assets/images/icon_no_search_results.png",
                width: Dimens.space48,
                height: Dimens.space48,
                assetWidth: Dimens.space48,
                assetHeight: Dimens.space48,
                boxFit: BoxFit.contain,
                outerCorner: Dimens.space0,
                innerCorner: Dimens.space0,
                iconSize: Dimens.space152,
                iconUrl: CustomIcon.icon_gallery,
                iconColor: CustomColors.white!,
                boxDecorationColor: CustomColors.transparent!,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space14.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("noSearchResults"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: Dimens.space14.sp,
                        color: CustomColors.textTertiaryColor,
                        fontFamily: Config.heeboRegular,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@swidget
Widget noSearchResult(BuildContext context) {
  return Container(
    padding: EdgeInsets.fromLTRB(
        Dimens.space80.w, Dimens.space26.h, Dimens.space80.w, Dimens.space26.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
      color: CustomColors.baseLightColor,
    ),
    child: Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/no_search_result.svg",
          fit: BoxFit.cover,
          clipBehavior: Clip.antiAlias,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : Utils.getString("noSearchResults"),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.textTertiaryColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: Config.heeboMedium,
                  fontSize: Dimens.space14.sp,
                  fontStyle: FontStyle.normal,
                ),
          ),
        )
      ],
    ),
  );
}
