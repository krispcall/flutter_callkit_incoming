/*
 * *
 *  * Created by Kedar on 7/30/21 1:06 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 1:06 PM
 *  
 */

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/workspace/plan/WorkSpacePlan.dart";

class WorkspaceDeleteDialog extends StatelessWidget {
  final PlanOverviewData planOverviewData;
  final String workspaceName;

  const WorkspaceDeleteDialog({
    Key? key,
    required this.planOverviewData,
    required this.workspaceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0.h, Dimens.space0, Dimens.space0),
      margin: EdgeInsets.fromLTRB(
          Dimens.space16.w, Dimens.space0, Dimens.space16.w, Dimens.space20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.space20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h,
                Dimens.space0.w, Dimens.space10.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: PlainAssetImageHolder(
              width: Dimens.space70,
              height: Dimens.space70,
              assetHeight: Dimens.space70,
              assetWidth: Dimens.space70,
              iconUrl: CustomIcon.icon_profile,
              iconColor: CustomColors.callInactiveColor!,
              iconSize: Dimens.space70,
              boxFit: BoxFit.contain,
              boxDecorationColor: CustomColors.transparent!,
              outerCorner: Dimens.space0,
              innerCorner: Dimens.space0,
              assetUrl: "assets/images/deleted_workspace.png",
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space5.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("workspaceDeleted"),
              textAlign: TextAlign.center,
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
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: Utils.getString("yourWorkspace"),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textTertiaryColor,
                          fontFamily: Config.heeboRegular,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                  TextSpan(
                    text: workspaceName,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.mainColor,
                          fontFamily: Config.heeboRegular,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                  TextSpan(
                    text: Utils.getString("hasBeenDeleted"),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textTertiaryColor,
                          fontFamily: Config.heeboRegular,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                  TextSpan(
                    text:
                        "${planOverviewData != null ? (planOverviewData.remainingDays! <= 0 ? 0 : planOverviewData.remainingDays) : 0} days.",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textTertiaryColor,
                          fontFamily: Config.heeboRegular,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
                Dimens.space0.w, Dimens.space20.h),
            child: TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h,
                    Dimens.space0.w, Dimens.space12.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.center,
              ),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Utils.getString("ok").toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: Dimens.space15.sp,
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeSemiBold,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
