import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/DateTimeTextWidget.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";

class MemberListItemView extends StatelessWidget {
  const MemberListItemView({
    Key? key,
    required this.memberEdges,
    required this.animationController,
    required this.animation,
    required this.memberId,
    this.isOnCall = false,
    this.isFromMember = false,
    this.onTransfer,
    this.onTab,
  }) : super(key: key);

  final MemberEdges memberEdges;
  final AnimationController animationController;
  final Animation<double> animation;
  final String memberId;
  final bool isOnCall;
  final Function? onTransfer;
  final bool isFromMember;
  final Function? onTab;

  @override
  Widget build(BuildContext context) {
    if (memberEdges != null) {
      final String firstName =
          memberEdges.members?.firstName ?? Utils.getString("unknown");
      final String lastName = memberEdges.members?.lastName ?? "";
      return InkWell(
        onTap: () async {
          if (isOnCall) {
            onTransfer!();
          } else {
            if (onTab != null) {
              onTab!();
            }
          }
        },
        child: isFromMember
            ? MemberImageAndTextWidget(
                memberEdges: memberEdges,
                userId: memberId,
                firstName: firstName,
                lastName: lastName,
              )
            : MemberItemWidget(
                memberEdges: memberEdges,
                userId: memberId,
                firstName: firstName,
                lastName: lastName,
              ),
      );
    } else {
      return Container();
    }
  }
}

class MemberItemWidget extends StatelessWidget {
  const MemberItemWidget({
    Key? key,
    required this.memberEdges,
    required this.userId,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  final MemberEdges memberEdges;
  final String userId;
  final String firstName;
  final String lastName;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space20.w, Dimens.space7.h, Dimens.space20.w, Dimens.space7.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space10.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space36,
                    height: Dimens.space36,
                    iconUrl: CustomIcon.icon_profile,
                    iconColor: CustomColors.callInactiveColor,
                    iconSize: Dimens.space30,
                    boxDecorationColor: CustomColors.mainDividerColor,
                    containerAlignment: Alignment.bottomCenter,
                    imageUrl: memberEdges.members?.profilePicture ?? "",
                  ),
                ),
                Positioned(
                  right: Dimens.space0.w,
                  bottom: Dimens.space0.w,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space13,
                      height: Dimens.space13,
                      iconUrl: Icons.circle,
                      iconColor: memberEdges.members?.online != null &&
                              memberEdges.members!.online!
                          ? CustomColors.callAcceptColor
                          : CustomColors.callInactiveColor,
                      iconSize: Dimens.space10,
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
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RichText(
                overflow: TextOverflow.fade,
                softWrap: false,
                textAlign: TextAlign.left,
                maxLines: 1,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeSemiBold,
                        fontSize: Dimens.space15.sp,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                  text: Config.checkOverFlow
                      ? Const.OVERFLOW
                      : userId == memberEdges.members?.id
                          ? "$firstName $lastName (You)"
                          : "$firstName $lastName",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemberImageAndTextWidget extends StatelessWidget {
  const MemberImageAndTextWidget({
    Key? key,
    required this.memberEdges,
    required this.userId,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  final MemberEdges memberEdges;
  final String userId;
  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    if (memberEdges != null) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space7.h,
            Dimens.space20.w, Dimens.space7.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: Dimens.space45.w,
                  height: Dimens.space45.w,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space45,
                    height: Dimens.space45,
                    containerAlignment: Alignment.bottomCenter,
                    iconUrl: CustomIcon.icon_profile,
                    iconColor: CustomColors.callInactiveColor,
                    iconSize: Dimens.space40,
                    boxDecorationColor: CustomColors.mainDividerColor,
                    imageUrl: memberEdges.members?.profilePicture != null
                        ? memberEdges.members?.profilePicture?.trim()
                        : "",
                  ),
                ),
                Positioned(
                  right: Dimens.space0.w,
                  bottom: Dimens.space0.w,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space13,
                      height: Dimens.space13,
                      iconUrl: Icons.circle,
                      iconColor: memberEdges.members?.online != null &&
                              memberEdges.members!.online!
                          ? CustomColors.callAcceptColor
                          : CustomColors.callInactiveColor,
                      iconSize: Dimens.space11,
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
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 8,
                          child: Row(
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: RichText(
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontFamily: memberEdges.members
                                                        ?.unSeenMsgCount ==
                                                    0
                                                ? Config.manropeSemiBold
                                                : Config.manropeExtraBold,
                                            fontSize: Dimens.space15.sp,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                      text: Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : userId == memberEdges.members?.id
                                              ? "$firstName $lastName (You)"
                                              : "$firstName $lastName",
                                    ),
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage: !(memberEdges.members?.role
                                            ?.toLowerCase() ==
                                        "admin" ||
                                    memberEdges.members?.role?.toLowerCase() ==
                                        "owner"),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space6.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  child: RoundedAssetSvgHolder(
                                    containerWidth: Dimens.space15,
                                    containerHeight: Dimens.space15,
                                    imageWidth: Dimens.space15,
                                    imageHeight: Dimens.space15,
                                    outerCorner: Dimens.space0,
                                    innerCorner: Dimens.space0,
                                    iconUrl: CustomIcon.icon_gallery,
                                    iconColor: CustomColors.mainColor!,
                                    iconSize: Dimens.space0,
                                    boxDecorationColor: Colors.transparent,
                                    assetUrl: "assets/images/icon_admin.svg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h,
                            ),
                            alignment: Alignment.centerRight,
                            constraints: BoxConstraints(
                              maxWidth: Dimens.space65.w,
                              minWidth: Dimens.space10.w,
                            ),
                            child: DateTimeTextWidget(
                              timestamp: memberEdges
                                      .members?.chatMessageNode?.createdOn ??
                                  "",
                              date: memberEdges
                                      .members?.chatMessageNode?.createdOn ??
                                  "",
                              format: DateFormat("yyyy-MM-ddThh:mm:ss.SSSSSS"),
                              dateFontColor:
                                  memberEdges.members?.unSeenMsgCount == 0
                                      ? CustomColors.textQuinaryColor!
                                      : CustomColors.textTertiaryColor!,
                              dateFontFamily: Config.manropeSemiBold,
                              dateFontSize: Dimens.space13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.zero,
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : memberEdges.members?.chatMessageNode
                                              ?.message !=
                                          null
                                      ? memberEdges
                                          .members!.chatMessageNode!.message!
                                      : "No chat available.",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                    color: CustomColors.textPrimaryLightColor,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space14.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        if (memberEdges.members?.unSeenMsgCount == 0)
                          Container()
                        else
                          Container(
                            width: Dimens.space10.w,
                            height: Dimens.space10.w,
                            margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: CustomColors.textPrimaryErrorColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space5.w),
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
      );
    } else {
      return Container();
    }
  }
}
