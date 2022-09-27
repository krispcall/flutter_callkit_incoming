import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/CountryCodeSelectorDialog.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/Validation.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/editContactRequestHolder/EditContactRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/editContactRequestParamHolder/EditContactRequestParamHolder.dart";
import "package:mvp/viewObject/model/allContact/Tags.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/editContact/EditContactResponse.dart";
import "package:provider/provider.dart";

class ContactIndividualDetailEditView extends StatefulWidget {
  final String editName;
  final String contactName;
  final String contactNumber;
  final String email;
  final String company;
  final String address;
  final String photoUpload;
  final List<Tags>? tags;
  final bool? visibility;
  final String? id;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  const ContactIndividualDetailEditView(
      {Key? key,
      required this.onIncomingTap,
      required this.onOutgoingTap,
      this.editName = "",
      this.contactName = "",
      this.contactNumber = "",
      this.email = "",
      this.company = "",
      this.address = "",
      this.photoUpload = "",
      this.tags,
      this.visibility,
      this.id})
      : super(key: key);

  @override
  _ContactIndividualDetailEditViewState createState() =>
      _ContactIndividualDetailEditViewState();
}

class _ContactIndividualDetailEditViewState
    extends State<ContactIndividualDetailEditView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  TextEditingController contactName = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController address = TextEditingController();
  CountryCode? selectedCountryCode;
  bool isConnectedToInternet = false;
  bool isSelected = true;
  bool showAdditionalDetail = false;
  ContactsProvider? contactsProvider;
  ContactRepository? contactRepository;
  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;
  List<CountryCode>? countryCodeList;
  Animation<double>? animation;
  ValueHolder? valueHolder;
  FocusNode phoneFocus = FocusNode();
  final _debounce = DeBouncer(milliseconds: 500);

  @override
  void initState() {
    contactNumber.text = widget.contactNumber;
    contactName.text = widget.contactName;
    email.text = widget.email;
    company.text = widget.company;
    address.text = widget.address;

    checkConnection();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController!.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);
    countryListProvider!.getCountryListFromDb().then((data) async {
      countryCodeList = data as List<CountryCode>;
      try {
        selectedCountryCode =
            await countryRepository!.getCountryCodeByIso(widget.contactNumber);
      } catch (e) {
        selectedCountryCode = countryListProvider!.getDefaultCountryCode();
        phoneFocus.requestFocus();
      }
      contactNumber.addListener(() async {
        _debounce.run(() async {
          if (contactNumber.text.isNotEmpty) {
            for (int i = 0; i < countryCodeList!.length; i++) {
              if (contactNumber.text.toLowerCase() ==
                  countryCodeList![i].dialCode!.toLowerCase()) {
                setState(() {
                  selectedCountryCode = countryCodeList![i];
                  contactNumber.selection = TextSelection.fromPosition(
                      TextPosition(offset: contactNumber.text.length));
                });
                break;
              }
            }
            if (selectedCountryCode!.dialCode == "+1" &&
                contactNumber.text.length > 2) {
              final String dumper = contactNumber.text.split("+1")[1];
              String dump2 = "";
              if (dumper.length > 2) {
                dump2 = dumper.substring(0, 3);
              } else {
                dump2 = dumper;
              }
              for (int i = 0; i < Utils.canadaList.length; i++) {
                if (dump2.contains(Utils.canadaList[i])) {
                  selectedCountryCode =
                      await countryRepository!.getCountryCodeAlphaCode("CA");
                  setState(() {});
                  break;
                } else {
                  selectedCountryCode =
                      await countryRepository!.getCountryCodeAlphaCode("US");
                  setState(() {});
                }
              }
            }
            if (selectedCountryCode!.dialCode == "+61" &&
                contactNumber.text.length > 4) {
              final String dump = contactNumber.text.split("+61")[1];
              if (dump.contains(Utils.australiaList[0])) {
                selectedCountryCode =
                    await countryRepository!.getCountryCodeAlphaCode("CC");
                contactNumber.selection = TextSelection.fromPosition(
                    TextPosition(offset: contactNumber.text.length));
                setState(() {});
              } else if (dump.contains(Utils.australiaList[1])) {
                selectedCountryCode =
                    await countryRepository!.getCountryCodeAlphaCode("CX");
                contactNumber.selection = TextSelection.fromPosition(
                    TextPosition(offset: contactNumber.text.length));
                setState(() {});
              } else {
                selectedCountryCode =
                    await countryRepository!.getCountryCodeAlphaCode("AU");
                contactNumber.selection = TextSelection.fromPosition(
                    TextPosition(offset: contactNumber.text.length));
                setState(() {});
              }
            }
            if (selectedCountryCode!.dialCode == "+64") {
              selectedCountryCode =
                  await countryRepository!.getCountryCodeAlphaCode("NZ");
              contactNumber.selection = TextSelection.fromPosition(
                  TextPosition(offset: contactNumber.text.length));
              setState(() {});
            }
          } else {
            setState(() {
              contactNumber.text = selectedCountryCode!.dialCode!;
              contactNumber.selection = TextSelection.fromPosition(
                  TextPosition(offset: contactNumber.text.length));
            });
          }
        });
      });
      validate("");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: CustomAppBar<ContactsProvider>(
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
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: CustomColors.transparent),
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
                                    : Utils.getString("cancel"),
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
                    flex: 2,
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : "Edit ${widget.editName == "contactName" ? "Contact Name" : widget.editName == "phoneNumber" ? "Phone Number" : widget.editName == "email" ? "Email Address" : widget.editName == "company" ? "Company Name" : "Address"}",
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
                  Expanded(child: Container()),
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
              return ContactsProvider(
                  contactRepository: contactRepository,
                  valueHolder: valueHolder);
            },
            onProviderReady: (ContactsProvider provider) async {
              contactsProvider = provider;
            },
            builder: (BuildContext? context, ContactsProvider? provider,
                Widget? child) {
              animationController!.forward();
              final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animationController!,
                      curve: const Interval(0.5 * 1, 1.0,
                          curve: Curves.fastOutSlowIn)));
              return countryCodeList != null
                  ? Container(
                      color: CustomColors.white,
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            if (widget.editName == "contactName")
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space30.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: CustomTextField(
                                  titleText: Utils.getString("contactName"),
                                  containerFillColor:
                                      CustomColors.baseLightColor!,
                                  borderColor: CustomColors.secondaryColor!,
                                  titleFont: Config.manropeBold,
                                  titleTextColor:
                                      CustomColors.textSecondaryColor!,
                                  titleMarginBottom: Dimens.space6,
                                  hintText: Utils.getString("contactName"),
                                  hintFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  inputFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  textEditingController: contactName,
                                  showTitle: true,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                ),
                              )
                            else
                              Container(),
                            if (widget.editName == "phoneNumber")
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space30.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: CustomTextField(
                                  codes: countryCodeList,
                                  focusNode: phoneFocus,
                                  selectedCountryCode: selectedCountryCode,
                                  // widget.defaultCountryCode,
                                  prefix: true,
                                  titleText: Utils.getString("phoneNumber"),
                                  containerFillColor:
                                      CustomColors.baseLightColor!,
                                  borderColor: CustomColors.secondaryColor!,
                                  titleFont: Config.manropeBold,
                                  titleTextColor:
                                      CustomColors.textSecondaryColor!,
                                  titleMarginBottom: Dimens.space6,
                                  hintText: "",
                                  hintFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  inputFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  textEditingController: contactNumber,
                                  showTitle: true,
                                  keyboardType: TextInputType.number,
                                  onPrefixTap: () {
                                    showCountryCodeSelectorDialog();
                                  },
                                  onChanged: () {
                                    setCountrySelection();
                                  },
                                ),
                              )
                            else
                              Container(),
                            if (widget.editName == "email")
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space18.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: CustomTextField(
                                  autoFocus: true,
                                  titleText: Utils.getString("emailAddress"),
                                  containerFillColor:
                                      CustomColors.baseLightColor!,
                                  borderColor: CustomColors.secondaryColor!,
                                  titleFont: Config.manropeBold,
                                  titleTextColor:
                                      CustomColors.textSecondaryColor!,
                                  titleMarginBottom: Dimens.space6,
                                  hintText: Utils.getString("emailAddress"),
                                  hintFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  inputFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  textEditingController: email,
                                  showTitle: true,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                ),
                              )
                            else
                              Container(),
                            if (widget.editName == "company")
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space18.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: CustomTextField(
                                  titleText: Utils.getString("company"),
                                  containerFillColor:
                                      CustomColors.baseLightColor!,
                                  borderColor: CustomColors.secondaryColor!,
                                  titleFont: Config.manropeBold,
                                  titleTextColor:
                                      CustomColors.textSecondaryColor!,
                                  titleMarginBottom: Dimens.space6,
                                  hintText: Utils.getString("companyName"),
                                  hintFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  inputFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  textEditingController: company,
                                  showTitle: true,
                                  autoFocus: true,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                ),
                              )
                            else
                              Container(),
                            if (widget.editName == "address")
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space18.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: CustomTextField(
                                  titleText: Utils.getString("address"),
                                  containerFillColor:
                                      CustomColors.baseLightColor!,
                                  borderColor: CustomColors.secondaryColor!,
                                  titleFont: Config.manropeBold,
                                  titleTextColor:
                                      CustomColors.textSecondaryColor!,
                                  titleMarginBottom: Dimens.space6,
                                  hintText: Utils.getString("address"),
                                  hintFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  inputFontColor:
                                      CustomColors.textQuaternaryColor!,
                                  textEditingController: address,
                                  showTitle: true,
                                  autoFocus: true,
                                  keyboardType: TextInputType.name,
                                ),
                              )
                            else
                              Container(),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space28.h,
                                  Dimens.space0.w,
                                  Dimens.space34.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: RoundedButtonWidget(
                                width: double.maxFinite,
                                buttonBackgroundColor: CustomColors.mainColor!,
                                buttonTextColor: CustomColors.white!,
                                corner: Dimens.space10,
                                buttonBorderColor: CustomColors.mainColor!,
                                buttonFontFamily: Config.manropeSemiBold,
                                buttonText: Utils.getString("saveChanges"),
                                onPressed: () async {
                                  FocusScope.of(context!).unfocus();
                                  if (widget.editName == "contactName" &&
                                      isValidName(contactName.text)
                                          .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                              message: isValidName(
                                                  contactName.text));
                                        });
                                  } else if (widget.editName == "phoneNumber" &&
                                      isValidPhoneNumber(contactNumber.text)
                                          .isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: isValidPhoneNumber(
                                                contactNumber.text),
                                          );
                                        });
                                  } else if (widget.editName == "phoneNumber" &&
                                      contactNumber.text.isNotEmpty &&
                                      contactNumber.text[0] != "+") {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: Utils.getString(
                                                "invalidPhoneNumber"),
                                          );
                                        });
                                  } else if (widget.editName == "phoneNumber" &&
                                      (await checkValidPhoneNumber(
                                              selectedCountryCode!,
                                              contactNumber.text))!
                                          .isNotEmpty) {
                                    if (contactNumber.text.contains("+31")) {
                                      final RegExp regExp =
                                          RegExp(r"^[+31][0-9]{11,15}$");
                                      if (!regExp
                                          .hasMatch(contactNumber.text)) {
                                        final String? message =
                                            await checkValidPhoneNumber(
                                                selectedCountryCode!,
                                                contactNumber.text);

                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message: message,
                                              );
                                            });
                                      } else {
                                        doEditContactApiCall();
                                      }
                                    } else if (contactNumber.text
                                        .contains("+372")) {
                                      final RegExp regExp =
                                          RegExp(r"^[+372][0-9]{10,12}$");
                                      if (!regExp
                                          .hasMatch(contactNumber.text)) {
                                        final String? message =
                                            await checkValidPhoneNumber(
                                                selectedCountryCode!,
                                                contactNumber.text);

                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message: message,
                                              );
                                            });
                                      } else {
                                        doEditContactApiCall();
                                      }
                                    }
                                  } else if (widget.editName == "email" &&
                                      isValidEmail(email.text).isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: isValidEmail(email.text),
                                          );
                                        });
                                  } else if (widget.editName == "company" &&
                                      isValidCompany(company.text).isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message:
                                                isValidCompany(company.text),
                                          );
                                        });
                                  } else if (widget.editName == "address" &&
                                      isValidAddress(address.text).isNotEmpty) {
                                    showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message:
                                                isValidAddress(address.text),
                                          );
                                        });
                                  } else {
                                    doEditContactApiCall();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AnimatedBuilder(
                      animation: animationController!,
                      builder: (BuildContext? context, Widget? child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - animation.value), 0.0),
                            child: Container(
                              color: CustomColors.white,
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
                              child: SpinKitCircle(
                                color: CustomColors.mainColor,
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }),
      ),
    );
  }

  Future<bool> _requestPop() {
    animationController!.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context, {"data": false, "clientId": null});
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  Future<void> alertModel() async {
    await showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space10.r),
        ),
        backgroundColor: Colors.black.withOpacity(0.01),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                Dimens.space16.w, Dimens.space0.h),
            child: SizedBox(
              height: Dimens.space328.h,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Dimens.space220.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Dimens.space16.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/private_number.png",
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: Dimens.space10.h),
                        Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("saveNumberPrivately"),
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    // color: CustomColors.loadingCircleColor,
                                    fontFamily: Config.manropeRegular,
                                    fontSize: Dimens.space20.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        SizedBox(height: Dimens.space10.h),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space21.w,
                              Dimens.space0.h,
                              Dimens.space21.w,
                              Dimens.space0.h),
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString(
                                    "numbersSavedPrivatelyCannotBeAccessed"),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.space16.h),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: Dimens.space48.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(Dimens.space16.r)),
                      child: const Center(
                        child: Text(
                            Config.checkOverFlow ? Const.OVERFLOW : "Close"),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.space32.h),
                ],
              ),
            ),
          );
        });
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  Future<void> showCountryCodeSelectorDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space10.r),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height.h,
          width: MediaQuery.of(context).size.width.w,
          padding: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              Utils.getStatusBarHeight(context) + 30,
              Dimens.space0.w,
              Dimens.space0.h),
          child: CountryCodeSelectorDialog(
            countryCodeList: countryCodeList,
            selectedCountryCode: selectedCountryCode,
            onSelectCountryCode: (CountryCode countryCode) {
              setState(() {
                selectedCountryCode = countryCode;
                contactNumber.text = selectedCountryCode!.dialCode!;
                validate("");
              });
            },
          ),
        );
      },
    );
  }

  Future<void> setCountrySelection() async {
    if (contactNumber.text.isEmpty) {
      selectedCountryCode =
          await countryRepository!.getCountryCodeByIso(contactNumber.text);
      setState(() {});
    } else {
      selectedCountryCode =
          await countryRepository!.getCountryCodeByIso(contactNumber.text);
      setState(() {});
    }
  }

  void validate(String number) {
    if (contactNumber.text.isEmpty) {
      contactNumber.text =
          "${selectedCountryCode!.dialCode}${contactNumber.text}$number";
      setState(() {});
    } else {
      contactNumber.text = contactNumber.text + number;
      setState(() {});
    }
  }

  Future<void> doEditContactApiCall() async {
    if (await Utils.checkInternetConnectivity()) {
      /*TODO: need tor replace the company name*/
      final EditContactRequestParamHolder editContactRequestParamHolder =
          EditContactRequestParamHolder(
        name: widget.editName != "contactName" ? null : contactName.text,
        company: widget.editName != "company" ? null : company.text,
        visibility: null,
        phoneNumber: widget.editName != "phoneNumber"
            ? null
            : widget.contactNumber == contactNumber.text
                ? contactNumber.text
                : contactNumber.text,
        email: widget.editName != "email"
            ? null
            : email.text.isEmpty
                ? null
                : email.text,
        address: widget.editName != "address" ? null : address.text,
        profileImageUrl: null,
      );
      await PsProgressDialog.showDialog(context);
      final Resources<EditContactResponse> editContactResponse =
          await contactsProvider!.editContactApiCall(
        EditContactRequestHolder(
          data: editContactRequestParamHolder,
          id: widget.id!,
        ),
      );

      if (editContactResponse.data != null) {
        await PsProgressDialog.dismissDialog();
        DashboardView.workspaceOrChannelChanged.fire(
          SubscriptionWorkspaceOrChannelChanged(
            event: "channelChanged",
          ),
        );
        if (!mounted) return;
        Navigator.pop(context, {
          "data": true,
          "id": editContactResponse.data!.editContactResponseData!.contacts!.id
        });
      } else if (editContactResponse.message != null) {
        await PsProgressDialog.dismissDialog();
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: editContactResponse.message,
              );
            });
      }
    } else {
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }
}
