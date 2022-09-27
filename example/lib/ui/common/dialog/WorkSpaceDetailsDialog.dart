import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/intent_holder/MemberListIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/NumberListIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/OverWorkspaceIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/TeamListIntentHolder.dart";
import "package:provider/provider.dart";

/*
 * *
 *  * Created by Kedar on 7/27/21 1:22 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/27/21 1:22 PM
 *
 */

class WorkSpaceDetailsDialog extends StatefulWidget {
  const WorkSpaceDetailsDialog({
    Key? key,
    required this.onWorkspaceUpdateCallback,
    required this.scrollController,
    required this.loginWorkspaceProvider,
    required this.memberProvider,
    required this.contactsProvider,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final VoidCallback onWorkspaceUpdateCallback;
  final ScrollController scrollController;
  final LoginWorkspaceProvider loginWorkspaceProvider;
  final MemberProvider memberProvider;
  final ContactsProvider contactsProvider;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  _WorkSpaceDetailsDialogState createState() => _WorkSpaceDetailsDialogState();
}

class _WorkSpaceDetailsDialogState extends State<WorkSpaceDetailsDialog> {
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
    return Consumer<LoginWorkspaceProvider>(
      builder: (
        BuildContext context,
        LoginWorkspaceProvider provider1,
        Widget? child,
      ) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space12.r),
            topRight: Radius.circular(Dimens.space12.r),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space25.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space12.r),
                topRight: Radius.circular(Dimens.space12.r),
              ),
              color: CustomColors.white,
            ),
            child: ListView(
              shrinkWrap: true,
              controller: widget.scrollController,
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space20.w,
                      Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space12.r),
                      topRight: Radius.circular(Dimens.space12.r),
                    ),
                    color: CustomColors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedNetworkImageTextHolder(
                          imageUrl: widget.loginWorkspaceProvider
                                          .getWorkspaceDetail()
                                          .photo !=
                                      null &&
                                  widget.loginWorkspaceProvider
                                      .getWorkspaceDetail()
                                      .photo!
                                      .isNotEmpty
                              ? widget.loginWorkspaceProvider
                                  .getWorkspaceDetail()
                                  .photo!
                                  .trim()
                              : "",
                          width: Dimens.space80,
                          height: Dimens.space80,
                          text: widget.loginWorkspaceProvider
                                          .getWorkspaceDetail()
                                          .title !=
                                      null &&
                                  widget.loginWorkspaceProvider
                                      .getWorkspaceDetail()
                                      .title!
                                      .isNotEmpty
                              ? widget.loginWorkspaceProvider
                                  .getWorkspaceDetail()
                                  .title!
                                  .characters
                                  .first
                                  .toUpperCase()
                              : "",
                          corner: Dimens.space20,
                          iconSize: Dimens.space40,
                          fontSize: Dimens.space24,
                          textColor: CustomColors.textPrimaryColor!,
                          iconUrl: CustomIcon.icon_profile,
                          iconColor: CustomColors.textPrimaryColor!,
                          fontFamily: Config.heeboExtraBold,
                          boxDecorationColor: CustomColors.bottomAppBarColor!,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.fromLTRB(
                            Dimens.space20.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h,
                          ),
                          child: Visibility(
                            visible: Platform.isAndroid,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: Dimens.space16.h),
                                  child: widget.loginWorkspaceProvider
                                              .overviewData!.status ==
                                          Status.PROGRESS_LOADING
                                      ? SizedBox(
                                          height: Dimens.space20.r,
                                          width: Dimens.space20.r,
                                          child: CircularProgressIndicator(
                                            color: CustomColors.black,
                                            strokeWidth: 1.5,
                                          ),
                                        )
                                      : RoundedAssetSvgHolder(
                                          containerWidth: Dimens.space20,
                                          containerHeight: Dimens.space20,
                                          imageWidth: Dimens.space20,
                                          imageHeight: Dimens.space20,
                                          outerCorner: Dimens.space0,
                                          innerCorner: Dimens.space0,
                                          iconUrl: CustomIcon.icon_gallery,
                                          iconColor: CustomColors.mainColor!,
                                          iconSize: Dimens.space0,
                                          boxDecorationColor:
                                              Colors.transparent,
                                          assetUrl:
                                              "assets/images/icon_sync.svg",
                                          onTap: () async {
                                            await widget.loginWorkspaceProvider
                                                .doPlanOverViewApiCall();
                                          },
                                        ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                    ),
                                  ),
                                  onPressed: () async {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.space5.r),
                                      ),
                                      color: CustomColors.callAcceptColor,
                                    ),
                                    padding: EdgeInsets.fromLTRB(
                                      Dimens.space8.w,
                                      Dimens.space6.h,
                                      Dimens.space8.w,
                                      Dimens.space6.h,
                                    ),
                                    child: Text(
                                      Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : widget.loginWorkspaceProvider
                                                          .overviewData!.data !=
                                                      null &&
                                                  widget
                                                          .loginWorkspaceProvider
                                                          .overviewData!
                                                          .data!
                                                          .credit !=
                                                      null &&
                                                  widget
                                                          .loginWorkspaceProvider
                                                          .overviewData!
                                                          .data!
                                                          .credit!
                                                          .amount !=
                                                      null
                                              ? "\$${widget.loginWorkspaceProvider.overviewData!.data!.credit!.amount} ${Utils.getString("remaining")}"
                                              : "\$00.0000 ${Utils.getString("remaining")}",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontSize: Dimens.space13.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space8.h, Dimens.space16.w, Dimens.space0),
                  color: CustomColors.white,
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : widget.loginWorkspaceProvider
                                        .getWorkspaceDetail()
                                        .title !=
                                    null &&
                                widget.loginWorkspaceProvider
                                    .getWorkspaceDetail()
                                    .title!
                                    .isNotEmpty
                            ? widget.loginWorkspaceProvider
                                .getWorkspaceDetail()
                                .title!
                            : "",
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeExtraBold,
                          fontSize: Dimens.space20.sp,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space5.h,
                      Dimens.space20.w, Dimens.space10.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0,
                      Dimens.space0.w, Dimens.space0.h),
                  color: CustomColors.white,
                  child: Row(
                    children: [
                      Container(
                        width: Dimens.space10.w,
                        height: Dimens.space10.w,
                        decoration: BoxDecoration(
                          color: CustomColors.callAcceptColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.space10.r),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimens.space5.h),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                            text: Config.checkOverFlow
                                ? Const.OVERFLOW
                                : widget.memberProvider.memberEdges != null &&
                                        widget.memberProvider.memberEdges!
                                                .data !=
                                            null &&
                                        widget.memberProvider.memberEdges!.data!
                                            .isNotEmpty
                                    ? "${widget.memberProvider.memberEdges!.data!.where((element) => element.members!.online!).toList().length}/${widget.memberProvider.memberEdges!.data!.length} ${Utils.getString("members")}"
                                    : "0/0 ${Utils.getString("members")}",
                          ),
                        ),
                      ),
                      Container(
                        width: Dimens.space10.w,
                        height: Dimens.space10.w,
                        margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        decoration: BoxDecoration(
                          color: CustomColors.loadingCircleColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space10.r)),
                        ),
                      ),
                      SizedBox(width: Dimens.space5.h),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                            text: Config.checkOverFlow
                                ? Const.OVERFLOW
                                : "${(widget.contactsProvider.contactResponse != null && widget.contactsProvider.contactResponse!.data != null && widget.contactsProvider.contactResponse!.data!.contactResponse!.contactResponseData!.isNotEmpty) ? widget.contactsProvider.contactResponse!.data!.contactResponse!.contactResponseData!.length : 0} Contacts",
                          ),
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
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(
                          Dimens.space16.w,
                          Dimens.space15.h,
                          Dimens.space16.w,
                          Dimens.space15.h,
                        ),
                        color: CustomColors.bottomAppBarColor,
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("workspace").toUpperCase(),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: CustomColors.textPrimaryLightColor,
                                fontFamily: Config.manropeBold,
                                fontWeight: FontWeight.normal,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.center,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                              ),
                              onPressed: () {
                                gotoOverView();
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
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CustomColors.mainDividerColor!,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
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
                                              : Utils.getString("overview"),
                                          textAlign: TextAlign.left,
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
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
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
                                              :
                                              // contact.number,
                                              "",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                color: CustomColors
                                                    .textTertiaryColor,
                                                fontFamily:
                                                    Config.manropeSemiBold,
                                                fontSize: Dimens.space15.sp,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      CustomIcon.icon_arrow_right,
                                      size: Dimens.space24.w,
                                      color: CustomColors.textQuinaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.center,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutePaths.myNumbers,
                                  arguments: NumberListIntentHolder(
                                    onIncomingTap: () {
                                      widget.onIncomingTap();
                                    },
                                    onOutgoingTap: () {
                                      widget.onOutgoingTap();
                                    },
                                  ),
                                );
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
                                  border: Border(
                                    bottom: BorderSide(
                                      color: CustomColors.mainDividerColor!,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
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
                                              : Utils.getString("numbers"),
                                          textAlign: TextAlign.left,
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
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
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
                                              :
                                              // contact.number,
                                              "",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                color: CustomColors
                                                    .textTertiaryColor,
                                                fontFamily:
                                                    Config.manropeSemiBold,
                                                fontSize: Dimens.space15.sp,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      CustomIcon.icon_arrow_right,
                                      size: Dimens.space24.w,
                                      color: CustomColors.textQuinaryColor,
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
                Container(
                  alignment: Alignment.centerLeft,
                  color: CustomColors.bottomAppBarColor,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space15.h, Dimens.space16.w, Dimens.space15.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("usermanagement").toUpperCase(),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontFamily: Config.manropeBold,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space14.sp,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    alignment: Alignment.center,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    backgroundColor: CustomColors.white,
                  ),
                  onPressed: () {
                    gotoMemberListView();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CustomColors.mainDividerColor!,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
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
                                  : Utils.getString("members"),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
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
                              Config.checkOverFlow ? Const.OVERFLOW : "",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    alignment: Alignment.center,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    backgroundColor: CustomColors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.teamsList,
                      arguments: TeamListIntentHolder(
                        teamId: "",
                        onIncomingTap: () {
                          widget.onIncomingTap();
                        },
                        onOutgoingTap: () {
                          widget.onOutgoingTap();
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CustomColors.mainDividerColor!,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
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
                                  : Utils.getString("teams"),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
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
                                  :
                                  // contact.number,
                                  "",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    alignment: Alignment.center,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    backgroundColor: CustomColors.white,
                  ),
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      RoutePaths.blockList,
                      arguments: NumberListIntentHolder(
                        onIncomingTap: () {
                          widget.onIncomingTap();
                        },
                        onOutgoingTap: () {
                          widget.onOutgoingTap();
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: CustomColors.mainDividerColor!,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
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
                                  : Utils.getString("blockedList"),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
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
                                  :
                                  // contact.number,
                                  "",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                        Icon(
                          CustomIcon.icon_arrow_right,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void gotoOverView() {
    Navigator.pushNamed(
      context,
      RoutePaths.overview,
      arguments: OverViewWorkspaceIntentHolder(
        onUpdateCallback: () {
          Navigator.of(context).pop();
          widget.onWorkspaceUpdateCallback();
          setState(() {});
        },
        onIncomingTap: () {
          widget.onIncomingTap();
        },
        onOutgoingTap: () {
          widget.onOutgoingTap();
        },
      ),
    );
  }

  void gotoMemberListView() {
    Navigator.pushNamed(
      context,
      RoutePaths.memberList,
      arguments: MemberListIntentHolder(
        onIncomingTap: () {
          widget.onIncomingTap();
        },
        onOutgoingTap: () {
          widget.onOutgoingTap();
        },
      ),
    );
  }
}
