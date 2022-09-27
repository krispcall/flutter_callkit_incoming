import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";

class EmptyViewUiWidget extends StatelessWidget {
  final String? assetUrl;
  final String? title;
  final String? desc;
  final String? buttonTitle;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool showButton;

  const EmptyViewUiWidget({
    Key? key,
    this.onPressed,
    this.assetUrl,
    this.title,
    this.desc,
    this.buttonTitle,
    this.icon,
    this.showButton = true,
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
          PlainAssetImageHolder(
            assetUrl: assetUrl!,
            width: Dimens.space152,
            height: Dimens.space152,
            assetWidth: Dimens.space152,
            assetHeight: Dimens.space152,
            boxFit: BoxFit.contain,
            outerCorner: Dimens.space0,
            innerCorner: Dimens.space0,
            iconSize: Dimens.space152,
            iconUrl: CustomIcon.icon_call,
            iconColor: CustomColors.white!,
            boxDecorationColor: CustomColors.white!,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space20.h,
                Dimens.space40.w, Dimens.space0.h),
            child: Text(
              Config.checkOverFlow ? Const.OVERFLOW : title!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
              Config.checkOverFlow ? Const.OVERFLOW : desc!,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: CustomColors.textTertiaryColor,
                    fontFamily: Config.heeboRegular,
                    fontSize: Dimens.space15.sp,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          if (showButton)
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
                  Dimens.space0.w, Dimens.space20.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: RoundedButtonWidgetWithPrefix(
                corner: Dimens.space10,
                titleText: buttonTitle!,
                buttonColor: CustomColors.loadingCircleColor!,
                textFontSize: Dimens.space16,
                textFontFamily: Config.manropeSemiBold,
                textColor: CustomColors.white!,
                icon: icon!,
                iconColor: CustomColors.white!,
                iconSize: Dimens.space20.w,
                onPressed: onPressed!,
                height: Dimens.space54,
                width: Dimens.space270,
              ),
            )
          else
            Container(
              height: Dimens.space50.h,
            )
        ],
      ),
    );
  }
}

class RoundCornerWitIcon extends StatelessWidget {
  const RoundCornerWitIcon(
      {required this.onPressed,
      required this.fillColor,
      required this.iconColor,
      this.text,
      this.textColor,
      this.icon,
      this.verticalPadding,
      this.horizontalPadding,
      this.textstyle,
      this.iconSize});

  final GestureTapCallback onPressed;
  final Color fillColor;
  final Color iconColor;
  final IconData? icon;
  final double? iconSize;

  final String? text;
  final Color ?textColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final TextStyle? textstyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.space50.h,
      margin: EdgeInsets.symmetric(
          vertical: verticalPadding != null ? verticalPadding! : Dimens.space4.h,
          horizontal:
              horizontalPadding != null ? horizontalPadding! : Dimens.space0),
      child: RawMaterialButton(
        fillColor: fillColor,
        textStyle: TextStyle(color: textColor),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.space10)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: Dimens.space10.h),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
              Container(
                margin: EdgeInsets.only(left: Dimens.space10.w),
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : text!,
                  style: textstyle ??
                      Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: Dimens.space16.sp,
                            fontWeight: FontWeight.normal,
                            color: textColor,
                            fontFamily: Config.manropeSemiBold,
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
