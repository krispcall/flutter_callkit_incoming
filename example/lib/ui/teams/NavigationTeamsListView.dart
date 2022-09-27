/*
 * *
 *  * Created by Kedar on 7/12/21 12:51 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/12/21 12:51 PM
 *
 */
import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/team/TeamProvider.dart";
import "package:mvp/repository/TeamsRepository.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/shimmer/TeamShimmer.dart";
import "package:mvp/ui/common/shimmer/contactShimmer.dart";
import "package:mvp/ui/teams/TeamVerticalListItem.dart";
import "package:mvp/utils/ColorHolder.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/intent_holder/TeamListIntentHolder.dart";
import "package:provider/provider.dart";

class NavigationTeamListView extends StatefulWidget {
  const NavigationTeamListView({
    Key? key,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  NavigationTeamListViewState createState() => NavigationTeamListViewState();
}

class NavigationTeamListViewState extends State<NavigationTeamListView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  TextEditingController? controllerSearchTeams = TextEditingController();
  TeamRepository? teamRepository;
  TeamProvider? teamProvider;
  ColorHolder? selectedColor;
  List<String>? selectedTags = [];
  String? clientId = "";
  bool? isConnectedInternet = true;
  final _debounce = DeBouncer(milliseconds: 500);

  StreamSubscription? streamSubscriptionOnNetworkChanged;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    teamRepository = Provider.of<TeamRepository>(context, listen: false);

    Utils.checkInternetConnectivity().then((bool onValue) {
      setState(() {
        isConnectedInternet = onValue;
      });
    });

    streamSubscriptionOnNetworkChanged =
        InternetConnectionChecker().onStatusChange.listen(
              (InternetConnectionStatus status) {
            switch (status) {
              case InternetConnectionStatus.connected:
                setState(() {
                  isConnectedInternet = true;
                });
                teamProvider!.doGetTeamsListApiCall();
                break;
              case InternetConnectionStatus.disconnected:
                setState(() {
                  isConnectedInternet = false;
                });
                break;
            }
          },
        );
    super.initState();

  }

  @override
  void dispose() {
    animationController!.dispose();
    streamSubscriptionOnNetworkChanged!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      CustomAppBar.changeStatusColor(CustomColors.mainColor!);
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, clientId);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomAppBar<TeamProvider>(
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
                    margin: EdgeInsets.fromLTRB(Dimens.space8.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
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
                        : Utils.getString("teams"),
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
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  ),
                ),
              ],
            ),
          ),
          leadingWidget: null,
          elevation: 1,
          onIncomingTap: () {
            widget.onIncomingTap();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap();
          },
          initProvider: () {
            return TeamProvider(teamRepository: teamRepository);
          },
          onProviderReady: (TeamProvider provider) async {
            teamProvider = provider;
            teamProvider!.doGetTeamsListApiCall();
            controllerSearchTeams!.addListener(() {
              _debounce.run(() {
                if (controllerSearchTeams!.text.isNotEmpty) {
                  teamProvider!.doDbTeamsSearch(controllerSearchTeams!.text);
                } else {
                  teamProvider!.doGetTeamsListApiCall();
                }
              });
            });
          },
          builder: (BuildContext? context, TeamProvider? provider, Widget? child) {
            animationController!.forward();
            return RefreshIndicator(
              color: CustomColors.mainColor,
              backgroundColor: CustomColors.white,
              child: teamProvider!.teams != null &&
                      teamProvider!.teams!.data != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controllerSearchTeams!.text.isNotEmpty ||
                            teamProvider!.teams!.data!.isNotEmpty)
                          Container(
                            color: Colors.white,
                            alignment: Alignment.center,
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
                            child: CustomSearchFieldWidgetWithIcon(
                              animationController: animationController,
                              textEditingController: controllerSearchTeams,
                              customIcon: CustomIcon.icon_search,
                              hint: Utils.getString("searchTeams"),
                            ),
                          )
                        else
                          Container(),
                        Expanded(
                          child: Container(
                            color: Colors.white,
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
                            child: teamProvider!.teams!.data!.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: provider!.teams!.data!.length,
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return TeamVerticalListItem(
                                        animationController:
                                            animationController!,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: animationController!,
                                            curve: const Interval(0.5 * 1, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        team: teamProvider!.teams!.data![index],
                                        onPressed: () async {
                                          await Navigator.pushNamed(
                                            context,
                                            RoutePaths.teamsMemberList,
                                            arguments: TeamListIntentHolder(
                                              teamId: teamProvider!
                                                  .teams!.data![index].id!,
                                              onIncomingTap: () {
                                                widget.onIncomingTap();
                                              },
                                              onOutgoingTap: () {
                                                widget.onOutgoingTap();
                                              },
                                            ),
                                          ).then((value) => teamProvider!
                                              .doGetTeamsListApiCall());
                                        },
                                        onLongPressed: () {},
                                      );
                                    },
                                    physics: const BouncingScrollPhysics(),
                                  )
                                : teamProvider!.teams!.data!.isEmpty &&
                                        controllerSearchTeams!.text.isNotEmpty
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
                                            child: NoSearchResultsFoundWidget(),
                                          ),
                                        ),
                                      )
                                    : Container(
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
                                        child: SingleChildScrollView(
                                          child: Center(
                                            child: AnimatedBuilder(
                                              animation: animationController!,
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: Transform(
                                                    transform: Matrix4
                                                        .translationValues(
                                                      0.0,
                                                      100 *
                                                          (1.0 -
                                                              animation.value),
                                                      0.0,
                                                    ),
                                                    child: Container(
                                                      color: Colors.white,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space70.h),
                                                      child: EmptyViewUiWidget(
                                                        assetUrl:
                                                            "assets/images/empty_teams.png",
                                                        title: Utils.getString(
                                                            "noTeams"),
                                                        desc: Utils.getString(
                                                            "noTeamsDescription"),
                                                        buttonTitle:
                                                            Utils.getString(
                                                                "createNewTeam"),
                                                        icon: Icons
                                                            .add_circle_outline,
                                                        showButton: false,
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ContactSearchShimmer(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 15,
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space16.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            itemBuilder: (context, index) {
                              return const TeamShimmer();
                            },
                          ),
                        ),
                      ],
                    ),
              onRefresh: () {
                return teamProvider!.doGetTeamsListApiCall();
              },
            );
          },
        ),
      ),
    );
  }
}
