/*
 * *
 *  * Created by Kedar on 7/12/21 12:51 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/12/21 12:51 PM
 *
 */
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/numbers/MyNumberProviders.dart";
import "package:mvp/repository/MyNumberRepository.dart";
import "package:mvp/ui/common/CustomTextField.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/NoSearchResultsFoundWidget.dart";
import "package:mvp/ui/common/base/CustomAppBar.dart";
import "package:mvp/ui/common/shimmer/NumberShimmer.dart";
import "package:mvp/ui/common/shimmer/contactShimmer.dart";
import "package:mvp/ui/number/NumberListItemView.dart";
import "package:mvp/utils/ColorHolder.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:provider/provider.dart";

class NumberListView extends StatefulWidget {
  const NumberListView({
    Key? key,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final VoidCallback? onIncomingTap;
  final VoidCallback? onOutgoingTap;

  @override
  AddTagViewWidgetState createState() => AddTagViewWidgetState();
}

class AddTagViewWidgetState extends State<NumberListView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  TextEditingController controllerSearchTeams = TextEditingController();
  MyNumberRepository? myNumberRepository;
  MyNumberProvider? myNumberProvider;

  ColorHolder? selectedColor;
  List<String> selectedTags = [];
  String clientId = "";
  final _debounce = DeBouncer(milliseconds: 500);

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myNumberRepository =
        Provider.of<MyNumberRepository>(context, listen: false);

    Future<bool> _requestPop() {
      CustomAppBar.changeStatusColor(CustomColors.mainColor!);
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, clientId);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomAppBar<MyNumberProvider>(
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
                        : Utils.getString("numbers"),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
          elevation: 1,
          onIncomingTap: () {
            widget.onIncomingTap!();
          },
          onOutgoingTap: () {
            widget.onOutgoingTap!();
          },
          initProvider: () {
            return MyNumberProvider(myNumberRepository: myNumberRepository);
          },
          onProviderReady: (MyNumberProvider provider) async {
            myNumberProvider = provider;
            myNumberProvider!.doGetMyNumbersListApiCall();
            controllerSearchTeams.addListener(() {
              _debounce.run(() {
                if (controllerSearchTeams.text.isNotEmpty) {
                  if (controllerSearchTeams.text.length > 1 &&
                      controllerSearchTeams.text.startsWith("+") &&
                      RegExp(r"^[0-9]+$").hasMatch(
                          controllerSearchTeams.text.substring(1, 2))) {
                    myNumberProvider!.doDbNumbersSearch(
                        controllerSearchTeams.text.substring(1));
                  } else if (controllerSearchTeams.text == "+") {
                  } else if (controllerSearchTeams.text.length > 1 &&
                      controllerSearchTeams.text.startsWith("+")) {
                    myNumberProvider!.doDbNumbersSearch("zzzzzzz");
                  } else {
                    myNumberProvider!
                        .doDbNumbersSearch(controllerSearchTeams.text);
                  }
                } else {
                  myNumberProvider!.doGetMyNumbersListApiCall();
                }
              });
            });
          },
          builder: (BuildContext? context, MyNumberProvider? p, Widget? child) {
            animationController!.forward();
            if (myNumberProvider!.numbers != null &&
                myNumberProvider!.numbers!.data != null) {
              return SizedBox(
                width: ScreenUtil().screenHeight,
                child: Column(
                  children: [
                    if (myNumberProvider!.isNumberExist!)
                      Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space16.w,
                            Dimens.space20.h,
                            Dimens.space16.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: CustomSearchFieldWidgetWithIcon(
                          animationController: animationController,
                          textEditingController: controllerSearchTeams,
                          customIcon: CustomIcon.icon_search,
                          hint: Utils.getString("searchNumbers"),
                        ),
                      )
                    else
                      Container(),
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context!,
                        removeTop: true,
                        child: myNumberProvider!.isNumberExist!
                            ? (myNumberProvider!.numbers!.data!.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        myNumberProvider!.numbers!.data!.length,
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space20.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return NumberListItemView(
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: animationController!,
                                            curve: Interval(
                                                (1 / 10) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        number: myNumberProvider!
                                            .numbers!.data![index],
                                        onPressed: () async {},
                                        onLongPressed: () {},
                                      );
                                    },
                                    physics: const BouncingScrollPhysics(),
                                  )
                                : AnimatedBuilder(
                                    animation: animationController!,
                                    builder:
                                        (BuildContext? context, Widget? child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: Transform(
                                          transform: Matrix4.translationValues(
                                              0.0,
                                              100 * (1.0 - animation.value),
                                              0.0),
                                          child: const SingleChildScrollView(
                                            child: NoSearchResultsFoundWidget(),
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                            : AnimatedBuilder(
                                animation: animationController!,
                                builder:
                                    (BuildContext? context, Widget? child) {
                                  return FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(CurvedAnimation(
                                            parent: animationController!,
                                            curve: const Interval(0.5 * 1, 1.0,
                                                curve: Curves.fastOutSlowIn))),
                                    child: Transform(
                                      transform: Matrix4.translationValues(
                                          0.0,
                                          100 *
                                              (1.0 -
                                                  Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(CurvedAnimation(
                                                          parent:
                                                              animationController!,
                                                          curve: const Interval(
                                                              0.5 * 1, 1.0,
                                                              curve: Curves
                                                                  .fastOutSlowIn)))
                                                      .value),
                                          0.0),
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
                                        child: SingleChildScrollView(
                                          child: Center(
                                            child: AnimatedBuilder(
                                              animation: animationController!,
                                              builder: (BuildContext? context,
                                                  Widget? child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: Transform(
                                                    transform: Matrix4
                                                        .translationValues(
                                                            0.0,
                                                            100 *
                                                                (1.0 -
                                                                    animation
                                                                        .value),
                                                            0.0),
                                                    child: Container(
                                                      color: Colors.white,
                                                      margin: EdgeInsets.zero,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      child: EmptyViewUiWidget(
                                                        assetUrl:
                                                            "assets/images/empty_numbers.png",
                                                        title: Utils.getString(
                                                            "noNumbers"),
                                                        desc: Utils.getString(
                                                            "noNumbersDescription"),
                                                        buttonTitle:
                                                            Utils.getString(
                                                                "purchaseNumber"),
                                                        icon: Icons
                                                            .add_circle_outline,
                                                        showButton: false,
                                                        onPressed: () async {},
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  const ContactSearchShimmer(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 15,
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                      itemBuilder: (context, index) {
                        return const NumberShimmer();
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
