import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:intercom_flutter/intercom_flutter.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/api/WebSocketController.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/dialog/ConfirmDialogView.dart";
import "package:mvp/ui/user/dnd/UserDndView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EditProfileIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/NumberListIntentHolder.dart";
import "package:mvp/viewObject/model/userDnd/UserDndResponse.dart";
import "package:provider/provider.dart";
import "package:store_redirect/store_redirect.dart";

final _debouncer = DeBouncer(milliseconds: 200);

class UserProfileDialog extends StatefulWidget {
  const UserProfileDialog({
    Key? key,
    required this.onLogOut,
    required this.scrollController,
    required this.onProfileUpdateCallback,
    required this.onChangeImage,
    required this.selectedImage,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final Function onLogOut;
  final ScrollController scrollController;
  final VoidCallback onProfileUpdateCallback;
  final Function onChangeImage;
  final String selectedImage;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  UserProfileDialogState createState() => UserProfileDialogState();
}

class UserProfileDialogState extends State<UserProfileDialog>
    with SingleTickerProviderStateMixin {
  ValueHolder? valueHolder;

  UserProvider? userProvider;
  UserRepository? userRepository;

  MemberProvider? memberProvider;
  MemberRepository? memberRepository;

  LoginWorkspaceProvider? workspaceProvider;
  LoginWorkspaceRepository? workspaceRepository;

  StreamSubscription? streamSubscriptionOnNetworkChanged;

  @override
  void initState() {
    super.initState();

    UserDndViewWidget.onOfflineEvent
        .on<UserOnlineOfflineEvent>()
        .listen((event) {
      try {
        userProvider!.updateUserDndStatus(event.online!);
        userProvider!.getUserProfileDetails();
      } catch (e) {
        Utils.cPrint(e.toString());
      }
    });

    streamSubscriptionOnNetworkChanged = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      if (status != InternetConnectionStatus.disconnected) {
        userProvider!.updateNetworkDisconnected(true);
      } else {
        userProvider!.updateNetworkDisconnected(false);
      }
    });
  }

