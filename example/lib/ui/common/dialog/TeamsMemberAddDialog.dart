import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoInternetWidget.dart";
import "package:mvp/ui/members/MemberListItemView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:provider/provider.dart";

class TeamsMemberAddDialog extends StatefulWidget {
  const TeamsMemberAddDialog({
    Key? key,
    required this.onMemberTap,
    required this.animationController,
  }) : super(key: key);

  final Function(String) onMemberTap;
  final AnimationController animationController;

  @override
  TeamsMemberAddDialogState createState() => TeamsMemberAddDialogState();
}

class TeamsMemberAddDialogState extends State<TeamsMemberAddDialog> {
  bool isConnectedToInternet = true;
  bool isSuccessfullyLoaded = true;

  MemberProvider? memberProvider;
  MemberRepository? memberRepository;
  String? userId;

  final TextEditingController controllerSearchMember = TextEditingController();

  final _debounce = DeBouncer(milliseconds: 500);
  ButtonState internetState = ButtonState.idle;

  StreamSubscription? streamSubscriptionOnNetworkChanged;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      setState(() {
        isConnectedToInternet = onValue;
      });
    });

    streamSubscriptionOnNetworkChanged =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            setState(() {
              isConnectedToInternet = true;
            });
            break;
          case InternetConnectionStatus.disconnected:
            setState(() {
              isConnectedToInternet = false;
            });
            break;
        }
      },
    );
  }

  ValueHolder? valueHolder;

  @override
  void initState() {
    checkConnection();

    memberRepository = Provider.of<MemberRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    streamSubscriptionOnNetworkChanged!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.space16.r),
        topRight: Radius.circular(Dimens.space16.r),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height.h * 0.9,
        width: MediaQuery.of(context).size.width.w,
        alignment: Alignment.center,
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
        child: Scaffold(
          backgroundColor: CustomColors.transparent,
          resizeToAvoidBottomInset: true,
          body: isConnectedToInternet
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ChangeNotifierProvider<MemberProvider>(
                        lazy: false,
                        create: (BuildContext context) {
                          memberProvider = MemberProvider(
                              memberRepository: memberRepository);
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
                                memberProvider!.getAllMembersFromDb(
                                    memberProvider!.getMemberId());
                              }
                            });
                          });
                          return memberProvider!;
                        },
                        child: Consumer<MemberProvider>(
                          builder: (BuildContext context,
                              MemberProvider? provider, Widget? child) {
                            if (memberProvider!.memberEdges != null &&
                                memberProvider!.memberEdges!.data != null) {
                              return RefreshIndicator(
                                color: CustomColors.mainColor,
                                backgroundColor: CustomColors.white,
                                child: Container(
                                  color: CustomColors.white,
                                  alignment: Alignment.topCenter,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                color: CustomColors
                                                    .textSenaryColor,
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
                                              Dimens.space0.h,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CustomColors
                                                    .callInactiveColor!,
                                                width: Dimens.space1.w,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimens.space10.r),
                                              ),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CustomColors
                                                    .callInactiveColor!,
                                                width: Dimens.space1.w,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimens.space10.r),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CustomColors
                                                    .callInactiveColor!,
                                                width: Dimens.space1.w,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimens.space10.r),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CustomColors
                                                    .callInactiveColor!,
                                                width: Dimens.space1.w,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimens.space10.r),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CustomColors
                                                    .callInactiveColor!,
                                                width: Dimens.space1.w,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimens.space10.r),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: CustomColors
                                                    .callInactiveColor!,
                                                width: Dimens.space1.w,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimens.space10.r),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor:
                                                CustomColors.baseLightColor,
                                            prefixIconConstraints:
                                                BoxConstraints(
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
                                                color: CustomColors
                                                    .textTertiaryColor,
                                              ),
                                            ),
                                            hintText: Utils.getString(
                                                "searchMembers"),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  color: CustomColors
                                                      .textTertiaryColor,
                                                  fontFamily:
                                                      Config.heeboRegular,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: Dimens.space16.sp,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: CustomColors.mainDividerColor,
                                        height: Dimens.space1.h,
                                        thickness: Dimens.space1.h,
                                      ),
                                      if (memberProvider
                                          !.memberEdges!.data!.isNotEmpty)
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
                                            alignment: Alignment.topCenter,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              itemCount: memberProvider
                                                  !.memberEdges!.data!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                widget.animationController
                                                    .forward();
                                                return Column(
                                                  children: [
                                                    MemberListItemView(
                                                      memberId: userId!,
                                                      onTab: () {
                                                        widget.onMemberTap(
                                                            memberProvider!
                                                                .memberEdges!
                                                                .data![index]
                                                                .members!
                                                                .id!);
                                                      },
                                                      memberEdges:
                                                          memberProvider!
                                                              .memberEdges!
                                                              .data![index],
                                                      animation: Tween<double>(
                                                              begin: 0.0,
                                                              end: 1.0)
                                                          .animate(
                                                        CurvedAnimation(
                                                          parent: widget
                                                              .animationController,
                                                          curve: Interval(
                                                              (1 /
                                                                      memberProvider!
                                                                          .memberEdges!
                                                                          .data!
                                                                          .length) *
                                                                  index,
                                                              1.0,
                                                              curve: Curves
                                                                  .fastOutSlowIn),
                                                        ),
                                                      ),
                                                      animationController: widget
                                                          .animationController,
                                                    ),
                                                    Divider(
                                                      color: CustomColors
                                                          .mainDividerColor,
                                                      height: Dimens.space1.h,
                                                      thickness:
                                                          Dimens.space1.h,
                                                    ),
                                                  ],
                                                );
                                              },
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
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
                                                assetUrl:
                                                    "assets/images/empty_member.png",
                                                title: Utils.getString(
                                                    "noMembers"),
                                                desc: Utils.getString(
                                                    "makeAConversation"),
                                                buttonTitle: Utils.getString(
                                                    "inviteMembers"),
                                                icon: Icons.add_circle_outline,
                                                showButton: false,
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                onRefresh: () {
                                  return memberProvider!
                                      .doGetAllWorkspaceMembersApiCall(
                                          memberProvider!.getMemberId());
                                },
                              );
                            } else {
                              widget.animationController.forward();
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: widget.animationController,
                                  curve: const Interval(
                                    0.5 * 1,
                                    1.0,
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                ),
                              );
                              return AnimatedBuilder(
                                animation: widget.animationController,
                                builder: (BuildContext context, Widget? child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: Transform(
                                      transform: Matrix4.translationValues(0.0,
                                          100 * (1.0 - animation.value), 0.0),
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
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: NoInternetWidget(
                        state: internetState,
                        onPressed: onPressedNoInternetButton,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void onPressedNoInternetButton() {
    setState(() {
      switch (internetState) {
        case ButtonState.idle:
          checkConnection();
          if (isConnectedToInternet) {
            internetState = ButtonState.loading;
            memberProvider!
                .doGetAllWorkspaceMembersApiCall(memberProvider!.getMemberId());
          } else {
            Utils.showWarningToastMessage(
                Utils.getString("noInternet"), context);
          }
          break;
        case ButtonState.loading:
          internetState = ButtonState.idle;
          break;
      }
    });
  }
}
