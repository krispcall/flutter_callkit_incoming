import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

//Empty Call View

class EmptyConversationWidget extends StatelessWidget {
  final String? title;
  final String message;
  final String imageUrl;

  const EmptyConversationWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: Dimens.space100.w,
          height: Dimens.space100.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: RoundedNetworkImageHolder(
            width: Dimens.space100,
            height: Dimens.space100,
            containerAlignment: Alignment.bottomCenter,
            iconUrl: CustomIcon.icon_profile,
            iconColor: CustomColors.callInactiveColor,
            iconSize: Dimens.space85,
            boxDecorationColor: CustomColors.mainDividerColor,
            outerCorner: Dimens.space32,
            innerCorner: Dimens.space32,
            imageUrl: imageUrl,
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
              Dimens.space0.w, Dimens.space10),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : title ?? Utils.getString("unknown"),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
          margin: EdgeInsets.fromLTRB(Dimens.space37.w, Dimens.space0.h,
              Dimens.space37.w, Dimens.space0.h),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : title != null
                    ? "$message $title"
                    : "$message ${Utils.getString("unknown")}",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: CustomColors.textTertiaryColor,
                  fontFamily: Config.heeboRegular,
                  fontSize: Dimens.space15.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
      ],
    );
  }
}
