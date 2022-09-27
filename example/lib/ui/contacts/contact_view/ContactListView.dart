import "dart:async";

import "package:app_settings/app_settings.dart";
import "package:azlistview/azlistview.dart";
import "package:contacts_service/contacts_service.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:lpinyin/lpinyin.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoInternetWidget.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ContactAddImportDialog.dart";
import "package:mvp/ui/common/dialog/ContactDetailDialog.dart";
import "package:mvp/ui/common/shimmer/contactShimmer.dart";
import "package:mvp/ui/contacts/contact_view/ContactListItemView.dart";
import "package:mvp/ui/contacts/contact_view/PhoneContactListView.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/AddContactIntentHolder.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";

class ContactListView extends StatefulWidget {
  const ContactListView({
    Key? key,
    required this.animationController,
    required this.channelId,
    required this.channelName,
    required this.channelNumber,
    required this.onLeadingTap,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
  }) : super(key: key);

  final AnimationController animationController;
  final String? channelId;
  final String? channelName;
  final String? channelNumber;
  final Function onLeadingTap;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String,
      String, String) makeCallWithSid;

  @override
  _ContactListViewState createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView>
    with SingleTickerProviderStateMixin {
  ContactRepository? contactRepository;
  ContactsProvider? contactsProvider;
  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;

  ValueHolder? valueHolder;

  bool isConnectedToInternet = true;
  bool isLoading = false;
  ButtonState internetState = ButtonState.idle;

  StreamSubscription? streamSubscriptionOnWorkspaceOrChannelChanged;
  StreamSubscription? streamSubscriptionOnNetworkChanged;

  final TextEditingController controllerSearchContacts =
      TextEditingController();

  final _debounce = DeBouncer(milliseconds: 500);

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
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

  @override
  void initState() {
    super.initState();
    checkConnection();
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);
    streamSubscriptionOnWorkspaceOrChannelChanged =
        DashboardView.workspaceOrChannelChanged.on().listen((event) {
      contactsProvider!.doEmptyAllContactApiCall();
      contactsProvider!.doAllContactApiCall();
    });
  }

  @override
  void dispose() {
    streamSubscriptionOnWorkspaceOrChannelChanged?.cancel();
    streamSubscriptionOnNetworkChanged?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: CustomAppBar<ContactsProvider>(
        elevation: 0.8,
        centerTitle: true,
        onIncomingTap: () {
          widget.onIncomingTap();
        },
        onOutgoingTap: () {
          widget.onOutgoingTap();
        },
        titleWidget: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Text(
            Config.checkOverFlow ? Const.OVERFLOW : Utils.getString("contacts"),
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
            onPressed: () async {
              showImportContactDialog();
            },
            style: TextButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: CustomColors.transparent,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.space0.r),
              ),
            ),
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
              onTap: () {
                showImportContactDialog();
              },
            ),
          ),
        ],
        initProvider: () {
          contactsProvider = ContactsProvider(
              contactRepository: contactRepository, valueHolder: valueHolder);
          return contactsProvider;
        },
        onProviderReady: (ContactsProvider provider) {
          contactsProvider!.doAllContactApiCall();
          controllerSearchContacts.addListener(() {
            _debounce.run(() {
              if (controllerSearchContacts.text.isEmpty) {
                contactsProvider!.getAllContactsFromDB();
              } else if (controllerSearchContacts.text.isNotEmpty &&
                  controllerSearchContacts.text != "") {
                contactsProvider!
                    .doSearchContactFromDb(controllerSearchContacts.text);
              } else {
                contactsProvider!.getAllContactsFromDB();
              }
            });
          });
        },
        builder:
            (BuildContext? context, ContactsProvider? provider, Widget? child) {
          // if (isConnectedToInternet) {
          internetState = ButtonState.idle;
          if (contactsProvider!.contactResponse != null &&
              contactsProvider!.contactResponse!.status ==
                  Status.SERVER_EXCEPTION) {
            return Container(
              margin: EdgeInsets.only(
                  top: Dimens.space10.h,
                  left: Dimens.space16.h,
                  right: Dimens.space16.h,
                  bottom: Dimens.space10.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : contactsProvider!.contactResponse!.message!,
                style: Theme.of(context!).textTheme.bodyText2!.copyWith(
                      color: CustomColors.redButtonColor,
                      fontFamily: Config.manropeBold,
                      fontSize: Dimens.space15.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
              ),
            );
          } else {
            if (!isLoading) {
              if (contactsProvider!.contactResponse != null &&
                  contactsProvider!.contactResponse!.data != null) {
                if (contactsProvider!.contactResponse!.data!.contactResponse!
                    .contactResponseData!.isNotEmpty) {
                  for (int i = 0;
                      i <
                          contactsProvider!.contactResponse!.data!
                              .contactResponse!.contactResponseData!.length;
                      i++) {
                    final String pinyin = PinyinHelper.getPinyinE(
                      contactsProvider!.contactResponse!.data!.contactResponse!
                              .contactResponseData![i].name!.isNotEmpty
                          ? contactsProvider!.contactResponse!.data!
                              .contactResponse!.contactResponseData![i].name!
                          : contactsProvider!.contactResponse!.data!
                              .contactResponse!.contactResponseData![i].number!,
                    );
                    final String tag = pinyin.substring(0, 1).toUpperCase();
                    provider!.contactResponse!.data!.contactResponse!
                        .contactResponseData![i].namePinyin = pinyin;
                    if (RegExp("[A-Z]").hasMatch(tag)) {
                      provider.contactResponse!.data!.contactResponse!
                          .contactResponseData![i].tagIndex = tag;
                    } else {
                      provider.contactResponse!.data!.contactResponse!
                          .contactResponseData![i].tagIndex = "#";
                    }
                  }
                  // A-Z sort.
                  SuspensionUtil.sortListBySuspensionTag(
                    provider!.contactResponse!.data!.contactResponse!
                        .contactResponseData,
                  );

                  // show sus tag.
                  SuspensionUtil.setShowSuspensionStatus(
                    provider.contactResponse!.data!.contactResponse!
                        .contactResponseData,
                  );
                }
                return RefreshIndicator(
                  color: CustomColors.mainColor,
                  backgroundColor: CustomColors.white,
                  child: Container(
                    color: CustomColors.white,
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space0.w,
                      Dimens.space0.h,
                    ),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controllerSearchContacts.text.isNotEmpty ||
                            contactsProvider!
                                .contactResponse!
                                .data!
                                .contactResponse!
                                .contactResponseData!
                                .isNotEmpty)
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
                              controller: controllerSearchContacts,
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
                                hintText: Utils.getString("searchContacts"),
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
                            child: contactsProvider!
                                    .contactResponse!
                                    .data!
                                    .contactResponse!
                                    .contactResponseData!
                                    .isNotEmpty
                                ? AzListView(
                                    data: provider!.contactResponse!.data!
                                        .contactResponse!.contactResponseData!,
                                    itemCount: provider
                                        .contactResponse!
                                        .data!
                                        .contactResponse!
                                        .contactResponseData!
                                        .length,
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
                                          color: CustomColors.bottomAppBarColor,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width
                                              .sw,
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space20.w,
                                              Dimens.space5.h,
                                              Dimens.space20.w,
                                              Dimens.space5.h),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            Config.checkOverFlow
                                                ? Const.OVERFLOW
                                                : provider
                                                    .contactResponse!
                                                    .data!
                                                    .contactResponse!
                                                    .contactResponseData![i]
                                                    .getSuspensionTag(),
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontFamily: Config.manropeBold,
                                              fontSize: Dimens.space14.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final int count = provider
                                          .contactResponse!
                                          .data!
                                          .contactResponse!
                                          .contactResponseData!
                                          .length;
                                      widget.animationController.forward();
                                      return ContactListItemView(
                                        animationController:
                                            widget.animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: widget.animationController,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        offStage: true,
                                        contactEdges: provider
                                            .contactResponse!
                                            .data!
                                            .contactResponse!
                                            .contactResponseData![index],
                                        onTap: () async {
                                          showContactDetailDialog(index);
                                        },
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
                                      indexHintAlignment: Alignment.centerRight,
                                    ),
                                  )
                                : contactsProvider!
                                            .contactResponse!
                                            .data!
                                            .contactResponse!
                                            .contactResponseData!
                                            .isEmpty &&
                                        controllerSearchContacts.text.isNotEmpty
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
                                                "assets/images/empty_contact.png",
                                            title:
                                                Utils.getString("noContacts"),
                                            desc: Utils.getString(
                                                "noContactsDescription"),
                                            buttonTitle: Utils.getString(
                                                "addANewContact"),
                                            icon: Icons.add_circle_outline,
                                            onPressed: () async {
                                              final dynamic returnData =
                                                  await Navigator.pushNamed(
                                                context!,
                                                RoutePaths.newContact,
                                                arguments:
                                                    AddContactIntentHolder(
                                                  onIncomingTap: () {
                                                    widget.onIncomingTap();
                                                  },
                                                  onOutgoingTap: () {
                                                    widget.onOutgoingTap();
                                                  },
                                                ),
                                              );
                                              if (returnData != null &&
                                                  returnData["data"] is bool &&
                                                  returnData["data"] as bool) {
                                                contactsProvider!
                                                    .doAllContactApiCall();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onRefresh: () {
                    return contactsProvider!.doAllContactApiCall();
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
                              : const ContactShimmer();
                        },
                      ),
                    ),
                  ],
                );
              }
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
                            : const ContactShimmer();
                      },
                    ),
                  ),
                ],
              );
            }
          }
        },
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
            contactsProvider!.doAllContactApiCall();
          }
          break;
        case ButtonState.loading:
          internetState = ButtonState.idle;
          break;
      }
    });
  }

  Future<void> _askPermissions() async {
    final PermissionStatus permissionStatus = await _getContactPermission();

    if (permissionStatus == PermissionStatus.granted) {
      showDeviceContactListDialog();
      await ContactsService.getContacts(
          withThumbnails: false, iOSLocalizedLabels: false);
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void> showImportContactDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return importContact(
          context,
          addNewContacts: () async {
            Navigator.of(context).pop();
            final dynamic returnData = await Navigator.pushNamed(
              context,
              RoutePaths.newContact,
              arguments: AddContactIntentHolder(
                onIncomingTap: () {
                  widget.onIncomingTap();
                },
                onOutgoingTap: () {
                  widget.onOutgoingTap();
                },
              ),
            );
            if (returnData != null &&
                returnData["data"] is bool &&
                returnData["data"] as bool) {
              contactsProvider!.doAllContactApiCall();
            }
          },
          importAllContact: () async {
            Navigator.of(context).pop();
            _askPermissions();
          },
        );
      },
    );
  }

  Future<PermissionStatus> _getContactPermission() async {
    final PermissionStatus permission = await Permission.contacts.request();
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final PermissionStatus permissionStatus =
          await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(
          content: Text(Config.checkOverFlow
              ? Const.OVERFLOW
              : "Access to contact data denied"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus.isDenied) {
      Utils.showToastMessage("Permission deny");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      Utils.showToastMessage("Permission deny");
      AppSettings.openAppSettings();
    }
  }

  Future<void> showDeviceContactListDialog() async {
    return showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space16.r),
          topRight: Radius.circular(Dimens.space16.r),
        ),
      ),
      builder: (dialogContext) => PhoneContactListView(
        onSuccess: (v) {
          contactsProvider!.doAllContactApiCall();
        },
      ),
    );
  }

  void showContactDetailDialog(int index) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return ContactDetailDialog(
            channelId: widget.channelId,
            channelName: widget.channelName,
            channelNumber: widget.channelNumber,
            contact: contactsProvider!.contactResponse!.data!.contactResponse!
                .contactResponseData![index],
            onContactDelete: () {
              Navigator.pop(context);
              isLoading = true;
              setState(() {});
              contactsProvider!.doAllContactApiCall().then((value) {
                isLoading = false;
                setState(() {});
              });
            },
            onContactBlock: (value) {
              isLoading = true;
              setState(() {});
              contactsProvider!.doAllContactApiCall().then((value) {
                isLoading = false;
                setState(() {});
              });
            },
            contactId: contactsProvider!.contactResponse!.data!.contactResponse!
                .contactResponseData![index].id!,
            contactNumber: contactsProvider!.contactResponse!.data!
                .contactResponse!.contactResponseData![index].number!,
            onContactUpdate: () {
              isLoading = true;
              setState(() {});
              contactsProvider!.doAllContactApiCall().then((value) {
                isLoading = false;
                setState(() {});
              });
            },
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
            onMuteUnMuteCallBack: () {},
          );
        }).then((returnData) {
      if (returnData != null &&
          returnData["data"] is bool &&
          returnData["data"] as bool) {
        contactsProvider!.doAllContactApiCall();
      }
    });
  }
}
