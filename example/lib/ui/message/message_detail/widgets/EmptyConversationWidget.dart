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

class EmptyConversationWidget extends StatelessWidget {
  final String? title;
  final String message;
  final String? imageUrl;
  final String clientNumber;
  final Function onAddContactTap;
  final bool isContact;

  const EmptyConversationWidget(
      {Key? key,
      required this.title,
      required this.message,
      required this.imageUrl,
      required this.clientNumber,
      required this.onAddContactTap,
      this.isContact = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: Dimens.space100.w,
          height: Dimens.space100.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              RoundedNetworkImageHolder(
                width: Dimens.space100,
                height: Dimens.space100,
                containerAlignment: Alignment.bottomCenter,
                iconUrl: CustomIcon.icon_profile,
                iconColor: CustomColors.callInactiveColor,
                iconSize: Dimens.space85,
                boxDecorationColor: CustomColors.mainDividerColor,
                outerCorner: Dimens.space32,
                innerCorner: Dimens.space32,
                imageUrl: imageUrl,
              ),
              Positioned(
                bottom: Dimens.space0.h,
                right: Dimens.space0.w,
                child: Offstage(
                  offstage: isContact,
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space32,
                    height: Dimens.space32,
                    iconUrl: CustomIcon.icon_add_person,
                    iconColor: CustomColors.white,
                    iconSize: Dimens.space0,
                    boxDecorationColor: CustomColors.white,
                    outerCorner: Dimens.space32,
                    innerCorner: Dimens.space32,
                    imageUrl: "",
                    onTap: () {},
                  ),
                ),
              ),
              Positioned(
                bottom: Dimens.space2.h,
                right: Dimens.space2.w,
                child: Offstage(
                  offstage: isContact,
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space28,
                    height: Dimens.space28,
                    iconUrl: CustomIcon.icon_add_person,
                    iconColor: CustomColors.white,
                    iconSize: Dimens.space15,
                    boxDecorationColor: CustomColors.loadingCircleColor,
                    outerCorner: Dimens.space32,
                    innerCorner: Dimens.space32,
                    imageUrl: "",
                    onTap: onAddContactTap,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space37.w, Dimens.space10.h,
              Dimens.space37.w, Dimens.space0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RichText(
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: Dimens.space20.sp,
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeBold,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                      text: Config.checkOverFlow
                          ? Const.OVERFLOW
                          : title ?? clientNumber,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                child: FutureBuilder<String>(
                  future: Utils.getFlagUrl(clientNumber),
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
                        boxDecorationColor: CustomColors.mainBackgroundColor,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        imageUrl:
                            PSApp.config!.countryLogoUrl! + snapshot.data!,
                      );
                    }
                    return const CupertinoActivityIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space37.w, Dimens.space0.h,
              Dimens.space37.w, Dimens.space0.h),
          child: Text(
            Config.checkOverFlow
                ? Const.OVERFLOW
                : title != null
                    ? "$message $title"
                    : "$message $clientNumber",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: CustomColors.textTertiaryColor,
                  fontFamily: Config.heeboRegular,
                  fontSize: Dimens.space15.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
          ),
        ),
      ],
    );
  }
}
