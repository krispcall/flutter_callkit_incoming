import "dart:async";
import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:graphql/client.dart";
import "package:image_cropper/image_cropper.dart";
import "package:image_picker/image_picker.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/WebSocketController.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/enum/WorkspaceStatus.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/call_log/CallLogProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/provider/memberProvider/MemberProvider.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/dialog/CallInProgressErrorDialog.dart";
import "package:mvp/ui/common/dialog/CallInProgressErrorLogoutDialog.dart";
import "package:mvp/ui/common/dialog/UserProfileDialog.dart";
import "package:mvp/ui/common/dialog/WorkSpaceDeleteDialog.dart";
import "package:mvp/ui/common/dialog/WorkSpaceDetailsDialog.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/discord/SlidingUpPanel.dart";
import "package:mvp/ui/discord/ZoomDrawer.dart";
import "package:mvp/ui/user/dnd/UserDndView.dart";
import "package:mvp/ui/workspace/WorkspaceListItemView.dart";
import "package:mvp/ui/workspace/WorkspaceNumberListItemView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/WorkSpaceRequestParamHolder.dart";
import "package:mvp/viewObject/model/channel/ChannelData.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";
import "package:mvp/viewObject/model/memberLogin/Member.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/Workspace.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";

class DrawerView extends StatefulWidget {
  final ZoomDrawerController? zoomDrawerController;
  final AnimationController? animationController;
  final Animation? animation;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;
  final LoginWorkspaceProvider? loginWorkspaceProvider;
  final ContactsProvider? contactsProvider;
  final CountryListProvider? countryListProvider;
  final UserProvider? userProvider;
  final MemberProvider? memberProvider;
  final ValueHolder? valueHolder;
  final Function? onLogout;

  const DrawerView({
    @required this.zoomDrawerController,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    this.animationController,
    this.animation,
    this.loginWorkspaceProvider,
    this.contactsProvider,
    this.countryListProvider,
    this.userProvider,
    this.memberProvider,
    this.valueHolder,
    this.onLogout,
  });

  @override
  DrawerViewState createState() => DrawerViewState();
}

class DrawerViewState extends State<DrawerView> with TickerProviderStateMixin {
  Curve scaleDownCurve = const Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = const Interval(0.0, 1.0, curve: Curves.easeIn);
  Curve slideOutCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = const Interval(0.0, 1.0, curve: Curves.easeIn);
  ValueHolder? valueHolder;
  WebSocketController webSocketController = WebSocketController();
  final DeBouncer deBouncer = DeBouncer(milliseconds: 3000);
  PanelController panelControllerWorkspace = PanelController();
  PanelController panelControllerProfile = PanelController();
  List<Stream<QueryResult>?> streamSubscriptionCallLogsList = [];

  /// For Conversation Seen Decrease channel count
  StreamSubscription? streamSubscriptionOnConversationSeen;
  CallLogRepository? callLogRepository;
  CallLogProvider? callLogProvider;

  File? _image;
  final _picker = ImagePicker();
  File? _selectedFile;
  String selectedFilePath = "";

  Future<void> _askPermissionStorage() async {
    await [Permission.storage].request().then(_onStatusRequested);
  }

  Future<void> _askPermissionPhotos() async {
    await [Permission.photos].request().then(_onStatusRequested);
  }

