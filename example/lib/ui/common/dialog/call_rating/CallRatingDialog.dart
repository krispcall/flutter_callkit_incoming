import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/utils/Utils.dart";

class CallRatingDialog extends StatelessWidget {
  final Function(int) onRatingTap;

  const CallRatingDialog({
    Key? key,
    required this.onRatingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width.w * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.space16.r),
            ),
            padding: EdgeInsets.fromLTRB(Dimens.space32.w, Dimens.space26.h,
                Dimens.space32.w, Dimens.space26.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("rateCallQuality"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: CustomColors.textBoldColor,
                        fontFamily: Config.manropeRegular,
                        fontSize: Dimens.space20.sp,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space41.h,
                      Dimens.space0.w, Dimens.space41.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RatingBar(
                    minRating: 1,
                    unratedColor: CustomColors.textQuinaryColor,
                    itemPadding: EdgeInsets.fromLTRB(Dimens.space8.w,
                        Dimens.space0.h, Dimens.space8.w, Dimens.space0.h),
                    ratingWidget: RatingWidget(
                      full: Icon(
                        CustomIcon.icon_full_rating,
                        size: Dimens.space30.r,
                        color: CustomColors.ratingColor,
                      ),
                      half: Icon(
                        CustomIcon.icon_empty_rating,
                        size: Dimens.space30.r,
                        color: CustomColors.ratingColor,
                      ),
                      empty: Icon(
                        CustomIcon.icon_empty_rating,
                        size: Dimens.space30.r,
                        color: CustomColors.textQuinaryColor,
                      ),
                    ),
                    itemSize: Dimens.space30.r,
                    onRatingUpdate: (rating) {
                      onRatingTap(rating.toInt());
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("notNow"),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.textQuinaryColor,
                            fontFamily: Config.manropeRegular,
                            fontSize: Dimens.space18.sp,
                            fontWeight: FontWeight.w600,
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
  }
}