  @override
  void dispose() {
    streamSubscriptionOnNetworkChanged!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    memberRepository = Provider.of<MemberRepository>(context, listen: false);
    userRepository = Provider.of<UserRepository>(context, listen: false);
    workspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              userProvider = UserProvider(
                  userRepository: userRepository, valueHolder: valueHolder);
              userProvider!.getUserDndEnabledValue();
              userProvider!.getUserDndTimelist(true);
              userProvider!.getUserProfileDetails();
              return userProvider!;
            }),
        ChangeNotifierProvider<MemberProvider>(
            lazy: false,
            create: (BuildContext context) {
              memberProvider =
                  MemberProvider(memberRepository: memberRepository);
              return memberProvider!;
            }),
        ChangeNotifierProvider<LoginWorkspaceProvider>(
            lazy: false,
            create: (BuildContext context) {
              workspaceProvider = LoginWorkspaceProvider(
                  loginWorkspaceRepository: workspaceRepository,
                  valueHolder: valueHolder);
              return workspaceProvider!;
            }),
      ],
      child: Consumer3<UserProvider, MemberProvider, LoginWorkspaceProvider>(
        builder: (BuildContext context,
            UserProvider? provider,
            MemberProvider? memberProvider,
            LoginWorkspaceProvider? workspaceProvider,
            Widget? child) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.space12.r),
              topRight: Radius.circular(Dimens.space12.r),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
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
                controller: widget.scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space20.w,
                        Dimens.space25.h, Dimens.space20.w, Dimens.space0.h),
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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            widget.selectedImage == ""
                                ? RoundedNetworkImageHolder(
                                    width: Dimens.space80,
                                    height: Dimens.space80,
                                    containerAlignment: Alignment.bottomCenter,
                                    iconUrl: CustomIcon.icon_profile,
                                    iconColor: CustomColors.callInactiveColor,
                                    iconSize: Dimens.space70,
                                    boxDecorationColor:
                                        CustomColors.mainDividerColor,
                                    outerCorner: Dimens.space20,
                                    innerCorner: Dimens.space20,
                                    imageUrl:
                                        userProvider!.getUserProfilePicture() !=
                                                null
                                            ? userProvider!
                                                .getUserProfilePicture()
                                                .trim()
                                            : "",
                                    onTap: () {
                                      widget.onChangeImage();
                                    },
                                  )
                                : Container(
                                    width: Dimens.space80.w,
                                    height: Dimens.space80.w,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    decoration: BoxDecoration(
                                      color: CustomColors.mainDividerColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.space20.r),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimens.space20.r),
                                      child: Image.file(
                                        File(widget.selectedImage),
                                        width: Dimens.space80.w,
                                        height: Dimens.space80.w,
                                        fit: BoxFit.cover,
                                        cacheWidth: 500,
                                      ),
                                    ),
                                  ),
                            Positioned(
                              bottom: Dimens.space0.h,
                              right: Dimens.space0.w,
                              child: PlainAssetImageHolder(
                                assetUrl: "assets/images/icon_upload.png",
                                width: Dimens.space24,
                                height: Dimens.space26,
                                assetWidth: Dimens.space20,
                                assetHeight: Dimens.space20,
                                boxFit: BoxFit.contain,
                                iconUrl: CustomIcon.icon_plus_rounded,
                                iconColor: CustomColors.white!,
                                iconSize: Dimens.space24,
                                outerCorner: Dimens.space300,
                                innerCorner: Dimens.space300,
                                boxDecorationColor: CustomColors.white!,
                                onTap: () {
                                  widget.onChangeImage();
                                },
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 180),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(
                              Dimens.space20.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h,
                            ),
                            child: Container(
                              decoration: userProvider!
                                              .getWorkspaceDetail()
                                              .loginMemberRole !=
                                          null &&
                                      userProvider!
                                              .getWorkspaceDetail()
                                              .loginMemberRole!
                                              .role !=
                                          null
                                  ? BoxDecoration(
                                      color: CustomColors.startButtonColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    )
                                  : const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
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
                                    : userProvider!
                                                    .getWorkspaceDetail()
                                                    .loginMemberRole !=
                                                null &&
                                            userProvider!
                                                    .getWorkspaceDetail()
                                                    .loginMemberRole!
                                                    .role !=
                                                null
                                        ? userProvider!
                                            .getWorkspaceDetail()
                                            .loginMemberRole!
                                            .role!
                                            .toUpperCase()
                                        : "",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: CustomColors.white,
                                      fontSize: Dimens.space12.sp,
                                      fontFamily: Config.heeboRegular,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space8.h, Dimens.space16.w, Dimens.space0.h),
                    color: CustomColors.white,
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : userProvider?.getUserName() ?? "",
                      textAlign: TextAlign.left,
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
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space8.h, Dimens.space16.w, Dimens.space16.h),
                    color: CustomColors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : userProvider?.getUserEmail() ??
                                    userProvider?.getDefaultChannel().number ??
                                    "",
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontSize: Dimens.space15.sp,
                                      fontFamily: Config.heeboRegular,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: !isClickAble(),
                    child: DetailWidget(
                      userProvider: userProvider!,
                      memberProvider: memberProvider!,
                      onProfileUpdateCallback: () {
                        widget.onProfileUpdateCallback();
                        setState(() {});
                      },
                      onIncomingTap: () {
                        widget.onIncomingTap();
                      },
                      onOutgoingTap: () {
                        widget.onOutgoingTap();
                      },
                    ),
                  ),
                  const RatingAndLiveSupportView(),
                  Divider(
                    color: CustomColors.bottomAppBarColor,
                    height: Dimens.space25.h,
                    thickness: Dimens.space25.h,
                  ),
                  LogoutWidget(
                    userProvider: userProvider!,
                    onLogOut: widget.onLogOut,
                  ),
                  Divider(
                    color: CustomColors.bottomAppBarColor,
                    height: Dimens.space1.h,
                    thickness: Dimens.space1.h,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool isClickAble() {
    if (userProvider!.getWorkspaceDetail().plan != null &&
        userProvider!.getWorkspaceDetail().plan!.subscriptionActive != null &&
        userProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        userProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive!
                .toLowerCase() ==
            "active") {
      return true;
    } else {
      return false;
    }
  }
}

