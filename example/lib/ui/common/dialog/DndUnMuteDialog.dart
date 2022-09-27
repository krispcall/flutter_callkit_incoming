import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class ClientDndUnMuteDialog extends StatelessWidget {
  final String? name;
  final int? dndEndTime;
  final Function? onUmMuteTap;

  const ClientDndUnMuteDialog(
      {Key? key, this.name, this.dndEndTime, this.onUmMuteTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        children: <Widget>[
          Container(
              width: Dimens.space80.w,
              height: Dimens.space6.h,
              margin: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space6.h),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.space33),
                ),
                color: CustomColors.bottomAppBarColor,
              )),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustomColors.mainBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.space20.r),
                    topRight: Radius.circular(Dimens.space20.r)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimens.space20.r),
                          topRight: Radius.circular(Dimens.space20.r)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      children: [
                        Container(
                          width: Dimens.space40,
                          height: Dimens.space40,
                          margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                              Dimens.space0, Dimens.space0, Dimens.space0),
                          padding: EdgeInsets.zero,
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space40,
                            height: Dimens.space40,
                            iconUrl: CustomIcon.icon_notification,
                            iconColor: CustomColors.loadingCircleColor,
                            iconSize: Dimens.space20,
                            boxDecorationColor: CustomColors.loadingCircleColor!
                                .withOpacity(0.1),
                            outerCorner: Dimens.space25,
                            innerCorner: Dimens.space10,
                            imageUrl: "",
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                                Dimens.space0, Dimens.space0, Dimens.space0),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : Utils.getString("unMuteConversation"),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          color: CustomColors.textPrimaryColor,
                                          fontFamily: Config.manropeBold,
                                          fontSize: Dimens.space18.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
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
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : name!,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.textTertiaryColor,
                                          fontFamily: Config.heeboRegular,
                                          fontSize: Dimens.space14.sp,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CustomColors.mainDividerColor!,
                          width: Dimens.space1.w),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.space16.w)),
                      color: CustomColors.mainBackgroundColor,
                    ),
                    child: InkWell(
                      onTap: () {
                        onUmMuteTap!();
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space16.h,
                              Dimens.space16.w,
                              Dimens.space16.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space16.w)),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CustomIcon.icon_notification,
                                size: Dimens.space24.w,
                                color: CustomColors.textPrimaryErrorColor,
                              ),
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space10.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : "${Utils.getString("unmute")} @$name",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: CustomColors
                                                    .textPrimaryColor,
                                                fontFamily:
                                                    Config.manropeSemiBold,
                                                fontSize: Dimens.space15.sp,
                                                fontWeight: FontWeight.normal),
                                      ))),
                            ],
                          )),
                    ),
                  ),
                  if (dndEndTime != null && dndEndTime != 0)
                    Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space18.w,
                            Dimens.space0.h, Dimens.space18.w, Dimens.space8.h),
                        child: RichText(
                          text: TextSpan(
                              text: Utils.getString("mutedMessage"),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space14.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                              children: [
                                TextSpan(
                                  text: Utils.fromUnixTimeStampToDate(
                                      "MMM dd, hh:mm a", dndEndTime!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        color: CustomColors.loadingCircleColor,
                                        fontFamily: Config.heeboRegular,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                )
                              ]),
                        ))
                  else
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space18.w,
                          Dimens.space0.h, Dimens.space18.w, Dimens.space8.h),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("mutedMessageUntillTurnOn"),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
