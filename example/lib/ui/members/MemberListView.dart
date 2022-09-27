import "dart:async";

import "package:azlistview/azlistview.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:graphql/client.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoInternetWidget.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/shimmer/CallLogShimmer.dart";
import "package:mvp/ui/common/shimmer/contactShimmer.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/members/MemberListItemView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MemberMessageDetailIntentHolder.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
import "package:mvp/viewObject/model/members/MemberStatus.dart";
import "package:provider/provider.dart";

class MemberListView extends StatefulWidget {
  const MemberListView({
    Key? key,
    required this.animationController,
    required this.onLeadingTap,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final AnimationController animationController;
  final Function onLeadingTap;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  _MemberListView createState() => _MemberListView();
}

class _MemberListView extends State<MemberListView>
    with TickerProviderStateMixin {
  MemberRepository? memberRepository;
  MemberProvider? memberProvider;

  ValueHolder? valueHolder;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  ButtonState internetState = ButtonState.idle;

  final TextEditingController controllerSearchMember = TextEditingController();

  StreamSubscription? streamSubscriptionOnWorkspaceOrChannelChanged;
  Stream<QueryResult>? streamUpdateMemberOnline;
  StreamSubscription? streamSubscriptionUpdateMemberOnline;
  Stream<QueryResult>? streamSubscriptionUpdateMemberChatDetail;
  StreamSubscription? streamSubscriptionOnNetworkChanged;

  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;
  final _debounce = DeBouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    checkConnection();

    widget.animationController.forward();

    memberRepository = Provider.of<MemberRepository>(context, listen: false);
    memberProvider = MemberProvider(memberRepository: memberRepository);

    streamSubscriptionOnWorkspaceOrChannelChanged = DashboardView
        .workspaceOrChannelChanged
        .on<SubscriptionWorkspaceOrChannelChanged>()
        .listen((event) {
      memberProvider?.doEmptyMemberOnChannelChanged();
      memberProvider
          ?.doGetAllWorkspaceMembersApiCall(memberProvider!.getMemberId());
      doSubscriptionUpdateOnline();
      doSubscriptionUpdateChat();
    });

    doSubscriptionUpdateOnline();
    doSubscriptionUpdateChat();
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      if (onValue) {
        internetConnectionStatus = InternetConnectionStatus.connected;
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
      }
      setState(() {});
    });

