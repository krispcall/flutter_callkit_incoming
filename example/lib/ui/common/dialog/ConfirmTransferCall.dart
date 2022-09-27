import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class ConfirmTransferCallDialog extends StatelessWidget {
  final Function? onTap;
  final String? userName;

  const ConfirmTransferCallDialog({
    Key? key,
    this.onTap,
    this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.fromLTRB(
          Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimens.space16.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Dimens.space54,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h,
                      Dimens.space0.w, Dimens.space10.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space2.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageHolder(
                          width: Dimens.space54,
                          height: Dimens.space54,
                          iconUrl: CustomIcon.icon_profile,
                          iconColor: CustomColors.callInactiveColor,
                          iconSize: Dimens.space50,
                          boxDecorationColor: CustomColors.mainDividerColor,
                          containerAlignment: Alignment.bottomCenter,
                          imageUrl: "",
                        ),
                      ),
                      Positioned(
                        right: Dimens.space1.w,
                        bottom: Dimens.space1.w,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space15,
                            height: Dimens.space15,
                            iconUrl: Icons.circle,
                            iconColor: CustomColors.callAcceptColor,
                            iconSize: Dimens.space12,
                            boxDecorationColor: CustomColors.white,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            imageUrl: "",
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(Dimens.space21.w,
                      Dimens.space0.h, Dimens.space21.w, Dimens.space5.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("transferCall"),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeBold,
                          fontSize: Dimens.space20.sp,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(Dimens.space21.w,
                      Dimens.space0.h, Dimens.space21.w, Dimens.space14.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : "${Utils.getString("areYouSureYouWantToTransferYourCallTo")} \n @$userName",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeRegular,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space12.h),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center,
                    ),
                    onPressed: () {
                      onTap!();
                      Navigator.of(context).pop({"data": true});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(Dimens.space21.w,
                          Dimens.space0.h, Dimens.space21.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("yesTransferCall"),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.loadingCircleColor,
                              fontFamily: Config.manropeRegular,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
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
                        fontFamily: Config.manropeSemiBold,
                        fontSize: Dimens.space15.sp,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