  void _onStatusRequested(Map<Permission, PermissionStatus> status) {
    Permission perm;
    if (Platform.isIOS) {
      perm = Permission.photos;
    } else {
      perm = Permission.storage;
    }
    if (status[perm] != PermissionStatus.granted) {
      if (Platform.isIOS) {
        openAppSettings();
      }
    } else {
      _getImage(ImageSource.gallery).then((_) async {
        if (_image != null && selectedFilePath.isNotEmpty) {
          if (await Utils.checkInternetConnectivity()) {
            await PsProgressDialog.showDialog(context, isDissmissable: true);
            widget.userProvider!
                .changeProfilePicture(Utils.convertImageToBase64String(
                    "photoUpload", File(selectedFilePath)))
                .then((value) async {
              await PsProgressDialog.dismissDialog();
              setState(() {});
            });
          } else {
            Utils.showWarningToastMessage(
                Utils.getString('noInternet'), context);
          }
        }
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });

    if (_image != null) {
      final File? cropped = await ImageCropper().cropImage(
        compressQuality: 50,
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Cropper",
          toolbarColor: CustomColors.mainColor,
          toolbarWidgetColor: CustomColors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      setState(() {
        if (cropped != null) {
          if (_selectedFile != null && _selectedFile!.existsSync()) {
            _selectedFile!.deleteSync();
          }
          _selectedFile = cropped;
          selectedFilePath = _selectedFile!.path;
        }

        // delete image camera
        if (source.toString() == "ImageSource.camera" && _image!.existsSync()) {
          _image!.deleteSync();
        }
      });
    }
  }

  @override
  void initState() {
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    callLogRepository = Provider.of<CallLogRepository>(context, listen: false);
    callLogProvider = CallLogProvider(callLogRepository: callLogRepository);

    widget.loginWorkspaceProvider!.doChannelListOnlyApiCall(
        widget.loginWorkspaceProvider!.getCallAccessToken());
    doSubscriptionUpdate();
    streamSubscriptionOnConversationSeen = DashboardView
        .subscriptionConversationSeen
        .on<SubscriptionConversationSeenEvent>()
        .listen((event) {
      widget.loginWorkspaceProvider!
          .doChannelListOnlyApiCall(
              widget.loginWorkspaceProvider!.getCallAccessToken())
          .then((value) {
        setState(() {});
      });
    });
    UserDndViewWidget.onOfflineEvent
        .on<UserOnlineOfflineEvent>()
        .listen((event) {
      widget.userProvider!.updateUserDndStatus(event.online!);
      widget.userProvider!.getUserProfileDetails();
    });

    super.initState();
  }

  @override
  void dispose() {
    streamSubscriptionOnConversationSeen!.cancel();
    super.dispose();
  }

  Future<void> doSubscriptionUpdate() async {
    if (callLogProvider!.getChannelList() != null &&
        callLogProvider!.getChannelList()!.isNotEmpty) {
      final List<WorkspaceChannel> channelList =
          callLogProvider!.getChannelList()!;
      for (int i = 0; i < channelList.length; i++) {
        streamSubscriptionCallLogsList.add(await callLogProvider!
            .doSubscriptionCallLogsApiCall("all", channelList[i].id));
      }
      for (int i = 0; i < channelList.length; i++) {
        if (streamSubscriptionCallLogsList[i] != null) {
          streamSubscriptionCallLogsList[i]!.listen((event) async {
            if (event.data != null) {
              await widget.loginWorkspaceProvider!
                  .doChannelListOnlyApiCall(
                      widget.loginWorkspaceProvider!.getCallAccessToken())
                  .then((value) {
                if (!mounted) return;
                setState(() {});
              });
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isClickAble()) {
      widget.zoomDrawerController!.open!();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.loginWorkspaceProvider!.getLoginUserId() != null &&
            widget.loginWorkspaceProvider!.getLoginUserId()!.isNotEmpty)
          Scaffold(
            backgroundColor: CustomColors.mainColor,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
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
                  Dimens.space0.h,
                ),
                width: MediaQuery.of(context).size.width.sw,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: Dimens.space68.w,
                      alignment: Alignment.topCenter,
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
                        Dimens.space0.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          if (widget.loginWorkspaceProvider!
                                      .loginWorkspaceList !=
                                  null &&
                              widget.loginWorkspaceProvider!.loginWorkspaceList!.data !=
                                  null &&
                              widget.loginWorkspaceProvider!.loginWorkspaceList!
                                      .data!.data !=
                                  null &&
                              widget.loginWorkspaceProvider!.loginWorkspaceList!
                                  .data!.data!.isNotEmpty)
                            Expanded(
                              child: Container(
                                alignment: Alignment.topCenter,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.loginWorkspaceProvider!
                                      .loginWorkspaceList!.data!.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return WorkspaceListItemView(
                                      workspace: widget
                                          .loginWorkspaceProvider!
                                          .loginWorkspaceList!
                                          .data!
                                          .data![index],
                                      animationController:
                                          widget.animationController!,
                                      animation:
                                          widget.animation as Animation<double>,
                                      index: index,
                                      count: widget
                                          .loginWorkspaceProvider!
                                          .loginWorkspaceList!
                                          .data!
                                          .data!
                                          .length,
                                      defaultWorkspace: widget
                                          .loginWorkspaceProvider!
                                          .getDefaultWorkspace(),
                                      onWorkspaceTap: () async {
                                        if (Provider.of<DashboardProvider>(
                                                    context,
                                                    listen: false)
                                                .outgoingIsCallConnected ||
                                            Provider.of<DashboardProvider>(
                                                    context,
                                                    listen: false)
                                                .incomingIsCallConnected) {
                                          showCallInProgressErrorDialog(
                                            () async {
                                              Utils
                                                  .cancelIncomingNotification();
                                              Utils
                                                  .cancelCallInProgressNotification();
                                              Utils.cancelSMSNotification();
                                              voiceClient.disConnect();
                                              // if (widget.loginWorkspaceProvider
                                              //             .getWorkspaceList()[
                                              //                 index]
                                              //             .status !=
                                              //         null &&
                                              //     widget.loginWorkspaceProvider
                                              //             .getWorkspaceList()[
                                              //                 index]
                                              //             .status ==
                                              //         "Active") {

                                              _switchWorkSpace(widget
                                                  .loginWorkspaceProvider!
                                                  .loginWorkspaceList!
                                                  .data!
                                                  .data![index]);
                                              // } else {
                                              //   print(
                                              //       "this is workspace switch 3");
                                              //   showWorkspaceDeletedDialog(
                                              //       index);
                                              // }
                                            },
                                          );
                                        } else {
                                          Utils.cancelIncomingNotification();
                                          Utils
                                              .cancelCallInProgressNotification();
                                          Utils.cancelSMSNotification();
                                          // if (widget.loginWorkspaceProvider
                                          //     .getWorkSpaceStatus(widget
                                          //         .loginWorkspaceProvider
                                          //         .getWorkspaceList()[index])) {
                                          Utils.cPrint(
                                              "this is workspaceswitch");
                                          _switchWorkSpace(widget
                                              .loginWorkspaceProvider!
                                              .loginWorkspaceList!
                                              .data!
                                              .data![index]);
                                          // } else {
                                          //   showWorkspaceDeletedDialog(index);
                                          // }
                                        }
                                      },
                                    );
                                  },
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                  ),
                                ),
                              ),
                            )
                          else
                            Expanded(child: Container()),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space14.h,
                                Dimens.space0.w,
                                Dimens.space16.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            width: Dimens.space48.w,
                            height: Dimens.space48.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space2.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  child: RoundedNetworkImageHolder(
                                    width: Dimens.space48,
                                    height: Dimens.space48,
                                    iconUrl: CustomIcon.icon_profile,
                                    iconColor: CustomColors.callInactiveColor,
                                    iconSize: Dimens.space41,
                                    boxDecorationColor:
                                        CustomColors.mainDividerColor,
                                    containerAlignment: Alignment.bottomCenter,
                                    imageUrl: widget.loginWorkspaceProvider!
                                        .getUserProfilePicture()
                                        .trim(),
                                    onTap: () {
                                      panelControllerProfile.open();
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: Dimens.space0.w,
                                  bottom: Dimens.space0.w,
                                  child: Container(
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
                                    child: StreamBuilder<bool>(
                                      stream: widget.userProvider!
                                          .streamOnlineStatus!.stream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<bool> snapshot) {
                                        bool onlineStatus = false;
                                        if (snapshot.hasData) {
                                          onlineStatus = snapshot.data!;
                                          if (onlineStatus) {
                                            onlineStatus = widget.userProvider!
                                                .getUserOnlineStatus();
                                          }
                                        }
                                        return RoundedNetworkImageHolder(
                                          width: Dimens.space15,
                                          height: Dimens.space15,
                                          iconUrl: Icons.circle,
                                          iconColor: onlineStatus
                                              ? CustomColors.callAcceptColor
                                              : Colors.grey,
                                          iconSize: Dimens.space12,
                                          boxDecorationColor:
                                              CustomColors.mainColor,
                                          outerCorner: Dimens.space300,
                                          innerCorner: Dimens.space300,
                                          imageUrl: "",
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: NavigationContentWidget(
                        zoomDrawerController: widget.zoomDrawerController!,
                        loginWorkspaceProvider: widget.loginWorkspaceProvider!,
                        animation: widget.animation!,
                        animationController: widget.animationController!,
                        onWorkSpaceTitleTap: () {
                          widget.contactsProvider!
                              .doEmptyAllContactApiCall()
                              .then((value) {
                            widget.contactsProvider!
                                .doAllContactApiCall()
                                .then((value) {
                              setState(() {});
                            });
                          });

                          widget.memberProvider!
                              .doEmptyMemberOnChannelChanged()
                              .then((value) {
                            widget.memberProvider!
                                .doGetAllWorkspaceMembersApiCall(
                                    widget.memberProvider!.getMemberId())
                                .then((value) {
                              setState(() {});
                            });
                          });
                          panelControllerWorkspace.open();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Container(
            color: CustomColors.white,
          ),
        Positioned(
          top: Dimens.space0,
          right: Dimens.space0,
          bottom: Dimens.space0,
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space40.h,
                  Dimens.space0.w, Dimens.space40.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              width: Dimens.space45.w,
              height: MediaQuery.of(context).size.height.h,
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space16.r),
                  bottomLeft: Radius.circular(Dimens.space16.r),
                ),
                border: Border.all(
                  width: Dimens.space0.w,
                  color: CustomColors.transparent!,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimens.space16.r),
                      ),
                      border: Border.all(
                        width: Dimens.space0.w,
                        color: CustomColors.transparent!,
                      ),
                    ),
                    width: kToolbarHeight.w,
                    height: kToolbarHeight.w,
                    child: TextButton(
                      onPressed: () {
                        if (isClickAble()) {
                          widget.zoomDrawerController!.close!();
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space16.h,
                            Dimens.space16.w,
                            Dimens.space16.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Icon(
                          Icons.menu,
                          color: CustomColors.textSecondaryColor,
                          size: Dimens.space24.w,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: CustomColors.mainDividerColor,
                    thickness: Dimens.space1.h,
                    height: Dimens.space1.h,
                  )
                ],
              ),
            ),
          ),
        ),
        SlidingUpPanel(
          maxHeight: ScreenUtil().screenHeight - Dimens.space50,
          minHeight: Dimens.space0.h,
          backdropColor: CustomColors.black!,
          backdropEnabled: true,
          parallaxEnabled: true,
          parallaxOffset: .5,
          controller: panelControllerWorkspace,
          color: CustomColors.white!,
          panelBuilder: (sc) {
            return WorkSpaceDetailsDialog(
              onWorkspaceUpdateCallback: () {
                widget.loginWorkspaceProvider!
                    .doGetWorkSpaceListApiCall(
                        widget.loginWorkspaceProvider!.getLoginUserId())
                    .then((value) {
                  setState(() {});
                });
              },
              scrollController: sc,
              loginWorkspaceProvider: widget.loginWorkspaceProvider!,
              contactsProvider: widget.contactsProvider!,
              memberProvider: widget.memberProvider!,
              onIncomingTap: () {
                widget.onIncomingTap!();
              },
              onOutgoingTap: () {
                widget.onOutgoingTap!();
              },
            );
          },
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space12.r),
            topRight: Radius.circular(Dimens.space12.r),
          ),
          onPanelSlide: (double pos) {},
          onPanelClosed: () {
            setState(() {});
          },
        ),
        SlidingUpPanel(
          maxHeight: ScreenUtil().screenHeight - Dimens.space50,
          minHeight: Dimens.space0.h,
          backdropColor: CustomColors.black!,
          backdropEnabled: true,
          parallaxEnabled: true,
          parallaxOffset: .5,
          controller: panelControllerProfile,
          color: CustomColors.white!,
          panelBuilder: (sc) {
            return UserProfileDialog(
              scrollController: sc,
              onProfileUpdateCallback: () {
                setState(() {});
              },
              onChangeImage: () {
                if (Platform.isIOS) {
                  _askPermissionPhotos();
                } else {
                  _askPermissionStorage();
                }
              },
              onIncomingTap: () {
                widget.onIncomingTap!();
              },
              onOutgoingTap: () {
                widget.onOutgoingTap!();
              },
              onLogOut: () async {
                if (panelControllerProfile.isPanelShown) {
                  panelControllerProfile.close();
                }
                widget.onLogout!();
                // Future.delayed(const Duration(milliseconds:100), () async {
                //   // await Navigator.of(context).pop();
                //   if (widget.outgoingIsCallConnected || widget.incomingIsCallConnected) {
                //     showCallInProgressErrorLogoutDialog(() {
                //       // This is logout error
                //       voiceClient.disConnect();
                //       widget.userProvider.onLogout(context: context);
                //     });
                //   } else {
                //     // This is okay
                //     widget.userProvider.onLogout(context: context);
                //   }
                // });
              },
              selectedImage: selectedFilePath,
            );
          },
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space12.r),
            topRight: Radius.circular(Dimens.space12.r),
          ),
          onPanelSlide: (double pos) {
            selectedFilePath = "";
          },
          onPanelClosed: () {
            selectedFilePath = "";

            // setState(() {});
          },
        ),
      ],
    );
  }

