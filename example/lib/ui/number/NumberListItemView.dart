/*
 * *
 *  * Created by Kedar on 7/30/21 3:12 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/30/21 3:12 PM
 *
 */
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
import "package:mvp/viewObject/model/numbers/Numbers.dart";

class NumberListItemView extends StatelessWidget {
  final VoidCallback? onTap;
  final Numbers? number;
  final AnimationController? animationController;
  final Animation? animation;
  final Function? onPressed;
  final Function? onLongPressed;

  const NumberListItemView(
      {Key? key,
      this.onTap,
      this.number,
      this.animationController,
      this.animation,
      this.onPressed,
      this.onLongPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColors.mainDividerColor!,
          ),
        ),
        color: Colors.white,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h,
              Dimens.space20.w, Dimens.space12.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onTap,
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
              child: FutureBuilder<String>(
                future: Utils.getFlagUrl(number!.number!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RoundedNetworkImageHolder(
                      width: Dimens.space20,
                      height: Dimens.space20,
                      boxFit: BoxFit.contain,
                      iconUrl: CustomIcon.icon_gallery,
                      iconColor: CustomColors.grey,
                      iconSize: Dimens.space24,
                      boxDecorationColor: CustomColors.mainDividerColor,
                      outerCorner: Dimens.space25,
                      innerCorner: Dimens.space0,
                      imageUrl: PSApp.config!.countryLogoUrl! + snapshot.data!,
                    );
                  }
                  return const CupertinoActivityIndicator();
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space0.h,
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
                        Config.checkOverFlow ? Const.OVERFLOW : number!.name!,
                        textAlign: TextAlign.left,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : number!.number!,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textPrimaryLightColor,
                              fontFamily: Config.heeboMedium,
                              fontSize: Dimens.space13.sp,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
