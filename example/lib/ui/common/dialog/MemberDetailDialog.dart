import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class MemberDetailDialog extends StatefulWidget {
  final String? name;
  final String? image;
  final bool? onlineStatus;
  final String? email;

  const MemberDetailDialog({
    Key? key,
    required this.name,
    required this.image,
    required this.onlineStatus,
    required this.email,
  }) : super(key: key);

  @override
  MemberDetailDialogState createState() => MemberDetailDialogState();
}

class MemberDetailDialogState extends State<MemberDetailDialog>
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
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      color: CustomColors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
                Dimens.space0.w, Dimens.space20.h),
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space20.r),
                topRight: Radius.circular(Dimens.space20.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: Dimens.space40,
                  height: Dimens.space40,
                  margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space40,
                    height: Dimens.space40,
                    iconUrl: CustomIcon.icon_profile,
                    containerAlignment: Alignment.bottomCenter,
                    iconColor: CustomColors.callInactiveColor,
                    iconSize: Dimens.space34,
                    boxDecorationColor: CustomColors.mainDividerColor,
                    outerCorner: Dimens.space14,
                    innerCorner: Dimens.space14,
                    imageUrl: widget.image != null && widget.image!.isNotEmpty
                        ? widget.image!.trim()
                        : "",
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space14.w,
                        Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space0.w,
                      Dimens.space0.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
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
                                  : widget.name ?? Utils.getString("unknown"),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                    color: CustomColors.textPrimaryColor,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                        if (widget.onlineStatus != null && widget.onlineStatus!)
                          Row(
                            children: [
                              Container(
                                width: Dimens.space8.w,
                                height: Dimens.space8.w,
                                decoration: BoxDecoration(
                                  color: CustomColors.callAcceptColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space10.r),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Dimens.space6.w,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : Utils.getString("activeNow"),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.textTertiaryColor,
                                          fontFamily: Config.manropeSemiBold,
                                          fontSize: Dimens.space13.sp,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1.h,
            thickness: Dimens.space1.h,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space16.h,
                Dimens.space20.w, Dimens.space16.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("name"),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : widget.name!,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomColors.textTertiaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1.h,
            thickness: Dimens.space1.h,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space16.h,
                Dimens.space20.w, Dimens.space16.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space8.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("emailAddress"),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : widget.email!,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomColors.textTertiaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1.h,
            thickness: Dimens.space1.h,
          ),
        ],
      ),
    );
  }
}
