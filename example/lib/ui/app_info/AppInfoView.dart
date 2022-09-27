import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:in_app_update/in_app_update.dart";
import "package:lottie/lottie.dart";
import "package:mvp/BaseStatefulState.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/app_info/AppInfoProvider.dart";
import "package:mvp/provider/area_code/AreaCodeProvider.dart";
import "package:mvp/provider/call_rating/CallRatingProvider.dart";
import "package:mvp/provider/contacts/ContactsProvider.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/AppInfoRepository.dart";
import "package:mvp/repository/AreaCodeRepository.dart";
import "package:mvp/repository/Common/CallRatingRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/appInfo/AppVersion.dart";
import "package:mvp/viewObject/model/stateCode/StateCodeResponse.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

class AppInfoView extends StatefulWidget {
  const AppInfoView({
    Key? key,
  }) : super(key: key);

  @override
  AppInfoViewState createState() => AppInfoViewState();
}

class AppInfoViewState extends BaseStatefulState<AppInfoView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AppInfoRepository? appInfoRepository;
  AppInfoProvider? appInfoProvider;
  UserRepository? userRepository;
  bool iOSCanUpdate = false;
  String appStoreVersion = "";
  String appLocalVersion = "";

  ValueHolder? valueHolder;

  AnimationController? controller;
  Animation? _offsetFloat;
  Animation? sizeAnimation;

  UserProvider? userProvider;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;

  CallRatingProvider? callRatingProvider;
  CallRatingRepository? callRatingRepository;

  AreaCodeProvider? areaCodeProvider;
  AreaCodeRepository? areaCodeRepository;

  ContactsProvider? contactsProvider;
  ContactRepository? contactRepository;

  DashboardProvider? dashboardProvider;

  void initializeProvider() {
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

    appInfoRepository = Provider.of<AppInfoRepository>(context, listen: false);
    appInfoProvider = AppInfoProvider(repository: appInfoRepository);

    userRepository = Provider.of<UserRepository>(context, listen: false);
    userProvider =
        UserProvider(userRepository: userRepository, valueHolder: valueHolder);

    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    loginWorkspaceProvider = LoginWorkspaceProvider(
        loginWorkspaceRepository: loginWorkspaceRepository,
        valueHolder: valueHolder);

    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);

    callRatingRepository =
        Provider.of<CallRatingRepository>(context, listen: false);
    callRatingProvider =
        CallRatingProvider(callRatingRepository: callRatingRepository);

    areaCodeRepository =
        Provider.of<AreaCodeRepository>(context, listen: false);
    areaCodeProvider = AreaCodeProvider(areaCodeRepository: areaCodeRepository);

    contactRepository = Provider.of<ContactRepository>(context, listen: false);
    contactsProvider = ContactsProvider(contactRepository: contactRepository);
  }

  void initFunction() {
    if (Platform.isIOS) {
      checkIsLogin();
    } else {
      SharedPreferences.getInstance().then((psSharePref) async {
        await psSharePref.reload();
        if (psSharePref.getBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND) ==
                null ||
            !psSharePref.getBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND)!) {
          checkForNewVersion();
        } else {
          if (!mounted) return;
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.home,
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    CustomAppBar.changeStatusColor(CustomColors.textPrimaryColor!);
    initializeProvider();
    initFunction();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _offsetFloat =
        Tween(begin: const Offset(0.0, 0.10), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller!,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _offsetFloat!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mainColor,
      body: ChangeNotifierProvider<AppInfoProvider>(
        lazy: false,
        create: (BuildContext context) {
          appInfoProvider = AppInfoProvider(
              repository: appInfoRepository, valueHolder: valueHolder);
          // checkForNewVersion();
          return appInfoProvider!;
        },
        child: Consumer<AppInfoProvider>(
          builder: (BuildContext? context,
              AppInfoProvider? clearAllDataProvider, Widget? child) {
            return Container(
              width: MediaQuery.of(context!).size.width.sw,
              height: MediaQuery.of(context).size.height.sh,
              color: CustomColors.mainColor,
              child: SlideTransition(
                position: _offsetFloat as Animation<Offset>,
                child: Container(
                  margin: EdgeInsets.zero,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlainAssetImageHolder(
                        assetUrl: "assets/images/logo.png",
                        height: Dimens.space60,
                        width: Dimens.space180,
                        assetWidth: Dimens.space180,
                        assetHeight: Dimens.space60,
                        boxFit: BoxFit.contain,
                        iconUrl: CustomIcon.icon_person,
                        iconSize: Dimens.space10,
                        iconColor: CustomColors.mainColor,
                        boxDecorationColor: CustomColors.transparent,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                      ),
                      Lottie.asset(
                        "assets/animation/splash_loader.json",
                        width: Dimens.space82.w,
                        height: Dimens.space17.h,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> checkForNewVersion() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND) == null ||
          !psSharePref.getBool(Const.VALUE_HOLDER_CALL_IN_BACKGROUND)!) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            final Resources<AppVersion> psAppInfo =
                await appInfoProvider!.doVersionApiCall();

            if (psAppInfo.status == Status.SUCCESS) {
              if (psAppInfo.data != null) {
                checkAppVersion(psAppInfo.data!, appInfoProvider!);
              } else {
                doRefreshTokenApiCall();
              }
            } else {
              doRefreshTokenApiCall();
            }
          } else {
            Future.delayed(const Duration(seconds: 4), () {
              checkIsLogin();
            });
          }
        });
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      }
    });
  }

  void checkAppVersion(AppVersion psAppInfo, AppInfoProvider appInfoProvider) {
    if (psAppInfo.versionForceUpdate != null && psAppInfo.versionForceUpdate!) {
      startForceUpdate(psAppInfo);
    } else {
      startFlexibleUpdate(psAppInfo);
    }
  }

  void startForceUpdate(AppVersion psAppInfo) {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (psAppInfo.versionNeedClearData != null &&
            psAppInfo.versionNeedClearData!) {
          appInfoProvider!.replaceLoginUserId("");
        }
        InAppUpdate.performImmediateUpdate()
            .then((value) => doRefreshTokenApiCall())
            .catchError((e) => doRefreshTokenApiCall());
      } else {
        doRefreshTokenApiCall();
      }
    }).catchError((e) {
      doRefreshTokenApiCall();
    });
  }

  void startFlexibleUpdate(AppVersion psAppInfo) {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (psAppInfo.versionNeedClearData != null &&
            psAppInfo.versionNeedClearData!) {
          appInfoProvider!.replaceLoginUserId("");
        }
        InAppUpdate.startFlexibleUpdate()
            .then((value) => doRefreshTokenApiCall())
            .catchError((e) => doRefreshTokenApiCall());
      } else {
        doRefreshTokenApiCall();
      }
    }).catchError((e) {
      doRefreshTokenApiCall();
    });
  }

  void checkIsLogin() {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RoutePaths.home);
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RoutePaths.loginView);
      }
    });
  }

  Future<void> doRefreshTokenApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await loginWorkspaceProvider!.doRefreshTokenApiCall().then((v1) {
              if (v1.data != null &&
                  v1.data!.refreshTokenResponseData != null &&
                  v1.data!.refreshTokenResponseData!.data != null &&
                  v1.data!.refreshTokenResponseData!.data!.accessToken !=
                      null &&
                  v1.data!.refreshTokenResponseData!.data!.accessToken!
                      .isNotEmpty) {
                doCountryListApiCall();
              } else {
                doRefreshTokenApiCall();
              }
            }).catchError((onError) {
              doRefreshTokenApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doCountryListApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await countryListProvider!.doCountryListApiCall().then((v2) {
              if (v2.status == Status.SUCCESS) {
                doAreaCodeApiCall();
              } else {
                doCountryListApiCall();
              }
            }).catchError((onError) {
              doCountryListApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doAreaCodeApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await areaCodeProvider!.getAllAreaCodes().then((v3) {
              if (v3.status == Status.SUCCESS) {
                dashboardProvider!.areaCode =
                    StateCodeResponse().toMap(v3.data!.stateCodeResponse)!;

                doGetPlanRestriction();
              } else {
                doAreaCodeApiCall();
              }
            }).catchError((onError) {
              doAreaCodeApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doGetPlanRestriction() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await userProvider!.doGetPlanRestriction().then((v4) {
              if (v4.status == Status.SUCCESS) {
                getUserProfileDetails();
              } else {
                doGetPlanRestriction();
              }
            }).catchError((onError) {
              doGetPlanRestriction();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> getUserProfileDetails() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await userProvider!.getUserProfileDetails().then((v5) {
              if (v5.status == Status.SUCCESS) {
                doGetWorkSpaceListApiCall();
              } else {
                getUserProfileDetails();
              }
            }).catchError((onError) {
              getUserProfileDetails();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doGetWorkSpaceListApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await loginWorkspaceProvider!
                .doGetWorkSpaceListApiCall(
                    loginWorkspaceProvider!.getLoginUserId())
                .then((v6) {
              if (v6.status == Status.SUCCESS) {
                doWorkSpaceDetailApiCall();
              } else {
                doGetWorkSpaceListApiCall();
              }
            }).catchError((onError) {
              doGetWorkSpaceListApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doWorkSpaceDetailApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await loginWorkspaceProvider!
                .doWorkSpaceDetailApiCall(
                    loginWorkspaceProvider!.getCallAccessToken())!
                .then((v7) {
              if (v7!.status == Status.SUCCESS) {
                doChannelListForDashboardApiCall();
              } else {
                doWorkSpaceDetailApiCall();
              }
            }).catchError((onError) {
              doWorkSpaceDetailApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doChannelListForDashboardApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await loginWorkspaceProvider!
                .doChannelListForDashboardApiCall(
                    loginWorkspaceProvider!.getCallAccessToken())
                .then((v8) {
              if (v8!.status == Status.SUCCESS) {
                doPlanOverViewApiCall();
              } else {
                doChannelListForDashboardApiCall();
              }
            }).catchError((onError) {
              doChannelListForDashboardApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doPlanOverViewApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await loginWorkspaceProvider!.doPlanOverViewApiCall().then((v9) {
              if (v9.status == Status.SUCCESS) {
                doAllContactApiCall();
              } else {
                doPlanOverViewApiCall();
              }
            }).catchError((onError) {
              doPlanOverViewApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doAllContactApiCall() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await contactsProvider!.doAllContactApiCall().then((v10) {
              if (v10.status == Status.SUCCESS) {
                doGetUserPermissions();
              } else {
                doAllContactApiCall();
              }
            }).catchError((onError) {
              doAllContactApiCall();
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }

  Future<void> doGetUserPermissions() async {
    SharedPreferences.getInstance().then((psSharePref) async {
      await psSharePref.reload();
      if (psSharePref.getString(Const.VALUE_HOLDER_USER_ID) != null &&
          psSharePref.getString(Const.VALUE_HOLDER_USER_ID)!.isNotEmpty) {
        Utils.checkInternetConnectivity().then((value) async {
          if (value) {
            await loginWorkspaceProvider!.doGetUserPermissions().then((v11) {
              if (v11.status == Status.SUCCESS) {
                checkIsLogin();
              } else {
                doGetUserPermissions();
              }
            });
          } else {
            checkIsLogin();
          }
        });
      } else {
        checkIsLogin();
      }
    });
  }
}
