import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/ui/common/dialog/ForgotPasswordSuccessDialog.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/Validation.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/forgotPasswordRequestParamHolder/ForgotPasswordRequestParamHolder.dart";
import "package:provider/provider.dart";

class ForgotPasswordView extends StatefulWidget {
  @override
  ForgotPasswordViewState createState() => ForgotPasswordViewState();
}

class ForgotPasswordViewState extends State<ForgotPasswordView>
    with TickerProviderStateMixin {
  UserRepository? userRepository;
  UserProvider? userProvider;

  AnimationController? animationController;
  Animation<double>? animation;

  ValueHolder? valueHolder;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    animationController!.forward();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    userRepository = Provider.of<UserRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar<UserProvider>(
      elevation: 0,
      removeHeight: true,
      onIncomingTap: () {},
      onOutgoingTap: () {},
      titleWidget: Container(),
      leadingWidget: Container(),
      initProvider: () {
        return UserProvider(
            userRepository: userRepository, valueHolder: valueHolder);
      },
      onProviderReady: (UserProvider provider) {
        userProvider = provider;
      },
      builder: (BuildContext? context, UserProvider? provider, Widget? child) {
        return AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                    Dimens.space16.w, Dimens.space0.h),
                color: CustomColors.white,
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space70.h),
                      color: CustomColors.white,
                      alignment: Alignment.centerLeft,
                      child: PlainAssetImageHolder(
                        containerAlignment: Alignment.centerLeft,
                        assetUrl: "assets/images/krispcall.png",
                        width: Dimens.space110,
                        height: Dimens.space30,
                        assetWidth: Dimens.space120,
                        assetHeight: Dimens.space30,
                        boxFit: BoxFit.contain,
                        iconUrl: CustomIcon.icon_person,
                        iconSize: Dimens.space10,
                        iconColor: CustomColors.mainColor!,
                        boxDecorationColor: CustomColors.transparent!,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                      ),
                    ),
                    LoginFields(
                      userProvider: userProvider!,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class LoginFields extends StatefulWidget {
  const LoginFields({
    required this.userProvider,
  });

  final UserProvider userProvider;

  @override
  LoginFieldsState createState() => LoginFieldsState();
}

class LoginFieldsState extends State<LoginFields> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode focusEmail = FocusNode();
  final emailKey = GlobalKey<FormState>();

  final TextEditingController dummyController = TextEditingController();
  final FocusNode focusDummy = FocusNode();
  final dummyKey = GlobalKey<FormState>();

  bool error = false;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    focusEmail.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Dimens.space0.w,
        Dimens.space0.h,
        Dimens.space0.w,
        Dimens.space0.h,
      ),
      color: CustomColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space30.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: CustomColors.loadingCircleColor,
                    size: Dimens.space16.w,
                  ),
                  Flexible(
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("back"),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.loadingCircleColor,
                            fontFamily: Config.manropeSemiBold,
                            fontWeight: FontWeight.normal,
                            fontSize: Dimens.space15.sp,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width.sw,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space40.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.centerLeft,
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("forgotPassword"),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: Dimens.space24.sp,
                  color: CustomColors.textPrimaryColor,
                  fontFamily: Config.manropeExtraBold,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width.sw,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space4.h,
                Dimens.space0.w, Dimens.space34.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("forgotPasswordDesc"),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: Dimens.space14.sp,
                    color: CustomColors.textTertiaryColor,
                    fontFamily: Config.heeboRegular,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
          Visibility(
            visible: error,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
                  Dimens.space0.w, Dimens.space10.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
                  Dimens.space0.w, Dimens.space10.h),
              color: CustomColors.errorBackgroundColor,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                    child: Icon(
                      Icons.error_rounded,
                      color: CustomColors.textPrimaryErrorColor,
                      size: Dimens.space20,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : errorText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: Dimens.space16.sp,
                              color: CustomColors.textPrimaryErrorColor,
                              fontFamily: Config.manropeRegular,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space20.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: CustomTextForm(
              focusNode: focusEmail,
              validationKey: emailKey,
              controller: emailController,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              context: context,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              focusColor: focusEmail.hasFocus
                  ? CustomColors.white!
                  : CustomColors.baseLightColor!,
              title: Utils.getString("emailAddress"),
              validatorErrorText: Utils.getString("required"),
              inputFontColor: CustomColors.textSenaryColor!,
              inputFontSize: Dimens.space16,
              inputFontStyle: FontStyle.normal,
              inputFontFamily: Config.heeboRegular,
              hint: "",
              hintFontColor: CustomColors.textQuaternaryColor!,
              hintFontFamily: Config.heeboRegular,
              hintFontStyle: FontStyle.normal,
              hintFontWeight: FontWeight.normal,
              titleFontColor: CustomColors.textSecondaryColor!,
              titleFontFamily: Config.manropeBold,
              titleFontSize: Dimens.space14,
              titleFontStyle: FontStyle.normal,
              titleFontWeight: FontWeight.normal,
              validator: (value) {
                final String val = isValidEmail(emailController.text.trim());
                if (value == "") {
                  return Utils.getString("required");
                } else if (val != "") {
                  return val;
                } else {
                  return null;
                }
              },
              changeFocus: () {
                focusDummy.requestFocus();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
                Dimens.space0.w, Dimens.space30.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedButtonWidget(
              width: double.maxFinite,
              buttonBackgroundColor: CustomColors.mainColor!,
              buttonTextColor: CustomColors.white!,
              corner: Dimens.space10,
              buttonBorderColor: CustomColors.mainColor!,
              buttonFontFamily: Config.manropeSemiBold,
              buttonText: Utils.getString("sendPasswordResetLink"),
              onPressed: () async {
                focusDummy.requestFocus();
                final email = emailKey.currentState!.validate();
                if (await Utils.checkInternetConnectivity()) {
                  if (email) {
                    // if (checkisNotEmpty) {
                    // error = true;
                    // errorText = checkLoginValidation;
                    // setState(() {});
                    // } else {
                    // error = false;
                    // errorText = "";
                    // setState(() {});

                    await PsProgressDialog.showDialog(context);
                    final ForgotPasswordRequestParamHolder
                        forgotPasswordRequestParamHolder =
                        ForgotPasswordRequestParamHolder(
                      userEmail: emailController.text,
                      route: "reset-password",
                    );
                    final Resources<String> response = await widget.userProvider
                            .doUserForgotPasswordApiCall(
                                forgotPasswordRequestParamHolder.toMap())
                        as Resources<String>;
                    if (response.data != null &&
                        response.data!.isNotEmpty) {
                      await PsProgressDialog.dismissDialog();
                      showForgotPasswordSuccessDialog();
                    } else {
                      await PsProgressDialog.dismissDialog();
                      // error = true;
                      // errorText = response.message;
                      // setState(() {});
                      errorAlertDialog(
                          context: context,
                          title: Utils.getString("forgotPassword"),
                          errorMsg: response.message);
                    }
                  }
                } else {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Utils.showWarningToastMessage(
                      Utils.getString("noInternet"), context);
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            height: 0,
            width: 0,
            child: TextField(
              focusNode: focusDummy,
              controller: dummyController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              autofocus: true,
              cursorHeight: 0,
              cursorColor: CustomColors.transparent,
              decoration: InputDecoration(
                isDense: true,
                errorMaxLines: 0,
                counterText: "",
                filled: true,
                fillColor: CustomColors.transparent,
                contentPadding: EdgeInsets.fromLTRB(
                  Dimens.space16.w,
                  Dimens.space14.h,
                  Dimens.space16.w,
                  Dimens.space14.h,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.space0.r),
                  ),
                  borderSide: BorderSide(
                    width: Dimens.space0.w,
                    color: CustomColors.transparent!,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space0.r)),
                  borderSide: BorderSide(
                    width: Dimens.space0.w,
                    color: CustomColors.transparent!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space0.r)),
                  borderSide: BorderSide(
                    width: Dimens.space0.w,
                    color: CustomColors.transparent!,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space0.r)),
                  borderSide: BorderSide(
                    width: Dimens.space0.w,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space0.r)),
                  borderSide: BorderSide(
                    width: Dimens.space0.w,
                    color: CustomColors.transparent!,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space0.r)),
                  borderSide: BorderSide(
                    width: Dimens.space0.w,
                    color: CustomColors.transparent!,
                  ),
                ),
                errorStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.transparent,
                      fontSize: Dimens.space0.sp,
                      fontStyle: FontStyle.normal,
                      fontFamily: Config.heeboRegular,
                      fontWeight: FontWeight.normal,
                    ),
                hintText: "",
                hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.transparent,
                      fontFamily: Config.heeboRegular,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      fontSize: Dimens.space0.sp,
                    ),
              ),
              onEditingComplete: () {
                focusEmail.requestFocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showForgotPasswordSuccessDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ForgotPasswordSuccessDialog(
          onDone: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                RoutePaths.loginView, (Route<dynamic> route) => false);
          },
        );
      },
    );
  }
}
