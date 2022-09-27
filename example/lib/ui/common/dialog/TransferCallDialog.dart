import "package:azlistview/azlistview.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/call_transfer/CallTransferProvider.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/dialog/ConfirmTransferCall.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/members/MemberListItemView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:provider/provider.dart";

/*
 * *
 *  * Created by Kedar on 7/23/21 12:55 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/23/21 12:55 PM
 *
 */

class TransferCallDialog extends StatefulWidget {
  final Function? onCancelTap;
  final AnimationController? animationController;
  final CallTransferProvider? callTransferProvider;
  final String? callerId;
  final String? direction;

  const TransferCallDialog({
    Key? key,
    this.callTransferProvider,
    this.onCancelTap,
    this.animationController,
    this.callerId,
    this.direction,
  }) : super(key: key);

  @override
  _TransferCallDialogState createState() => _TransferCallDialogState();
}

class _TransferCallDialogState extends State<TransferCallDialog> {
  MemberProvider? memberProvider;
  MemberRepository? memberRepository;
  Animation<double>? animation;
  String? userId;
  final TextEditingController controllerSearchMember = TextEditingController();
  DashboardProvider? dashboardProvider;

  final _debounce = DeBouncer(milliseconds: 500);

  @override
  void initState() {
    memberRepository = Provider.of<MemberRepository>(context, listen: false);
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    widget.animationController!.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().screenHeight - Dimens.space50,
      width: MediaQuery.of(context).size.width.w,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space16.r),
          topRight: Radius.circular(Dimens.space16.r),
        ),
        color: CustomColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space18.h,
                Dimens.space20.w, Dimens.space18.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("transferCall"),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeBold,
                        fontWeight: FontWeight.normal,
                        fontSize: Dimens.space16.sp,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                Positioned(
                  left: Dimens.space0.w,
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space24,
                    height: Dimens.space24,
                    iconUrl: CustomIcon.icon_arrow_left,
                    iconColor: CustomColors.loadingCircleColor,
                    iconSize: Dimens.space24,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    boxDecorationColor: CustomColors.transparent,
                    imageUrl: "",
                    onTap: () {
                      Navigator.of(context).pop();
                    },
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
          Expanded(
            child: ChangeNotifierProvider<MemberProvider>(
              lazy: false,
              create: (BuildContext context) {
                memberProvider =
                    MemberProvider(memberRepository: memberRepository);
                memberProvider!.doGetAllWorkspaceMembersApiCall(
                    memberProvider!.getMemberId());
                userId = memberProvider!.getMemberId();
                controllerSearchMember.addListener(() {
                  _debounce.run(() {
                    if (controllerSearchMember.text.isNotEmpty &&
                        controllerSearchMember.text != "") {
                      memberProvider!.doSearchMemberFromDb(
                          memberProvider!.getMemberId(),
                          controllerSearchMember.text);
                    } else {
                      memberProvider!
                          .getAllMembersFromDb(memberProvider!.getMemberId());
                    }
                  });
                });
                return memberProvider!;
              },
              child: Consumer<MemberProvider>(builder: (BuildContext context,
                  MemberProvider? provider, Widget? child) {
                if (memberProvider!.memberEdges != null &&
                    memberProvider!.memberEdges!.data != null) {
                  if (memberProvider!.memberEdges != null &&
                      memberProvider!.memberEdges!.data != null) {
                    int onlineLength = 0;
                    int offlineLength = 0;
                    for (int i = 0,
                            length = memberProvider!.memberEdges!.data!.length;
                        i < length;
                        i++) {
                      if (memberProvider!.memberEdges!.data != null &&
                          memberProvider!.memberEdges!.data!.isNotEmpty &&
                          memberProvider!
                                  .memberEdges!.data![i].members!.online !=
                              null &&
                          memberProvider!
                                  .memberEdges!.data![i].members!.online ==
                              true) {
                        onlineLength++;
                      } else {
                        offlineLength++;
                      }
                    }
                    for (int i = 0,
                            length = memberProvider!.memberEdges!.data!.length;
                        i < length;
                        i++) {
                      String pinyin = "";
                      if (memberProvider!.memberEdges!.data != null &&
                          memberProvider!.memberEdges!.data!.isNotEmpty &&
                          memberProvider!
                                  .memberEdges!.data![i].members!.online !=
                              null &&
                          memberProvider!
                                  .memberEdges!.data![i].members!.online ==
                              true) {
                        pinyin =
                            "${Utils.getString("online").toUpperCase()}-$onlineLength";
                      } else {
                        pinyin =
                            "${Utils.getString("offline").toUpperCase()}-$offlineLength";
                      }
                      memberProvider!.memberEdges!.data![i].namePinyin = pinyin;
                      if (RegExp("[A-Z]").hasMatch(pinyin)) {
                        memberProvider!.memberEdges!.data![i].tagIndex = pinyin;
                      } else {
                        memberProvider!.memberEdges!.data![i].tagIndex =
                            Utils.getString("offline");
                      }
                    }
                    // A-Z sort.
                    // SuspensionUtil.sortListBySuspensionTag(memberProvider.memberEdges.data);
                    memberProvider!.memberEdges!.data!.sort((b, a) {
                      if (a.getSuspensionTag() == "@" ||
                          b.getSuspensionTag() == "#") {
                        return -1;
                      } else if (a.getSuspensionTag() == "#" ||
                          b.getSuspensionTag() == "@") {
                        return 1;
                      } else {
                        return a
                            .getSuspensionTag()
                            .compareTo(b.getSuspensionTag());
                      }
                    });
                    // show sus tag.
                    SuspensionUtil.setShowSuspensionStatus(
                        memberProvider!.memberEdges!.data);
                  }
                  return Container(
                    color: CustomColors.white,
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space20.h,
                              Dimens.space16.w,
                              Dimens.space20.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          height: Dimens.space52.h,
                          child: TextField(
                            controller: controllerSearchMember,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textSenaryColor,
                                      fontFamily: Config.heeboRegular,
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimens.space16.sp,
                                      fontStyle: FontStyle.normal,
                                    ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: CustomColors.callInactiveColor!,
                                  width: Dimens.space1.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space10.r),
                                ),
                              ),
                              filled: true,
                              fillColor: CustomColors.baseLightColor,
                              prefixIconConstraints: BoxConstraints(
                                minWidth: Dimens.space40.w,
                                maxWidth: Dimens.space40.w,
                                maxHeight: Dimens.space20.h,
                                minHeight: Dimens.space20.h,
                              ),
                              prefixIcon: Container(
                                alignment: Alignment.center,
                                width: Dimens.space20.w,
                                height: Dimens.space20.w,
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space15.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space0.h),
                                child: Icon(
                                  CustomIcon.icon_search,
                                  size: Dimens.space16.w,
                                  color: CustomColors.textTertiaryColor,
                                ),
                              ),
                              hintText: Utils.getString("searchMembers"),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.heeboRegular,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space16.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ),
                        if (memberProvider!.memberEdges!.data!.isNotEmpty)
                          Expanded(
                            child: Container(
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
                              alignment: Alignment.center,
                              child: AzListView(
                                data: memberProvider!.memberEdges!.data!,
                                itemCount:
                                    memberProvider!.memberEdges!.data!.length,
                                susItemBuilder: (context, i) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width.sw,
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    decoration: BoxDecoration(
                                      color: CustomColors.mainDividerColor,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width.sw,
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space20.w,
                                          Dimens.space5.h,
                                          Dimens.space20.w,
                                          Dimens.space5.h),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : memberProvider
                                                    ?.memberEdges?.data![i]
                                                    .getSuspensionTag() ??
                                                "",
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: CustomColors.textTertiaryColor,
                                          fontFamily: Config.manropeBold,
                                          fontSize: Dimens.space14.sp,
                                          fontWeight: FontWeight.normal,
                                          wordSpacing: Dimens.space0.w,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  widget.animationController!.forward();
                                  return MemberListItemView(
                                    isOnCall: true,
                                    onTransfer: () async {
                                      if (memberProvider
                                                  ?.memberEdges
                                                  ?.data![index]
                                                  .members
                                                  ?.onCall ==
                                              false ||
                                          memberProvider!.getMemberId() ==
                                              memberProvider?.memberEdges
                                                  ?.data![index].members?.id ||
                                          !memberProvider!.memberEdges!
                                              .data![index].members!.online!) {
                                        Utils.showToastMessage(
                                            "You cannot transfer in this number");
                                      } else {
                                        final returnData =
                                            await showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.space16.r),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder:
                                                    (BuildContext context) {
                                                  return ConfirmTransferCallDialog(
                                                    userName:
                                                        "${memberProvider!.memberEdges!.data![index].members!.firstName} ${memberProvider!.memberEdges!.data![index].members!.lastName}",
                                                    onTap: () {
                                                      widget.callTransferProvider!.callTransfer(
                                                          direction:
                                                              widget.direction,
                                                          destination:
                                                              memberProvider!
                                                                  .memberEdges!
                                                                  .data![index]
                                                                  .members!
                                                                  .id,
                                                          callerId:
                                                              widget.callerId,
                                                          conversationId: Provider.of<
                                                                          DashboardProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .conversationId,
                                                          conversationSid: Provider.of<
                                                                          DashboardProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .conversationSid);
                                                    },
                                                  );
                                                });

                                        if (returnData != null &&
                                            returnData["data"] is bool &&
                                            returnData["data"] as bool) {
                                          widget.direction!.toUpperCase() ==
                                                  "INCOMING"
                                              ? DashboardView.incomingEvent
                                                  .fire({
                                                  "incomingEvent":
                                                      "incomingTransfer",
                                                  "isTransfer": true,
                                                  "state": "Transferring"
                                                })
                                              : DashboardView.outgoingEvent
                                                  .fire({
                                                  "outgoingEvent":
                                                      "incomingTransfer",
                                                  "isTransfer": true,
                                                  "state": "Transferring"
                                                });
                                          Provider.of<DashboardProvider>(
                                                  context,
                                                  listen: false)
                                              .isTransfer = true;
                                          Utils.showToastMessage(
                                              Utils.getString("transferCall"));
                                          Navigator.of(context)
                                              .pop({"transferCall": true});
                                        }
                                      }
                                    },
                                    memberId: userId!,
                                    memberEdges: memberProvider!
                                        .memberEdges!.data![index],
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: widget.animationController!,
                                        curve: Interval(
                                            (1 /
                                                    memberProvider!.memberEdges!
                                                        .data!.length) *
                                                index,
                                            1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    animationController:
                                        widget.animationController!,
                                  );
                                },
                                physics: const AlwaysScrollableScrollPhysics(),
                                indexBarData:
                                    SuspensionUtil.getTagIndexList(null),
                                indexBarMargin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                indexBarOptions: const IndexBarOptions(
                                  needRebuild: true,
                                  indexHintAlignment: Alignment.centerRight,
                                ),
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Container(
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
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                child: EmptyViewUiWidget(
                                  assetUrl: "assets/images/empty_member.png",
                                  title: Utils.getString("noMembers"),
                                  desc: Utils.getString("makeAConversation"),
                                  buttonTitle: Utils.getString("inviteMembers"),
                                  icon: Icons.add_circle_outline,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                } else {
                  widget.animationController!.forward();
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController!,
                              curve: const Interval(0.5 * 1, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  return AnimatedBuilder(
                    animation: widget.animationController!,
                    builder: (BuildContext context, Widget? child) {
                      return FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 100 * (1.0 - animation.value), 0.0),
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.zero,
                            child: SpinKitCircle(
                              color: CustomColors.mainColor,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
