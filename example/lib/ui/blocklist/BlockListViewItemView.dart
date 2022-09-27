import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";

class BlockListItemView extends StatelessWidget {
  const BlockListItemView({
    Key? key,
    required this.onUnblockTap,
    this.contactEdges,
  }) : super(key: key);

  final Function? onUnblockTap;
  final Contacts? contactEdges;

  @override
  Widget build(BuildContext context) {
    if (contactEdges != null) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              Dimens.space0.h,
              Dimens.space0.w,
              Dimens.space0.h,
            ),
            padding: EdgeInsets.fromLTRB(
              Dimens.space20.w,
              Dimens.space10.h,
              Dimens.space5.w,
              Dimens.space10.h,
            ),
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
                    width: Dimens.space46,
                    height: Dimens.space46,
                    iconUrl: CustomIcon.icon_profile,
                    containerAlignment: Alignment.bottomCenter,
                    iconColor: CustomColors.callInactiveColor,
                    iconSize: Dimens.space40,
                    boxDecorationColor: CustomColors.mainDividerColor!,
                    outerCorner: Dimens.space14,
                    innerCorner: Dimens.space14,
                    imageUrl: contactEdges!.profilePicture != null &&
                            contactEdges!.profilePicture!.isNotEmpty
                        ? contactEdges!.profilePicture!
                        : "",
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space10.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : contactEdges!.name != null &&
                                      contactEdges!.name!.isNotEmpty
                                  ? contactEdges!.name!
                                  : contactEdges!.number!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: CustomColors.textBoldColor,
                                fontFamily: Config.manropeSemiBold,
                                fontSize: Dimens.space16.sp,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                        ),
                        SizedBox(
                          height: Dimens.space5.h,
                        ),
                        Text(
                          Config.checkOverFlow
                              ? Const.OVERFLOW
                              : contactEdges!.number != null &&
                                      contactEdges!.number!.isNotEmpty
                                  ? contactEdges!.number!
                                  : contactEdges!.number!,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: CustomColors.textTertiaryColor,
                                fontFamily: Config.heeboRegular,
                                fontSize: Dimens.space12.sp,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    Dimens.space0.w,
                    Dimens.space0.h,
                    Dimens.space16.w,
                    Dimens.space0.h,
                  ),
                  padding: EdgeInsets.fromLTRB(
                    Dimens.space0.w,
                    Dimens.space0.h,
                    Dimens.space0.w,
                    Dimens.space0.h,
                  ),
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      onUnblockTap!();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: CustomColors.transparent,
                    ),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("unblock").toUpperCase(),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.loadingCircleColor,
                            fontFamily: Config.heeboRegular,
                            fontSize: Dimens.space14.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: CustomColors.mainDividerColor,
            height: Dimens.space1.h,
            thickness: Dimens.space1.h,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
