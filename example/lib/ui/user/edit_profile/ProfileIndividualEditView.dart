import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/user/userProvider.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/ui/common/dialog/SuccessDialog.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/Validation.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EditProfileIntentHolder.dart";
import "package:mvp/viewObject/model/login/User.dart";
import "package:mvp/viewObject/model/profile/EditProfile.dart";
import "package:provider/provider.dart";

class ProfileIndividualDetailEditView extends StatefulWidget {
  final String whichToEdit;
  final VoidCallback onProfileUpdateCallback;
  final VoidCallback onIncomingTap;
  final VoidCallback? onOutgoingTap;

  const ProfileIndividualDetailEditView({
    Key? key,
    required this.whichToEdit,
    required this.onProfileUpdateCallback,
    required this.onIncomingTap,
    this.onOutgoingTap,
  }) : super(key: key);

  @override
  _ProfileIndividualDetailEditViewState createState() =>
      _ProfileIndividualDetailEditViewState();
}

class _ProfileIndividualDetailEditViewState
    extends State<ProfileIndividualDetailEditView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  TextEditingController textEditingControllerFirstname =
      TextEditingController();
  final firstnameKey = GlobalKey<FormState>();
  final FocusNode focusFirstname = FocusNode();

  TextEditingController textEditingControllerLastname = TextEditingController();
  final lastnameKey = GlobalKey<FormState>();
  final FocusNode focusLastname = FocusNode();

  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  bool isConnectedToInternet = false;
  bool isSelected = true;
  bool showAdditionalDetail = false;
  Animation<double>? animation;
  UserRepository? userRepository;
  UserProvider? userProvider;
  ValueHolder? valueHolder;

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    userRepository = Provider.of<UserRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    focusFirstname.addListener(() {
      setState(() {});
    });

    focusLastname.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: CustomAppBar<UserProvider>(
          onIncomingTap: () {
            widget.onIncomingTap();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap!();
          },
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
                        : Utils.getString("editProfile"),
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
                Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h)),
                ),
              ],
            ),
          ),
          leadingWidget: null,
          elevation: 0.6,
          initProvider: () {
            userProvider = UserProvider(
              userRepository: userRepository,
              valueHolder: valueHolder,
            );
            return userProvider;
          },
          onProviderReady: (UserProvider provider) async {
            textEditingControllerFirstname.text =
                userProvider!.getUserFirstName();

            textEditingControllerLastname.text =
                userProvider!.getUserLastName();

            textEditingControllerEmail.text = userProvider!.getUserEmail();

            textEditingControllerPassword.text =
                userProvider!.getUserPassword();
          },
          builder:
              (BuildContext? context, UserProvider? provider, Widget? child) {
            return Container(
              color: CustomColors.white,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (widget.whichToEdit == "name")
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space30.h,
                            Dimens.space16.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: CustomTextForm(
                          focusNode: focusFirstname,
                          validationKey: firstnameKey,
                          controller: textEditingControllerFirstname,
                          context: context!,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          validatorErrorText: Utils.getString("required"),
                          focusColor: focusFirstname.hasFocus
                              ? CustomColors.white!
                              : CustomColors.baseLightColor!,
                          inputFontColor: CustomColors.textQuaternaryColor!,
                          inputFontSize: Dimens.space16,
                          inputFontStyle: FontStyle.normal,
                          inputFontFamily: Config.heeboRegular,
                          title: Utils.getString("firstName"),
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
                            final String val = isValidFirstName(
                                textEditingControllerFirstname.text.trim());
                            if (val != "") {
                              return val;
                            } else {
                              return null;
                            }
                          },
                          changeFocus: () {
                            focusLastname.requestFocus();
                          },
                        ),
                      )
                    else
                      Container(),
                    if (widget.whichToEdit == "name")
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space30.h,
                            Dimens.space16.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: CustomTextForm(
                          focusNode: focusLastname,
                          validationKey: lastnameKey,
                          controller: textEditingControllerLastname,
                          context: context!,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          validatorErrorText: Utils.getString("required"),
                          focusColor: focusLastname.hasFocus
                              ? CustomColors.white!
                              : CustomColors.baseLightColor!,
                          inputFontColor: CustomColors.textQuaternaryColor!,
                          inputFontSize: Dimens.space16,
                          inputFontStyle: FontStyle.normal,
                          inputFontFamily: Config.heeboRegular,
                          title: Utils.getString("lastName"),
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
                            final String val = isValidLastName(
                                textEditingControllerLastname.text.trim());
                            if (val != "") {
                              return val;
                            } else {
                              return null;
                            }
                          },
                          changeFocus: () {
                            focusFirstname.requestFocus();
                          },
                        ),
                      )
                    else
                      Container(),
                    if (widget.whichToEdit == "email")
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space18.h,
                            Dimens.space16.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: CustomTextField(
                          autoFocus: true,
                          height: Dimens.space48,
                          titleText: Utils.getString("emailAddress"),
                          containerFillColor: CustomColors.baseLightColor!,
                          borderColor: CustomColors.secondaryColor!,
                          maxLength: 46,
                          titleFont: Config.manropeBold,
                          titleTextColor: CustomColors.textSecondaryColor!,
                          titleMarginBottom: Dimens.space6,
                          hintText: Utils.getString("emailAddress"),
                          hintFontColor: CustomColors.textQuaternaryColor!,
                          inputFontColor: CustomColors.textQuaternaryColor!,
                          textEditingController: textEditingControllerEmail,
                          onChanged: () {},
                          showTitle: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                      )
                    else
                      Container(),
                    if (widget.whichToEdit == "password")
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space18.h,
                            Dimens.space16.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: CustomTextField(
                          obscure: obscurePassword,
                          height: Dimens.space48,
                          titleText: Utils.getString("passwordConfirmChanges"),
                          containerFillColor: CustomColors.baseLightColor!,
                          borderColor: CustomColors.secondaryColor!,
                          titleFont: Config.manropeBold,
                          titleTextColor: CustomColors.textSecondaryColor!,
                          titleMarginBottom: Dimens.space6,
                          hintText: Utils.getString("password"),
                          hintFontColor: CustomColors.textQuaternaryColor!,
                          inputFontColor: CustomColors.textQuaternaryColor!,
                          textEditingController: textEditingControllerPassword,
                          showTitle: true,
                          autoFocus: true,
                          onSuffixTap: () {
                            obscurePassword = !obscurePassword;
                            setState(() {});
                          },
                          suffix: true,
                          textInputAction: TextInputAction.next,
                        ),
                      )
                    else
                      Container(),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                        Dimens.space16.w,
                        Dimens.space28.h,
                        Dimens.space16.w,
                        Dimens.space34.h,
                      ),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedButtonWidget(
                        width: double.maxFinite,
                        height: Dimens.space54,
                        buttonBackgroundColor: CustomColors.mainColor!,
                        buttonTextColor: CustomColors.white!,
                        corner: Dimens.space10,
                        buttonBorderColor: CustomColors.mainColor!,
                        buttonFontFamily: Config.manropeSemiBold,
                        buttonText: Utils.getString("saveChanges"),
                        onPressed: () async {
                          FocusScope.of(context!).unfocus();
                          Utils.checkInternetConnectivity().then(
                            (bool onValue) async {
                              if (onValue) {
                                if (widget.whichToEdit == "name") {
                                  final isFirstnameValid =
                                      firstnameKey.currentState!.validate();
                                  final isLastnameValid =
                                      lastnameKey.currentState!.validate();
                                  if (isFirstnameValid && isLastnameValid) {
                                    await PsProgressDialog.showDialog(context,
                                        isDissmissable: true);
                                    final Resources<EditProfile>
                                        changeProfileResponse =
                                        await provider!.editUsernameApiCall({
                                      "data": {
                                        "firstName":
                                            textEditingControllerFirstname.text,
                                        "lastName":
                                            textEditingControllerLastname.text,
                                      }
                                    });

                                    if (changeProfileResponse.data != null) {
                                      await PsProgressDialog.dismissDialog();
                                      widget.onProfileUpdateCallback();
                                    }
                                  }
                                } else if (widget.whichToEdit == "email") {
                                  if (isValidEmail(
                                          textEditingControllerEmail.text)
                                      .isNotEmpty) {
                                    showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorDialog(
                                          message: isValidEmail(
                                            textEditingControllerEmail.text,
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.pushNamed(
                                      context,
                                      RoutePaths.profileIndividualEditView,
                                      arguments: EditProfileIntentHolder(
                                        whichToEdit: "password",
                                        onProfileUpdateCallback: () {
                                          widget.onProfileUpdateCallback();
                                        },
                                        onIncomingTap: () {
                                          widget.onIncomingTap();
                                        },
                                        onOutgoingTap: () {
                                          widget.onOutgoingTap!();
                                        },
                                      ),
                                    );
                                  }
                                } else if (widget.whichToEdit == "password") {
                                  if (passwordValidation(
                                          textEditingControllerPassword.text)
                                      .isNotEmpty) {
                                    showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorDialog(
                                          message: passwordValidation(
                                              textEditingControllerPassword
                                                  .text),
                                        );
                                      },
                                    );
                                  } else {
                                    await PsProgressDialog.showDialog(context);
                                    final Resources<UpdateUserEmail>
                                        updateEmail =
                                        await userProvider!.changeEmail({
                                      "data": {
                                        "email":
                                            textEditingControllerEmail.text,
                                        "confirmEmail":
                                            textEditingControllerEmail.text,
                                        "password":
                                            textEditingControllerPassword.text
                                      }
                                    }) as Resources<UpdateUserEmail>;
                                    if (updateEmail.data != null) {
                                      userProvider!.updateEmail(
                                          textEditingControllerEmail.text);
                                      await PsProgressDialog.dismissDialog();
                                      await showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const SuccessDialog(
                                            message: "Your email is changed.",
                                          );
                                        },
                                      );
                                      if (!mounted) return null;
                                      Navigator.pop(context, {
                                        "data": true,
                                      });
                                      Navigator.pop(context, {
                                        "data": true,
                                      });
                                    } else {
                                      await PsProgressDialog.dismissDialog();
                                      showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ErrorDialog(
                                            message: updateEmail.message ??
                                                "Something went wrong.",
                                          );
                                        },
                                      );
                                    }
                                  }
                                }
                              } else {
                                Utils.showWarningToastMessage(
                                    Utils.getString("noInternet"), context);
                              }
                            },
                          );
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
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
    return Future<bool>.value(true);
  }
}
