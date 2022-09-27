import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:functional_widget_annotation/functional_widget_annotation.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

@swidget
Widget importContact(
  BuildContext context, {
  Function? addNewContacts,
  Function? importAllContact,
}) {
  return Container(
    alignment: Alignment.bottomCenter,
    padding: EdgeInsets.fromLTRB(
        Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width.w,
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(Dimens.space16.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space30.w,
                      Dimens.space0.h, Dimens.space30.w, Dimens.space0.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  addNewContacts!();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedNetworkImageHolder(
                      width: Dimens.space30,
                      height: Dimens.space52,
                      iconUrl: CustomIcon.icon_person_full,
                      iconColor: CustomColors.loadingCircleColor,
                      iconSize: Dimens.space20,
                      outerCorner: Dimens.space0,
                      innerCorner: Dimens.space0,
                      boxDecorationColor: CustomColors.transparent,
                      imageUrl: "",
                    ),
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: CustomColors.loadingCircleColor,
                                fontFamily: Config.manropeRegular,
                                fontSize: Dimens.space13.sp,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                          text: Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("addANewContacts"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.spaceHalf.h,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space30.w,
                      Dimens.space0.h, Dimens.space30.w, Dimens.space0.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  importAllContact!();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedNetworkImageHolder(
                      width: Dimens.space30,
                      height: Dimens.space52,
                      iconUrl: CustomIcon.icon_contact_book,
                      iconColor: CustomColors.textQuaternaryColor,
                      iconSize: Dimens.space20,
                      outerCorner: Dimens.space0,
                      innerCorner: Dimens.space0,
                      boxDecorationColor: CustomColors.transparent,
                      imageUrl: "",
                    ),
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: CustomColors.textPrimaryColor,
                                fontFamily: Config.manropeRegular,
                                fontSize: Dimens.space13.sp,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                          text: Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("importContacts"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width.w,
          height: Dimens.space50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimens.space16.r),
          ),
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
              Dimens.space0.w, Dimens.space10.h),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space10.h,
                  Dimens.space10.w, Dimens.space10.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("cancel"),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeRegular,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
