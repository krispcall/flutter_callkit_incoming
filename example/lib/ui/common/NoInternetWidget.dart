import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:flutter_svg/svg.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";

enum ButtonState { idle, loading }

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final ButtonState? state;

  const NoInternetWidget({
    Key? key,
    this.onPressed,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            "assets/images/no_wifi.svg",
            fit: BoxFit.cover,
            clipBehavior: Clip.antiAlias,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space20.h,
                Dimens.space40.w, Dimens.space0.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("noInternetConnection"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: Dimens.space20.sp,
                    color: CustomColors.textPrimaryColor,
                    fontFamily: Config.manropeBold,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space37.w, Dimens.space10.h,
                Dimens.space37.w, Dimens.space0.h),
            child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("noInternetDes"),
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: CustomColors.textTertiaryColor,
                    fontFamily: Config.heeboRegular,
                    fontSize: Dimens.space15.sp,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.center),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
                Dimens.space0.w, Dimens.space20.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Container(
              width: Dimens.space270.w,
              height: Dimens.space54.h,
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: CustomColors.loadingCircleColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.space10.r)),
                ),
                onPressed: onPressed,
                child: Container(
                  width: Dimens.space270.w,
                  height: Dimens.space54.h,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space40.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("retry"),
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.white,
                                      fontStyle: FontStyle.normal,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: Config.manropeSemiBold,
                                    ),
                          ),
                        ),
                      ),
                      if (getButtonChild())
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space10.w,
                              Dimens.space0.h),
                          child: SpinKitCircle(
                            color: CustomColors.white,
                          ),
                        )
                      else
                        Container(),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool getButtonChild() {
    bool isLoading = false;
    if (state == ButtonState.loading) {
      isLoading = true;
    } else {
      isLoading = false;
    }
    return isLoading;
  }
}
