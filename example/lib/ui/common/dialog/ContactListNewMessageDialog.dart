import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:provider/provider.dart";

class ContactListNewMessageDialog extends StatefulWidget {
  const ContactListNewMessageDialog({
    Key? key,
    @required this.animationController,
    @required this.onItemTap,
    @required this.defaultCountryCode,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final AnimationController? animationController;
  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;
  final CountryCode? defaultCountryCode;
  final Function(Contacts)? onItemTap;

  @override
  ContactListNewMessageDialogState createState() =>
      ContactListNewMessageDialogState();
}

class ContactListNewMessageDialogState
    extends State<ContactListNewMessageDialog> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  TextEditingController textEditingControllerSearchContacts =
      TextEditingController();

  Contacts? selectedContact;

  ContactRepository? contactRepository;
  ContactsProvider? contactsProvider;

  bool isLoading = false;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  ValueHolder? valueHolder;

  @override
  void initState() {
    if (!isConnectedToInternet) {
      checkConnection();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.defaultCountryCode != null) {
        textEditingControllerSearchContacts.text =
            widget.defaultCountryCode!.dialCode!;
      } else {
        textEditingControllerSearchContacts.text = "+1";
      }
    });
    super.initState();

    contactRepository = Provider.of<ContactRepository>(context, listen: false);

    valueHolder = Provider.of<ValueHolder>(context, listen: false);
  }

  @override
  void dispose() {
    textEditingControllerSearchContacts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height.h,
      width: MediaQuery.of(context).size.width.w,
      color: CustomColors.transparent,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Scaffold(
        backgroundColor: CustomColors.transparent,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space14.h,
                  Dimens.space20.w, Dimens.space14.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space20.w,
                        Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("newMessage"),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.manropeBold,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space18.sp,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  Positioned(
                    left: Dimens.space0.w,
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space24,
                      height: Dimens.space24,
                      iconUrl: Icons.close_outlined,
                      iconColor: CustomColors.loadingCircleColor,
                      iconSize: Dimens.space20,
                      outerCorner: Dimens.space0,
                      innerCorner: Dimens.space0,
                      boxDecorationColor: CustomColors.transparent,
                      imageUrl: "",
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1.h,
              thickness: Dimens.space1.h,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space15.w, Dimens.space20.h,
                  Dimens.space15.w, Dimens.space20.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: CustomColors.textTertiaryColor!, width: 0.2),
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.space8.r),
                ),
                color: CustomColors.baseLightColor,
              ),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space14.w,
                        Dimens.space0.h, Dimens.space8.w, Dimens.space0.h),
                    constraints: BoxConstraints(
                      maxWidth: Dimens.space30.w,
                      minWidth: Dimens.space10.w,
                    ),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : "${Utils.getString("to")} : ",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textSenaryColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
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
                      alignment: Alignment.center,
                      child: TextField(
                        controller: textEditingControllerSearchContacts,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.textSenaryColor,
                            fontFamily: Config.manropeMedium,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space14.sp,
                            fontStyle: FontStyle.normal),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space13.h,
                            Dimens.space0.w,
                            Dimens.space13.h,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space10.r),
                            ),
                          ),
                          hintText: "Enter name or number with country code",
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space10.r),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space10.r),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space10.r),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space10.r),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: Dimens.space0.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space10.r),
                            ),
                          ),
                          filled: true,
                          fillColor: CustomColors.baseLightColor,
                          hintStyle:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.textQuinaryColor,
                                    fontFamily: Config.manropeMedium,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space12.sp,
                                    fontStyle: FontStyle.normal,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ChangeNotifierProvider<ContactsProvider>(
              lazy: false,
              create: (BuildContext context) {
                contactsProvider = ContactsProvider(
                  contactRepository: contactRepository,
                );
                contactsProvider!.doAllContactApiCall();
                textEditingControllerSearchContacts.addListener(() {
                  if (textEditingControllerSearchContacts.text.length > 1 &&
                      textEditingControllerSearchContacts.text
                          .startsWith("+") &&
                      RegExp(r"^[a-z]+$").hasMatch(
                          textEditingControllerSearchContacts.text
                              .substring(1, 2))) {
                    contactsProvider!.doSearchContactNameOrNumber("zzzzzzz");
                  } else {
                    contactsProvider!.doSearchContactNameOrNumber(
                      textEditingControllerSearchContacts.text,
                    );
                  }
                });

                return contactsProvider!;
              },
              child: Consumer<ContactsProvider>(
                builder: (BuildContext? context, ContactsProvider? provider1,
                    Widget? child) {
                  return Expanded(
                    child: Container(
                      color: CustomColors.white,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: contactsProvider!.contactList!.data!.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  contactsProvider!.contactList!.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final int count =
                                    contactsProvider!.contactList!.data!.length;
                                widget.animationController!.forward();
                                return NewMessageListItemView(
                                  animationController:
                                      widget.animationController!,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: widget.animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  offStage: false,
                                  contactEdges: contactsProvider!
                                      .contactList!.data![index],
                                  onTap: () async {
                                    selectedContact = contactsProvider!
                                        .contactList!.data![index];
                                    setState(() {});
                                    widget.onItemTap!(selectedContact!);
                                  },
                                );
                              },
                              physics: const BouncingScrollPhysics(),
                            )
                          : Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(
                                Dimens.space20.w,
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
                              child: Text(
                                Utils.getString("noResultContact"),
                                style: Theme.of(context!)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: CustomColors.textPrimaryLightColor,
                                      fontFamily: Config.heeboRegular,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewMessageListItemView extends StatelessWidget {
  const NewMessageListItemView({
    Key? key,
    required this.contactEdges,
    required this.onTap,
    required this.animationController,
    required this.offStage,
    required this.animation,
  }) : super(key: key);

  final Contacts? contactEdges;
  final Function onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final bool? offStage;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext? context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation!.value), 0.0),
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space7.h,
                  Dimens.space20.w, Dimens.space7.h),
              child: TextButton(
                onPressed: () {
                  onTap();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center,
                ),
                child: NewMessageListTile(
                  contactEdges: contactEdges!,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewMessageListTile extends StatelessWidget {
  const NewMessageListTile({
    Key? key,
    @required this.contactEdges,
  }) : super(key: key);

  final Contacts? contactEdges;

  @override
  Widget build(BuildContext context) {
    if (contactEdges != null) {
      return Container(
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
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
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
              alignment: Alignment.center,
              child: RoundedNetworkImageHolder(
                width: Dimens.space40,
                height: Dimens.space40,
                iconUrl: CustomIcon.icon_profile,
                containerAlignment: Alignment.bottomCenter,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space30,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space20,
                innerCorner: Dimens.space20,
                imageUrl: contactEdges!.profilePicture != null &&
                        contactEdges!.profilePicture!.isNotEmpty
                    ? contactEdges!.profilePicture
                    : "",
              ),
            ),
            Flexible(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(
                  Dimens.space10.w,
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
                child: RichText(
                  text: TextSpan(
                    text: Utils.getString("sendTo"),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontFamily: Config.heeboRegular,
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                    children: [
                      TextSpan(
                        text: Config.checkOverFlow
                            ? Const.OVERFLOW
                            : contactEdges!.name != null &&
                                    contactEdges!.name!.isNotEmpty
                                ? contactEdges!.name
                                : contactEdges!.number,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.loadingCircleColor,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
