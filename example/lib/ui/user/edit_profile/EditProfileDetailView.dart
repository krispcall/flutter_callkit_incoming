import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EditProfileIntentHolder.dart";
import "package:provider/provider.dart";

class EditProfileDetailView extends StatefulWidget {
  final VoidCallback onProfileUpdateCallback;
  final VoidCallback onIncomingTap;
  final VoidCallback onOutgoingTap;

  const EditProfileDetailView({
    Key? key,
    required this.onProfileUpdateCallback,
    required this.onIncomingTap,
    required this.onOutgoingTap,
  }) : super(key: key);

  @override
  _EditProfileDetailViewState createState() => _EditProfileDetailViewState();
}

class _EditProfileDetailViewState extends State<EditProfileDetailView>
    with SingleTickerProviderStateMixin {
  UserRepository? userRepository;
  UserProvider? userProvider;

  ValueHolder? valueHolder;

  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    userRepository = Provider.of<UserRepository>(context, listen: false);
    valueHolder = Provider.of<ValueHolder>(context, listen: false);
  }

  Future<bool> _requestPop() {
    CustomAppBar.changeStatusColor(CustomColors.mainColor!);
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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: CustomAppBar<UserProvider>(
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
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  ),
                ),
              ],
            ),
          ),
          leadingWidget: null,
          elevation: 0.6,
          initProvider: () {
            userProvider = UserProvider(
                userRepository: userRepository, valueHolder: valueHolder);
            return userProvider;
          },
          onProviderReady: (UserProvider provider) async {},
          builder: (BuildContext? context, UserProvider? provider, Widget? child) {
            animationController!.forward();
            return Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              // alignment: Alignment.center,
              color: CustomColors.white,
              child: Column(
                children: [
                  Divider(
                    height: Dimens.space1.h,
                    thickness: Dimens.space1.h,
                    color: CustomColors.mainDividerColor,
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pushNamed(
                        context!,
                        RoutePaths.profileIndividualEditView,
                        arguments: EditProfileIntentHolder(
                          whichToEdit: "name",
                          onProfileUpdateCallback: () {
                            widget.onProfileUpdateCallback();
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          onIncomingTap: () {
                            widget.onIncomingTap();
                          },
                          onOutgoingTap: () {
                            widget.onOutgoingTap();
                          },
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space16.h, Dimens.space16.w, Dimens.space16.h),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
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
                              child: Text(
                                Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : Utils.getString("name"),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context!)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: CustomColors.textPrimaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
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
                              alignment: Alignment.centerRight,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  Config.checkOverFlow
                                      ? Const.OVERFLOW
                                      : "${userProvider!.getUserFirstName()} ${userProvider!.getUserLastName()}",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: CustomColors.textTertiaryColor,
                                        fontFamily: Config.manropeSemiBold,
                                        fontSize: Dimens.space15.sp,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            CustomIcon.icon_arrow_right,
                            size: Dimens.space24.w,
                            color: CustomColors.textQuinaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: Dimens.space1.h,
                    thickness: Dimens.space1.h,
                    color: CustomColors.mainDividerColor,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