    streamSubscriptionOnNetworkChanged = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      if (status != InternetConnectionStatus.disconnected &&
          internetConnectionStatus == InternetConnectionStatus.disconnected) {
        internetConnectionStatus = InternetConnectionStatus.connected;
        doSubscriptionUpdateOnline();
        doSubscriptionUpdateChat();
        setState(() {});
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    try {
      streamSubscriptionOnWorkspaceOrChannelChanged?.cancel();
      streamSubscriptionUpdateMemberChatDetail?.cast();
      streamSubscriptionOnNetworkChanged?.cancel();
      streamSubscriptionUpdateMemberOnline?.cancel();
      Utils.cPrint("member list dispose");
    } catch (e) {
      Utils.cPrint(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.white,
      body: CustomAppBar<MemberProvider>(
        elevation: 0.8,
        centerTitle: true,
        titleWidget: PreferredSize(
          preferredSize:
              Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("members"),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: CustomColors.textPrimaryColor,
                    fontFamily: Config.manropeBold,
                    fontSize: Dimens.space16.sp,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
        ),
        leadingWidget: TextButton(
          onPressed: () {
            widget.onLeadingTap();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Icon(
              Icons.menu,
              color: CustomColors.textSecondaryColor,
              size: Dimens.space24.w,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Icon(
                    Icons.menu,
                    color: CustomColors.transparent,
                    size: Dimens.space24.w,
                  ),
                ),
              ],
            ),
          ),
        ],
        onIncomingTap: () {
          widget.onIncomingTap();
        },
        onOutgoingTap: () {
          widget.onOutgoingTap();
        },
        initProvider: () {
          return MemberProvider(memberRepository: memberRepository);
        },
        onProviderReady: (MemberProvider provider) {
          memberProvider = provider;
          controllerSearchMember.addListener(() {
            _debounce.run(() {
              if (controllerSearchMember.text.isNotEmpty &&
                  controllerSearchMember.text != "") {
                memberProvider?.doSearchMemberFromDb(
                    memberProvider!.getMemberId(), controllerSearchMember.text);
              } else {
                memberProvider
                    ?.getAllMembersFromDb(memberProvider!.getMemberId());
              }
            });
          });
          memberProvider
              ?.doGetAllWorkspaceMembersApiCall(memberProvider!.getMemberId());
        },
        builder:
            (BuildContext? context, MemberProvider? provider, Widget? child) {
          if (memberProvider?.memberEdges != null &&
              memberProvider?.memberEdges?.data != null) {
            if (memberProvider?.memberEdges != null &&
                memberProvider?.memberEdges?.data != null) {
              int onlineLength = 0;
              int offlineLength = 0;
              for (int i = 0;
                  i < memberProvider!.memberEdges!.data!.length;
                  i++) {
                if (memberProvider?.memberEdges?.data != null &&
                    memberProvider!.memberEdges!.data!.isNotEmpty &&
                    memberProvider?.memberEdges?.data?[i].members?.online !=
                        null &&
                    memberProvider?.memberEdges?.data?[i].members?.online ==
                        true) {
                  onlineLength++;
                } else {
                  offlineLength++;
                }
              }
              for (int i = 0;
                  i < memberProvider!.memberEdges!.data!.length;
                  i++) {
                String pinyin = "";
                if (memberProvider?.memberEdges?.data != null &&
                    memberProvider!.memberEdges!.data!.isNotEmpty &&
                    memberProvider?.memberEdges?.data?[i].members?.online !=
                        null &&
                    memberProvider?.memberEdges?.data?[i].members?.online ==
                        true) {
                  pinyin =
                      "${Utils.getString("online").toUpperCase()}-$onlineLength";
                } else {
                  pinyin =
                      "${Utils.getString("offline").toUpperCase()}-$offlineLength";
                }
                memberProvider?.memberEdges?.data?[i].namePinyin = pinyin;
                if (RegExp("[A-Z]").hasMatch(pinyin)) {
                  memberProvider?.memberEdges?.data?[i].tagIndex = pinyin;
                } else {
                  memberProvider?.memberEdges?.data?[i].tagIndex =
                      Utils.getString("offline");
                }
              }

              memberProvider?.memberEdges?.data?.sort((b, a) {
                if (a.getSuspensionTag() == "@" ||
                    b.getSuspensionTag() == "#") {
                  return -1;
                } else if (a.getSuspensionTag() == "#" ||
                    b.getSuspensionTag() == "@") {
                  return 1;
                } else {
                  return a.getSuspensionTag().compareTo(b.getSuspensionTag());
                }
              });

              SuspensionUtil.setShowSuspensionStatus(
                  memberProvider?.memberEdges?.data);
            }
            // if (isConnectedToInternet)
            // {
            internetState = ButtonState.idle;
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
                  Dimens.space0.h,
                ),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space20.h, Dimens.space16.w, Dimens.space20.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.center,
                      height: Dimens.space52.h,
                      child: TextField(
                        controller: controllerSearchMember,
                        style: Theme.of(context!).textTheme.bodyText1!.copyWith(
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
                          hintStyle:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
                                  width: MediaQuery.of(context).size.width.sw,
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space20.w,
                                      Dimens.space5.h,
                                      Dimens.space20.w,
                                      Dimens.space5.h),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : memberProvider?.memberEdges?.data?[i]
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
                              widget.animationController.forward();
                              return MemberListItemView(
                                isFromMember: true,
                                memberId: memberProvider!.getMemberId(),
                                onTab: () async {
                                  final dynamic returnData =
                                      await Navigator.pushNamed(
                                    context,
                                    RoutePaths.memberMessageDetail,
                                    arguments: MemberMessageDetailIntentHolder(
                                        onlineStatus: memberProvider!
                                            .memberEdges!
                                            .data![index].members!
                                            .online!,
                                        clientName: memberProvider
                                                ?.memberEdges
                                                ?.data?[index]
                                                .members
                                                ?.fullName ??
                                            Utils.getString("unknown"),
                                        clientProfilePicture: memberProvider
                                                ?.memberEdges
                                                ?.data?[index]
                                                .members
                                                ?.profilePicture ??
                                            "",
                                        clientEmail: memberProvider!
                                            .memberEdges!
                                            .data![index]
                                            .members!
                                            .email!,
                                        clientId: memberProvider!.memberEdges!
                                            .data![index].members!.id!,
                                        onOutgoingTap: () {
                                          widget.onOutgoingTap();
                                        },
                                        onIncomingTap: () {
                                          widget.onIncomingTap();
                                        }),
                                  );
                                  if (returnData["data"] != null) {
                                    memberProvider
                                        ?.doGetAllWorkspaceMembersApiCall(
                                            memberProvider!.getMemberId());
                                    memberProvider?.doEditMemberChatSeenApiCall(
                                        memberProvider!.getMemberId(),
                                        memberProvider!.memberEdges!
                                            .data![index].members!.id!);
                                  }
                                },
                                memberEdges:
                                    memberProvider!.memberEdges!.data![index],
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: widget.animationController,
                                    curve: Interval(
                                      (1 /
                                              memberProvider!
                                                  .memberEdges!.data!.length) *
                                          index,
                                      1.0,
                                      curve: Curves.fastOutSlowIn,
                                    ),
                                  ),
                                ),
                                animationController: widget.animationController,
                              );
                            },
                            physics: const AlwaysScrollableScrollPhysics(),
                            indexBarData: SuspensionUtil.getTagIndexList(null),
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
                return memberProvider!.doGetAllWorkspaceMembersApiCall(
                    memberProvider!.getMemberId());
              },
            );
          } else {
            return Column(
              children: [
                const ContactSearchShimmer(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return index == 0 || index == 5
                          ? const ContactBarShimmer()
                          : const CallLogShimmer();
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> doSubscriptionUpdateOnline() async {
    Utils.cPrint("this is member online");
    streamUpdateMemberOnline =
        await memberProvider?.doSubscriptionOnlineMemberStatus(
      memberProvider!.getWorkspaceDetail().id!,
      memberProvider!.getMemberId(),
    );
    Utils.cPrint("this is member online1 $streamUpdateMemberOnline");

    if (streamUpdateMemberOnline != null) {
      streamSubscriptionUpdateMemberOnline =
          streamUpdateMemberOnline?.listen((event) async {
        if (event.data != null) {
          final MemberStatus memberStatus = MemberStatus()
              .fromMap(event.data?["onlineMemberStatus"]["message"])!;
          memberProvider?.updateSubscriptionMemberOnline(
              memberStatus,
              memberProvider!.getWorkspaceDetail().id!,
              memberProvider!.getMemberId());
        }
      });
    }
  }

  Future<void> doSubscriptionUpdateChat() async {
    streamSubscriptionUpdateMemberChatDetail =
        await memberProvider?.doSubscriptionWorkspaceChatDetail();
    if (streamSubscriptionUpdateMemberChatDetail != null) {
      streamSubscriptionUpdateMemberChatDetail?.listen((event) async {
        if (event.data != null) {
          final RecentConversationMemberNodes recentConversationMemberNodes =
              RecentConversationMemberNodes()
                  .fromMap(event.data?["workspaceChat"]["message"])!;
          memberProvider?.updateSubscriptionMemberChatDetail(
              memberProvider!.getMemberId(), recentConversationMemberNodes);
        }
      });
    }
  }
}
