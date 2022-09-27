import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";

class DateTimeTextWidget extends StatelessWidget {
  const DateTimeTextWidget({
    Key? key,
    required this.timestamp,
    required this.date,
    required this.format,
    required this.dateFontColor,
    this.dateFontSize = Dimens.space14,
    this.dateFontFamily = Config.heeboRegular,
    this.dateFontStyle = FontStyle.normal,
    this.dateFontWeight = FontWeight.normal,
  }) : super(key: key);
  final String timestamp;
  final String date;
  final DateFormat format;
  final String dateFontFamily;
  final double dateFontSize;
  final FontWeight dateFontWeight;
  final FontStyle dateFontStyle;
  final Color dateFontColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      Config.checkOverFlow
          ? Const.OVERFLOW
          : timestamp != null
              ? Utils.readTimestamp(date, format)
              : "",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: dateFontColor,
            fontFamily: dateFontFamily,
            fontSize: dateFontSize.sp,
            fontWeight: dateFontWeight,
            fontStyle: dateFontStyle,
          ),
    );
  }
}
