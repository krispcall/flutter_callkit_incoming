import "dart:async";

import "package:azlistview/azlistview.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/shimmer/contactShimmer.dart";
import "package:mvp/ui/members/MemberListItemView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:provider/provider.dart";

class NavigationMemberListView extends StatefulWidget {
  const NavigationMemberListView({
    Key? key,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  NavigationMemberListViewState createState() =>
      NavigationMemberListViewState();
}

class NavigationMemberListViewState extends State<NavigationMemberListView>
    with TickerProviderStateMixin {
  MemberProvider? memberProvider;
  MemberRepository? memberRepository;

  ValueHolder? valueHolder;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  final ScrollController _scrollController = ScrollController();
  AnimationController? animationController;

  bool isCheckBoxVisible = true;
  bool selectAllCheck = false;
  int selectedIndex = 0;
  List<String> toDeleteList = [];

  final TextEditingController controllerSearchMember = TextEditingController();
  Animation<double>? animation;
  final _debounce = DeBouncer(milliseconds: 500);
  StreamSubscription? streamSubscriptionOnNetworkChanged;

  @override
  void dispose() {
    streamSubscriptionOnNetworkChanged?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    memberRepository = Provider.of<MemberRepository>(context, listen: false);
    animationController =
        AnimationController(vsync: this, duration: Config.animation_duration);
    animationController?.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // messagesProvider.nextMessagesList();
      }
    });

    streamSubscriptionOnNetworkChanged =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            setState(() {
              isConnectedToInternet = true;
            });
            memberProvider?.doGetAllWorkspaceMembersApiCall(
                memberProvider!.getMemberId());

            break;
          case InternetConnectionStatus.disconnected:
            setState(() {
              isConnectedToInternet = false;
            });
            break;
        }
      },
    );
    super.initState();
  }

  Future<bool> _requestPop() {
    CustomAppBar.changeStatusColor(CustomColors.mainColor!);
    animationController?.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context);
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: CustomAppBar<MemberProvider>(
        elevation: 0.8,
        centerTitle: true,
        titleWidget: PreferredSize(
          preferredSize:
              Size(MediaQuery.of(context).size.width.w, kToolbarHeight.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: CustomColors.white,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: TextButton(
                    onPressed: _requestPop,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: CustomColors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CustomIcon.icon_arrow_left,
                          color: CustomColors.loadingCircleColor,
                          size: Dimens.space22.w,
                        ),
                        Expanded(
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("back"),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.loadingCircleColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("members"),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeBold,
                        fontSize: Dimens.space16.sp,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
        leadingWidget: null,
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
          memberProvider = MemberProvider(memberRepository: memberRepository);
          return memberProvider;
        },
        onProviderReady: (MemberProvider provider) {
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
              for (int i = 0;
                  i < memberProvider!.memberEdges!.data!.length;
                  i++) {
                if (memberProvider?.memberEdges?.data?[i].members?.role
                        ?.toLowerCase() ==
                    "owner") {
                  final String pinyin = "a ${Utils.getString("owner")}";
                  memberProvider?.memberEdges?.data?[i].namePinyin = pinyin;
                  memberProvider?.memberEdges?.data?[i].tagIndex = pinyin;
                } else if (memberProvider?.memberEdges?.data?[i].members?.role
                        ?.toLowerCase() ==
                    "admin") {
                  final String pinyin = "b ${Utils.getString("admins")}";
                  memberProvider?.memberEdges?.data?[i].namePinyin = pinyin;
                  memberProvider?.memberEdges?.data?[i].tagIndex = pinyin;
                } else {
                  final String pinyin = "c ${Utils.getString("members")}";
                  memberProvider?.memberEdges?.data?[i].namePinyin = pinyin;
                  memberProvider?.memberEdges?.data?[i].tagIndex = pinyin;
                }
              }
              // A-Z sort.
              SuspensionUtil.sortListBySuspensionTag(
                  memberProvider?.memberEdges?.data);

              // show sus tag.
              SuspensionUtil.setShowSuspensionStatus(
                  memberProvider?.memberEdges?.data);
            }
            return RefreshIndicator(
              color: CustomColors.mainColor,
              backgroundColor: CustomColors.white,
              child: Container(
                color: CustomColors.white,
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            Dimens.space0.h,
                          ),
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
                                                .getSuspensionTag()
                                                .split(" ")[1] ??
                                            "",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
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
                              animationController?.forward();
                              return MemberListItemView(
                                memberEdges:
                                    memberProvider!.memberEdges!.data![index],
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval(
                                        (1 /
                                                memberProvider!.memberEdges!
                                                    .data!.length) *
                                            index,
                                        1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                memberId: memberProvider!.getMemberId(),
                                animationController: animationController!,
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
            animationController?.forward();
            return Column(
              children: [
                const ContactSearchShimmer(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return index == 0 || index == 5
                          ? const ContactBarShimmer()
                          : const ContactShimmer();
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
}
