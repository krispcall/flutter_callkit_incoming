import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:functional_widget_annotation/functional_widget_annotation.dart";
import "package:internet_connection_checker/internet_connection_checker.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";

abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  bool isConnectedToInternet = true;
  StreamSubscription? streamSubscriptionOnNetworkChanged;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  void dispose() {
    streamSubscriptionOnNetworkChanged!.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  ///Check internet auto detect internet connection
  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      setState(() {
        isConnectedToInternet = onValue;
      });
      if (!onValue) {
        Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
      }
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
              Utils.showWarningToastMessage(
                  Utils.getString("noInternet"), context);
            });
            break;
        }
      },
    );
  }

  ///Custom view no internet in status bar
  @swidget
  Widget customViewNoInternet() {
    return Offstage(
      offstage: isConnectedToInternet,
      child: SizedBox(
        height: Dimens.space26.h,
        child: Container(
          color: CustomColors.callDeclineColor,
          height: Dimens.space26.h,
          alignment: Alignment.center,
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : Utils.getString("noInternetConnection"),
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: CustomColors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: Config.heeboMedium,
                  fontSize: Dimens.space12.sp,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
      ),
    );
  }
}
