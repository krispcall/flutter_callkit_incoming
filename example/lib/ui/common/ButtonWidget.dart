import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";

class RoundedButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final Color buttonBackgroundColor;
  final Color buttonTextColor;
  final String buttonFontFamily;
  final Color buttonBorderColor;
  final FontWeight buttonFontWeight;
  final double buttonFontSize;
  final double width;
  final double height;
  final bool hasShadow;
  final TextAlign titleTextAlign;
  final double corner;
  final FontStyle fontStyle;

  const RoundedButtonWidget({
    required this.onPressed,
    required this.buttonText,
    required this.buttonBackgroundColor,
    required this.buttonTextColor,
    required this.buttonBorderColor,
    required this.corner,
    this.titleTextAlign = TextAlign.center,
    this.buttonFontFamily = Config.heeboRegular,
    this.buttonFontWeight = FontWeight.normal,
    this.buttonFontSize = Dimens.space16,
    this.fontStyle = FontStyle.normal,
    this.width = Dimens.space50,
    this.height = Dimens.space52,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width.w,
      height: height.h,
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space0.h,
              Dimens.space14.w, Dimens.space0.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(corner.r),
            side: BorderSide(
              color: buttonBorderColor,
              width: 0.5,
            ),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          width: width.w,
          height: height.h,
          child: Text(
            Config.checkOverFlow ? Const.OVERFLOW : buttonText,
            textAlign: titleTextAlign,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: buttonTextColor,
                  fontFamily: buttonFontFamily,
                  fontWeight: buttonFontWeight,
                  fontSize: buttonFontSize.sp,
                  fontStyle: fontStyle,
                ),
          ),
        ),
      ),
    );
  }
}

class RoundedButtonWidgetWithPrefix extends StatelessWidget {
  const RoundedButtonWidgetWithPrefix({
    required this.onPressed,
    required this.buttonColor,
    required this.corner,
    required this.titleText,
    required this.textColor,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    this.titleTextAlign = TextAlign.center,
    this.width = Dimens.space50,
    this.height = Dimens.space16,
    this.textFontWeight = FontWeight.normal,
    this.textFontStyle = FontStyle.normal,
    this.textFontFamily = Config.heeboRegular,
    this.textFontSize = Dimens.space14,
  });

  final Function onPressed;
  final String titleText;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final TextAlign titleTextAlign;
  final double corner;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final FontStyle textFontStyle;
  final double textFontSize;
  final FontWeight textFontWeight;
  final String textFontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(corner.r),
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Container(
          width: width.w,
          height: height.h,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
              Dimens.space10.w, Dimens.space0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space10.w, Dimens.space0.h),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize.w,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RichText(
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: textColor,
                            fontStyle: textFontStyle,
                            fontSize: textFontSize.sp,
                            fontWeight: textFontWeight,
                            fontFamily: textFontFamily,
                          ),
                      text: Config.checkOverFlow ? Const.OVERFLOW : titleText,
                    ),
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

class RoundedButtonWidgetWithSuffix extends StatelessWidget {
  const RoundedButtonWidgetWithSuffix({
    required this.onPressed,
    required this.buttonColor,
    required this.corner,
    required this.titleText,
    required this.textColor,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    this.titleTextAlign = TextAlign.center,
    this.width = Dimens.space50,
    this.height = Dimens.space16,
    this.textFontWeight = FontWeight.normal,
    this.textFontStyle = FontStyle.normal,
    this.textFontFamily = Config.heeboRegular,
    this.textFontSize = Dimens.space14,
  });

  final Function onPressed;
  final String titleText;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final TextAlign titleTextAlign;
  final double corner;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final FontStyle textFontStyle;
  final double textFontSize;
  final FontWeight textFontWeight;
  final String textFontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(corner.r)),
        ),
        onPressed: () {
          onPressed();
        },
        child: Container(
          width: width.w,
          height: height.h,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : titleText,
                    textAlign: titleTextAlign,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: textColor,
                          fontStyle: textFontStyle,
                          fontSize: textFontSize.sp,
                          fontWeight: textFontWeight,
                          fontFamily: textFontFamily,
                        ),
                  ),
                ),
              ),
              Container(
                width: Dimens.space32.w,
                height: Dimens.space32.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CustomColors.black!.withOpacity(0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.space300.r),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space0.h,
                    Dimens.space14.w, Dimens.space0.h),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: iconSize.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
