import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_cropper/image_cropper.dart";
import "package:image_picker/image_picker.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/TagsItemWidget.dart";
import "package:mvp/ui/common/dialog/BlockContactDialog.dart";
import "package:mvp/ui/common/dialog/ChannelSelectionDialog.dart";
import "package:mvp/ui/common/dialog/ContactDeleteBlockDialog.dart";
import "package:mvp/ui/common/dialog/CustomOverlayToastWidget.dart";
import "package:mvp/ui/common/dialog/DndMuteDialog.dart";
import "package:mvp/ui/common/dialog/DndUnMuteDialog.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/ui/common/shimmer/contactShimmer.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/intent_holder/AddNotesIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EditContactIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MessageDetailIntentHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactResponse/BlockContactResponse.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/updateClientDNDRequestParamHolder/UpdateClientDndHolder.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/allNotes/Notes.dart";
import "package:mvp/viewObject/model/clientDndResponse/ClientDndResponse.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";

class ContactDetailDialog extends StatefulWidget {
  const ContactDetailDialog({
    Key? key,
    required this.channelId,
    required this.channelName,
    required this.channelNumber,
    required this.contactId,
    required this.contactNumber,
    required this.onContactUpdate,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
    required this.onContactBlock,
    required this.onContactDelete,
    required this.onMuteUnMuteCallBack,
    this.contact,
  }) : super(key: key);

  final String? channelId;
  final String? channelName;
  final String? channelNumber;
  final String? contactId;
  final String? contactNumber;
  final VoidCallback onContactUpdate;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final Function(bool) onContactBlock;
  final VoidCallback onContactDelete;
  final Function onMuteUnMuteCallBack;
  final Function(String, String, String, String, String, String, String, String,
      String, String) makeCallWithSid;
  final Contacts? contact;

  @override
  _ContactDetailDialogState createState() => _ContactDetailDialogState();
}

