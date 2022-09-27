import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class ForceUpdate extends StatelessWidget {
  const ForceUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      color: CustomColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimens.space16.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: PlainAssetImageHolder(
                    assetUrl: "assets/images/updateApp.png",
                    height: Dimens.space152,
                    width: Dimens.space152,
                    assetWidth: Dimens.space152,
                    assetHeight: Dimens.space152,
                    boxFit: BoxFit.contain,
                    iconUrl: CustomIcon.icon_person,
                    iconSize: Dimens.space10,
                    iconColor: CustomColors.mainColor,
                    boxDecorationColor: CustomColors.transparent,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space21.w,
                      Dimens.space48.h, Dimens.space21.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("krispcallNeedsAnUpdate"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeBold,
                          fontSize: Dimens.space20.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space21.w,
                      Dimens.space10.h, Dimens.space21.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("pleaseUpdateTheKrispCall"),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: CustomColors.textTertiaryColor,
                          fontFamily: Config.heeboRegular,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space56.w,
                      Dimens.space32.h, Dimens.space56.w, Dimens.space8.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedButtonWidget(
                    width: double.maxFinite,
                    buttonBackgroundColor: CustomColors.mainColor!,
                    buttonTextColor: CustomColors.white!,
                    corner: Dimens.space10,
                    buttonBorderColor: CustomColors.mainColor!,
                    buttonFontFamily: Config.manropeSemiBold,
                    buttonFontSize: Dimens.space15,
                    buttonText: Utils.getString("update"),
                    onPressed: () async {
                      Utils.checkInternetConnectivity()
                          .then((bool onValue) async {
                        if (onValue) {
                          Utils.lunchWebUrl(
                              url: Platform.isIOS
                                  ? EndPoints.APPSTORE_URL
                                  : EndPoints.PLAYSTORE_URL,
                              context: context);
                        } else {
                          Utils.showWarningToastMessage(
                              Utils.getString("noInternet"), context);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
