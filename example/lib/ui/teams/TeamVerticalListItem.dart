/*
 * *
 *  * Created by Kedar on 7/29/21 1:59 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 1:59 PM
 *
 */
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/viewObject/model/teams/Teams.dart";

class TeamVerticalListItem extends StatelessWidget {
  const TeamVerticalListItem({
    Key? key,
    required this.team,
    required this.animationController,
    required this.animation,
    required this.onPressed,
    required this.onLongPressed,
  }) : super(key: key);

  final Teams team;
  final AnimationController animationController;
  final Animation<double> animation;
  final Function onPressed;
  final Function onLongPressed;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: ImageAndTextWidget(
                team: team,
                onPressed: () {
                  onPressed();
                },
                onLongPressed: () {},
              ),
            ),
          ),
        );
      },
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key? key,
    required this.team,
    required this.onPressed,
    required this.onLongPressed,
  }) : super(key: key);

  final Teams team;
  final Function onPressed;
  final Function onLongPressed;

  @override
  Widget build(BuildContext context) {
    if (team != null) {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CustomColors.mainDividerColor!,
            ),
          ),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space16.h,
                Dimens.space20.w, Dimens.space16.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: Dimens.space40.w,
                height: Dimens.space40.w,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedAssetImageTextHolder(
                  width: Dimens.space40,
                  height: Dimens.space40,
                  text: team.name != null ? team.name![0] : "",
                  textColor: CustomColors.textPrimaryColor!,
                  fontFamily: Config.heeboMedium,
                  fontSize: Dimens.space16,
                  boxFit: BoxFit.contain,
                  iconSize: Dimens.space30,
                  iconColor: CustomColors.callInactiveColor!,
                  iconUrl: CustomIcon.icon_gallery,
                  boxDecorationColor: CustomColors.mainDividerColor!,
                  corner: Dimens.space15,
                  imageUrl: team.avatar != null
                      ? "assets/images/050-goal-${team.avatar}.png"
                      : "",
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Config.checkOverFlow ? Const.OVERFLOW : team.title!,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: CustomColors.textSecondaryColor,
                                fontFamily: Config.manropeBold,
                                fontSize: Dimens.space14.sp,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                              ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space2.h, Dimens.space0.w, Dimens.space0.h),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.zero,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              int onlineCount = 0;
                              for (final element in team.members!) {
                                if (element.online != null && element.online!) {
                                  onlineCount++;
                                }
                              }
                              return CounterWidget(
                                count: "$onlineCount/${team.total} Members",
                                color: CustomColors.callAcceptColor!,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            onPressed();
          },
          onLongPress: () {
            onLongPressed();
          },
        ),
      );
    } else {
      return Container();
    }
  }
}

class CounterWidget extends StatelessWidget {
  final String? count;
  final Color? color;

  const CounterWidget({Key? key, this.count, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space4.w, Dimens.space0.h, Dimens.space4.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            width: Dimens.space10.w,
            height: Dimens.space10.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
            ),
            alignment: Alignment.centerLeft,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(Dimens.space4.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.centerLeft,
              child: Text(
                Config.checkOverFlow ? Const.OVERFLOW : count!,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: CustomColors.textPrimaryLightColor,
                      fontFamily: Config.manropeSemiBold,
                      fontSize: Dimens.space13.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