class _ContactDetailDialogState extends State<ContactDetailDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  CountryCode? selected;

  ContactsProvider? contactsProvider;
  ContactRepository? contactRepository;

  String? contactId;
  String? contactNumber;
  bool isLoading = false;

  File? _image;
  final _picker = ImagePicker();
  File? _selectedFile;
  String? selectedFilePath;

  @override
  void initState() {
    contactId = widget.contactId;
    contactNumber = widget.contactNumber;
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController!.forward();

    return ChangeNotifierProvider<ContactsProvider>(
      lazy: false,
      create: (BuildContext context) {
        contactsProvider =
            ContactsProvider(contactRepository: contactRepository);
        contactsProvider!
            .doGetContactDetailApiCall(contactId!, widget.contact!);
        contactsProvider!
            .doGetLastContactedApiCall(Map.from({"contact": contactNumber}));
        final ContactPinUnpinRequestHolder param = ContactPinUnpinRequestHolder(
          channel: widget.channelId,
          contact: contactNumber,
          pinned: false,
        );
        contactsProvider!.doGetAllNotesApiCall(param);
        return contactsProvider!;
      },
      child: Consumer<ContactsProvider>(builder:
          (BuildContext context, ContactsProvider? provider, Widget? child) {
        animationController!.forward();
        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: animationController!,
                curve:
                    const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
        if (!isLoading) {
          if (contactsProvider!.contactDetailResponse != null &&
              contactsProvider!.contactDetailResponse!.data != null) {
            return Container(
              height: ScreenUtil().screenHeight - Dimens.space50.h,
              width: ScreenUtil().screenWidth,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space28.h,
                  Dimens.space0.w, Dimens.space0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.space16.r),
                  topRight: Radius.circular(Dimens.space16.r),
                ),
                color: CustomColors.white,
              ),
              child: SingleChildScrollView(
                child: ContactDetailWidget(
                  contactsProvider: contactsProvider!,
                  animationController: animationController!,
                  animation: animation,
                  clientId: contactId!,
                  contact: contactsProvider!.contactDetailResponse!.data!,
                  selectedCountryCode: selected,
                  onEditProfilePicture: () {
                    if (Platform.isIOS) {
                      _askPermissionPhotos();
                    } else {
                      _askPermissionStorage();
                    }
                  },
                  notes: contactsProvider!.notes != null &&
                          contactsProvider!.notes!.data != null
                      ? contactsProvider!.notes!.data!
                      : [],
                  onMuteTap: () async {
                    Utils.checkInternetConnectivity().then((data) async {
                      if (data) {
                        _showMuteDialog(
                          context: context,
                          clientName: contactsProvider!
                              .contactDetailResponse!.data!.name,
                          onMuteTap: (int minutes, bool value) {
                            onMuteTap(minutes, value);
                          },
                        );
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  onUnMuteTap: () {
                    Utils.checkInternetConnectivity().then((data) async {
                      if (data) {
                        _showUnMuteDialog(
                          context: context,
                          clientName: contactsProvider!
                                  .contactDetailResponse!.data!.name ??
                              contactsProvider!
                                  .contactDetailResponse!.data!.number!,
                          dndEndTime: contactsProvider!
                              .contactDetailResponse!.data!.dndInfo!.dndEndtime,
                          onUnMuteTap: (bool value) {
                            onMuteTap(0, value);
                          },
                        );
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  onNotesTap: () async {
                    Utils.checkInternetConnectivity().then((data) async {
                      if (data) {
                        final dynamic returnData = await Navigator.pushNamed(
                          context,
                          RoutePaths.notesList,
                          arguments: AddNotesIntentHolder(
                            channelId: widget.channelId,
                            clientId: contactId,
                            number: contactsProvider!
                                        .contactDetailResponse!.data! !=
                                    null
                                ? contactsProvider!
                                    .contactDetailResponse!.data!.number!
                                : contactNumber!,
                            onIncomingTap: () {
                              widget.onIncomingTap();
                            },
                            onOutgoingTap: () {
                              widget.onOutgoingTap();
                            },
                          ),
                        );

                        if (returnData != null &&
                            returnData["data"] != null &&
                            returnData["data"] as bool) {
                          Utils.checkInternetConnectivity().then((data) async {
                            if (data) {
                              contactsProvider!
                                  .doContactDetailApiCall(contactId);
                              contactsProvider!.doGetLastContactedApiCall(
                                  Map.from({"contact": contactNumber}));
                              final ContactPinUnpinRequestHolder param =
                                  ContactPinUnpinRequestHolder(
                                channel: widget.channelId,
                                contact: contactNumber,
                                pinned: false,
                              );
                              contactsProvider!.doGetAllNotesApiCall(param);
                              setState(() {});
                            } else {
                              Utils.showWarningToastMessage(
                                  Utils.getString("noInternet"), context);
                            }
                          });
                        }
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  onMessageTap: () async {
                    Utils.checkInternetConnectivity().then((data) async {
                      if (data) {
                        final dynamic returnData = await Navigator.pushNamed(
                          context,
                          RoutePaths.messageDetail,
                          arguments: MessageDetailIntentHolder(
                              channelId: widget.channelId,
                              channelName: widget.channelName,
                              channelNumber: widget.channelNumber,
                              clientName: contactsProvider!
                                      .contactDetailResponse!.data!.name ??
                                  contactsProvider!
                                      .contactDetailResponse!.data!.number,
                              clientPhoneNumber: contactsProvider!
                                  .contactDetailResponse!.data!.number,
                              clientProfilePicture: contactsProvider!
                                      .contactDetailResponse!
                                      .data!
                                      .profilePicture ??
                                  "",
                              countryId: contactsProvider!
                                  .contactDetailResponse!.data!.country,
                              isBlocked: contactsProvider!
                                  .contactDetailResponse!.data!.blocked,
                              lastChatted: contactsProvider!
                                      .contactDetailResponse!.data!.createdOn ??
                                  DateTime.now().toString(),
                              clientId: contactsProvider!
                                  .contactDetailResponse!.data!.id,
                              // dndMissed:
                              //     contactsProvider
                              //         .contactDetailResponse.data.dndMissed,
                              isContact: true,
                              onIncomingTap: () {
                                widget.onIncomingTap();
                              },
                              onOutgoingTap: () {
                                widget.onOutgoingTap();
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
                              onContactBlocked: (value) {
                                contactsProvider!
                                    .doContactDetailApiCall(contactId);
                                widget.onContactBlock(value);
                                setState(() {});
                              }),
                        );
                        Utils.checkInternetConnectivity().then((data) async {
                          if (data) {
                            if (returnData != null &&
                                returnData["data"] != null &&
                                returnData["data"] as bool) {
                              contactsProvider!
                                  .doContactDetailApiCall(contactId);
                              contactsProvider!.doGetLastContactedApiCall(
                                Map.from({"contact": contactNumber}),
                              );
                              final ContactPinUnpinRequestHolder param =
                                  ContactPinUnpinRequestHolder(
                                channel: widget.channelId,
                                contact: contactNumber,
                                pinned: false,
                              );
                              contactsProvider!.doGetAllNotesApiCall(param);
                            }
                          } else {
                            Utils.showWarningToastMessage(
                                Utils.getString("noInternet"), context);
                          }
                        });
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  onMakeCallTap: () async {
                    Utils.checkInternetConnectivity().then((value) async {
                      if (value) {
                        if (contactsProvider!.getChannelList() != null &&
                            contactsProvider!.getChannelList()!.isNotEmpty) {
                          if (contactsProvider!.getChannelList()!.length == 1) {
                            widget.makeCallWithSid(
                              contactsProvider!.getDefaultChannel().number!,
                              contactsProvider!.getDefaultChannel().name!,
                              contactsProvider!.getDefaultChannel().id!,
                              contactsProvider!
                                  .contactDetailResponse!.data!.number!,
                              contactsProvider!.getDefaultWorkspace(),
                              contactsProvider!.getMemberId(),
                              contactsProvider!.getVoiceToken()!,
                              contactsProvider!
                                  .contactDetailResponse!.data!.name!,
                              contactsProvider!
                                  .contactDetailResponse!.data!.id!,
                              contactsProvider!.contactDetailResponse!.data!
                                              .profilePicture !=
                                          null &&
                                      contactsProvider!.contactDetailResponse!
                                          .data!.profilePicture!.isNotEmpty
                                  ? contactsProvider!.contactDetailResponse!
                                      .data!.profilePicture!
                                  : "",
                            );
                          } else {
                            _channelSelectionDialog(
                              context: context,
                              channelList: contactsProvider!.getChannelList(),
                            );
                          }
                        } else {
                          Utils.showToastMessage(
                              Utils.getString("emptyChannel"));
                        }
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  onDeleteBlockTap: () async {
                    Utils.checkInternetConnectivity().then((data) async {
                      if (data) {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimens.space16.r),
                          ),
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return ContactDeleteBlockDialog(
                              blocked: contactsProvider!
                                  .contactDetailResponse!.data!.blocked!,
                              onBlockTap: (value) async {
                                Navigator.pop(context);
                                isLoading = true;
                                setState(() {});
                                if (await Utils.checkInternetConnectivity()) {
                                  final Resources<BlockContactResponse>
                                      responseBlockContact =
                                      await contactsProvider!
                                          .doBlockContactApiCall(
                                    BlockContactRequestHolder(
                                      // contactId: contactsProvider
                                      //     .contactDetailResponse
                                      //     .data
                                      //     .id,
                                      data: BlockContactRequestParamHolder(
                                        isBlock: !contactsProvider!
                                            .contactDetailResponse!
                                            .data!
                                            .blocked!,
                                      ),
                                      number: contactsProvider!
                                          .contactDetailResponse!.data!.number!,
                                    ),
                                  );
                                  if (responseBlockContact.data != null) {
                                    contactsProvider!
                                        .doContactDetailApiCall(contactId);
                                    isLoading = false;
                                    setState(() {});
                                    Utils.showToastMessage(!contactsProvider!
                                            .contactDetailResponse!
                                            .data!
                                            .blocked!
                                        ? Utils.getString("blockContact")
                                        : Utils.getString("unblockContact"));
                                    widget.onContactBlock(value);
                                  } else if (responseBlockContact.message !=
                                      null) {
                                    isLoading = false;
                                    setState(() {});
                                    await PsProgressDialog.dismissDialog();
                                    showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorDialog(
                                          message: responseBlockContact.message,
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  Utils.showWarningToastMessage(
                                      Utils.getString("noInternet"), context);
                                }
                              },
                              onDeleteTap: () async {
                                Navigator.pop(context);
                                isLoading = true;
                                setState(() {});
                                if (await Utils.checkInternetConnectivity()) {
                                  final Resources<DeleteContactResponse>
                                      deleteContactResponse =
                                      await contactsProvider!.deleteContact([
                                    contactsProvider!
                                        .contactDetailResponse!.data!.id!,
                                  ]) as Resources<DeleteContactResponse>;
                                  if (deleteContactResponse.data != null) {
                                    /// Fire event for new leads counter
                                    DashboardView.workspaceOrChannelChanged
                                        .fire(
                                      SubscriptionWorkspaceOrChannelChanged(
                                        event: "channelChanged",
                                      ),
                                    );

                                    Utils.showToastMessage(
                                        Utils.getString("successfullyDeleted"));
                                    widget.onContactDelete();
                                  } else if (deleteContactResponse.message !=
                                      null) {
                                    await PsProgressDialog.dismissDialog();
                                    isLoading = false;
                                    setState(() {});
                                    showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorDialog(
                                          message:
                                              deleteContactResponse.message,
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  isLoading = false;
                                  setState(() {});
                                  Utils.showWarningToastMessage(
                                      Utils.getString("noInternet"), context);
                                }
                              },
                            );
                          },
                        );
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  onUnblockTap: () {
                    showBlockContactDialog(context);
                  },
                  onIncomingTap: () {
                    widget.onIncomingTap();
                  },
                  onOutgoingTap: () {
                    widget.onOutgoingTap();
                  },
                ),
              ),
            );
          } else {
            return SizedBox(
              height: ScreenUtil().screenHeight - Dimens.space50.h,
              width: ScreenUtil().screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: ScreenUtil().screenWidth,
                    child: const ContactDetailHeaderShimmer(),
                  ),
                  const ContactBarShimmer(),
                  Row(
                    children: const [
                      Flexible(
                        child: ButtonShimmer(),
                      ),
                      Flexible(
                        child: ButtonShimmer(),
                      ),
                      Flexible(
                        child: ButtonShimmer(),
                      ),
                    ],
                  ),
                  const ContactBarShimmer(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return index == 0 || index == 2
                              ? const ContactBarShimmer()
                              : const ContactShimmer();
                        }),
                  ),
                ],
              ),
            );
          }
        } else {
          return SizedBox(
            height: ScreenUtil().screenHeight - Dimens.space50.h,
            width: ScreenUtil().screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: ScreenUtil().screenWidth,
                  child: const ContactDetailHeaderShimmer(),
                ),
                const ContactBarShimmer(),
                Row(
                  children: const [
                    Flexible(
                      child: ButtonShimmer(),
                    ),
                    Flexible(
                      child: ButtonShimmer(),
                    ),
                    Flexible(
                      child: ButtonShimmer(),
                    ),
                  ],
                ),
                const ContactBarShimmer(),
                Expanded(
                  child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return index == 0 || index == 2
                            ? const ContactBarShimmer()
                            : const ContactShimmer();
                      }),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  void _channelSelectionDialog({
    BuildContext? context,
    List<WorkspaceChannel>? channelList,
  }) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * 0.48,
        child: ChannelSelectionDialog(
          channelList: channelList,
          onChannelTap: (WorkspaceChannel data) {
            widget.makeCallWithSid(
              data.number!,
              data.name!,
              data.id!,
              contactsProvider!.contactDetailResponse!.data!.number!,
              contactsProvider!.getDefaultWorkspace(),
              contactsProvider!.getMemberId(),
              contactsProvider!.getVoiceToken()!,
              contactsProvider!.contactDetailResponse!.data!.name!,
              contactsProvider!.contactDetailResponse!.data!.id!,
              contactsProvider!.contactDetailResponse!.data!.profilePicture ??
                  "",
            );
          },
        ),
      ),
    );
  }

  void _showUnMuteDialog({
    BuildContext? context,
    String? clientName,
    int? dndEndTime,
    Function? onUnMuteTap,
  }) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: ScreenUtil().screenHeight * 0.35,
        child: ClientDndUnMuteDialog(
          name: clientName,
          onUmMuteTap: () {
            Navigator.of(context).pop();
            onUnMuteTap!(true);
          },
          dndEndTime: dndEndTime,
        ),
      ),
    );
  }

  void showBlockContactDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return BlockContactDialog(
          isBlocked: true,
          onBlockTap: (value) async {
            Navigator.pop(dialogContext);
            isLoading = true;
            setState(() {});
            if (await Utils.checkInternetConnectivity()) {
              final Resources<BlockContactResponse> responseBlockContact =
                  await contactsProvider!.doBlockContactApiCall(
                BlockContactRequestHolder(
                  // contactId:
                  //     contactsProvider.contactDetailResponse.data.id,
                  data: BlockContactRequestParamHolder(
                    isBlock: !contactsProvider!
                        .contactDetailResponse!.data!.blocked!,
                  ),
                  number:
                      contactsProvider!.contactDetailResponse!.data!.number!,
                ),
              );
              if (responseBlockContact.data != null) {
                contactsProvider!.doContactDetailApiCall(contactId);
                isLoading = false;
                setState(() {});
                Utils.showToastMessage(
                    !contactsProvider!.contactDetailResponse!.data!.blocked!
                        ? Utils.getString("blockContact")
                        : Utils.getString("unblockContact"));
                widget.onContactBlock(value);
              } else if (responseBlockContact.message != null) {
                isLoading = false;
                setState(() {});
                await PsProgressDialog.dismissDialog();
                showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: responseBlockContact.message,
                    );
                  },
                );
              }
            } else {
              Utils.showWarningToastMessage(
                  Utils.getString("noInternet"), context);
            }
          },
        );
      },
    );
  }

  void _showMuteDialog(
      {BuildContext? context, String? clientName, Function? onMuteTap}) {
    showModalBottomSheet(
      context: context!,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClientDndMuteDialog(
        clientName: clientName,
        onMuteTap: (int minutes, bool value) {
          Navigator.of(context).pop();
          onMuteTap!(minutes, value);
        },
      ),
    );
  }

  Future<void> onMuteTap(int minutes, bool value) async {
    final bool checkConnectivity = await Utils.checkInternetConnectivity();
    if (checkConnectivity) {
      await PsProgressDialog.showDialog(context, isDissmissable: true);
      final UpdateClientDNDRequestParamHolder
          updateClientDNDRequestParamHolder = UpdateClientDNDRequestParamHolder(
        contact: contactsProvider!.contactDetailResponse!.data!.number!,
        minutes: minutes,
        removeFromDND: value,
      );
      final Resources<ClientDndResponse> resource = await contactsProvider!
              .doClientDndApiCall(updateClientDNDRequestParamHolder)
          as Resources<ClientDndResponse>;
      if (resource.status == Status.ERROR) {
        await PsProgressDialog.dismissDialog();
        Utils.showToastMessage(resource.message!);
      } else {
        await PsProgressDialog.dismissDialog();
        widget.onMuteUnMuteCallBack();
        contactsProvider!.doContactDetailApiCall(
            resource.data!.clientDndResponseData!.contacts!.id);
      }
    } else {
      if (!mounted) return;
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }

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
        if (selectedFilePath != null) {
          await PsProgressDialog.showDialog(context);
          contactsProvider!
              .doUpdateContactProfilePicture(
                  Utils.convertImageToBase64String(
                      "photoUpload", File(selectedFilePath!)),
                  contactId!)
              .then((value) {
            contactsProvider!
                .doContactDetailApiCall(contactId)
                .then((value) async {
              await PsProgressDialog.dismissDialog();
              widget.onContactUpdate();
              setState(() {});
            });
          });
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
}

class ContactDetailWidget extends StatelessWidget {
  const ContactDetailWidget({
    Key? key,
    required this.animationController,
    required this.animation,
    required this.contact,
    required this.selectedCountryCode,
    required this.onMakeCallTap,
    required this.onMessageTap,
    required this.onNotesTap,
    required this.onMuteTap,
    required this.onUnMuteTap,
    required this.clientId,
    required this.notes,
    required this.contactsProvider,
    required this.onDeleteBlockTap,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.onEditProfilePicture,
    this.onUnblockTap,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Contacts contact;
  final List<Notes> notes;
  final CountryCode? selectedCountryCode;
  final Function onMakeCallTap;
  final Function onMessageTap;
  final Function onNotesTap;
  final Function onMuteTap;
  final Function onUnMuteTap;
  final String clientId;
  final ContactsProvider contactsProvider;
  final Function onDeleteBlockTap;
  final Function? onUnblockTap;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final VoidCallback onEditProfilePicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space24.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  color: CustomColors.white,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: Dimens.space54.w,
                            height: Dimens.space54.w,
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
                            child: RoundedNetworkImageHolder(
                              width: Dimens.space54,
                              height: Dimens.space54,
                              iconUrl: CustomIcon.icon_profile,
                              containerAlignment: Alignment.bottomCenter,
                              iconColor: CustomColors.callInactiveColor,
                              iconSize: Dimens.space46,
                              boxDecorationColor: CustomColors.mainDividerColor,
                              outerCorner: Dimens.space18,
                              innerCorner: Dimens.space18,
                              imageUrl: contact.profilePicture ?? "",
                              onTap: () {
                                if (contact.blocked != null &&
                                    !contact.blocked!) {
                                  onEditProfilePicture();
                                } else {
                                  showToastMessage(context, onUnblockTap!);
                                }
                              },
                            ),
                          ),
                          Positioned(
                            right: Dimens.space0.w,
                            bottom: Dimens.space0.h,
                            child: Offstage(
                              offstage:
                                  contact.blocked == null || !contact.blocked!,
                              child: Container(
                                width: Dimens.space20.w,
                                height: Dimens.space20.w,
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
                                child: RoundedNetworkImageHolder(
                                  width: Dimens.space20,
                                  height: Dimens.space20,
                                  iconUrl: Icons.block,
                                  iconColor: CustomColors.callDeclineColor,
                                  iconSize: Dimens.space20,
                                  boxDecorationColor: CustomColors.white,
                                  outerCorner: Dimens.space300,
                                  innerCorner: Dimens.space300,
                                  imageUrl: "",
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: Dimens.space0.h,
                            right: Dimens.space0.w,
                            child: Offstage(
                              offstage:
                                  contact.blocked != null && contact.blocked!,
                              child: PlainAssetImageHolder(
                                assetUrl: "assets/images/icon_upload.png",
                                width: Dimens.space20,
                                height: Dimens.space21,
                                assetWidth: Dimens.space18,
                                assetHeight: Dimens.space18,
                                boxFit: BoxFit.contain,
                                iconUrl: CustomIcon.icon_plus_rounded,
                                iconColor: CustomColors.white,
                                iconSize: Dimens.space20,
                                outerCorner: Dimens.space300,
                                innerCorner: Dimens.space300,
                                boxDecorationColor: CustomColors.white,
                                onTap: () {
                                  if (contact.blocked != null &&
                                      !contact.blocked!) {
                                    onEditProfilePicture();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space14.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                child: Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : contact.name ?? contact.number!,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 3,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontFamily: Config.manropeExtraBold,
                                        fontSize: Dimens.space20.sp,
                                        fontWeight: FontWeight.normal,
                                        color: CustomColors.textPrimaryColor,
                                        fontStyle: FontStyle.normal,
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
                                child: Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : "${Utils.getString("lastContacted")} ${contactsProvider.lastContactedDate!.data ?? "N/A"}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontFamily: Config.heeboRegular,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal,
                                        color: CustomColors.textPrimaryColor,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onDeleteBlockTap();
                        },
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
                          width: Dimens.space24.w,
                          height: Dimens.space24.w,
                          alignment: Alignment.center,
                          child: Icon(
                            CustomIcon.icon_more_vertical,
                            size: Dimens.space18.w,
                            color: CustomColors.textSecondaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (contact.tags!.isNotEmpty)
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space20.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    height: Dimens.space24.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: contact.tags!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space8.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          height: Dimens.space24.h,
                          child: TagsItemWidget(tags: contact.tags![index]),
                        );
                      },
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    ),
                  )
                else
                  Container(),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1.h,
            thickness: Dimens.space1.h,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space20.h,
                Dimens.space16.w, Dimens.space20.h),
            alignment: Alignment.center,
            color: CustomColors.bottomAppBarColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space11.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space11.h,
                            Dimens.space0.w,
                            Dimens.space11.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space10.r),
                        ),
                      ),
                      onPressed: () {
                        contact.dndInfo!.dndEnabled
                            ? onUnMuteTap()
                            : onMuteTap();
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                              child: Icon(
                                contact.dndInfo!.dndEnabled
                                    ? CustomIcon.icon_muted
                                    : CustomIcon.icon_notification,
                                color: contact.dndInfo!.dndEnabled
                                    ? CustomColors.textPrimaryErrorColor
                                    : CustomColors.loadingCircleColor,
                                size: Dimens.space20.w,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space6.w,
                                  Dimens.space6.h,
                                  Dimens.space6.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : contact.dndInfo!.dndEnabled
                                        ? Utils.getString("muted")
                                        : Utils.getString("alwaysOn")
                                            .toLowerCase(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space12.sp,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.textTertiaryColor,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space11.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space11.h,
                            Dimens.space0.w,
                            Dimens.space11.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space10.r),
                        ),
                      ),
                      onPressed: () {
                        onMessageTap();
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                              child: Icon(
                                CustomIcon.icon_chat,
                                color: CustomColors.loadingCircleColor,
                                size: Dimens.space20.w,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space6.w,
                                  Dimens.space6.h,
                                  Dimens.space6.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("message").toLowerCase(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space12.sp,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.textTertiaryColor,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space11.h,
                            Dimens.space0.w,
                            Dimens.space11.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.space10.r),
                        ),
                      ),
                      onPressed: () {
                        onMakeCallTap();
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                              child: Icon(
                                CustomIcon.icon_call,
                                color: CustomColors.loadingCircleColor,
                                size: Dimens.space20.w,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space6.w,
                                  Dimens.space6.h,
                                  Dimens.space6.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("call").toLowerCase(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space12.sp,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.textTertiaryColor,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // contactsProvider.contactDetailResponse.data.blocked
          //     ? Container()
          //     : ,
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          //Add Notes
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                    Dimens.space16.w, Dimens.space0.h),
                backgroundColor: CustomColors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                if (contact.blocked != null && !contact.blocked!) {
                  onNotesTap();
                } else {
                  showToastMessage(context, onUnblockTap!);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CustomIcon.icon_add_notes,
                            size: Dimens.space16.w,
                            color: CustomColors.textTertiaryColor,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space10.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("notes"),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space5.h, Dimens.space10.w, Dimens.space5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.space16.r),
                          ),
                          border: Border.all(
                            color: CustomColors.textQuinaryColor!,
                            width: Dimens.space1.h,
                          ),
                          color: CustomColors.white,
                        ),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : notes.isNotEmpty && notes.isNotEmpty
                                  ? notes.length.toString()
                                  : Utils.getString("0"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.heeboMedium,
                                    fontSize: Dimens.space13.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                        ),
                      ),
                    ),
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
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          DetailWidget(
            clientId: clientId,
            contact: contact,
            contactsProvider: contactsProvider,
            onIncomingTap: () {
              onIncomingTap();
            },
            onOutgoingTap: () {
              onOutgoingTap();
            },
            onUnblockTap: onUnblockTap!,
          ),
        ],
      ),
    );
  }

  void showToastMessage(BuildContext context, Function onUnblockTap) {
    Toast.show(Utils.getString("unblockFirst"), context, onTap: () {
      onUnblockTap();
    });
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    required this.clientId,
    required this.contact,
    required this.contactsProvider,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.onUnblockTap,
  });

  final Contacts contact;
  final String clientId;
  final ContactsProvider contactsProvider;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final Function onUnblockTap;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: CustomColors.bottomAppBarColor,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space15.h, Dimens.space16.w, Dimens.space15.h),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("moreDetails").toUpperCase(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: CustomColors.textPrimaryLightColor,
                          fontFamily: Config.manropeBold,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space14.sp,
                          fontStyle: FontStyle.normal,
                        ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          //Name
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          : Utils.getString("name"),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (contact.blocked != null && !contact.blocked!) {
                        Utils.checkInternetConnectivity().then((data) async {
                          if (data) {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                              context,
                              RoutePaths.editContact,
                              arguments: EditContactIntentHolder(
                                editName: "contactName",
                                contactName: contact.name ?? "",
                                contactNumber: contact.number ?? "",
                                email: contact.email ?? "",
                                company: contact.company ?? "",
                                address: contact.address ?? "",
                                photoUpload: contact.profilePicture ?? "",
                                tags: contact.tags ?? [],
                                visibility: contact.visibility ?? false,
                                id: contact.id ?? "",
                                onIncomingTap: () {
                                  onIncomingTap();
                                },
                                onOutgoingTap: () {
                                  onOutgoingTap();
                                },
                              ),
                            );
                            if (returnData != null &&
                                returnData["data"] is bool &&
                                returnData["data"] as bool) {
                              contactsProvider
                                  .doContactDetailApiCall(contact.id);
                            }
                          } else {
                            Utils.showWarningToastMessage(
                                Utils.getString("noInternet"), context);
                          }
                        });
                      } else {
                        showToastMessage(context, onUnblockTap);
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : contact.name ?? contact.number!,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          : Utils.getString("phoneNumber"),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (contact.blocked != null && !contact.blocked!) {
                        Utils.checkInternetConnectivity().then((data) async {
                          if (data) {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                                    context, RoutePaths.editContact,
                                    arguments: EditContactIntentHolder(
                                        editName: "phoneNumber",
                                        contactName: contact.name ?? "",
                                        contactNumber: contact.number ?? "",
                                        email: contact.email ?? "",
                                        company: contact.company ?? "",
                                        address: contact.address ?? "",
                                        photoUpload:
                                            contact.profilePicture ?? "",
                                        tags: contact.tags ?? [],
                                        visibility: contact.visibility ?? false,
                                        id: contact.id ?? "",
                                        onIncomingTap: () {
                                          onIncomingTap();
                                        },
                                        onOutgoingTap: () {
                                          onOutgoingTap();
                                        }));
                            if (returnData != null &&
                                returnData["data"] is bool &&
                                returnData["data"] as bool) {
                              contactsProvider
                                  .doContactDetailApiCall(contact.id);
                            }
                          } else {
                            Utils.showWarningToastMessage(
                                Utils.getString("noInternet"), context);
                          }
                        });
                      } else {
                        showToastMessage(context, onUnblockTap);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space5.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: FutureBuilder<String>(
                            future: Utils.getFlagUrl(contact.number),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RoundedNetworkImageHolder(
                                  width: Dimens.space14,
                                  height: Dimens.space14,
                                  boxFit: BoxFit.contain,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconUrl: CustomIcon.icon_gallery,
                                  iconColor: CustomColors.grey,
                                  iconSize: Dimens.space14,
                                  boxDecorationColor:
                                      CustomColors.mainBackgroundColor,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  imageUrl: PSApp.config!.countryLogoUrl! +
                                      snapshot.data!,
                                );
                              }
                              return const CupertinoActivityIndicator();
                            },
                          ),
                        ),
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.manropeSemiBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                              text: Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : contact.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CustomColors.mainDividerColor!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          : Utils.getString("email"),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (contact.blocked != null && !contact.blocked!) {
                        Utils.checkInternetConnectivity().then((data) async {
                          if (data) {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                              context,
                              RoutePaths.editContact,
                              arguments: EditContactIntentHolder(
                                editName: "email",
                                contactName: contact.name ?? "",
                                contactNumber: contact.number ?? "",
                                email: contact.email ?? "",
                                company: contact.company ?? "",
                                address: contact.address ?? "",
                                photoUpload: contact.profilePicture ?? "",
                                tags: contact.tags ?? [],
                                visibility: contact.visibility ?? false,
                                id: contact.id ?? "",
                                onIncomingTap: () {
                                  onIncomingTap();
                                },
                                onOutgoingTap: () {
                                  onOutgoingTap();
                                },
                              ),
                            );
                            if (returnData != null &&
                                returnData["data"] is bool &&
                                returnData["data"] as bool) {
                              contactsProvider
                                  .doContactDetailApiCall(contact.id);
                            }
                          } else {
                            Utils.showWarningToastMessage(
                                Utils.getString("noInternet"), context);
                          }
                        });
                      } else {
                        showToastMessage(context, onUnblockTap);
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : contact.email ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CustomColors.mainDividerColor!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          : Utils.getString("company"),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (contact.blocked != null && !contact.blocked!) {
                        Utils.checkInternetConnectivity().then(
                          (data) async {
                            if (data) {
                              final dynamic returnData =
                                  await Navigator.pushNamed(
                                      context, RoutePaths.editContact,
                                      arguments: EditContactIntentHolder(
                                          editName: "company",
                                          contactName: contact.name ?? "",
                                          contactNumber: contact.number ?? "",
                                          email: contact.email ?? "",
                                          company: contact.company ?? "",
                                          address: contact.address ?? "",
                                          photoUpload:
                                              contact.profilePicture ?? "",
                                          tags: contact.tags ?? [],
                                          visibility:
                                              contact.visibility ?? false,
                                          id: contact.id ?? "",
                                          onIncomingTap: () {
                                            onIncomingTap();
                                          },
                                          onOutgoingTap: () {
                                            onOutgoingTap();
                                          }));
                              if (returnData != null &&
                                  returnData["data"] is bool &&
                                  returnData["data"] as bool) {
                                contactsProvider
                                    .doContactDetailApiCall(contact.id);
                              }
                            } else {
                              Utils.showWarningToastMessage(
                                  Utils.getString("noInternet"), context);
                            }
                          },
                        );
                      } else {
                        showToastMessage(context, onUnblockTap);
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : contact.company ?? "",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            alignment: Alignment.center,
            height: Dimens.space52.h,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CustomColors.mainDividerColor!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          : Utils.getString("address"),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (contact.blocked != null && !contact.blocked!) {
                        Utils.checkInternetConnectivity().then((data) async {
                          if (data) {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                              context,
                              RoutePaths.editContact,
                              arguments: EditContactIntentHolder(
                                editName: "address",
                                contactName: contact.name ?? "",
                                contactNumber: contact.number ?? "",
                                email: contact.email ?? "",
                                company: contact.company ?? "",
                                address: contact.address ?? "",
                                photoUpload: contact.profilePicture ?? "",
                                tags: contact.tags ?? [],
                                visibility: contact.visibility ?? false,
                                id: contact.id ?? "",
                                onIncomingTap: () {
                                  onIncomingTap();
                                },
                                onOutgoingTap: () {
                                  onOutgoingTap();
                                },
                              ),
                            );
                            if (returnData != null &&
                                returnData["data"] is bool &&
                                returnData["data"] as bool) {
                              contactsProvider
                                  .doContactDetailApiCall(contact.id);
                            }
                          } else {
                            Utils.showWarningToastMessage(
                                Utils.getString("noInternet"), context);
                          }
                        });
                      } else {
                        showToastMessage(context, onUnblockTap);
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : contact.address ?? "",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textTertiaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  CustomIcon.icon_arrow_right,
                  size: Dimens.space24.w,
                  color: CustomColors.textQuinaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showToastMessage(BuildContext context, Function onUnblockTap) {
    Toast.show(Utils.getString("unblockFirst"), context, onTap: () {
      onUnblockTap();
    });
  }
}
