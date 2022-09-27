import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/login_workspace/LoginWorkspaceProvider.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDnd.dart";
import "package:provider/provider.dart";

class ChannelDndDialog extends StatefulWidget {
  final String? clientName;
  final String? mutedDate;
  final Function? onSetRemoveTap;

  const ChannelDndDialog({
    Key? key,
    this.clientName,
    this.mutedDate,
    this.onSetRemoveTap,
  }) : super(key: key);

  @override
  _ChannelDndDialogState createState() {
    return _ChannelDndDialogState();
  }
}

class _ChannelDndDialogState extends State<ChannelDndDialog> {
  ValueHolder? valueHolder;

  LoginWorkspaceRepository? loginWorkspaceRepository;
  LoginWorkspaceProvider? loginWorkspaceProvider;

  @override
  void initState() {
    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginWorkspaceProvider>(
      lazy: false,
      create: (BuildContext context) {
        loginWorkspaceProvider = LoginWorkspaceProvider(
          loginWorkspaceRepository: loginWorkspaceRepository,
          valueHolder: valueHolder,
        );
        loginWorkspaceProvider!.getChannelDndTimeList(true);
        return loginWorkspaceProvider!;
      },
      child: Consumer<LoginWorkspaceProvider>(
        builder: (BuildContext context, LoginWorkspaceProvider? provider,
            Widget? child) {
          return Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: Dimens.space80.w,
                  height: Dimens.space6.h,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space6.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space33.r),
                    ),
                    color: CustomColors.bottomAppBarColor,
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    color: CustomColors.mainBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space20.r),
                      topRight: Radius.circular(Dimens.space20.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space16.h,
                            Dimens.space16.w,
                            Dimens.space18.h),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimens.space20.r),
                              topRight: Radius.circular(Dimens.space20.r)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.space40,
                              height: Dimens.space40,
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
                              child: RoundedNetworkImageHolder(
                                width: Dimens.space40,
                                height: Dimens.space40,
                                iconUrl: CustomIcon.icon_notification,
                                iconColor: CustomColors.loadingCircleColor,
                                iconSize: Dimens.space20,
                                boxDecorationColor: CustomColors
                                    .loadingCircleColor!
                                    .withOpacity(0.09),
                                outerCorner: Dimens.space10,
                                innerCorner: Dimens.space0,
                                imageUrl: "",
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space10.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : Utils.getString("muteNumber"),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                              color:
                                                  CustomColors.textPrimaryColor,
                                              fontFamily: Config.manropeBold,
                                              fontSize: Dimens.space18.sp,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space10.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : widget.clientName ??
                                                Utils.getString("unknown"),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: CustomColors
                                                  .textTertiaryColor,
                                              fontFamily: Config.heeboRegular,
                                              fontSize: Dimens.space14.sp,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space16.h,
                            Dimens.space16.w,
                            Dimens.space16.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomColors.mainDividerColor!,
                              width: Dimens.space1.w),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space16.w)),
                          color: CustomColors.white,
                        ),
                        child: DndTimeListView(
                          loginWorkspaceProvider: loginWorkspaceProvider!,
                          dndList: loginWorkspaceProvider!.channelDndTimeList!,
                          onTimeSelected: (int time, bool value) {
                            widget.onSetRemoveTap!(time, value);
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space20.w,
                            Dimens.space0.h, Dimens.space20.w, Dimens.space8.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : Utils.getString("notifyMessage"),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: CustomColors.textPrimaryColor,
                                fontFamily: Config.heeboRegular,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DndTimeListView extends StatelessWidget {
  const DndTimeListView({
    Key? key,
    required this.loginWorkspaceProvider,
    required this.onTimeSelected,
    required this.dndList,
  }) : super(key: key);

  final LoginWorkspaceProvider loginWorkspaceProvider;
  final Function(int, bool) onTimeSelected;
  final List<ChannelDnd> dndList;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: ListView.separated(
        itemCount: dndList.length,
        shrinkWrap: true,
        separatorBuilder: (c, i) {
          return Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1,
            thickness: Dimens.space1,
          );
        },
        physics: const BouncingScrollPhysics(),
        itemBuilder: (c, i) {
          return AbsorbPointer(
            absorbing: dndList[i].status ?? false,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                      Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: CustomColors.transparent,
                  alignment: Alignment.centerRight,
                  fixedSize: Size(double.infinity, Dimens.space56.h)),
              onPressed: () {
                _updateChannelDnd(dndList[i], context);
              },
              child: Row(
                children: [
                  CustomCheckBox(
                    width: Dimens.space20,
                    height: Dimens.space20,
                    boxFit: BoxFit.contain,
                    iconUrl: Icons.fiber_manual_record,
                    iconColor: CustomColors.white!,
                    selectedColor: CustomColors.loadingCircleColor!,
                    unSelectedColor: CustomColors.textQuaternaryColor!,
                    isChecked: dndList[i].status ?? false,
                    iconSize: Dimens.space14,
                    assetHeight: Dimens.space10,
                    assetWidth: Dimens.space10,
                    onCheckBoxTap: (value) async {
                      _updateChannelDnd(dndList[i], context);
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        dndList[i].title!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateChannelDnd(ChannelDnd data, BuildContext context) async {
    final bool isConnected = await Utils.checkInternetConnectivity();
    if (isConnected) {
      loginWorkspaceProvider.setChannelDndList(
        data.time!,
        ChannelDnd(
            status: data.status! ? false : true,
            title: data.title,
            time: data.time),
      );
      Future.delayed(const Duration(milliseconds: 200), () {
        onTimeSelected(data.time!, data.status! ? false : true);
      });
    } else {
      Future.delayed(const Duration(microseconds: 2), () {
        Utils.showWarningToastMessage(Utils.getString("noInternet"), context);
      });
    }
  }
}
