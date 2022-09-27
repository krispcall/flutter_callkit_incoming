import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/dialog/ErrorDialog.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/utils/Validation.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/channelSetting/ChannelSettingRequestParamHolder.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:provider/provider.dart";

class ChannelNameEditView extends StatefulWidget {
  const ChannelNameEditView({
    Key? key,
    required this.channel,
    required this.onUpdateCallback,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  final WorkspaceChannel channel;
  final VoidCallback onUpdateCallback;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  @override
  _ChannelNameEditViewState createState() => _ChannelNameEditViewState();
}

class _ChannelNameEditViewState extends State<ChannelNameEditView>
    with SingleTickerProviderStateMixin {
  LoginWorkspaceRepository? repository;
  LoginWorkspaceProvider? provider;
  ValueHolder? valueHolder;

  AnimationController? animationController;
  final TextEditingController nameEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    repository = Provider.of<LoginWorkspaceRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    if (widget.channel.name != null) {
      nameEditingController.text = widget.channel.name!;
    }
  }

  Future<bool> _requestPop() {
    animationController!.reverse().then<dynamic>(
      (void data) {
        if (!mounted) {
          return Future<bool>.value(false);
        }
        Navigator.pop(context, true);
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: CustomAppBar<LoginWorkspaceProvider>(
          onIncomingTap: () {
            widget.onIncomingTap();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap();
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
                                  : Utils.getString("back"),
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
                        : Utils.getString("numberName"),
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
          elevation: 0,
          initProvider: () {
            provider = LoginWorkspaceProvider(
                loginWorkspaceRepository: repository, valueHolder: valueHolder);
            return provider;
          },
          onProviderReady: (LoginWorkspaceProvider provider) async {},
          builder: (BuildContext? context, LoginWorkspaceProvider? provider,
              Widget? child) {
            animationController!.forward();
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
                    Divider(
                      color: CustomColors.callInactiveColor,
                      height: Dimens.space1.h,
                      thickness: Dimens.space1.h,
                    ),
                    Divider(
                      color: CustomColors.bottomAppBarColor,
                      height: Dimens.space20.h,
                      thickness: Dimens.space20.h,
                    ),
                    Divider(
                      color: CustomColors.callInactiveColor,
                      height: Dimens.space1.h,
                      thickness: Dimens.space1.h,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space30.h, Dimens.space16.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: CustomTextField(
                        titleText: Utils.getString("name"),
                        containerFillColor: CustomColors.baseLightColor!,
                        borderColor: CustomColors.callInactiveColor!,
                        titleFont: Config.manropeBold,
                        onChanged: () {},
                        titleTextColor: CustomColors.textSecondaryColor!,
                        titleMarginBottom: Dimens.space6,
                        hintText: Utils.getString(""),
                        hintFontColor: CustomColors.textQuaternaryColor!,
                        inputFontColor: CustomColors.textQuaternaryColor!,
                        textEditingController: nameEditingController,
                        showTitle: true,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
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
                        buttonBackgroundColor: CustomColors.mainColor!,
                        buttonTextColor: CustomColors.white!,
                        corner: Dimens.space10,
                        buttonBorderColor: CustomColors.mainColor!,
                        buttonFontFamily: Config.manropeSemiBold,
                        buttonText: Utils.getString("saveChanges"),
                        onPressed: () async {
                          FocusScope.of(context!).unfocus();
                          if (nameEditingController.text.isEmpty) {
                            showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message:
                                      Utils.getString("channelNameRequired"),
                                );
                              },
                            );
                          } else {
                            if (isValidName(nameEditingController.text)
                                .isNotEmpty) {
                              showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ErrorDialog(
                                    message: validateName(
                                        nameEditingController.text),
                                  );
                                },
                              );
                            } else {
                              await PsProgressDialog.showDialog(context,
                                  isDissmissable: true);
                              final Resources<NumberSettings> resources =
                                  await provider!.updateChannelDetails(
                                      GeneralChannelSettingsInputHolder(
                                              channel: widget.channel.id,
                                              data: GeneralChannelSettingParam(
                                                  name: nameEditingController
                                                      .text))
                                          .toMap() as Map<String, dynamic>);
                              if (resources.status == Status.SUCCESS) {
                                await PsProgressDialog.dismissDialog();
                                widget.onUpdateCallback();
                                nav.pop();
                              } else {
                                await PsProgressDialog.dismissDialog();
                                if (!mounted) return null;
                                Utils.showWarningToastMessage(
                                    resources.message!, context);
                              }
                            }
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
}
