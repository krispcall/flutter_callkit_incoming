import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/TagsItemWidget.dart";
import "package:mvp/ui/common/dialog/BlockContactDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/allNotes/Notes.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";

class MessageDetailSliderMenuWidget extends StatefulWidget {
  const MessageDetailSliderMenuWidget({
    Key? key,
    required this.clientId,
    required this.clientPhoneNumber,
    required this.countryId,
    required this.clientName,
    required this.isBlocked,
    // required this.dndMissed,
    required this.notes,
    required this.onCallTap,
    required this.onMuteTap,
    required this.onUnMuteTap,
    required this.onTapSearchConversation,
    required this.onNotesTap,
    required this.onAddContactTap,
    required this.onIncomingTap,
    required this.onOutgoingTap,
    required this.makeCallWithSid,
    this.onlineStatus = false,
    required this.contactsProvider,
    required this.onContactBlockUnblockTap,
  }) : super(key: key);

  final String clientId;
  final String clientPhoneNumber;
  final String clientName;
  final String? countryId;
  final bool isBlocked;
  final List<Notes>? notes;
  final Function onCallTap;
  final Function onMuteTap;
  final Function onUnMuteTap;
  final Function onNotesTap;
  // final bool dndMissed;
  final Function onAddContactTap;
  final Function onTapSearchConversation;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;
  final Function(bool) onContactBlockUnblockTap;
  final bool onlineStatus;
  final ContactsProvider contactsProvider;

  final Function(String, String, String, String, String, String, String, String,
      String, String) makeCallWithSid;

  @override
  _MessageDetailSliderMenuWidgetState createState() =>
      _MessageDetailSliderMenuWidgetState();
}

