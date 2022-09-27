import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ConfirmDialogView.dart";
import "package:mvp/utils/Utils.dart";

class EmptyWorkspaceWidget extends StatelessWidget {
  final VoidCallback? onContinueToWebsiteClick;
  final VoidCallback? onLogoutPressed;
  final UserProvider? userProvider;

  const EmptyWorkspaceWidget(
      {Key? key,
      this.onContinueToWebsiteClick,
      this.onLogoutPressed,
      this.userProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomAppBar.changeStatusColor(CustomColors.textPrimaryColor!);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space80.h,
                    Dimens.space40.w, Dimens.space0.h),
                child: PlainAssetImageHolder(
                  assetUrl: "assets/images/logo_maincolor.png",
                  width: Dimens.space124,
                  height: Dimens.space30,
                  assetWidth: Dimens.space124,
                  assetHeight: Dimens.space30,
                  boxFit: BoxFit.contain,
                  outerCorner: Dimens.space0,
                  innerCorner: Dimens.space0,
                  iconSize: Dimens.space0,
                  iconUrl: CustomIcon.icon_gallery,
                  iconColor: CustomColors.white!,
                  boxDecorationColor: CustomColors.transparent!,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedAssetImageHolder(
                        assetUrl: "assets/images/workspace_not_found.png",
                        width: Dimens.space152,
                        height: Dimens.space152,
                        boxFit: BoxFit.scaleDown,
                        iconUrl: CustomIcon.icon_gallery,
                        iconColor: CustomColors.grey!,
                        iconSize: Dimens.space30,
                        boxDecorationColor: CustomColors.bottomAppBarColor!,
                        outerCorner: Dimens.space152,
                        innerCorner: Dimens.space0,
                        containerAlignment: Alignment.bottomCenter,
                        applyFactor: true,
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space40.w,
                        Dimens.space20.h, Dimens.space40.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("workspaceNotFound"),
                      textAlign: TextAlign.center,
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
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space37.w,
                        Dimens.space10.h, Dimens.space37.w, Dimens.space0.h),
                    child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("workspaceNotFoundDesc"),
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.heeboRegular,
                            fontSize: Dimens.space14.sp,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center),
                  ),
                ],
              )),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space30.h,
                    Dimens.space20.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedButtonWidget(
                  width: double.maxFinite,
                  height: Dimens.space54,
                  buttonBackgroundColor: CustomColors.callAcceptColor!,
                  buttonTextColor: CustomColors.white!,
                  corner: Dimens.space10,
                  buttonBorderColor: CustomColors.bottomAppBarColor!,
                  buttonFontFamily: Config.manropeSemiBold,
                  buttonText: Utils.getString("openInBrowser"),
                  onPressed: () async {
                    if (await Utils.checkInternetConnectivity()) {
                      Utils.lunchWebUrl(
                          url: PSApp.config!.imageUrl!, context: context);
                    } else {
                      Utils.showWarningToastMessage(
                          Utils.getString("noInternet"), context);
                    }
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space24.h,
                    Dimens.space20.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space70.h),
                child: RoundedButtonWidget(
                  width: double.maxFinite,
                  height: Dimens.space54,
                  buttonBackgroundColor: CustomColors.bottomAppBarColor!,
                  buttonTextColor: CustomColors.textPrimaryColor!,
                  corner: Dimens.space10,
                  buttonBorderColor: CustomColors.white!,
                  buttonFontFamily: Config.manropeSemiBold,
                  buttonText: Utils.getString("logOut"),
                  onPressed: () async {
                    await showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return ConfirmDialogView(
                              description:
                                  Utils.getString("areYouSureToLogOut"),
                              leftButtonText: Utils.getString("cancel"),
                              rightButtonText: Utils.getString("ok"),
                              onAgreeTap: () {
                                Navigator.of(dialogContext).pop();
                                voiceClient.disConnect();
                                userProvider!.onLogout(context: context);
                              });
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
