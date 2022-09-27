import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:image_cropper/image_cropper.dart";
import "package:image_picker/image_picker.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/CountryCodeSelectorDialog.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/Validation.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/addContactRequestParamHolder/AddContactRequestParamHolder.dart";
import "package:mvp/viewObject/model/addContact/AddContactResponse.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";

class ContactAddView extends StatefulWidget {
  final CountryCode? defaultCountryCode;
  final String? phoneNumber;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  const ContactAddView(
      {Key? key,
      required this.onIncomingTap,
      required this.onOutgoingTap,
      this.defaultCountryCode,
      this.phoneNumber})
      : super(key: key);

  @override
  _ContactAddViewState createState() => _ContactAddViewState();
}

class _ContactAddViewState extends State<ContactAddView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final TextEditingController contactName = TextEditingController();
  final FocusNode focusContactName = FocusNode();

  final TextEditingController contactNumber = TextEditingController();
  final FocusNode focusContactNumber = FocusNode();

  final TextEditingController textControllerEmail = TextEditingController();
  final FocusNode focusEmail = FocusNode();

  final TextEditingController textControllerCompany = TextEditingController();
  final FocusNode focusCompany = FocusNode();

  final TextEditingController textControllerAddress = TextEditingController();
  final FocusNode focusAddress = FocusNode();

  final contactNameKey = GlobalKey<FormState>();
  final phoneNumberKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormState>();
  final companyKey = GlobalKey<FormState>();
  final addressKey = GlobalKey<FormState>();

  CountryCode? selectedCountryCode;
  bool isConnectedToInternet = false;
  bool isSelected = true;
  bool showAdditionalDetail = false;
  ContactsProvider? contactsProvider;
  ContactRepository? contactRepository;
  File? _image;
  final _picker = ImagePicker();
  File? _selectedFile;
  String? selectedFilePath;
  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;
  List<CountryCode>? countryCodeList;
  Animation<double>? animation;
  bool isCountrySelected = false;

  ValueHolder? valueHolder;

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
      _getImage(ImageSource.gallery);
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

  @override
  void initState() {
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

    countryListProvider!.getCountryListFromDb().then((data) {
      countryCodeList = data as List<CountryCode>;
    });

    if (widget.defaultCountryCode != null) {
      selectedCountryCode = widget.defaultCountryCode;
    } else {
      selectedCountryCode = countryListProvider!.getDefaultCountryCode();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.phoneNumber != null) {
        isCountrySelected = true;
        selectedCountryCode = widget.defaultCountryCode;
        contactNumber.text = widget.phoneNumber!;
        countryListProvider!.updateSelectedCountryFlag(selectedCountryCode!);
      } else {
        contactNumber.text = "+1";
        contactNumber.selection =
            TextSelection.fromPosition(const TextPosition(offset: 1));
        Future.delayed(const Duration(milliseconds: 500), () {
          countryListProvider!.updateCountryFlag(contactNumber.text);
          // setState(() {});
        });
      }
    });

    contactNumber.addListener(() async {
      if (!isCountrySelected) {
        if (contactNumber.text.isEmpty) {
          contactNumber.text = "+";
          contactNumber.selection =
              TextSelection.fromPosition(const TextPosition(offset: 1));
        }
        countryListProvider!.updateCountryFlag(contactNumber.text);
      } else {
        if (contactNumber.text.isEmpty) {
          contactNumber.text = "+";
          contactNumber.selection = TextSelection.fromPosition(const TextPosition(offset: 1));
        }
        if ((contactNumber.text.length) < (selectedCountryCode!.dialCode!.length)) {
          isCountrySelected = false;
          countryListProvider!.updateCountryFlag(contactNumber.text);
        } else {
          countryListProvider!.updateCountryFlag(contactNumber.text, isCountrySelected: isCountrySelected, countryCode: selectedCountryCode);
        }
      }
    });
    super.initState();

    focusContactName.addListener(() {
      setState(() {});
    });

    focusEmail.addListener(() {
      setState(() {});
    });

    focusCompany.addListener(() {
      setState(() {});
    });

    focusAddress.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                  child: Text(
                    Config.checkOverFlow
                        ? Const.OVERFLOW
                        : Utils.getString("newContact"),
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
            return ContactsProvider(contactRepository: contactRepository, valueHolder: valueHolder);
          },
          onProviderReady: (ContactsProvider provider) async {
            contactsProvider = provider;
          },
          builder: (BuildContext? context, ContactsProvider? provider,
              Widget? child) {
            return Container(
              color: CustomColors.white,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                  Dimens.space16.w, Dimens.space0.h),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space30.h, Dimens.space0.w, Dimens.space0.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.space32.r),
                        child: PlainFileImageHolder(
                          width: Dimens.space80,
                          height: Dimens.space80,
                          containerAlignment: Alignment.bottomCenter,
                          iconUrl: CustomIcon.icon_profile,
                          iconColor: CustomColors.callInactiveColor!,
                          iconSize: Dimens.space68,
                          boxDecorationColor: CustomColors.mainDividerColor!,
                          outerCorner: Dimens.space32,
                          innerCorner: Dimens.space32,
                          fileUrl:
                              _selectedFile != null ? _selectedFile!.path : "",
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space5.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: InkWell(
                        onTap: () {
                          if (Platform.isIOS) {
                            _askPermissionPhotos();
                          } else {
                            _askPermissionStorage();
                          }
                        },
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("uploadPhoto"),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context!).textTheme.bodyText2!.copyWith(
                                    color: CustomColors.loadingCircleColor,
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
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space30.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: CustomTextForm(
                        focusNode: focusContactName,
                        title: Utils.getString("contactName"),
                        validationKey: contactNameKey,
                        controller: contactName,
                        context: context,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validatorErrorText: Utils.getString("required"),
                        focusColor: focusContactName.hasFocus
                            ? CustomColors.white!
                            : CustomColors.baseLightColor!,
                        inputFontColor: CustomColors.textQuaternaryColor!,
                        inputFontSize: Dimens.space16,
                        inputFontStyle: FontStyle.normal,
                        inputFontFamily: Config.heeboRegular,
                        titleFontColor: CustomColors.textSecondaryColor!,
                        titleFontFamily: Config.manropeBold,
                        titleFontSize: Dimens.space14,
                        titleFontStyle: FontStyle.normal,
                        titleFontWeight: FontWeight.normal,
                        hint: "",
                        hintFontColor: CustomColors.textQuaternaryColor!,
                        hintFontFamily: Config.heeboRegular,
                        hintFontStyle: FontStyle.normal,
                        hintFontWeight: FontWeight.normal,
                        validator: (value) {
                          final String val =
                              isValidName(contactName.text.trim());
                          if (value == "") {
                            return Utils.getString("required");
                          } else if (val != "") {
                            return val;
                          } else {
                            return null;
                          }
                        },
                        changeFocus: () {
                          focusContactNumber.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space16.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: PhoneNumberTextFieldWidget(
                        focusNode: focusContactNumber,
                        validationKey: phoneNumberKey,
                        onChanged: () {},
                        prefix: true,
                        height: Dimens.space58,
                        readOnly: widget.phoneNumber != null ? true : false,
                        selectedCountryCode: selectedCountryCode,
                        isForCountry: widget.phoneNumber != null ? true : false,
                        titleText: Utils.getString("phoneNumber"),
                        containerFillColor: CustomColors.baseLightColor!,
                        borderColor: CustomColors.secondaryColor!,
                        titleFont: Config.manropeBold,
                        titleTextColor: CustomColors.textSecondaryColor!,
                        titleMarginBottom: Dimens.space6,
                        hintText: "",
                        hintFontColor: CustomColors.textQuaternaryColor!,
                        inputFontColor: CustomColors.textQuaternaryColor!,
                        textEditingController: contactNumber,
                        showTitle: true,
                        keyboardType: TextInputType.phone,
                        provider: countryListProvider,
                        onPrefixTap: () {
                          Utils.removeKeyboard(context);
                          showCountryCodeSelectorDialog(countryListProvider!);
                        },
                        validator: (value) {
                          final String isValid =
                              isValidPhoneNumber(contactNumber.text.trim());
                          String checkIsValid = "";
                          checkValidPhoneNumber(selectedCountryCode!,
                                  contactNumber.text.trim())
                              .then((value) {
                            checkIsValid = value!;
                            return value;
                          });
                          if (checkIsValid.isNotEmpty) {
                            return checkIsValid;
                          } else if (value == "") {
                            return Utils.getString("required");
                          } else if (isValid.isNotEmpty) {
                            return isValid;
                          } else if (value!.isNotEmpty && value[0] != "+") {
                            return Utils.getString("invalidPhoneNumber");
                          } else {
                            return null;
                          }
                        },
                        changeFocus: () {
                          focusEmail.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space18.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                        onPressed: () {
                          showAdditionalDetail = !showAdditionalDetail;
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          backgroundColor: CustomColors.transparent,
                        ),
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
                                      .bodyText2!
                                      .copyWith(
                                        color: CustomColors.loadingCircleColor,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                  text: Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : Utils.getString("additionalDetails"),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space5.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Icon(
                                !showAdditionalDetail
                                    ? Icons.arrow_right
                                    : Icons.arrow_drop_down,
                                color: CustomColors.loadingCircleColor,
                                size: Dimens.space18.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !showAdditionalDetail,
                      child: Column(
                        children: [
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
                            child: CustomTextForm(
                              focusNode: focusEmail,
                              validationKey: emailKey,
                              controller: textControllerEmail,
                              context: context,
                              title: Utils.getString("emailId"),
                              titleSub: Utils.getString("optional"),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validatorErrorText: Utils.getString("required"),
                              focusColor: focusEmail.hasFocus
                                  ? CustomColors.white!
                                  : CustomColors.baseLightColor!,
                              inputFontColor: CustomColors.textQuaternaryColor!,
                              inputFontSize: Dimens.space16,
                              inputFontStyle: FontStyle.normal,
                              inputFontFamily: Config.heeboRegular,
                              titleFontColor: CustomColors.textSecondaryColor!,
                              titleFontFamily: Config.manropeBold,
                              titleFontSize: Dimens.space14,
                              titleFontStyle: FontStyle.normal,
                              titleFontWeight: FontWeight.normal,
                              hint: "",
                              hintFontColor: CustomColors.textQuaternaryColor!,
                              hintFontFamily: Config.heeboRegular,
                              hintFontStyle: FontStyle.normal,
                              hintFontWeight: FontWeight.normal,
                              validator: (value) {
                                final String val = isValidEmail(
                                    textControllerEmail.text.trim(),
                                    applyEmptyValidation: false);
                                if (val != "") {
                                  return val;
                                } else {
                                  return null;
                                }
                              },
                              changeFocus: () {
                                focusCompany.requestFocus();
                              },
                            ),
                          ),
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
                            child: CustomTextForm(
                              focusNode: focusCompany,
                              validationKey: companyKey,
                              controller: textControllerCompany,
                              context: context,
                              title: Utils.getString("company"),
                              titleSub: Utils.getString("optional"),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validatorErrorText: Utils.getString("required"),
                              focusColor: focusCompany.hasFocus
                                  ? CustomColors.white!
                                  : CustomColors.baseLightColor!,
                              inputFontColor: CustomColors.textQuaternaryColor!,
                              inputFontSize: Dimens.space16,
                              inputFontStyle: FontStyle.normal,
                              inputFontFamily: Config.heeboRegular,
                              titleFontColor: CustomColors.textSecondaryColor!,
                              titleFontFamily: Config.manropeBold,
                              titleFontSize: Dimens.space14,
                              titleFontStyle: FontStyle.normal,
                              titleFontWeight: FontWeight.normal,
                              hint: "",
                              hintFontColor: CustomColors.textQuaternaryColor!,
                              hintFontFamily: Config.heeboRegular,
                              hintFontStyle: FontStyle.normal,
                              hintFontWeight: FontWeight.normal,
                              validator: (value) {
                                final String val = isValidCompany(
                                    textControllerCompany.text.trim());
                                if (val != "") {
                                  return val;
                                } else {
                                  return null;
                                }
                              },
                              changeFocus: () {
                                focusAddress.requestFocus();
                              },
                            ),
                          ),
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
                            child: CustomTextForm(
                              focusNode: focusAddress,
                              validationKey: addressKey,
                              controller: textControllerAddress,
                              context: context,
                              title: Utils.getString("address"),
                              titleSub: Utils.getString("optional"),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              validatorErrorText: Utils.getString("required"),
                              focusColor: focusAddress.hasFocus
                                  ? CustomColors.white!
                                  : CustomColors.baseLightColor!,
                              inputFontColor: CustomColors.textQuaternaryColor!,
                              inputFontSize: Dimens.space16,
                              inputFontStyle: FontStyle.normal,
                              inputFontFamily: Config.heeboRegular,
                              titleFontColor: CustomColors.textSecondaryColor!,
                              titleFontFamily: Config.manropeBold,
                              titleFontSize: Dimens.space14,
                              titleFontStyle: FontStyle.normal,
                              titleFontWeight: FontWeight.normal,
                              hint: "",
                              hintFontColor: CustomColors.textQuaternaryColor!,
                              hintFontFamily: Config.heeboRegular,
                              hintFontStyle: FontStyle.normal,
                              hintFontWeight: FontWeight.normal,
                              validator: (value) {
                                final String val = isValidAddress(
                                    textControllerAddress.text.trim());
                                if (val != "") {
                                  return val;
                                } else {
                                  return null;
                                }
                              },
                              changeFocus: () {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space30.h, Dimens.space0.w, Dimens.space34.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedButtonWidget(
                        width: double.maxFinite,
                        buttonBackgroundColor: CustomColors.mainColor!,
                        buttonTextColor: CustomColors.white!,
                        corner: Dimens.space10,
                        buttonBorderColor: CustomColors.mainColor!,
                        buttonFontFamily: Config.manropeSemiBold,
                        buttonText: Utils.getString("addANewContact"),
                        onPressed: () async {
                          Utils.removeKeyboard(context);
                          final contactName =
                              contactNameKey.currentState!.validate();
                          final phoneNumber =
                              phoneNumberKey.currentState!.validate();
                          final email = emailKey.currentState!.validate();
                          final company = companyKey.currentState!.validate();
                          final address = addressKey.currentState!.validate();
                          if (contactName &&
                              phoneNumber &&
                              email &&
                              company &&
                              address) {
                            _proceedAddContact();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontFamily: Config.manropeRegular,
                              fontSize: Dimens.space20.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      SizedBox(height: Dimens.space10.h),
                      Padding(
                        padding: EdgeInsets.fromLTRB(Dimens.space21.w,
                            Dimens.space0.h, Dimens.space21.w, Dimens.space0.h),
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
                      borderRadius: BorderRadius.circular(Dimens.space16.r),
                    ),
                    child: const Center(
                      child:
                          Text(Config.checkOverFlow ? Const.OVERFLOW : "Close"),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.space32.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet) {
        setState(() {});
      }
    });
  }

  Future<void> showCountryCodeSelectorDialog(
      CountryListProvider countryListProvider) async {
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
                isCountrySelected = true;
                selectedCountryCode = countryCode;
                countryListProvider.updateSelectedCountryFlag(countryCode);
                contactNumber.text =
                    "${selectedCountryCode!.dialCode}${(widget.phoneNumber != null) ? widget.phoneNumber : ""}";
              },
            ),
          );
        });
  }

  Future<void> _proceedAddContact() async {
    if (await Utils.checkInternetConnectivity()) {
      final AddContactRequestParamHolder addContactRequestParamHolder =
          AddContactRequestParamHolder(
        country: selectedCountryCode!.id!,
        name: contactName.text,
        company: textControllerCompany.text.trim(),
        visibility: isSelected,
        phoneNumber: contactNumber.text,
        email: textControllerEmail.text.isEmpty
            ? ""
            : textControllerEmail.text.trim(),
        address: textControllerAddress.text.trim(),
      );
      await PsProgressDialog.showDialog(context);
      final Resources<AddContactResponse> addContactResponse =
          await contactsProvider!.doAddContactsApiCall(
                  addContactRequestParamHolder, _selectedFile)
              as Resources<AddContactResponse>;
      if (addContactResponse.data != null) {
        await PsProgressDialog.dismissDialog();
        if (!mounted) return;
        Navigator.pop(context, {
          "data": true,
          "clientId":
              addContactResponse.data?.addContactResponseData?.contacts?.id
        });
      } else if (addContactResponse.message != null) {
        await PsProgressDialog.dismissDialog();
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: addContactResponse.message,
              );
            });
      }
    } else {
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }
}
