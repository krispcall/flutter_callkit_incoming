import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/dialog/MemberDetailDialog.dart";
import "package:mvp/utils/Utils.dart";

class MemberMessageDetailSliderMenuWidget extends StatefulWidget {
  const MemberMessageDetailSliderMenuWidget(
      {Key? key,
      required this.clientId,
      required this.clientName,
      required this.clientProfilePicture,
      required this.onTapSearchConversation,
      this.clientEmail = "",
      this.onlineStatus = false})
      : super(key: key);

  final String clientId;
  final String? clientName;
  final String clientProfilePicture;
  final Function onTapSearchConversation;
  final bool onlineStatus;
  final String clientEmail;

  @override
  _MemberMessageDetailSliderMenuWidgetState createState() =>
      _MemberMessageDetailSliderMenuWidgetState();
}

class _MemberMessageDetailSliderMenuWidgetState
    extends State<MemberMessageDetailSliderMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.bottomAppBarColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height.sh,
        width: MediaQuery.of(context).size.width.w,
        margin: EdgeInsets.fromLTRB(Dimens.space50.w, Dimens.space24.h,
            Dimens.space16.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
          border: Border.all(
              color: CustomColors.mainDividerColor!, width: Dimens.space1.r),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimens.space16.w),
            topLeft: Radius.circular(Dimens.space16.w),
          ),
          color: CustomColors.bottomAppBarColor,
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                  Dimens.space16.w, Dimens.space24.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimens.space16.w),
                    topLeft: Radius.circular(Dimens.space16.w)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: CustomColors.white,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space20.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Row(
                      children: [
                        Container(
                          width: Dimens.space40,
                          height: Dimens.space40,
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
                            width: Dimens.space40,
                            height: Dimens.space40,
                            iconUrl: CustomIcon.icon_profile,
                            containerAlignment: Alignment.bottomCenter,
                            iconColor: CustomColors.callInactiveColor,
                            iconSize: Dimens.space34,
                            boxDecorationColor: CustomColors.mainDividerColor,
                            outerCorner: Dimens.space14,
                            innerCorner: Dimens.space14,
                            imageUrl: widget.clientProfilePicture,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space14.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            alignment: Alignment.center,
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : widget.clientName ??
                                              Utils.getString("unknown"),
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
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontStyle: FontStyle.normal,
                                          ),
                                    ),
                                  ),
                                ),
                                if (widget.onlineStatus)
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
                                                  color: CustomColors
                                                      .textTertiaryColor,
                                                  fontFamily:
                                                      Config.manropeSemiBold,
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
                ],
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1,
              thickness: Dimens.space1,
            ),
            //Search
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              height: Dimens.space52.h,
              color: CustomColors.white,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                  backgroundColor: CustomColors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  Utils.checkInternetConnectivity().then((data) async {
                    if (data) {
                      widget.onTapSearchConversation();
                    } else {
                      Utils.showWarningToastMessage(
                          Utils.getString("noInternet"), context);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CustomIcon.icon_search,
                      size: Dimens.space16.w,
                      color: CustomColors.textTertiaryColor,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("searchConversation"),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1,
              thickness: Dimens.space1,
            ),
            SizedBox(
              height: Dimens.space20.h,
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1,
              thickness: Dimens.space1,
            ),

            //Search
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              height: Dimens.space52.h,
              color: CustomColors.white,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                  backgroundColor: CustomColors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  showMemberDetailDialog();
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("memberDetails"),
                    textAlign: TextAlign.center,
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
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1,
              thickness: Dimens.space1,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.space0.w),
                    bottomRight: Radius.circular(Dimens.space0.w),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMemberDetailDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space20.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MemberDetailDialog(
          name: widget.clientName,
          onlineStatus: widget.onlineStatus,
          image: widget.clientProfilePicture,
          email: widget.clientEmail,
        );
      },
    );
  }
}