class _MessageDetailSliderMenuWidgetState
    extends State<MessageDetailSliderMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.bottomAppBarColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height.sh,
        width: MediaQuery.of(context).size.width.w,
        margin: EdgeInsets.fromLTRB(Dimens.space50.w, Dimens.space24.h,
            Dimens.space16.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
          border: Border.all(
              color: CustomColors.mainDividerColor!, width: Dimens.space1.r),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimens.space16.w),
            topLeft: Radius.circular(Dimens.space16.w),
          ),
          color: CustomColors.bottomAppBarColor,
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                  Dimens.space16.w, Dimens.space24.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimens.space16.w),
                  topLeft: Radius.circular(Dimens.space16.w),
                ),
                color: Colors.white,
              ),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: CustomColors.white,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space20.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Row(
                      children: [
                        Container(
                          width: Dimens.space40,
                          height: Dimens.space40,
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
                            width: Dimens.space40,
                            height: Dimens.space40,
                            iconUrl: CustomIcon.icon_profile,
                            containerAlignment: Alignment.bottomCenter,
                            iconColor: CustomColors.callInactiveColor,
                            iconSize: Dimens.space34,
                            boxDecorationColor: CustomColors.mainDividerColor,
                            outerCorner: Dimens.space14,
                            innerCorner: Dimens.space14,
                            imageUrl: (widget.contactsProvider
                                            .contactDetailResponse !=
                                        null &&
                                    widget.contactsProvider
                                            .contactDetailResponse?.data !=
                                        null &&
                                    widget.contactsProvider
                                            .contactDetailResponse?.data !=
                                        null &&
                                    widget
                                            .contactsProvider
                                            .contactDetailResponse
                                            ?.data
                                            ?.profilePicture !=
                                        null)
                                ? widget.contactsProvider.contactDetailResponse
                                    ?.data?.profilePicture
                                : "",
                          ),
                        ),
                        Expanded(
                          child:  GestureDetector(
                            onLongPress: (){
                              Clipboard.setData(ClipboardData(text: Config.checkOverFlow
                                  ? Const.OVERFLOW
                                  : (widget.contactsProvider
                                  .contactDetailResponse !=
                                  null
                                  ? ((widget
                                  .contactsProvider
                                  .contactDetailResponse
                                  ?.data !=
                                  null &&
                                  widget
                                      .contactsProvider
                                      .contactDetailResponse
                                      ?.data !=
                                      null &&
                                  widget
                                      .contactsProvider
                                      .contactDetailResponse
                                      ?.data
                                      ?.name !=
                                      null)
                                  ? widget
                                  .contactsProvider
                                  .contactDetailResponse
                                  ?.data
                                  ?.name
                                  : widget.clientName)
                                  : widget.clientPhoneNumber)))
                                  .then((_) {
                                Utils.showCopyToastMessage("Phone number copied", context);
                              });
                            },
                            child:Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space14.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                                    .bodyText1
                                                    ?.copyWith(
                                                  fontFamily:
                                                  Config.manropeBold,
                                                  fontSize: Dimens.space16.sp,
                                                  fontWeight: FontWeight.normal,
                                                  color: CustomColors
                                                      .textPrimaryColor,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                                text: Config.checkOverFlow
                                                    ? Const.OVERFLOW
                                                    : (widget.contactsProvider
                                                    .contactDetailResponse !=
                                                    null
                                                    ? ((widget
                                                    .contactsProvider
                                                    .contactDetailResponse
                                                    ?.data !=
                                                    null &&
                                                    widget
                                                        .contactsProvider
                                                        .contactDetailResponse
                                                        ?.data !=
                                                        null &&
                                                    widget
                                                        .contactsProvider
                                                        .contactDetailResponse
                                                        ?.data
                                                        ?.name !=
                                                        null)
                                                    ? widget
                                                    .contactsProvider
                                                    .contactDetailResponse
                                                    ?.data
                                                    ?.name
                                                    : widget.clientName)
                                                    : widget.clientPhoneNumber),
                                              ),
                                            )
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space6.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        alignment: Alignment.centerLeft,
                                        child: FutureBuilder<String>(
                                          future: Utils.getFlagUrl(
                                              widget.clientPhoneNumber),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return RoundedNetworkImageHolder(
                                                width: Dimens.space14,
                                                height: Dimens.space14,
                                                boxFit: BoxFit.contain,
                                                containerAlignment:
                                                Alignment.bottomCenter,
                                                iconUrl: CustomIcon.icon_gallery,
                                                iconColor: CustomColors.grey,
                                                iconSize: Dimens.space14,
                                                boxDecorationColor: CustomColors
                                                    .mainBackgroundColor,
                                                outerCorner: Dimens.space0,
                                                innerCorner: Dimens.space0,
                                                imageUrl: PSApp
                                                    .config!.countryLogoUrl! +
                                                    snapshot.data!,
                                              );
                                            }
                                            return const CupertinoActivityIndicator();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Offstage(
                                    offstage: !(widget.clientId != null),
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
                                            : widget.clientPhoneNumber,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                          fontFamily: Config.heeboMedium,
                                          fontSize: Dimens.space13.sp,
                                          fontWeight: FontWeight.normal,
                                          color:
                                          CustomColors.textTertiaryColor,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
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
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child:
                        (widget.contactsProvider.contactDetailResponse !=
                                    null &&
                                widget.contactsProvider.contactDetailResponse
                                        ?.data !=
                                    null &&
                                widget.contactsProvider.contactDetailResponse
                                        ?.data !=
                                    null &&
                                widget.contactsProvider.contactDetailResponse
                                        ?.data?.tags !=
                                    null &&
                                widget.contactsProvider.contactDetailResponse!
                                    .data!.tags!.isNotEmpty)
                            ? Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space20.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                height: Dimens.space24.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget
                                      .contactsProvider
                                      .contactDetailResponse
                                      ?.data
                                      ?.tags
                                      ?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                      child: TagsItemWidget(
                                        tags: widget
                                            .contactsProvider
                                            .contactDetailResponse
                                            ?.data
                                            ?.tags![index],
                                      ),
                                    );
                                  },
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                  ),
                                ),
                              )
                            : Container(),
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
                          Dimens.space0.h, Dimens.space7.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                            borderRadius:
                                BorderRadius.circular(Dimens.space10.r),
                          ),
                        ),
                        onPressed: () {
                          if (widget.contactsProvider.contactDetailResponse
                                  ?.status !=
                              Status.PROGRESS_LOADING) {
                            Utils.checkInternetConnectivity()
                                .then((data) async {
                              if (data) {
                                (widget.contactsProvider
                                                .contactDetailResponse !=
                                            null &&
                                        widget.contactsProvider
                                                .contactDetailResponse?.data !=
                                            null &&
                                        widget.contactsProvider
                                                .contactDetailResponse?.data !=
                                            null &&
                                        widget
                                            .contactsProvider
                                            .contactDetailResponse!
                                            .data!
                                            .dndInfo!
                                            .dndEnabled)
                                    ? widget.onUnMuteTap()
                                    : widget.onMuteTap();
                              } else {
                                Utils.showWarningToastMessage(
                                    Utils.getString("noInternet"), context);
                              }
                            });
                          }
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
                                  Dimens.space0.h,
                                ),
                                alignment: Alignment.center,
                                child: widget.contactsProvider
                                            .contactDetailResponse?.status !=
                                        Status.PROGRESS_LOADING
                                    ? widget.contactsProvider
                                                    .contactDetailResponse !=
                                                null &&
                                            widget
                                                    .contactsProvider
                                                    .contactDetailResponse
                                                    ?.data !=
                                                null &&
                                            widget
                                                    .contactsProvider
                                                    .contactDetailResponse
                                                    ?.data
                                                    ?.dndInfo !=
                                                null
                                        ? Icon(
                                            (widget
                                                    .contactsProvider
                                                    .contactDetailResponse!
                                                    .data!
                                                    .dndInfo!
                                                    .dndEnabled)
                                                ? CustomIcon.icon_muted
                                                : CustomIcon.icon_notification,
                                            color: (widget
                                                    .contactsProvider
                                                    .contactDetailResponse!
                                                    .data!
                                                    .dndInfo!
                                                    .dndEnabled)
                                                ? CustomColors
                                                    .textPrimaryErrorColor
                                                : CustomColors
                                                    .loadingCircleColor,
                                            size: Dimens.space20.w,
                                          )
                                        : Icon(
                                            CustomIcon.icon_notification,
                                            color:
                                                CustomColors.loadingCircleColor,
                                            size: Dimens.space20.w,
                                          )
                                    : Container(
                                        width: Dimens.space30.r,
                                        alignment: Alignment.centerRight,
                                        child: SpinKitCircle(
                                          size: Dimens.space20.r,
                                          color: CustomColors.textQuinaryColor,
                                        ),
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
                                      : (widget.contactsProvider
                                                      .contactDetailResponse !=
                                                  null &&
                                              widget
                                                      .contactsProvider
                                                      .contactDetailResponse!
                                                      .data !=
                                                  null &&
                                              widget
                                                      .contactsProvider
                                                      .contactDetailResponse!
                                                      .data !=
                                                  null &&
                                              widget
                                                  .contactsProvider
                                                  .contactDetailResponse!
                                                  .data!
                                                  .dndInfo!
                                                  .dndEnabled)
                                          ? Utils.getString("muted")
                                          : Utils.getString("alwaysOn")
                                              .toLowerCase(),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
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
                      margin: EdgeInsets.fromLTRB(Dimens.space7.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
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
                            borderRadius:
                                BorderRadius.circular(Dimens.space10.r),
                          ),
                        ),
                        onPressed: () {
                          Utils.checkInternetConnectivity().then((data) async {
                            if (data) {
                              widget.onCallTap();
                            } else {
                              Utils.showWarningToastMessage(
                                  Utils.getString("noInternet"), context);
                            }
                          });
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
                                      .bodyText1
                                      ?.copyWith(
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
                ],
              ),
            ),
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
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                  backgroundColor: CustomColors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Utils.checkInternetConnectivity().then((data) async {
                    if (data) {
                      widget.onNotesTap();
                    } else {
                      Utils.showWarningToastMessage(
                          Utils.getString("noInternet"), context);
                    }
                  });
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
                                      .bodyText1
                                      ?.copyWith(
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
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space10.w,
                              Dimens.space5.h,
                              Dimens.space10.w,
                              Dimens.space5.h),
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
                                : widget.notes != null &&
                                        widget.notes!.isNotEmpty
                                    ? widget.notes!.length.toString()
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
            //Search
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              height: Dimens.space52.h,
              color: CustomColors.white,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                  backgroundColor: CustomColors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  Utils.checkInternetConnectivity().then((data) async {
                    if (data) {
                      widget.onTapSearchConversation();
                    } else {
                      Utils.showWarningToastMessage(
                          Utils.getString("noInternet"), context);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CustomIcon.icon_search,
                      size: Dimens.space16.w,
                      color: CustomColors.textTertiaryColor,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("searchConversation"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
            Offstage(
              offstage: widget.clientId.isNotEmpty,
              child: Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
            ),
            Offstage(
              offstage: widget.clientId.isNotEmpty,
              child: Divider(
                color: CustomColors.bottomAppBarColor,
                height: Dimens.space30.h,
                thickness: Dimens.space30.h,
              ),
            ),
            Offstage(
              offstage: widget.clientId.isNotEmpty,
              child: Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
            ),
            Offstage(
              offstage: widget.clientId.isNotEmpty,
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                height: Dimens.space52.h,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                    backgroundColor: CustomColors.white,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Utils.checkInternetConnectivity().then((data) async {
                      if (data) {
                        widget.onAddContactTap();
                      } else {
                        Utils.showWarningToastMessage(
                            Utils.getString("noInternet"), context);
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CustomIcon.icon_plus_rounded,
                                size: Dimens.space16.w,
                                color: CustomColors.loadingCircleColor,
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
                                        : Utils.getString("addContacts"),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          color: CustomColors.startButtonColor,
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
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1,
              thickness: Dimens.space1,
            ),
            Divider(
              color: CustomColors.bottomAppBarColor,
              height: Dimens.space30.h,
              thickness: Dimens.space30.h,
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1,
              thickness: Dimens.space1,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              height: Dimens.space52.h,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CustomColors.mainDividerColor!,
                  ),
                ),
                color: Colors.white,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space8.h, Dimens.space16.w, Dimens.space8.h),
                  backgroundColor: CustomColors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.space16.r),
                    ),
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return BlockContactDialog(
                        isBlocked: widget.isBlocked,
                        onBlockTap: (value) {
                          Navigator.pop(context);
                          Future.delayed(const Duration(milliseconds: 400), () {
                            widget.onContactBlockUnblockTap(value);
                          });
                        },
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : widget.isBlocked
                            ? Utils.getString("unblockContact1")
                            : Utils.getString("blockContact1"),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.callDeclineColor,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.space0.w),
                    bottomRight: Radius.circular(Dimens.space0.w),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Future<String> getFlagUrl(String contactNumber) async {
//   if (contactNumber != null && contactNumber.isNotEmpty != null) {
//     PhoneNumber phoneNumber =
//         await PhoneNumber.getRegionInfoFromPhoneNumber(contactNumber);
//     return "/storage/flags/" + phoneNumber.isoCode.toLowerCase() + ".png";
//   } else {
//     return "";
//   }
// }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key? key,
    required this.clientNumber,
    required this.clientName,
    required this.clientProfilePicture,
    required this.callLogNode,
  }) : super(key: key);

  final String clientNumber;
  final String clientName;
  final String clientProfilePicture;
  final RecentConversationNodes callLogNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Dimens.space48,
            height: Dimens.space48,
            margin: EdgeInsets.fromLTRB(
                Dimens.space12.w, Dimens.space0, Dimens.space0, Dimens.space0),
            padding: EdgeInsets.zero,
            child: RoundedNetworkImageHolder(
              width: Dimens.space48,
              height: Dimens.space48,
              iconUrl: CustomIcon.icon_profile,
              iconColor: CustomColors.callInactiveColor,
              iconSize: Dimens.space48,
              boxDecorationColor: CustomColors.mainDividerColor,
              imageUrl: callLogNode.clientInfo != null
                  ? callLogNode.clientInfo?.profilePicture
                  : "",
            ),
          ),
          Flexible(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0,
                  Dimens.space0, Dimens.space0),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.zero,
                        child: Text(
                          Config.checkOverFlow ? Const.OVERFLOW : clientName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Dimens.space0.w),
                        child: RoundedNetworkSvgHolder(
                          containerWidth: Dimens.space20.w,
                          containerHeight: Dimens.space20.w,
                          boxFit: BoxFit.contain,
                          imageWidth: Dimens.space16.w,
                          imageHeight: Dimens.space16.w,
                          imageUrl: "",
                          outerCorner: Dimens.space0.w,
                          innerCorner: Dimens.space0.w,
                          iconUrl: CustomIcon.icon_person,
                          iconColor: CustomColors.white!,
                          iconSize: Dimens.space16.w,
                          boxDecorationColor: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow ? Const.OVERFLOW : clientNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.manropeSemiBold,
                            fontSize: Dimens.space10.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
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
}
