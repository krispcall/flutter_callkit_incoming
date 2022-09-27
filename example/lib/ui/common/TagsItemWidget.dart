import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/utils/HexToColor.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/allContact/Tags.dart";

class TagsItemWidget extends StatelessWidget {
  final Tags? tags;
  final bool fromContact;

  const TagsItemWidget({Key? key, this.tags, this.fromContact = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space8.w, Dimens.space0.h, Dimens.space8.w, Dimens.space0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.space5.r)),
        color: CustomColors.bottomAppBarColor,
      ),
      height: Dimens.space24.h,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Icon(
              CustomIcon.icon_circle,
              color: HexToColor(tags!.colorCode!),
              size: Dimens.space12.w,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow ? Const.OVERFLOW : tags!.title!,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textWidthBasis: TextWidthBasis.parent,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textSenaryColor,
                      fontFamily: Config.heeboMedium,
                      fontSize:
                          fromContact ? Dimens.space12.sp : Dimens.space14.sp,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                    ),
              ),
            ),
          ),
          Offstage(
            offstage: fromContact,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space8.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : tags!.count != null
                        ? tags!.count.toString()
                        : Utils.getString("0"),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.heeboMedium,
                      fontSize: Dimens.space12.sp,
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
