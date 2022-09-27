import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";

class ContactListItemView extends StatelessWidget {
  const ContactListItemView({
    Key? key,
    required this.contactEdges,
    required this.onTap,
    required this.animationController,
    required this.offStage,
    required this.animation,
  }) : super(key: key);

  final Contacts contactEdges;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final bool offStage;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext? context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: TextButton(
              onPressed: () {
                onTap();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.center,
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space7.h,
                    Dimens.space20.w, Dimens.space7.h),
                child: ContactListItemWidget(
                  contactEdges: contactEdges,
                  offStage: offStage,
                  // offStage: offStage,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ContactListItemWidget extends StatelessWidget {
  const ContactListItemWidget({
    Key? key,
    required this.contactEdges,
    required this.offStage,
  }) : super(key: key);

  final Contacts contactEdges;
  final bool offStage;

  @override
  Widget build(BuildContext context) {
    if (contactEdges != null) {
      return Container(
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              child: RoundedNetworkImageHolder(
                width: Dimens.space36,
                height: Dimens.space36,
                iconUrl: CustomIcon.icon_profile,
                containerAlignment: Alignment.bottomCenter,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space30,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space14,
                innerCorner: Dimens.space14,
                imageUrl: contactEdges.profilePicture != null &&
                        contactEdges.profilePicture!.isNotEmpty
                    ? contactEdges.profilePicture
                    : "",
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space10.w,
                              Dimens.space0.h,
                              Dimens.space10.w,
                              Dimens.space0.h),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            Config.checkOverFlow
                                ? Const.OVERFLOW
                                : contactEdges.name != null &&
                                        contactEdges.name!.isNotEmpty
                                    ? contactEdges.name!
                                    : contactEdges.number!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: contactEdges.blocked != null &&
                                              contactEdges.blocked!
                                          ? CustomColors.textSenaryColor!
                                              .withOpacity(0.4)
                                          : CustomColors.textSenaryColor,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.centerLeft,
                        child: Offstage(
                          offstage: offStage,
                          child: FutureBuilder<String>(
                            future: Utils.getFlagUrl(contactEdges.number!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return RoundedNetworkImageHolder(
                                  width: Dimens.space14,
                                  height: Dimens.space14,
                                  boxFit: BoxFit.contain,
                                  containerAlignment: Alignment.bottomCenter,
                                  iconUrl: CustomIcon.icon_gallery,
                                  iconColor: CustomColors.grey,
                                  iconSize: Dimens.space14,
                                  boxDecorationColor:
                                      CustomColors.mainBackgroundColor,
                                  outerCorner: Dimens.space0,
                                  innerCorner: Dimens.space0,
                                  imageUrl: PSApp.config!.countryLogoUrl! +
                                      snapshot.data!,
                                );
                              }
                              return const CupertinoActivityIndicator();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Offstage(
                    offstage: offStage,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                          Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : contactEdges.number!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomColors.textPrimaryLightColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space14.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
