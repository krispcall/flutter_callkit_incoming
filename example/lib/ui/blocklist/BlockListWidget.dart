import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/ui/blocklist/BlockListViewItemView.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/ui/common/shimmer/ContactShimmer.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/blockContactResponse/BlockContactResponse.dart";
import "package:provider/provider.dart";

class BlockListWidget extends StatefulWidget {
  const BlockListWidget({
    Key? key,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;

  @override
  _BlockListWidgetState createState() => _BlockListWidgetState();
}

class _BlockListWidgetState extends State<BlockListWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  ContactsProvider? contactsProvider;
  ContactRepository? contactRepository;
  TextEditingController controllerSearch = TextEditingController();
  final _debounce = DeBouncer(milliseconds: 500);
  InternetConnectionStatus internetConnectionStatus =
      InternetConnectionStatus.connected;
  StreamSubscription? streamSubscriptionOnNetworkChanged;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    checkConnection();
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
  }

  @override
  void dispose() {
    animationController!.dispose();
    streamSubscriptionOnNetworkChanged?.cancel();
    super.dispose();
  }

  ///Check internet auto detect internet connection
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
        contactsProvider!.doBlockContactListApiCall();
        setState(() {});
      } else {
        internetConnectionStatus = InternetConnectionStatus.disconnected;
        setState(() {});
      }
    });
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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColors.white,
        body: CustomAppBar<ContactsProvider>(
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
                        : Utils.getString("blockedList"),
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
          onIncomingTap: () {
            widget.onIncomingTap!();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap!();
          },
          initProvider: () {
            contactsProvider =
                ContactsProvider(contactRepository: contactRepository);
            contactsProvider!.doBlockContactListApiCall();
            controllerSearch.addListener(() {
              _debounce.run(() {
                contactsProvider!.doSearchBlockContact(controllerSearch.text);
              });
            });
            return contactsProvider;
          },
          onProviderReady: (ContactsProvider provider) {
            contactsProvider!.doAllContactApiCall();
          },
          builder: (BuildContext? context, ContactsProvider? provider1,
              Widget? child) {
            animationController!.forward();
            if (contactsProvider!.blockedContactList != null &&
                contactsProvider!.blockedContactList!.data != null) {
              return RefreshIndicator(
                color: CustomColors.mainColor,
                backgroundColor: CustomColors.white,
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controllerSearch.text.isNotEmpty ||
                          (contactsProvider!.blockedContactList!.data != null &&
                              contactsProvider!
                                  .blockedContactList!.data!.isNotEmpty))
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space16.w,
                              Dimens.space20.h,
                              Dimens.space16.w,
                              Dimens.space10.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          height: Dimens.space52.h,
                          child: TextField(
                            controller: controllerSearch,
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
                              isDense: false,
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
                              hintText: Utils.getString("searchContact"),
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
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (submittedQuery) async {
                              contactsProvider!
                                  .doSearchBlockContact(controllerSearch.text);
                            },
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
                          child: contactsProvider!.blockedContactList!.data !=
                                      null &&
                                  contactsProvider!
                                      .blockedContactList!.data!.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: contactsProvider!
                                      .blockedContactList!.data!.length,
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space6.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return BlockListItemView(
                                      contactEdges: contactsProvider!
                                          .blockedContactList!.data![index],
                                      onUnblockTap: () async {
                                        FocusScope.of(context).unfocus();

                                        if (await Utils
                                            .checkInternetConnectivity()) {
                                          await PsProgressDialog.showDialog(
                                              context);
                                          final Resources<BlockContactResponse>
                                              responseBlockContact =
                                              await contactsProvider!
                                                  .doBlockContactApiCall(
                                            BlockContactRequestHolder(
                                              contactId: "",
                                              data:
                                                  BlockContactRequestParamHolder(
                                                isBlock: false,
                                              ),
                                              number: contactsProvider!
                                                  .blockedContactList!
                                                  .data![index]
                                                  .number!,
                                            ),
                                          );
                                          controllerSearch.text = "";
                                          setState(() {});
                                          if (responseBlockContact.data !=
                                              null) {
                                            contactsProvider!
                                                .doBlockContactListApiCall()
                                                .then((value) async {
                                              await PsProgressDialog
                                                  .dismissDialog();
                                            });
                                          } else if (responseBlockContact
                                                  .message !=
                                              null) {
                                            await PsProgressDialog
                                                .dismissDialog();
                                            showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ErrorDialog(
                                                  message: responseBlockContact
                                                      .message,
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          Utils.showWarningToastMessage(
                                              Utils.getString("noInternet"),
                                              context);
                                        }
                                      },
                                    );
                                  },
                                )
                              : contactsProvider!.blockedContactList!.data !=
                                          null &&
                                      contactsProvider!
                                          .blockedContactList!.data!.isEmpty &&
                                      controllerSearch.text.isNotEmpty
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
                                        child: EmptyViewUiWidget(
                                          assetUrl: "assets/images/banned.png",
                                          title: Utils.getString("noBlockList"),
                                          desc: Utils.getString(
                                              "noUnblockContactsDescription"),
                                          buttonTitle: Utils.getString(""),
                                          icon: Icons.add_circle_outline,
                                          showButton: false,
                                          onPressed: () async {},
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ),
                onRefresh: () {
                  return contactsProvider!.doBlockContactListApiCall();
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
          },
        ),
      ),
    );
  }
}
