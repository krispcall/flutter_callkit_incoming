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

class CallOnProgressMoreOptionDialog extends StatefulWidget {
  const CallOnProgressMoreOptionDialog({
    Key? key,
    required this.onContactTap,
    required this.onAddNoteTap,
    required this.onTransferCallTap,
  }) : super(key: key);

  final Function? onContactTap;
  final Function? onAddNoteTap;
  final Function? onTransferCallTap;

  @override
  CallOnProgressMoreOptionDialogState createState() =>
      CallOnProgressMoreOptionDialogState();
}

class CallOnProgressMoreOptionDialogState
    extends State<CallOnProgressMoreOptionDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.transparent,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h,
          Dimens.space20.w, Dimens.space30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space16.r),
                  topRight: Radius.circular(Dimens.space16.r),
                )),
              ),
              onPressed: () {
                widget.onTransferCallTap!();
              },
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedNetworkImageHolder(
                      width: Dimens.space30,
                      height: Dimens.space52,
                      iconUrl: CustomIcon.icon_transfer_call,
                      iconColor: CustomColors.blueLightColor,
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
                                color: CustomColors.blueLightColor,
                                fontStyle: FontStyle.normal,
                                fontSize: Dimens.space13.sp,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.manropeSemiBold,
                              ),
                          text: Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("transferCall"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.spaceHalf.h,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.space0.r),
                  ),
                ),
              ),
              onPressed: () {
                widget.onAddNoteTap!();
              },
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedNetworkImageHolder(
                      width: Dimens.space30,
                      height: Dimens.space52,
                      iconUrl: CustomIcon.icon_notes,
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
                                fontStyle: FontStyle.normal,
                                fontSize: Dimens.space13.sp,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.manropeSemiBold,
                              ),
                          text: Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("addNote"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.spaceHalf.h,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.space16.r),
                    bottomRight: Radius.circular(Dimens.space16.r),
                  ),
                ),
              ),
              onPressed: () {
                widget.onContactTap!();
              },
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedNetworkImageHolder(
                      width: Dimens.space30,
                      height: Dimens.space52,
                      iconUrl: CustomIcon.icon_person_full,
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
                                fontStyle: FontStyle.normal,
                                fontSize: Dimens.space13.sp,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.manropeSemiBold,
                              ),
                          text: Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("contacts"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space15.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedButtonWidget(
              width: MediaQuery.of(context).size.width,
              height: Dimens.space48,
              buttonBackgroundColor: CustomColors.white!,
              buttonTextColor: CustomColors.textPrimaryColor!,
              buttonBorderColor: CustomColors.white!,
              corner: Dimens.space16,
              buttonFontSize: Dimens.space15,
              buttonFontFamily: Config.manropeSemiBold,
              buttonText: Utils.getString("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
