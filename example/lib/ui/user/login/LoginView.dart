import "dart:io";

import "package:device_info_plus/device_info_plus.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/Validation.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EmptyCardDetailsParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/UserLoginParameterHolder.dart";
import "package:mvp/viewObject/holder/request_holder/WorkSpaceRequestParamHolder.dart";
import "package:mvp/viewObject/model/channel/ChannelData.dart";
import "package:mvp/viewObject/model/checkDuplicateLogin/CheckDuplicateLogin.dart";
import "package:mvp/viewObject/model/login/LoginDataDetails.dart";
import "package:mvp/viewObject/model/memberLogin/Member.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  UserRepository? userRepository;
  UserProvider? userProvider;
  AnimationController? animationController;
  Animation<double>? animation;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;

  ValueHolder? valueHolder;

  @override
  void initState() {
    super.initState();
    CustomAppBar.changeStatusColor(CustomColors.white!);
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
    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    countryRepository = Provider.of<CountryRepository>(context, listen: false);
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
      builder:
          (BuildContext? context, UserProvider? userProvider, Widget? child) {
        return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context!).size.width,
              height: MediaQuery.of(context).size.height,
              color: CustomColors.transparent,
              alignment: Alignment.center,
              child: MultiProvider(
                providers: <SingleChildWidget>[
                  ChangeNotifierProvider<LoginWorkspaceProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      loginWorkspaceProvider = LoginWorkspaceProvider(
                        loginWorkspaceRepository: loginWorkspaceRepository,
                        valueHolder: valueHolder,
                      );
                      return loginWorkspaceProvider!;
                    },
                  ),
                  ChangeNotifierProvider<CountryListProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      countryListProvider = CountryListProvider(
                          countryListRepository: countryRepository);
                      return countryListProvider!;
                    },
                  ),
                ],
                child: AnimatedBuilder(
                  animation: animationController!,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                      color: CustomColors.white,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space70.h),
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
                            loginWorkspaceProvider: loginWorkspaceProvider!,
                            countryListProvider: countryListProvider!,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ));
      },
    );
  }
}

class LoginFields extends StatefulWidget {
  const LoginFields({
    required this.userProvider,
    required this.loginWorkspaceProvider,
    required this.countryListProvider,
  });

  final UserProvider userProvider;
  final LoginWorkspaceProvider loginWorkspaceProvider;
  final CountryListProvider countryListProvider;

  @override
  LoginFieldsState createState() => LoginFieldsState();
}

