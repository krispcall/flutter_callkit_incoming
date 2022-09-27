import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/viewObject/model/recentSearch/RecentSearch.dart";

class RecentSearchItemWidget extends StatelessWidget {
  final RecentSearch? recentSearch;
  final Function? onClearTap;
  final Function(String)? onItemTap;
  const RecentSearchItemWidget(
      {Key? key, this.recentSearch, this.onClearTap, this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        height: Dimens.space48.h,
        child: TextButton(
            onPressed: () async {
              onItemTap!(recentSearch!.recentSearch!);
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                  Dimens.space16.w, Dimens.space0.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space16,
                    height: Dimens.space16,
                    iconUrl: CustomIcon.icon_history,
                    containerAlignment: Alignment.bottomCenter,
                    iconColor: CustomColors.textTertiaryColor,
                    iconSize: Dimens.space16,
                    boxDecorationColor: CustomColors.transparent,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                    onTap: (){

                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space15.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : recentSearch != null &&
                                  recentSearch!.recentSearch != null
                              ? recentSearch!.recentSearch!
                              : "Test",
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.textPrimaryColor,
                          fontStyle: FontStyle.normal,
                          fontFamily: Config.manropeSemiBold,
                          fontSize: Dimens.space15.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    width: Dimens.space20,
                    height: Dimens.space20,
                    iconUrl: CustomIcon.icon_close,
                    iconColor: CustomColors.textQuinaryColor,
                    iconSize: Dimens.space10,
                    boxDecorationColor: CustomColors.transparent,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    imageUrl: "",
                    onTap: onClearTap,
                  ),
                ),
              ],
            )));
  }
}
