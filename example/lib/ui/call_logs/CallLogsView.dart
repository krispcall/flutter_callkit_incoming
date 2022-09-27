import "dart:async";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_libphonenumber/flutter_libphonenumber.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/ui/call_logs/all/AllCallsLogsView.dart";
import "package:mvp/ui/call_logs/missed/AllMissedCallLogsView.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ContactListNewMessageDialog.dart";
import "package:mvp/ui/common/dialog/NavigationSearchDialog.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MessageDetailIntentHolder.dart";
import "package:provider/provider.dart";
import "package:flutter/services.dart";


class CallLogsView extends StatefulWidget {
  const CallLogsView({
    Key? key,
    required this.animationController,
    required this.onCallTap,
    required this.onLeadingTap,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
    required this.loginWorkspaceProvider,
  }) : super(key: key);

  final AnimationController? animationController;
  final Function? onCallTap;
  final Function? onLeadingTap;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String,
      String, String) makeCallWithSid;
  final LoginWorkspaceProvider? loginWorkspaceProvider;

  @override
  CallLogsViewState createState() => CallLogsViewState();
}

class CallLogsViewState extends State<CallLogsView>
    with TickerProviderStateMixin {
  int selectedIndex = 0;

  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;
  ValueHolder? valueHolder;

  bool isConnectedToInternet = true;

  StreamSubscription? streamSubscriptionOnWorkspaceOrChannelChanged;

  @override
  void initState() {
    super.initState();
    callLogRepository = Provider.of<CallLogRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    streamSubscriptionOnWorkspaceOrChannelChanged = DashboardView
        .workspaceOrChannelChanged
        .on<SubscriptionWorkspaceOrChannelChanged>()
        .listen((event) {
      /// toolbar title wont changes so need this
      setState(() {});
    });
  }

  @override
  void dispose() {
    streamSubscriptionOnWorkspaceOrChannelChanged?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: CustomAppBar<CallLogProvider>(
        elevation: 0,
        onIncomingTap: () {
          widget.onIncomingTap!();
        },
        onOutgoingTap: () {
          widget.onOutgoingTap!();
        },
        titleWidget: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: FutureBuilder<String>(
                  future: Utils.getFlagUrl(widget.loginWorkspaceProvider!
                      .getDefaultChannel()
                      .number),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return AppBarNetworkImageHolder(
                        width: Dimens.space40,
                        height: Dimens.space40,
                        boxFit: BoxFit.scaleDown,
                        containerAlignment: Alignment.bottomCenter,
                        iconUrl: CustomIcon.icon_gallery,
                        iconColor: CustomColors.grey,
                        iconSize: Dimens.space20,
                        boxDecorationColor: CustomColors.baseLightColor,
                        outerCorner: Dimens.space30,
                        innerCorner: Dimens.space5,
                        imageUrl: PSApp.config!.countryLogoUrl! + snapshot.data!,
                      );
                    }
                    return const CupertinoActivityIndicator();
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onLongPress: (){
                    Clipboard.setData(ClipboardData(text:Config.checkOverFlow
                        ? Const.OVERFLOW
                        : callLogRepository!
                        .getDefaultChannel()
                        .number ??
                        Utils.getString("appName"))).then((_){
                      Utils.showCopyToastMessage(Utils.getString('phoneNumberCopied'), context);
                    });

                  },
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                            Dimens.space0.h, Dimens.space12.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                                        .bodyText1!
                                        .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    text: Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : callLogRepository!
                                        .getDefaultChannel()
                                        .name ??
                                        Utils.getString("appName"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                            Dimens.space0.h, Dimens.space2.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : FlutterLibphonenumber().formatNumberSync(widget
                              .loginWorkspaceProvider!
                              .getDefaultChannel()
                              .number ??
                              Utils.getString("appName")),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.heeboMedium,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
        leadingWidget: TextButton(
          onPressed: () {
            widget.onLeadingTap!();
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.center,
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
            onPressed: () async {
              showNavigationSearch();
            },
            style: TextButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: CustomColors.transparent,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.space0.r),
              ),
            ),
            child: RoundedNetworkImageHolder(
              width: Dimens.space20,
              height: Dimens.space20,
              iconUrl: CustomIcon.icon_search,
              iconColor: CustomColors.textTertiaryColor,
              iconSize: Dimens.space18,
              outerCorner: Dimens.space10,
              innerCorner: Dimens.space10,
              boxDecorationColor: CustomColors.transparent,
              imageUrl: "",
              onTap: () async {
                showNavigationSearch();
              },
            ),
          ),
        ],
        initProvider: () {
          return CallLogProvider(callLogRepository: callLogRepository);
        },
        onProviderReady: (CallLogProvider provider) {
          callLogProvider = provider;
        },
        builder:
            (BuildContext? context, CallLogProvider? provider, Widget? child) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(
                  MediaQuery.of(context!).size.width,
                  40.h,
                ),
                child: Material(
                  color: Colors.transparent,
                  elevation: 0.8,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CustomColors.white!,
                          CustomColors.bottomAppBarColor!
                        ],
                      ),
                    ),
                    child: TabBar(
                      physics: const NeverScrollableScrollPhysics(),
                      indicatorColor: CustomColors.mainColor,
                      labelColor: CustomColors.mainColor,
                      unselectedLabelColor: CustomColors.textTertiaryColor,
                      indicatorWeight: Dimens.space2.w,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                            width: Dimens.space2.h,
                            color: CustomColors.mainColor!),
                        insets: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      ),
                      labelStyle:
                          Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontSize: Dimens.space14.sp,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.mainColor,
                                fontFamily: Config.manropeSemiBold,
                                fontStyle: FontStyle.normal,
                              ),
                      unselectedLabelStyle:
                          Theme.of(context).textTheme.bodyText1!.copyWith(
                                fontSize: Dimens.space14.sp,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.textTertiaryColor,
                                fontFamily: Config.manropeSemiBold,
                                fontStyle: FontStyle.normal,
                              ),
                      tabs: <Widget>[
                        Tab(
                            text: Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("all")),
                        Tab(
                          text: Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("missed"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              backgroundColor: CustomColors.white,
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AllCallLogsView(
                    animationController: widget.animationController!,
                    onCallTap: widget.onCallTap!,
                    onStartConversationTap: showContactDialogForNewMessage,
                    onIncomingTap: () {
                      widget.onIncomingTap!();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap!();
                    },
                    makeCallWithSid: (channelNumber,
                        channelName,
                        channelSid,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId,
                        outgoingProfilePicture) {
                      widget.makeCallWithSid(
                        channelNumber,
                        channelName,
                        channelSid,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId,
                        outgoingProfilePicture,
                      );
                    },
                  ),
                  AllMissedCallLogsView(
                    animationController: widget.animationController,
                    onCallTap: widget.onCallTap,
                    onStartConversationTap: showContactDialogForNewMessage,
                    onIncomingTap: () {
                      widget.onIncomingTap!();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap!();
                    },
                    makeCallWithSid: (channelNumber,
                        channelName,
                        channelSid,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId,
                        outgoingProfilePicture) {
                      widget.makeCallWithSid(
                        channelNumber,
                        channelName,
                        channelSid,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId ?? "",
                        outgoingProfilePicture,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        height: Dimens.space60.w,
        width: Dimens.space60.w,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w,
            Dimens.space0.h,
            Dimens.space5.w,
            (Utils.getBottomNotchHeight(context)) + Dimens.space10.h),
        child: RoundedNetworkImageHolder(
          width: Dimens.space60,
          height: Dimens.space60,
          boxFit: BoxFit.contain,
          iconUrl: CustomIcon.icon_call_edit,
          iconColor: CustomColors.white,
          iconSize: Dimens.space20,
          boxDecorationColor: CustomColors.mainColor,
          outerCorner: Dimens.space300,
          innerCorner: Dimens.space0,
          imageUrl: "",
          onTap: () {
            showContactDialogForNewMessage();
          },
        ),
      ),
    );
  }

  Future<void> showContactDialogForNewMessage() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space10.r),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext dialogContext) {
        return SizedBox(
          height: ScreenUtil().screenHeight * 0.90,
          child: ContactListNewMessageDialog(
            animationController: widget.animationController,
            onIncomingTap: () {
              widget.onIncomingTap!();
            },
            onOutgoingTap: () {
              widget.onOutgoingTap!();
            },
            defaultCountryCode: callLogProvider!.getDefaultCountryCode(),
            onItemTap: (selectedContact) async {
              Navigator.of(dialogContext).pop();
              Future.delayed(const Duration(milliseconds: 300), () async {
                final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.messageDetail,
                  arguments: MessageDetailIntentHolder(
                    clientName: selectedContact.name,
                    clientPhoneNumber: selectedContact.number,
                    clientProfilePicture: selectedContact.profilePicture,
                    countryId: selectedContact.country,
                    isBlocked: selectedContact.blocked,
                    lastChatted: DateTime.now().toString(),
                    channelId: callLogProvider!.getDefaultChannel().id,
                    channelName: callLogProvider!.getDefaultChannel().name,
                    channelNumber: callLogProvider!.getDefaultChannel().number,
                    clientId: selectedContact.id,
                    // dndMissed: false,
                    isContact: true,
                    onIncomingTap: () {
                      widget.onIncomingTap!();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap!();
                    },
                    makeCallWithSid: (channelNumber,
                        channelName,
                        channelSid,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId,
                        outgoingProfilePicture) {
                      widget.makeCallWithSid(
                          channelNumber!,
                          channelName!,
                          channelSid!,
                          outgoingNumber!,
                          workspaceSid!,
                          memberId!,
                          voiceToken!,
                          outgoingName!,
                          outgoingId ?? "",
                          outgoingProfilePicture!);
                    },
                    onContactBlocked: (bool value) {},
                  ),
                );
                if (returnData != null && returnData is bool && returnData) {
                  if (selectedIndex == 1) {
                    callLogProvider!
                        .doGetCallLogsAndPinnedConversationLogsApiCall(
                        "missed");
                  } else if (selectedIndex == 2) {
                    callLogProvider!
                        .doGetCallLogsAndPinnedConversationLogsApiCall("new");
                  } else {
                    callLogProvider!
                        .doGetCallLogsAndPinnedConversationLogsApiCall("all");
                  }
                }
              });
            },
          ),
        );
      },
    );
  }

  Future<void> showNavigationSearch() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return NavigationSearchDialog(
          onIncomingTap: () {
            widget.onIncomingTap!();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap!();
          },
          makeCallWithSid: (channelNumber,
              channelName,
              channelSid,
              outgoingNumber,
              workspaceSid,
              memberId,
              voiceToken,
              outgoingName,
              outgoingId,
              outgoingProfilePicture) {
            widget.makeCallWithSid(
              channelNumber,
              channelName,
              channelSid,
              outgoingNumber,
              workspaceSid,
              memberId,
              voiceToken,
              outgoingName,
              outgoingId,
              outgoingProfilePicture,
            );
          },
        );
      },
    );
  }
}