class DetailWidget extends StatefulWidget {
  final UserProvider userProvider;
  final MemberProvider memberProvider;
  final VoidCallback onProfileUpdateCallback;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  const DetailWidget({
    required this.userProvider,
    required this.memberProvider,
    required this.onProfileUpdateCallback,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  });

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  bool isOnline = true;
  bool onlineConnection = true;
  WebSocketController webSocketController = WebSocketController();

  Future<void> getOnlineConnection() async {
    _debouncer.run(() async {
      // await widget.memberProvider
      //     .doGetAllWorkspaceMembersApiCall(widget.memberProvider.getMemberId());
      final bool onlineConnection =
          widget.memberProvider.getMemberOnlineStatus();
      final bool stayOnline = PsSharedPreferences.instance!.shared!
          .getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS)!;
      webSocketController.send(sendScreen: "Zoom Scaffold");
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(
            color: CustomColors.bottomAppBarColor,
            height: Dimens.space25.h,
            thickness: Dimens.space25.h,
          ),
          Consumer<UserProvider>(
            builder: (BuildContext context, UserProvider userProvider, _) {
              isOnline = userProvider.getUserOnlineStatus();
              return Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CustomColors.mainDividerColor!,
                    ),
                  ),
                  color: CustomColors.white,
                ),
                child: TextButton(
                  onPressed: () {
                    _onUserDndClicked(userProvider.getUserOnlineStatus(),
                        widget.userProvider);
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          constraints: BoxConstraints(
                            minWidth: Dimens.space10.w,
                            maxWidth: Dimens.space90.w,
                          ),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("setStatus"),
                            textAlign: TextAlign.left,
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
                        Expanded(
                          child: Container(
                            height: Dimens.space28,
                            alignment: Alignment.centerRight,
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
                              child: isOnline
                                  ? StreamBuilder(
                                      stream: userProvider
                                          .streamOnlineStatus!.stream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<bool> snapshot) {
                                        bool onlineStatus = false;
                                        if (snapshot.hasData) {
                                          onlineStatus = snapshot.data!;
                                        }
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: Dimens.space10.w,
                                              height: Dimens.space10.w,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space5.w,
                                                  Dimens.space0.h),
                                              decoration: BoxDecoration(
                                                color: onlineStatus
                                                    ? CustomColors
                                                        .callAcceptColor
                                                    : CustomColors.grey,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space100.r),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: RichText(
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                textAlign: TextAlign.left,
                                                maxLines: 1,
                                                text: TextSpan(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        color: CustomColors
                                                            .textTertiaryColor,
                                                        fontFamily: Config
                                                            .manropeSemiBold,
                                                        fontSize:
                                                            Dimens.space15.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                  text: Config.checkOverFlow
                                                      ? Const.OVERFLOW
                                                      : (onlineStatus
                                                          ? Utils.getString(
                                                              "online")
                                                          : Utils.getString(
                                                              "offline")),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                  : Container(
                                      child: userProvider.userDnd!.data != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: Dimens.space10.w,
                                                  height: Dimens.space10.w,
                                                  margin: EdgeInsets.fromLTRB(
                                                      Dimens.space0.w,
                                                      Dimens.space0.h,
                                                      Dimens.space5.w,
                                                      Dimens.space0.h),
                                                  decoration: BoxDecoration(
                                                    color: CustomColors.grey,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(
                                                          Dimens.space100.r),
                                                    ),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: RichText(
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    textAlign: TextAlign.left,
                                                    maxLines: 1,
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                            color: CustomColors
                                                                .textTertiaryColor,
                                                            fontFamily: Config
                                                                .manropeSemiBold,
                                                            fontSize: Dimens
                                                                .space13.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                      text: Config.checkOverFlow
                                                          ? Const.OVERFLOW
                                                          : (userProvider
                                                                      .userDnd!
                                                                      .data!
                                                                      .dndEndtime !=
                                                                  null
                                                              ? "${Utils.getString("awayUntill")}${Utils.fromUnixTimeStampToDate("MMM dd, hh:mm a", userProvider.userDnd!.data!.dndEndtime!)}"
                                                              : "${Utils.getString('away')}${Utils.getString("muteUntillBack")}"),
                                                    ),
                                                  ),
                                                ),
                                                // Container(
                                                //   padding: EdgeInsets.only(
                                                //       left: Dimens.space10),
                                                //   constraints: BoxConstraints(
                                                //       maxWidth: ScreenUtil()
                                                //               .screenWidth *
                                                //           0.5),
                                                //   child: Text(
                                                //     Config.checkOverFlow
                                                //         ? Const.OVERFLOW
                                                //         : Utils.getString(
                                                //                 "Away untill ") +
                                                //             (userProvider
                                                //                         .userDnd!
                                                //                         .data!
                                                //                         .dndEndtime !=
                                                //                     null
                                                //                 ? Utils.fromUnixTimeStampToDate(
                                                //                     "MMM dd, hh:mm a",
                                                //                     userProvider!
                                                //                         .userDnd!
                                                //                         .data!
                                                //                         .dndEndtime!)
                                                //                 : Utils.getString(
                                                //                     " i turn it back on")),
                                                //     textAlign: TextAlign.center,
                                                //     maxLines: 1,
                                                //     overflow:
                                                //         TextOverflow.ellipsis,
                                                //     style: Theme.of(context)
                                                //         .textTheme
                                                //         .bodyText1!
                                                //         .copyWith(
                                                //           color: CustomColors
                                                //               .textTertiaryColor,
                                                //           fontFamily: Config
                                                //               .manropeSemiBold,
                                                //           fontSize:
                                                //               Dimens.space13.sp,
                                                //           fontWeight:
                                                //               FontWeight.normal,
                                                //           fontStyle:
                                                //               FontStyle.normal,
                                                //         ),
                                                //   ),
                                                // ),
                                              ],
                                            )
                                          : Container(),
                                    ),
                            ),
                          ),
                        ),
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
                          child: Icon(
                            CustomIcon.icon_arrow_right,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Divider(
            color: CustomColors.bottomAppBarColor,
            height: Dimens.space25.h,
            thickness: Dimens.space25.h,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Utils.checkInternetConnectivity().then((bool onValue) {
                      if (onValue) {
                        Navigator.pushNamed(
                          context,
                          RoutePaths.editProfileDetail,
                          arguments: EditProfileIntentHolder(
                            whichToEdit: "",
                            onProfileUpdateCallback: () {
                              widget.onProfileUpdateCallback();
                            },
                            onIncomingTap: () {
                              widget.onIncomingTap();
                            },
                            onOutgoingTap: () {
                              widget.onOutgoingTap();
                            },
                          ),
                        );
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  : Utils.getString("editProfile"),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                          child: Icon(
                            CustomIcon.icon_arrow_right,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: CustomColors.bottomAppBarColor,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space15.h,
                Dimens.space16.w, Dimens.space15.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("appSettings").toUpperCase(),
              textAlign: TextAlign.left,
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
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            color: CustomColors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      alignment: Alignment.center,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.userNotificationSetting,
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
                          Dimens.space14.h, Dimens.space16.w, Dimens.space14.h),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    : Utils.getString("notifications"),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                            child: Icon(
                              CustomIcon.icon_arrow_right,
                              size: Dimens.space24.w,
                              color: CustomColors.textQuinaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                  color: CustomColors.mainDividerColor,
                ),
              ],
            ),
          ),
          Platform.isAndroid
              ? Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  color: CustomColors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: TextButton(
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
                            openSoundSettings();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space16.w,
                                Dimens.space14.h,
                                Dimens.space16.w,
                                Dimens.space14.h),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          : Utils.getString("soundSettings"),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color:
                                                CustomColors.textPrimaryColor,
                                            fontFamily: Config.manropeSemiBold,
                                            fontSize: Dimens.space15.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
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
                                  child: Icon(
                                    CustomIcon.icon_arrow_right,
                                    size: Dimens.space24.w,
                                    color: CustomColors.textQuinaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: Dimens.space1,
                        thickness: Dimens.space1,
                        color: CustomColors.mainDividerColor,
                      ),
                    ],
                  ),
                )
              : Container(),
          Container(
            width: double.infinity,
            color: CustomColors.bottomAppBarColor,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space15.h,
                Dimens.space16.w, Dimens.space10.h),
          ),
        ],
      ),
    );
  }

  Future<void> _onUserDndClicked(
      bool userOnlineStatus, UserProvider userProvider) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext c) {
        return SizedBox(
          height: ScreenUtil().screenHeight * 0.8,
          child: UserDndViewWidget(
            onTimeSelected: (int time, bool value) {
              switchStatus(time, value);
            },
            userProvider: userProvider,
          ),
        );
      },
    );
  }

  Future<void> switchStatus(int time, bool data) async {
    await PsProgressDialog.showDialog(context, isDissmissable: true);

    final Resources<UserDndResponse> response =
        await widget.userProvider.doSetUserDndApiCall(time, data);
    if (response.status == Status.SUCCESS) {
      await PsProgressDialog.dismissDialog();
      widget.userProvider
          .getUserDndTimelist(response.data!.data!.data!.dndEnabled!);
      widget.userProvider.getUserProfileDetails();
      getOnlineConnection();
    } else {
      await PsProgressDialog.dismissDialog();
      widget.userProvider.getUserDndTimelist(false);
      widget.userProvider.getUserProfileDetails();
    }
  }

  Future<void> openSoundSettings() async {
    await Navigator.pushNamed(
      context,
      RoutePaths.soundSettings,
      arguments: NumberListIntentHolder(
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

class RatingAndLiveSupportView extends StatelessWidget {
  const RatingAndLiveSupportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.center,
      color: CustomColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Utils.checkInternetConnectivity().then((bool onValue) {
                if (onValue) {
                  StoreRedirect.redirect(
                    androidAppId: "app.krispcall",
                    iOSAppId: "1597876448",
                  );
                  // Utils.lunchWebUrl(
                  //     url: Platform.isIOS
                  //         ? EndPoints.APPSTORE_URL
                  //         : EndPoints.PLAYSTORE_URL,
                  //     context: context);
                } else {
                  Utils.showWarningToastMessage(
                      Utils.getString("noInternet"), context);
                }
              });
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space16.h,
                  Dimens.space16.w, Dimens.space16.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CustomColors.mainDividerColor!,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("rateKrispCall"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      )
                    ],
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
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                alignment: Alignment.center,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
              ),
              onPressed: () {
                Utils.checkInternetConnectivity().then((bool onValue) async {
                  if (onValue) {
                    await Intercom.instance.displayMessenger();
                  } else {
                    Utils.showWarningToastMessage(
                        Utils.getString("noInternet"), context);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space14.h,
                    Dimens.space16.w, Dimens.space14.h),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Row(
                          children: [
                            Flexible(
                              child: RichText(
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.textPrimaryColor,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  text: Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("liveSupport"),
                                ),
                              ),
                            ),
                            Container(
                              height: Dimens.space10.h,
                              width: Dimens.space10.h,
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space5.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    Dimens.space100.r,
                                  ),
                                ),
                                color: const Color(0xffDB312B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Icon(
                        CustomIcon.icon_arrow_right,
                        size: Dimens.space24.w,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: Dimens.space1,
            thickness: Dimens.space1,
            color: CustomColors.mainDividerColor,
          ),
        ],
      ),
    );
  }
}

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({
    required this.userProvider,
    required this.onLogOut,
  });

  final UserProvider userProvider;
  final Function onLogOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: TextButton(
        style: TextButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.fromLTRB(
              Dimens.space16, Dimens.space14, Dimens.space16, Dimens.space14),
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.zero,
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : toBeginningOfSentenceCase(Utils.getString("logOut"))!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.callDeclineColor,
                  fontFamily: Config.manropeSemiBold,
                  fontSize: Dimens.space15.sp,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
        onPressed: () {
          showDialog<dynamic>(
            context: context,
            builder: (BuildContext dialogContext) {
              return logoutDialog(context,
                  title: Utils.getString("logoutKrispcall"), onAgreeTap: () {
                Navigator.of(dialogContext).pop();
                onLogOut();
              });
            },
          );
        },
      ),
    );
  }
}