class LoginFieldsState extends State<LoginFields> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode focusEmail = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode focusPassword = FocusNode();

  final TextEditingController dummyController = TextEditingController();
  final FocusNode focusDummy = FocusNode();

  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();
  final dummyKey = GlobalKey<FormState>();

  bool obscure = true;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String uniqueKey = "";

  @override
  void initState() {
    getUniQueKey();
    super.initState();
    ensureDebugMode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showBottomLoginError(isDuplicateLogin: false);
    });
    focusEmail.addListener(() {
      setState(() {});
    });

    focusPassword.addListener(() {
      setState(() {});
    });

    // Future.delayed(const Duration(seconds: 5)).then((value) => doAutoLogin());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    dummyController.dispose();

    focusEmail.dispose();
    focusPassword.dispose();
    focusDummy.dispose();

    super.dispose();
  }

  Future<void> getUniQueKey() async {
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        uniqueKey = iosInfo.identifierForVendor!;
      });
    } else {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        uniqueKey = androidInfo.id!;
      });
    }
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
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width.sw,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.centerLeft,
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("welcomeBack"),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: Dimens.space24.sp,
                    color: CustomColors.textPrimaryColor,
                    fontFamily: Config.manropeExtraBold,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width.sw,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space4.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Utils.getString("pleaseLoginToContinue"),
              maxLines: 1,
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
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
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
              validatorErrorText: Utils.getString("required"),
              focusColor: focusEmail.hasFocus
                  ? CustomColors.white!
                  : CustomColors.baseLightColor!,
              inputFontColor: CustomColors.textSenaryColor!,
              inputFontSize: Dimens.space16,
              inputFontStyle: FontStyle.normal,
              inputFontFamily: Config.heeboRegular,
              title: Utils.getString("emailAddress"),
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
                focusPassword.requestFocus();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space24.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: CustomTextForm(
              focusNode: focusPassword,
              validationKey: passwordKey,
              controller: passwordController,
              context: context,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validatorErrorText: Utils.getString("required"),
              focusColor: focusPassword.hasFocus
                  ? CustomColors.white!
                  : CustomColors.baseLightColor!,
              inputFontColor: CustomColors.textSenaryColor!,
              inputFontSize: Dimens.space16,
              inputFontStyle: FontStyle.normal,
              inputFontFamily: Config.heeboRegular,
              hint: "",
              hintFontColor: CustomColors.textQuaternaryColor!,
              hintFontFamily: Config.heeboRegular,
              hintFontStyle: FontStyle.normal,
              hintFontWeight: FontWeight.normal,
              title: Utils.getString("password"),
              titleFontColor: CustomColors.textSecondaryColor!,
              titleFontFamily: Config.manropeBold,
              titleFontSize: Dimens.space14,
              titleFontStyle: FontStyle.normal,
              titleFontWeight: FontWeight.normal,
              suffix: true,
              obscure: obscure,
              onSuffixTap: () {
                setState(() {
                  obscure = !obscure;
                });
              },
              validator: (value) {
                if (value == "") {
                  return Utils.getString("required");
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
                Dimens.space0.w, Dimens.space0.h),
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
              buttonText: Utils.getString("login"),
              onPressed: () async {
                focusDummy.requestFocus();
                final email = emailKey.currentState!.validate();
                final password = passwordKey.currentState!.validate();
                if (email && password) {
                  await PsProgressDialog.showDialog(context);
                  if (await Utils.checkInternetConnectivity()) {
                    final UserLoginParameterHolder userLoginParameterHolder =
                        UserLoginParameterHolder(
                      client: "mobile",
                      details: UserLoginParamDetails(
                        userEmail: emailController.text,
                        userPassword: passwordController.text,
                        kind: "classic",
                      ),
                      deviceId: uniqueKey,
                    );

                    final Resources<CheckDuplicateLogin> checkDuplicateLogin =
                        await widget.userProvider.doCheckDuplicateLogin(
                                userLoginParameterHolder.toMap())
                            as Resources<CheckDuplicateLogin>;

                    if (checkDuplicateLogin.data != null &&
                        !checkDuplicateLogin
                            .data!.clientDndResponseData!.data!.success!) {
                      login(isFromBottomSheet: false, isDuplicateLogin: false);
                    } else if (checkDuplicateLogin.status == Status.ERROR) {
                      if (checkDuplicateLogin.message!.toLowerCase() !=
                          "Invalid Credentials".toLowerCase()) {
                        login(
                            isFromBottomSheet: false, isDuplicateLogin: false);
                      } else {
                        UserLoginParameterHolder userLoginParameterHolder;
                        userLoginParameterHolder = UserLoginParameterHolder(
                          client: "mobile",
                          details: UserLoginParamDetails(
                            userEmail: emailController.text,
                            userPassword: passwordController.text,
                            kind: "classic",
                          ),
                          deviceId: uniqueKey,
                        );
                        //Do user login in the app
                        final Resources<LoginDataDetails> loginApiStatus =
                            await widget.userProvider.doUserLoginApiCall(
                                userLoginParameterHolder.toMap());

                        if (loginApiStatus.data != null &&
                            loginApiStatus.data!.userProfile != null) {
                        } else {
                          PsProgressDialog.dismissDialog();
                          errorAlertDialog(
                              context: context,
                              title: Utils.getString("loginFailed"),
                              errorMsg: loginApiStatus.message);
                        }
                      }
                    } else {
                      await PsProgressDialog.dismissDialog();
                      UserProvider.boolIsTokenChanged = true;
                      showBottomLoginError(isDuplicateLogin: true);
                    }
                  } else {
                    PsProgressDialog.dismissDialog();
                    FocusScope.of(context).unfocus();
                    Utils.showWarningToastMessage(
                        Utils.getString("noInternet"), context);
                  }
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space13.h,
                Dimens.space16.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            alignment: Alignment.center,
            child: RoundedButtonWidget(
              width: double.maxFinite,
              buttonBackgroundColor: CustomColors.transparent!,
              buttonTextColor: CustomColors.loadingCircleColor!,
              corner: Dimens.space0,
              buttonBorderColor: CustomColors.transparent!,
              buttonFontSize: Dimens.space14,
              buttonText: Utils.getString("forgotYourPassword"),
              onPressed: () async {
                Navigator.pushNamed(context, RoutePaths.forgotPassword);
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
                focusPassword.requestFocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login({bool? isFromBottomSheet, bool? isDuplicateLogin}) async {
    UserProvider.boolIsTokenChanged = false;
    UserProvider.boolIsTokenChangedLoop = false;
    UserProvider.checkLoop = false;

    if (await Utils.checkInternetConnectivity()) {
      UserLoginParameterHolder userLoginParameterHolder;
      if (isFromBottomSheet! && !isDuplicateLogin!) {
        userLoginParameterHolder = UserLoginParameterHolder(
          client: "mobile",
          details: UserLoginParamDetails(
            userEmail: widget.userProvider.getUserEmail(),
            userPassword: widget.userProvider.getUserPassword(),
            kind: "classic",
          ),
          deviceId: uniqueKey,
        );
      } else {
        userLoginParameterHolder = UserLoginParameterHolder(
          client: "mobile",
          details: UserLoginParamDetails(
            userEmail: emailController.text,
            userPassword: passwordController.text,
            kind: "classic",
          ),
          deviceId: uniqueKey,
        );
      }

      //Do user login in the app
      final Resources<LoginDataDetails> loginApiStatus =
          await widget.userProvider.doUserLoginApiCall(
        userLoginParameterHolder.toMap(),
      );

      if (loginApiStatus.data != null) {
        final bool hasWorkspace = loginApiStatus.data!.workspaces != null &&
            loginApiStatus.data!.workspaces!.isNotEmpty;

        if (!hasWorkspace) {
          await PsProgressDialog.dismissDialog();
          /*Redirect to Empty workspace if
          * workspace list found to be null and
          * empty*/
          if (!mounted) return;
          await Navigator.pushReplacementNamed(
            context,
            RoutePaths.emptyWorkspace,
            arguments: EmptyCardDetailsParamHolder(
              onContinueToWebsiteClick: () {},
              onLogoutClick: () async {},
              userProvider: widget.userProvider,
            ),
          );
        } else {
          final bool hasActiveWorkspace = loginApiStatus.data!.workspaces!
              .any((element) => element.status!.toLowerCase() == "active");

          if (!hasActiveWorkspace) {
            await PsProgressDialog.dismissDialog();
            widget.userProvider.onLogout(onlyClearLoginData: true);
            errorAlertDialog(
              context: context,
              title: Utils.getString("workspaceDeleted"),
              errorMsg: Utils.getString("allWorkspaceDeleted"),
            );
          } else {
            //member login to default workspace
            final Resources<Member>? workspaceLoginData =
                await widget.loginWorkspaceProvider.doWorkSpaceLogin(
              WorkSpaceRequestParamHolder(
                authToken: widget.loginWorkspaceProvider.getApiToken(),
                workspaceId:
                    widget.loginWorkspaceProvider.getDefaultWorkspace(),
                memberId: widget.loginWorkspaceProvider.getMemberId(),
              ).toMap(),
            );

            if (workspaceLoginData!.data != null &&
                workspaceLoginData.data!.data != null &&
                workspaceLoginData.data!.data!.data != null) {
              ///Refresh Permission
              await widget.loginWorkspaceProvider.doGetUserPermissions();

              ///Refresh Plan Restriction
              await widget.userProvider.doGetPlanRestriction();

              ///Refresh Workspace List
              await widget.loginWorkspaceProvider
                  .doGetWorkSpaceListApiCall(loginApiStatus.data!.id);

              ///Refresh Country List
              await widget.countryListProvider.doCountryListApiCall();

              ///Refresh Plan OverView
              await widget.loginWorkspaceProvider.doPlanOverViewApiCall();

              ///Refresh Workspace Detail
              await widget.loginWorkspaceProvider.doWorkSpaceDetailApiCall(
                widget.loginWorkspaceProvider.getCallAccessToken(),
              );

              final Resources<ChannelData>? resources =
                  await widget.loginWorkspaceProvider.doChannelListApiCall(
                      widget.loginWorkspaceProvider.getCallAccessToken());
              if (resources!.status == Status.SUCCESS) {
                print("this is user id ${loginApiStatus.data!.id!}");
                widget.loginWorkspaceProvider
                    .replaceLoginUserId(loginApiStatus.data!.id!);
                widget.userProvider.addLanguage(Config.psSupportedLanguageMap[
                    loginApiStatus.data?.userProfile?.defaultLanguage ??
                        "en"]!);
                if (!mounted) return;
                EasyLocalization.of(context)!.setLocale(Locale(
                    Config
                            .psSupportedLanguageMap[loginApiStatus
                                    .data?.userProfile?.defaultLanguage ??
                                "en"]!
                            .languageCode ??
                        "en",
                    Config
                            .psSupportedLanguageMap[loginApiStatus
                                    .data?.userProfile?.defaultLanguage ??
                                "en"]
                            ?.countryCode ??
                        "US"));
                AppBuilder.of(context)?.rebuild();
                await PsProgressDialog.dismissDialog();
                if (!mounted) return;
                await Navigator.pushReplacementNamed(
                  context,
                  RoutePaths.home,
                );
              } else {
                await PsProgressDialog.dismissDialog();
                await Future.delayed(const Duration(microseconds: 3), () {
                  Utils.showWarningToastMessage(resources.message!, context);
                });
              }
            } else {
              await PsProgressDialog.dismissDialog();
              widget.userProvider.onLogout();
              errorAlertDialog(
                context: context,
                title: Utils.getString("loginFailed"),
                errorMsg: workspaceLoginData.message,
              );
            }
          }
        }
      } else {
        await PsProgressDialog.dismissDialog();
        widget.userProvider.onLogout(onlyClearLoginData: true);
        errorAlertDialog(
          context: context,
          title: Utils.getString("loginFailed"),
          errorMsg: loginApiStatus.message,
        );
      }
    } else {
      await PsProgressDialog.dismissDialog();
      if (!mounted) return;
      Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
    }
  }

  Future<void> doAutoLogin() async {
    focusDummy.requestFocus();
    final email = emailKey.currentState!.validate();
    final password = passwordKey.currentState!.validate();
    if (email && password) {
      if (await Utils.checkInternetConnectivity()) {
        await PsProgressDialog.showDialog(context);
        final UserLoginParameterHolder userLoginParameterHolder =
            UserLoginParameterHolder(
          client: "mobile",
          details: UserLoginParamDetails(
            userEmail: emailController.text,
            userPassword: passwordController.text,
            kind: "classic",
          ),
          deviceId: uniqueKey,
        );

        final Resources<CheckDuplicateLogin> checkDuplicateLogin = await widget
                .userProvider
                .doCheckDuplicateLogin(userLoginParameterHolder.toMap())
            as Resources<CheckDuplicateLogin>;

        if (checkDuplicateLogin.data != null &&
            !checkDuplicateLogin.data!.clientDndResponseData!.data!.success!) {
          login(isFromBottomSheet: false, isDuplicateLogin: false);
        } else if (checkDuplicateLogin.status == Status.ERROR) {
          if (checkDuplicateLogin.message!.toLowerCase() !=
              "Invalid Credentials".toLowerCase()) {
            login(isFromBottomSheet: false, isDuplicateLogin: false);
          } else {
            UserLoginParameterHolder userLoginParameterHolder;
            userLoginParameterHolder = UserLoginParameterHolder(
              client: "mobile",
              details: UserLoginParamDetails(
                userEmail: emailController.text,
                userPassword: passwordController.text,
                kind: "classic",
              ),
              deviceId: uniqueKey,
            );
            //Do user login in the app
            final Resources<LoginDataDetails> loginApiStatus = await widget
                .userProvider
                .doUserLoginApiCall(userLoginParameterHolder.toMap());

            if (loginApiStatus.data != null &&
                loginApiStatus.data!.userProfile != null) {
            } else {
              PsProgressDialog.dismissDialog();
              errorAlertDialog(
                  context: context,
                  title: Utils.getString("loginFailed"),
                  errorMsg: loginApiStatus.message);
            }
          }
        } else {
          await PsProgressDialog.dismissDialog();
          UserProvider.boolIsTokenChanged = true;
          showBottomLoginError(isDuplicateLogin: true);
        }
      } else {
        FocusScope.of(context).unfocus();
        Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
      }
    }
  }

  Future<void> showBottomLoginError({bool? isDuplicateLogin}) async {
    if (UserProvider.boolIsTokenChanged) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(Dimens.space21.w, Dimens.space0.h,
                Dimens.space21.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            color: CustomColors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimens.space16.r)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: PlainAssetImageHolder(
                          assetUrl: "assets/images/smartphone.png",
                          height: Dimens.space64,
                          width: Dimens.space64,
                          assetWidth: Dimens.space64,
                          assetHeight: Dimens.space64,
                          boxFit: BoxFit.contain,
                          iconUrl: CustomIcon.icon_person,
                          iconSize: Dimens.space10,
                          iconColor: CustomColors.mainColor!,
                          boxDecorationColor: CustomColors.transparent!,
                          outerCorner: Dimens.space0,
                          innerCorner: Dimens.space0,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space21.w,
                            Dimens.space20.h,
                            Dimens.space21.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("singleLogin"),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: CustomColors.textPrimaryColor,
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space20.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space21.w,
                            Dimens.space10.h,
                            Dimens.space21.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("yourAccountLogin"),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: CustomColors.textTertiaryColor,
                                    fontFamily: Config.heeboRegular,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space10.h, Dimens.space0.w, Dimens.space8.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedButtonWidget(
                          width: double.maxFinite,
                          buttonBackgroundColor: CustomColors.white!,
                          buttonTextColor: CustomColors.loadingCircleColor!,
                          corner: Dimens.space10,
                          buttonBorderColor: CustomColors.white!,
                          buttonFontFamily: Config.manropeSemiBold,
                          buttonFontSize: Dimens.space15,
                          buttonText: Utils.getString("signInHere"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await PsProgressDialog.showDialog(context);
                            login(
                                isFromBottomSheet: true,
                                isDuplicateLogin: isDuplicateLogin);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
                      Dimens.space0.w, Dimens.space30.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedButtonWidget(
                    width: double.maxFinite,
                    buttonBackgroundColor: CustomColors.white!,
                    buttonTextColor: CustomColors.textPrimaryColor!,
                    corner: Dimens.space16,
                    buttonBorderColor: CustomColors.white!,
                    buttonFontFamily: Config.manropeSemiBold,
                    buttonFontSize: Dimens.space15,
                    buttonText: Utils.getString("cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void ensureDebugMode() {
    if (kDebugMode) {
      // emailController.text = "n.giri@krispcall.com";
      // passwordController.text = "diwakeR@123";

      // emailController.text = "shahithakurisundar@gmail.com";
      // passwordController.text = "Pa\$\$w0rd!";
      // emailController.text = "dristisushan@gmail.com";
      // passwordController.text = "p@ssword";
      // emailController.text = "harriskunwar@icloud.com";
      // passwordController.text = "madan1123";

      // emailController.text = "a.acharya@krispcall.com";q
      // passwordControlle9r.text = "diwaker123";

      // emailController.text = "a.acharya@krispcall.com";
      // passwordController.text = "diwaker123";
      // emailController.text = "salina.balami@ombryo.com";
      // passwordController.text = "mvp@12345";
      // emailController.text = "tapish.adhikari5@gmail.com";
      // passwordController.text = "Test@12345";
      // emailController.text = "n.giri@krispcall.com";
      // passwordController.text = "diwakeR@123";
      // emailController.text = "salina.balami@ombryo.com";
      // passwordController.text = "mvp@12345";
      // emailController.text = "salinabalami24+ii@gmail.com";
      // passwordController.text = "mvp@12345";
      // emailController.text = "chapa4gainmanoj35@gmail.com";
      // passwordController.text = "password123";
      // emailController.text = "harriskunwar@icloud.com";
      // passwordController.text = "madan1123";
      //

      //
      // emailController.text = "dristisushan@gmail.com";
      // passwordController.text = "P@ssword";
      // //
      // emailController.text = "dristisushan+1@gmail.com";
      // passwordController.text = "P@ssword";

      // emailController.text = "r.lamichhane+461@codavatar.tech";
      // passwordController.text = "QA@1234";

      // emailController.text = "abinkhatiwada@gmail.com";
      // passwordController.text = "member@123";

      // emailController.text = "joshan.tandukar@yahoo.com";
      // passwordController.text = "Admin@123";

      // emailController.text = "b.wagle@codavatar.tech";
      // passwordController.text = "MnbvcxZ@#\$01";

      // emailController.text = "joshan.jt@gmail.com";
      // passwordController.text = "Admin@123";

      // emailController.text = "joshan.jt@gmail.com";
      // passwordController.text = "admin@123";

      // emailController.text = "tapish.adhikari5+0@gmail.com";
      // passwordController.text = "Test@1234";

      // emailController.text = "joshan39@daum.net";
      // passwordController.text = "Admin@123";

      // emailController.text = "k.shrestha1@codavatar.tech";
      // passwordController.text = "madan1123";

      // emailController.text = "r.lamichhane+1@codavatar.tech";
      // passwordController.text = "Roji@#123";

      // emailController.text = "k.shrestha1@codavatartech.tech";
      // emailController.text = "r.lamichhane@codavatar.tech";
      // passwordController.text = "QAROJI@1234";
      // passwordController.text = "madan1123";
      //
      // emailController.text = "bishwas@krispcall.com";
      // passwordController.text = "MnbvcxZ@#\$01";

      emailController.text = "kedarjirel@gmail.com";
      passwordController.text = "kedarcod@2021";

      // emailController.text = "joshan.tandukar@yahoo.com";
      // passwordController.text = "Admin@123";

      // emailController.text = "k.shrestha1@codavatartech.tech";
      // passwordController.text = "madan1123";

      // emailController.text = "k.shrestha1@codavatartech.tech";
      // passwordController.text = "madan1123";

/*      emailController.text = "codavater123@gmail.com";
      passwordController.text = "Kedarcod@2021";*/

      // emailController.text = "rojitalamichhane11+456@gmail.com";
      // passwordController.text = "Roji@#123";

      // emailController.text = "joshan.jt@gmail.com";
      // emailController.text = "joshan.tandukar@yahoo.com";
      // emailController.text = "joshan.tandukar@yahoo.com";
      // passwordController.text = "Admin@123";
      //   emailController.text = "callservice@krispcall.com";
      // passwordController.text = "Sujan@#1650";
      //   passwordController.text = "Ashi@#7865";
      // emailController.text = "r.lamichhane@codavatar.tech";
      // passwordController.text = "Qa@1234";
      // emailController.text = "Tnabina461@gmail.com";
      // passwordController.text = "Roji@#123";
      // emailController.text = "poonam.maharjan123@ombryo.com";
      // passwordController.text = "Everything@123";
      // emailController.text = "s.sharma@codavatar.tech";
      // passwordController.text = "sudip@12345";

      // emailController.text = "sudipsharma20287@gmail.com";
      // passwordController.text = "Qwerty@12345";

      // emailController.text = "r.lamichhane+New@codavatar.tech";
      // passwordController.text = "Roji@#123";

      // Testing of new lead
      // emailController.text = "rojitalamichhane11+25@gmail.com";
      // passwordController.text = "Roji@#123";

      // emailController.text = "riteshsainju70+1@gmail.com";
      // passwordController.text = "secret@";

      // emailController.text = "harriskunwar@icloud.com";
      // passwordController.text = "madan1123";

      // emailController.text = "r.lamichhane@codavatar.tech";
      // passwordController.text = "Roji@#123";

      // emailController.text = "r.lamichhane@codavatar.tech";
      // passwordController.text = "Dev@1234";

      // emailController.text = "saya@cdrreportwriters.com";
      // passwordController.text = "Saya@123";

      // emailController.text = "r.lamichhane+qa@codavatar.tech";
      // passwordController.text = "Roji@#123";

      // emailController.text = "anushawork456@gmail.com";
      // passwordController.text = "Anusha@kripscall";

      //
      // emailController.text = "poonam.maharjan@ombryo.com";
      // passwordController.text = "Everything@123";

      // emailController.text = "rajendra@fenced.ai";
      // passwordController.text = "Dondai@1563";

      // emailController.text = "riteshsainju70@gmail.com";
      // passwordController.text = "Secret@";

      // emailController.text = "r.lamichhane+app@codavatar.tech";
      // passwordController.text = "Rojita@#123";

      // emailController.text = "rojitalamichhane11@gmail.com";
      // passwordController.text = "Roji@#123";

      // emailController.text = "joshan.tandukar@yahoo.com";
      // passwordController.text = "Admin@123";

      //Workspace disabled
      // emailController.text = "salinalamichhane@gmail.com";
      // passwordController.text = "Roji@#123";

      // emailController.text = "rojitalamichhane11+26@gmail.com";
      // passwordController.text = "Everything@123";

      // emailController.text = "spravesh1818@gmail.com";
      // passwordController.text = "Secret12345@";
      // emailController.text = "salina.ombryo@gmail.com";
      // passwordController.text = "Mvp@12345";
      // emailController.text = "tapish.adhikari5+1@gmail.com";
      // passwordController.text = "Test@1234";
      // emailController.text = "shahithakurisundar@gmail.com";
      // passwordController.text = "Pa\$\$w0rd!";

      // emailController.text = "r.lamichhane+uat1@codavatar.tech";
      // passwordController.text = "UAT@1234";
      // emailController.text = "anishalee1379@gmail.com";
      // passwordController.text = "Anisha@123";
      // emailController.text = "dristisushan@gmail.com";
      // passwordController.text = "P@ssword";

      emailController.text = "anishalee1379@gmail.com";
      passwordController.text = "Anisha@456";

      // emailController.text = "bishwas@krispcall.com";
      // passwordController.text = "MnbvcxZ@#\$01";
      // emailController.text = "dristisushan@gmail.com";
      // passwordController.text = "P@ssword";
      //       //
      //       // emailController.text = "bikrammhz@gmail.com";
      //       // passwordController.text = "Bikramn@1234";
      //
      // emailController.text = "bikrammhz@gmail.com";
      // passwordController.text = "Bikram@1234";
      // emailController.text = "joshan39@daum.net";
      // passwordController.text = "Admin@123";
    }
    // emailController.text = "bishwas@krispcall.com";
    // passwordController.text = "MnbvcxZ@#\$01";
  }
}