  Future<void> getOnlineConnection() async {
    deBouncer.run(() async {
      // await widget.memberProvider
      //     .doGetAllWorkspaceMembersApiCall(widget.memberProvider.getMemberId());
      final bool onlineConnection =
          widget.memberProvider!.getMemberOnlineStatus();
      final bool stayOnline = PsSharedPreferences.instance!.shared!
          .getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS)!;
      webSocketController.send(sendScreen: "Zoom Scaffold");
    });
  }

  Future<void> showCallInProgressErrorDialog(VoidCallback callback) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CallInProgressErrorDialog(
          onTap: () {
            Navigator.of(context).pop();
            callback();
          },
        );
      },
    );
  }

  Future<void> showCallInProgressErrorLogoutDialog(
      VoidCallback callback) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CallInProgressErrorLogoutDialog(
          onTap: () {
            Navigator.of(context).pop();
            callback();
          },
        );
      },
    );
  }

  Future<void> showWorkspaceDeletedDialog(int index) async {
    await showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => WorkspaceDeleteDialog(
        planOverviewData: widget.loginWorkspaceProvider!.loginWorkspaceList!
            .data!.data![index].plan!,
        workspaceName: widget.loginWorkspaceProvider!.loginWorkspaceList!.data!
            .data![index].title!,
      ),
    );
  }

  Future<void> _switchWorkSpace(LoginWorkspace loginWorkspace) async {
    final bool connectivity = await Utils.checkInternetConnectivity();
    if (connectivity) {
      Utils.cancelIncomingNotification();
      Utils.cancelCallInProgressNotification();
      Utils.cancelSMSNotification();
      Utils.cancelVoiceMailNotification();
      Utils.cancelMissedCallNotification();
      Utils.cancelChatMessageNotification();
      voiceClient.disConnect();
      await PsProgressDialog.showDialog(context, isDissmissable: false);

      final Resources<Member>? workspaceLoginData =
          await widget.loginWorkspaceProvider!.doWorkSpaceLogin(
        WorkSpaceRequestParamHolder(
          authToken: widget.loginWorkspaceProvider!.getApiToken(),
          workspaceId: loginWorkspace.id!,
          memberId: loginWorkspace.memberId!,
        ).toMap(),
      );

      if (workspaceLoginData!.data != null &&
          workspaceLoginData.data!.data != null &&
          workspaceLoginData.data!.data!.data != null) {
        widget.loginWorkspaceProvider!
            .replaceDefaultWorkspace(loginWorkspace.id);
        webSocketController.onClose();

        ///Refresh Permission
        await widget.loginWorkspaceProvider!.doGetUserPermissions();

        ///Refresh Plan Restriction
        await widget.userProvider!.doGetPlanRestriction();

        ///Refresh Workspace List
        await widget.loginWorkspaceProvider!.doGetWorkSpaceListApiCall(
            widget.loginWorkspaceProvider!.getLoginUserId());

        ///Refresh Plan OverView
        await widget.loginWorkspaceProvider!.doPlanOverViewApiCall();

        ///Refresh Workspace Detail
        final Resources<Workspace>? workspaceDetail =
            await widget.loginWorkspaceProvider!.doWorkSpaceDetailApiCall(
          workspaceLoginData.data!.data!.data!.accessToken!,
        );

        if (workspaceDetail != null &&
            workspaceDetail.data != null &&
            workspaceDetail.data!.workspace != null &&
            workspaceDetail.data!.workspace!.data != null) {
          ///Refresh User Detail
          final Resources<UserProfileData> profileData =
              await widget.userProvider!.getUserProfileDetails();

          if (profileData.data != null) {
            webSocketController.initWebSocketConnection();
            getOnlineConnection();
            webSocketController.sendData("Drawer View");
          }
          final Resources<ChannelData>? channelList =
              await widget.loginWorkspaceProvider!.doChannelListApiCall(
                  widget.loginWorkspaceProvider!.getCallAccessToken());
          if (channelList != null &&
              channelList.data != null &&
              channelList.data!.data != null) {
            setState(() {});
            if (channelList.data != null &&
                channelList.data!.data != null &&
                channelList.data!.data!.isNotEmpty) {
              DashboardView.workspaceOrChannelChanged.fire(
                SubscriptionWorkspaceOrChannelChanged(
                  event: "workspaceChanged",
                  workspaceChannel: channelList.data!.data![0],
                ),
              );
            } else {
              DashboardView.workspaceOrChannelChanged.fire(
                SubscriptionWorkspaceOrChannelChanged(
                  event: "workspaceChanged",
                ),
              );
            }
            setState(() {});
            PsProgressDialog.dismissDialog();
          } else {
            DashboardView.workspaceOrChannelChanged.fire(
              SubscriptionWorkspaceOrChannelChanged(
                event: "workspaceChanged",
              ),
            );
            setState(() {});
            PsProgressDialog.dismissDialog();
          }
        } else {
          DashboardView.workspaceOrChannelChanged.fire(
            SubscriptionWorkspaceOrChannelChanged(
              event: "workspaceChanged",
            ),
          );
          setState(() {});
          PsProgressDialog.dismissDialog();
        }
      } else {
        setState(() {});
        PsProgressDialog.dismissDialog();
      }
      // CustomAppBar.changeStatusColor(CustomColors.white);
      Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
    } else {
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }

  bool isClickAble() {
    if (widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .loginWorkspaceReview!
            .reviewStatus!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus!
                .toLowerCase() ==
            "under review") {
      return false;
    } else if (widget.loginWorkspaceProvider!.getWorkspaceDetail().plan !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
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

class NavigationContentWidget extends StatefulWidget {
  final ZoomDrawerController? zoomDrawerController;
  final Function? onWorkSpaceTitleTap;
  final LoginWorkspaceProvider? loginWorkspaceProvider;
  final AnimationController? animationController;
  final Animation? animation;

  const NavigationContentWidget({
    Key? key,
    @required this.zoomDrawerController,
    this.onWorkSpaceTitleTap,
    this.loginWorkspaceProvider,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  NavigationContentWidgetState createState() => NavigationContentWidgetState();
}

class NavigationContentWidgetState extends State<NavigationContentWidget>
    with TickerProviderStateMixin {
  bool searchVisibility = false;
  TextEditingController controllerSearchTeams = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      widget.loginWorkspaceProvider!.getChannelList();
    });
    controllerSearchTeams.addListener(() {
      widget.loginWorkspaceProvider!
          .doSearchChannelFromDB(controllerSearchTeams.text)
          .then((value) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        color: CustomColors.baseLightColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space16.r),
          topRight: Radius.circular(Dimens.space0.r),
        ),
        border: Border.all(
          width: Dimens.space0.w,
          color: CustomColors.transparent!,
        ),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (isClickAble()) {
                widget.onWorkSpaceTitleTap!();
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(Dimens.space18.w, Dimens.space14.h,
                  Dimens.space18.w, Dimens.space0.h),
              decoration: BoxDecoration(
                color: getContainerColor(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space16.r),
                  bottomRight: Radius.circular(Dimens.space16.r),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space50.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h,
                          ),
                          child: Row(
                            children: [
                              Offstage(
                                offstage: isClickAble(),
                                child: Container(
                                  width: Dimens.space20.w,
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                  ),
                                  child: Icon(
                                    Icons.warning,
                                    size: Dimens.space20.w,
                                    color: CustomColors.white,
                                  ),
                                ),
                              ),
                              Expanded(
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
                                            color: isClickAble()
                                                ? CustomColors.textPrimaryColor
                                                : CustomColors.white,
                                            fontFamily: Config.manropeExtraBold,
                                            fontSize: Dimens.space18.sp,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                      text: Config.checkOverFlow
                                          ? Const.OVERFLOW
                                          : widget.loginWorkspaceProvider!
                                                          .getWorkspaceDetail()
                                                          .title !=
                                                      null &&
                                                  widget.loginWorkspaceProvider!
                                                      .getWorkspaceDetail()
                                                      .title!
                                                      .isNotEmpty
                                              ? widget.loginWorkspaceProvider!
                                                  .getWorkspaceDetail()
                                                  .title
                                              : Utils.getString("appName"),
                                    ),
                                  ),
                                ),
                              ),
                              if (isClickAble())
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space10.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  child: RoundedNetworkImageHolder(
                                    width: Dimens.space18,
                                    height: Dimens.space18,
                                    iconUrl: CustomIcon.icon_more,
                                    iconColor: CustomColors.textQuaternaryColor,
                                    iconSize: Dimens.space18,
                                    boxDecorationColor:
                                        CustomColors.transparent,
                                    outerCorner: Dimens.space0,
                                    innerCorner: Dimens.space0,
                                    imageUrl: "",
                                    onTap: () {
                                      widget.onWorkSpaceTitleTap!();
                                    },
                                  ),
                                )
                              else
                                Container(),
                            ],
                          ),
                        ),
                        if (getWorkspaceStatus() == WorkspaceStatus.ACTIVE)
                          Container()
                        else if (getWorkspaceStatus() ==
                            WorkspaceStatus.SUSPENDED)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space50.w,
                                    Dimens.space0.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space14.h,
                                  ),
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : Utils.getString("lowCreditMessage"),
                                    maxLines: 5,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.white,
                                          fontFamily: Config.heeboRegular,
                                          fontStyle: FontStyle.normal,
                                          fontSize: Dimens.space12.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (getWorkspaceStatus() ==
                            WorkspaceStatus.EXPIRED)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space50.w,
                                    Dimens.space0.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space14.h,
                                  ),
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : isYearly()
                                            ? Utils.getString(
                                                "expiredYearlySubsDesc")
                                            : Utils.getString(
                                                "expiredMonthlySubsDesc"),
                                    maxLines: 5,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.white,
                                          fontFamily: Config.heeboRegular,
                                          fontStyle: FontStyle.normal,
                                          fontSize: Dimens.space12.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (getWorkspaceStatus() ==
                            WorkspaceStatus.CANCELLED)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space50.w,
                                    Dimens.space14.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                  ),
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : Utils.getString("cancelledSubsDesc"),
                                    maxLines: 5,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.white,
                                          fontFamily: Config.heeboRegular,
                                          fontStyle: FontStyle.normal,
                                          fontSize: Dimens.space12.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (getWorkspaceStatus() ==
                            WorkspaceStatus.UNDER_REVIEW)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space50.w,
                                    Dimens.space0.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space14.h,
                                  ),
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : Utils.getString(
                                            "workspaceUnderReviewDesc"),
                                    maxLines: 5,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.white,
                                          fontFamily: Config.heeboRegular,
                                          fontStyle: FontStyle.normal,
                                          fontSize: Dimens.space12.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (getWorkspaceStatus() ==
                            WorkspaceStatus.DELETED)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space50.w,
                                    Dimens.space14.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                  ),
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : Utils.getString(
                                            "workspaceDeletedDesc"),
                                    maxLines: 5,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.white,
                                          fontFamily: Config.heeboRegular,
                                          fontStyle: FontStyle.normal,
                                          fontSize: Dimens.space12.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space50.w,
                                    Dimens.space14.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                  ),
                                  child: Text(
                                    Config.checkOverFlow
                                        ? Const.OVERFLOW
                                        : Utils.getString(
                                            "workspaceDeletedDesc"),
                                    maxLines: 5,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: CustomColors.white,
                                          fontFamily: Config.heeboRegular,
                                          fontStyle: FontStyle.normal,
                                          fontSize: Dimens.space12.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(Dimens.space18.w, Dimens.space0.h,
                Dimens.space50.w, Dimens.space0.h),
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space15.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space4.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space14,
                    height: Dimens.space14,
                    boxFit: BoxFit.fitWidth,
                    iconUrl: CustomIcon.icon_arrow_down,
                    iconColor: CustomColors.textTertiaryColor,
                    iconSize: Dimens.space12,
                    boxDecorationColor: CustomColors.transparent,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                  ),
                ),
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
                          : Utils.getString("numbers").toUpperCase(),
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: isClickAble()
                                ? CustomColors.textTertiaryColor
                                : CustomColors.textQuinaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space14.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space12.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child:
                      widget.loginWorkspaceProvider!.getChannelList() != null &&
                              widget.loginWorkspaceProvider!
                                  .getChannelList()!
                                  .isNotEmpty
                          ? RoundedNetworkImageHolder(
                              width: Dimens.space20,
                              height: Dimens.space20,
                              boxFit: BoxFit.fitWidth,
                              iconUrl: searchVisibility
                                  ? Icons.close
                                  : CustomIcon.icon_search,
                              iconColor: CustomColors.textTertiaryColor,
                              iconSize: Dimens.space14,
                              boxDecorationColor: CustomColors.transparent,
                              outerCorner: Dimens.space0,
                              innerCorner: Dimens.space0,
                              imageUrl: "",
                              onTap: () {
                                if (searchVisibility) {
                                  searchVisibility = false;
                                  widget.loginWorkspaceProvider!
                                      .doSearchChannelFromDB("")
                                      .then((value) {
                                    controllerSearchTeams.text = "";
                                    setState(() {});
                                  });
                                } else {
                                  searchVisibility = true;
                                }
                                setState(() {});
                              },
                            )
                          : Container(),
                ),
              ],
            ),
          ),
          widget.loginWorkspaceProvider!.getChannelList() != null &&
                  widget.loginWorkspaceProvider!.getChannelList()!.isNotEmpty
              ? Visibility(
                  visible: searchVisibility,
                  child: Container(
                    color: Colors.white,
                    height: Dimens.space40.h,
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space5.h, Dimens.space62.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: CustomSearchFieldWidgetWithIconColor(
                      animationController: widget.animationController,
                      textEditingController: controllerSearchTeams,
                      customIcon: CustomIcon.icon_search,
                      hint: Utils.getString("searchByNameNumber"),
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                Dimens.space18.w,
                Dimens.space0.h,
                Dimens.space62.w,
                Dimens.space5.h,
              ),
              child: Column(
                children: <Widget>[
                  if (widget.loginWorkspaceProvider!.channelList != null &&
                      widget.loginWorkspaceProvider!.channelList!.data !=
                          null &&
                      widget.loginWorkspaceProvider!.channelList!.data!.data !=
                          null &&
                      widget.loginWorkspaceProvider!.channelList!.data!.data!
                          .isNotEmpty)
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space14.h,
                          Dimens.space0.w,
                          Dimens.space0.h,
                        ),
                        padding: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space0.w,
                          Dimens.space0.h,
                        ),
                        child: ListView.builder(
                          itemCount: widget.loginWorkspaceProvider!.channelList!
                              .data!.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final WorkspaceChannel workspaceChannel = widget
                                .loginWorkspaceProvider!
                                .getDefaultChannel();
                            if (workspaceChannel != null) {
                              return WorkspaceNumberListItemView(
                                workspaceChannel: widget.loginWorkspaceProvider!
                                    .channelList!.data!.data![index],
                                animationController:
                                    widget.animationController!,
                                animation:
                                    widget.animation as Animation<double>,
                                selectedChannel: workspaceChannel,
                                count: widget.loginWorkspaceProvider!
                                    .channelList!.data!.data!.length,
                                isWorkspaceSubscriptionActive: !isClickAble(),
                                onChannelTap: () {
                                  widget.loginWorkspaceProvider!
                                      .replaceDefaultChannel(
                                    json.encode(widget.loginWorkspaceProvider!
                                        .channelList!.data!.data![index]
                                        .toJson()),
                                  );

                                  DashboardView.workspaceOrChannelChanged.fire(
                                    SubscriptionWorkspaceOrChannelChanged(
                                      event: "channelChanged",
                                      workspaceChannel: widget
                                          .loginWorkspaceProvider!
                                          .channelList!
                                          .data!
                                          .data![index],
                                    ),
                                  );
                                  setState(() {});
                                  if (isClickAble()) {
                                    widget.zoomDrawerController!.toggle!();
                                  }
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h,
                          ),
                        ),
                      ),
                    )
                  else if (widget.loginWorkspaceProvider!.getChannelList() !=
                          null &&
                      widget.loginWorkspaceProvider!
                          .getChannelList()!
                          .isNotEmpty &&
                      controllerSearchTeams.text.isNotEmpty)
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space17.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      width: Dimens.space274.w,
                      height: Dimens.space130.w,
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space8.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
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
                            child: PlainAssetImageHolder(
                              assetUrl:
                                  "assets/images/icon_no_search_results.png",
                              width: Dimens.space48,
                              height: Dimens.space48,
                              assetWidth: Dimens.space48,
                              assetHeight: Dimens.space48,
                              boxFit: BoxFit.contain,
                              outerCorner: Dimens.space0,
                              innerCorner: Dimens.space0,
                              iconSize: Dimens.space152,
                              iconUrl: CustomIcon.icon_gallery,
                              iconColor: CustomColors.white,
                              boxDecorationColor: CustomColors.transparent,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space14.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Text(
                              Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : Utils.getString("noSearchResults"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: Dimens.space14.sp,
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.heeboRegular,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space17.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      decoration: BoxDecoration(
                        color: CustomColors.mainDividerColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space8.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space24.h,
                                Dimens.space0.w,
                                Dimens.space14.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Icon(
                              CustomIcon.icon_empty_number,
                              size: Dimens.space48.w,
                              color: CustomColors.textQuaternaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Utils.lunchWebUrl(
                                url: PSApp.config!.imageUrl,
                                context: context,
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space20.w,
                                  Dimens.space0.h,
                                  Dimens.space20.w,
                                  Dimens.space25.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: RichText(
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      Utils.getString("youHaveNotBeenAssigned"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: CustomColors.textTertiaryColor,
                                          fontFamily: Config.heeboRegular,
                                          fontSize: Dimens.space14.sp,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: Utils.getString(""),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color:
                                                CustomColors.loadingCircleColor,
                                            fontFamily: Config.heeboRegular,
                                            fontSize: Dimens.space14.sp,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isClickAble() {
    if (widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .loginWorkspaceReview!
            .reviewStatus!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus!
                .toLowerCase() ==
            "under review") {
      return false;
    } else if (widget.loginWorkspaceProvider!.getWorkspaceDetail().plan !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive!
                .toLowerCase() ==
            "active") {
      if (widget.loginWorkspaceProvider!
              .getWorkspaceDetail()
              .plan!
              .currentCredit! <=
          0.2) {
        return false;
      } else if (widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .loginWorkspaceReview !=
              null &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .loginWorkspaceReview!
                  .reviewStatus !=
              null &&
          widget.loginWorkspaceProvider!
              .getWorkspaceDetail()
              .loginWorkspaceReview!
              .reviewStatus!
              .isNotEmpty &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .loginWorkspaceReview!
                  .reviewStatus!
                  .toLowerCase() ==
              "under review") {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Color getContainerColor() {
    if (widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .loginWorkspaceReview!
            .reviewStatus!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus!
                .toLowerCase() ==
            "under review") {
      return CustomColors.warningColor!;
    } else if (widget.loginWorkspaceProvider!.getWorkspaceDetail().plan !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive!
                .toLowerCase() ==
            "active") {
      if (widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .plan!
                  .currentCredit !=
              null &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .plan!
                  .currentCredit! >
              0.2) {
        return CustomColors.baseLightColor!;
      } else {
        return CustomColors.callDeclineColor!;
      }
    } else if (widget.loginWorkspaceProvider!.getWorkspaceDetail().plan !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive!
                .toLowerCase() ==
            "expired") {
      return CustomColors.expiredColor!;
    } else if (widget.loginWorkspaceProvider!.getWorkspaceDetail().plan !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive!
                .toLowerCase() ==
            "cancelled") {
      return CustomColors.callDeclineColor!;
    } else {
      return CustomColors.callDeclineColor!;
    }
  }

  WorkspaceStatus getWorkspaceStatus() {
    if (widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview !=
            null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .loginWorkspaceReview!
            .reviewStatus!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .loginWorkspaceReview!
                .reviewStatus!
                .toLowerCase() ==
            "under review") {
      return WorkspaceStatus.UNDER_REVIEW;
    } else if (widget.loginWorkspaceProvider!.getWorkspaceDetail().status !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .status!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!.getWorkspaceDetail().plan != null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty) {
      if (widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .loginWorkspaceReview !=
              null &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .loginWorkspaceReview!
                  .reviewStatus !=
              null &&
          widget.loginWorkspaceProvider!
              .getWorkspaceDetail()
              .loginWorkspaceReview!
              .reviewStatus!
              .isNotEmpty &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .loginWorkspaceReview!
                  .reviewStatus!
                  .toLowerCase() ==
              "under review") {
        return WorkspaceStatus.UNDER_REVIEW;
      } else if (widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .status!
                  .toLowerCase() ==
              "active" &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .plan!
                  .subscriptionActive!
                  .toLowerCase() ==
              "active") {
        if (widget.loginWorkspaceProvider!
                    .getWorkspaceDetail()
                    .plan!
                    .currentCredit !=
                null &&
            widget.loginWorkspaceProvider!
                    .getWorkspaceDetail()
                    .plan!
                    .currentCredit! >
                0.2) {
          return WorkspaceStatus.ACTIVE;
        } else {
          return WorkspaceStatus.SUSPENDED;
        }
      } else if (widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .status!
                  .toLowerCase() ==
              "active" &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .plan!
                  .subscriptionActive!
                  .toLowerCase() ==
              "expired") {
        return WorkspaceStatus.EXPIRED;
      } else if (widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .status!
                  .toLowerCase() ==
              "active" &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .plan!
                  .subscriptionActive!
                  .toLowerCase() ==
              "inactive") {
        return WorkspaceStatus.CANCELLED;
      } else if (widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .status!
                  .toLowerCase() ==
              "inactive" &&
          widget.loginWorkspaceProvider!
                  .getWorkspaceDetail()
                  .plan!
                  .subscriptionActive!
                  .toLowerCase() ==
              "inactive") {
        return WorkspaceStatus.DELETED;
      } else {
        return WorkspaceStatus.DELETED;
      }
    } else {
      return WorkspaceStatus.DELETED;
    }
  }

  bool isYearly() {
    if (widget.loginWorkspaceProvider!.getWorkspaceDetail().plan != null &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .subscriptionActive !=
            null &&
        widget.loginWorkspaceProvider!
            .getWorkspaceDetail()
            .plan!
            .subscriptionActive!
            .isNotEmpty &&
        widget.loginWorkspaceProvider!
                .getWorkspaceDetail()
                .plan!
                .planDetail!
                .interval!
                .toLowerCase() ==
            "year") {
      return true;
    } else {
      return false;
    }
  }
}
