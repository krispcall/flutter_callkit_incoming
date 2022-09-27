import "package:event_bus/event_bus.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/dnd/UserDnd.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";

class UserDndViewWidget extends StatefulWidget {
  static EventBus onOfflineEvent = EventBus();

  const UserDndViewWidget({
    Key? key,
    this.onTimeSelected,
    this.userProvider,
  }) : super(key: key);

  final Function? onTimeSelected;
  final UserProvider? userProvider;

  @override
  UserDndViewWidgetState createState() => UserDndViewWidgetState();
}

class UserDndViewWidgetState extends State<UserDndViewWidget>
    with SingleTickerProviderStateMixin {
  UserRepository? userRepository;
  UserProvider? userProvider;
  AnimationController? animationController;
  ValueHolder? valueHolder;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    super.initState();
    UserDndViewWidget.onOfflineEvent
        .on<UserOnlineOfflineEvent>()
        .listen((event) {
      try {
        userProvider!.getUserDndTimelist(!event.online!);
        userProvider!.getUserDndTimeValue();
      } catch (e) {
        Utils.cPrint(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.of(context).pop();
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    animationController!.forward();
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              userProvider = UserProvider(
                  userRepository: userRepository, valueHolder: valueHolder);
              userProvider!.getUserDndTimelist(true);
              return userProvider!;
            }),
      ],
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimens.space16.w),
                  topLeft: Radius.circular(Dimens.space16.w)),
              color: CustomColors.white,
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  height: Dimens.space60.h,
                  alignment: Alignment.topCenter,
                  color: CustomColors.transparent,
                  padding: const EdgeInsets.fromLTRB(Dimens.space0,
                      Dimens.space5, Dimens.space0, Dimens.space5),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: Dimens.space70.w,
                        top: Dimens.space0.w,
                        right: Dimens.space70.w,
                        child: Container(
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
                          width: Dimens.space150.w,
                          height: Dimens.space48.h,
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("Pause Notification"),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: Dimens.space0.w,
                        top: Dimens.space0.w,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space8.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          width: Dimens.space60.w,
                          height: Dimens.space48.h,
                          child: TextButton(
                            onPressed: _requestPop,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: CustomColors.transparent,
                              alignment: Alignment.center,
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
                                          color:
                                              CustomColors.loadingCircleColor,
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
                    ],
                  ),
                ),
                Divider(
                  color: CustomColors.mainDividerColor,
                  height: Dimens.space1,
                  thickness: Dimens.space1,
                ),
                Expanded(
                  child: DndTimeListView(
                    userProvider: userProvider!,
                    dndList: userProvider!.userDndTimeList!,
                    onTimeSelected: (int time, bool value) {
                      widget.onTimeSelected!(time, value);
                    },
                  ),
                ),
                if (userProvider!.getUserOnlineStatus())
                  Container()
                else
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space24.w,
                        Dimens.space24.h, Dimens.space24.w, Dimens.space24.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedButtonWidget(
                      width: double.maxFinite,
                      buttonBackgroundColor: CustomColors.callAcceptColor!,
                      buttonTextColor: CustomColors.white!,
                      corner: Dimens.space10,
                      buttonBorderColor: CustomColors.callAcceptColor!,
                      buttonFontFamily: Config.manropeSemiBold,
                      buttonText: Utils.getString("Resume Notification"),
                      onPressed: () async {
                        if (await Utils.checkInternetConnectivity()) {
                          userProvider!.resetUserDndTimeList();
                          userProvider!.getUserDndTimelist(false);
                          userProvider!.replaceUserOnlineStatus(false);
                          widget.onTimeSelected!(
                              widget.userProvider!.getUserDndTimeValue()!.time,
                              false);
                        } else {
                          Utils.showWarningToastMessage(
                              Utils.getString("noInternet"), context);
                        }
                      },
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
    required this.userProvider,
    required this.onTimeSelected,
    required this.dndList,
  }) : super(key: key);

  final UserProvider userProvider;
  final Function(int, bool) onTimeSelected;
  final List<UserDnd> dndList;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: ListView.builder(
        itemCount: dndList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (c, i) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: CustomColors.transparent,
                    alignment: Alignment.centerRight,
                    fixedSize: const Size(double.infinity, Dimens.space56)),
                onPressed: () async {
                  if (await Utils.checkInternetConnectivity()) {
                    if (userProvider.getUserOnlineStatus()) {
                      _updateUserDnd(dndList[i], context);
                    }
                  } else {
                    Utils.showWarningToastMessage(
                        Utils.getString("noInternet"), context);
                  }
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
                      isChecked: dndList[i].status!,
                      iconSize: Dimens.space14,
                      assetHeight: Dimens.space10,
                      assetWidth: Dimens.space10,
                      onCheckBoxTap: (value) async {
                        if (await Utils.checkInternetConnectivity()) {
                          if (userProvider.getUserOnlineStatus()) {
                            _updateUserDnd(dndList[i], context);
                          }
                        } else {
                          Utils.showWarningToastMessage(
                              Utils.getString("noInternet"), context);
                        }
                      },
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(Dimens.space10.w,
                            Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : dndList[i].title!,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
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
              Divider(
                color: CustomColors.mainDividerColor,
                height: Dimens.space1,
                thickness: Dimens.space1,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateUserDnd(UserDnd value, BuildContext context) async {
    userProvider.setUserDndTimeList(
      value.time!,
      UserDnd(status: !value.status!, title: value.title, time: value.time),
    );
    userProvider.getUserDndTimelist(true);
    onTimeSelected(value.time!, !value.status!);
  }
}
