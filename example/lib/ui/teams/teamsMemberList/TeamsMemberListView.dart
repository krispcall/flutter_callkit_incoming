import "dart:async";

import "package:azlistview/azlistview.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/team/TeamProvider.dart";
import "package:mvp/repository/TeamsRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/TeamsMemberAddDialog.dart";
import "package:mvp/ui/common/shimmer/contactShimmer.dart";
import "package:mvp/ui/members/MemberListItemView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/updateTeamsMemberList/UpdateTeamResponse.dart";
import "package:provider/provider.dart";

class TeamsMemberListView extends StatefulWidget {
  const TeamsMemberListView({
    Key? key,
    required this.teamId,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final String teamId;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  TeamsMemberListViewState createState() => TeamsMemberListViewState();
}

class TeamsMemberListViewState extends State<TeamsMemberListView>
    with TickerProviderStateMixin {
  TeamProvider? teamProvider;
  TeamRepository? teamRepository;

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
    streamSubscriptionOnNetworkChanged!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    teamRepository = Provider.of<TeamRepository>(context, listen: false);
    animationController =
        AnimationController(vsync: this, duration: Config.animation_duration);
    animationController!.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    streamSubscriptionOnNetworkChanged =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            setState(() {
              isConnectedToInternet = true;
            });
            teamProvider!.doGetAllTeamsMemberApiCall(widget.teamId);

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
    animationController!.reverse().then<dynamic>(
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
      body: CustomAppBar<TeamProvider>(
        elevation: 1,
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
                      : Utils.getString("teamList"),
                  textAlign: TextAlign.center,
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
              Expanded(
                child: teamRepository!.getAllowTeamEdit()
                    ? Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space0.w,
                          Dimens.space0.h,
                        ),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h,
                          ),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          width: Dimens.space60.w,
                          child: TextButton(
                            onPressed: showAddMemberDialog,
                            style: TextButton.styleFrom(
                              alignment: Alignment.center,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space10.w,
                                  Dimens.space0.h,
                                  Dimens.space10.w,
                                  Dimens.space0.h),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h,
                              ),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: RoundedNetworkImageHolder(
                                width: Dimens.space20,
                                height: Dimens.space20,
                                iconUrl: CustomIcon.icon_plus_rounded,
                                iconColor: CustomColors.loadingCircleColor,
                                iconSize: Dimens.space18,
                                outerCorner: Dimens.space10,
                                innerCorner: Dimens.space10,
                                boxDecorationColor: CustomColors.transparent,
                                imageUrl: "",
                                onTap: showAddMemberDialog,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        leadingWidget: null,
        onIncomingTap: () {
          widget.onIncomingTap();
        },
        onOutgoingTap: () {
          widget.onOutgoingTap();
        },
        initProvider: () {
          teamProvider = TeamProvider(teamRepository: teamRepository);
          return teamProvider;
        },
        onProviderReady: (TeamProvider provider) {
          controllerSearchMember.addListener(() {
            _debounce.run(() {
              if (controllerSearchMember.text.isNotEmpty &&
                  controllerSearchMember.text != "") {
                teamProvider!
                    .doSearchTeamsMemberFromDb(controllerSearchMember.text);
              } else {
                teamProvider!.doGetAllTeamsMemberApiCall(widget.teamId);
              }
            });
          });
          teamProvider!.doGetAllTeamsMemberApiCall(widget.teamId);
        },
        builder: (BuildContext? context, TeamProvider ?provider, Widget? child) {
          if (teamProvider!.memberEdges != null &&
              teamProvider!.memberEdges!.data != null) {
            if (teamProvider!.memberEdges != null &&
                teamProvider!.memberEdges!.data != null) {
              int onlineLength = 0;
              int offlineLength = 0;
              for (int i = 0, length = teamProvider!.memberEdges!.data!.length;
                  i < length;
                  i++) {
                if (teamProvider!.memberEdges!.data != null &&
                    teamProvider!.memberEdges!.data!.isNotEmpty &&
                    teamProvider!.memberEdges!.data![i].members!.online != null &&
                    teamProvider!.memberEdges!.data![i].members!.online == true) {
                  onlineLength++;
                } else {
                  offlineLength++;
                }
              }
              for (int i = 0, length = teamProvider!.memberEdges!.data!.length;
                  i < length;
                  i++) {
                String pinyin = "";
                if (teamProvider!.memberEdges!.data != null &&
                    teamProvider!.memberEdges!.data!.isNotEmpty &&
                    teamProvider!.memberEdges!.data![i].members!.online != null &&
                    teamProvider!.memberEdges!.data![i].members!.online == true) {
                  pinyin =
                      "${Utils.getString("online").toUpperCase()}-$onlineLength";
                } else {
                  pinyin =
                      "${Utils.getString("offline").toUpperCase()}-$offlineLength";
                }
                teamProvider!.memberEdges!.data![i].namePinyin = pinyin;
                if (RegExp("[A-Z]").hasMatch(pinyin)) {
                  teamProvider!.memberEdges!.data![i].tagIndex = pinyin;
                } else {
                  teamProvider!.memberEdges!.data![i].tagIndex =
                      Utils.getString("offline");
                }
              }
              // A-Z sort.
              // SuspensionUtil.sortListBySuspensionTag(memberProvider.memberEdges.data);
              teamProvider!.memberEdges!.data!.sort((b, a) {
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
              // show sus tag.
              SuspensionUtil.setShowSuspensionStatus(
                  teamProvider!.memberEdges!.data);
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
                child: teamProvider!.memberEdges!.data != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controllerSearchMember.text.isNotEmpty ||
                              teamProvider!.memberEdges!.data!.isNotEmpty)
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
                                style: Theme.of(context!)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
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
                            )
                          else
                            Container(),
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
                              child: teamProvider!.memberEdges!.data!.isNotEmpty
                                  ? AzListView(
                                      data: teamProvider!.memberEdges!.data!,
                                      itemCount:
                                          teamProvider!.memberEdges!.data!.length,
                                      susItemBuilder: (context, i) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width
                                              .sw,
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          decoration: BoxDecoration(
                                            color:
                                                CustomColors.mainDividerColor,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width
                                                .sw,
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space20.w,
                                                Dimens.space9.h,
                                                Dimens.space20.w,
                                                Dimens.space9.h),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              Config.checkOverFlow
                                                  ? Const.OVERFLOW
                                                  : teamProvider
                                                          ?.memberEdges?.data![i]
                                                          .getSuspensionTag() ??
                                                      "",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: CustomColors
                                                    .textTertiaryColor,
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        animationController!.forward();
                                        return MemberListItemView(
                                          memberEdges: teamProvider!
                                              .memberEdges!.data![index],
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: animationController!,
                                              curve: Interval(
                                                  (1 /
                                                          teamProvider!
                                                              .memberEdges!
                                                              .data!
                                                              .length) *
                                                      index,
                                                  1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          memberId: teamProvider!.getMemberId(),
                                          animationController:
                                              animationController!,
                                          onTab: () {},
                                          onTransfer: () {},
                                        );
                                      },
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      indexBarData:
                                          SuspensionUtil.getTagIndexList(null),
                                      indexBarMargin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      indexBarOptions: const IndexBarOptions(
                                        needRebuild: true,
                                        indexHintAlignment:
                                            Alignment.centerRight,
                                      ),
                                    )
                                  : teamProvider!.memberEdges!.data!.isEmpty &&
                                          controllerSearchMember.text.isNotEmpty
                                      ? Container(
                                          alignment: Alignment.center,
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
                                          child: const SingleChildScrollView(
                                            child: Center(
                                              child:
                                                  NoSearchResultsFoundWidget(),
                                            ),
                                          ),
                                        )
                                      : Container(),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
              onRefresh: () {
                return teamProvider!.doGetAllTeamsMemberApiCall(widget.teamId);
              },
            );
          } else {
            animationController!.forward();
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

  Future<void> showAddMemberDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return TeamsMemberAddDialog(
          animationController: animationController!,
          onMemberTap: (value) {
            Navigator.of(context).pop();
            teamsAddMemberApiCall(value);
          },
        );
      },
    );
  }

  Future<void> teamsAddMemberApiCall(String memberId) async {
    await PsProgressDialog.showDialog(context);
    final List<String> members = [];
    for (final element in teamProvider!.memberEdges!.data!) {
      members.add(element.members!.id!);
    }
    members.add(memberId);

    final Resources<UpdateTeamResponse> resources =
        await teamProvider!.doUpdateTeamsMemberApiCall(widget.teamId, members)
            as Resources<UpdateTeamResponse>;
    if (resources.status == Status.SUCCESS &&
        resources.data != null) {
      await PsProgressDialog.dismissDialog();
      teamProvider!.doGetAllTeamsMemberApiCall(widget.teamId);
    }
  }
}
