/*
 * *
 *  * Created by Kedar on 7/16/21 1:55 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/16/21 1:55 PM
 *  
 */

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_libphonenumber/flutter_libphonenumber.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";

class ChannelSelectionDialog extends StatelessWidget {
  final String? clientName;
  final String? mutedDate;
  final Function? onUmMuteTap;
  final List<WorkspaceChannel>? channelList;
  final Function? onChannelTap;

  const ChannelSelectionDialog(
      {Key? key,
      this.clientName,
      this.mutedDate,
      this.onUmMuteTap,
      this.channelList,
      this.onChannelTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        children: <Widget>[
          Container(
              width: Dimens.space80.w,
              height: Dimens.space6.h,
              margin: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.space33.r),
                ),
                color: CustomColors.bottomAppBarColor,
              )),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space30.h,
                  Dimens.space0, Dimens.space0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space20.r),
                      topRight: Radius.circular(Dimens.space20.r))),
              child: Column(
                children: [
                  Divider(
                    color: CustomColors.mainDividerColor,
                    height: Dimens.space1,
                    thickness: Dimens.space1,
                  ),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: channelList!=null?channelList!.length:0,
                          itemBuilder: (context, index) {
                            return ChannelListItemView(
                              channel: channelList![index],
                              onTap: () {
                                Navigator.of(context).pop();
                                onChannelTap!(channelList![index]);
                              },
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChannelListItemView extends StatelessWidget {
  final Function? onTap;
  final WorkspaceChannel? channel;

  const ChannelListItemView({Key? key, this.onTap, this.channel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        color: Colors.white,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space12.h,
              Dimens.space20.w, Dimens.space12.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          onTap!();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Dimens.space48.w,
              height: Dimens.space48.w,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: FutureBuilder<String>(
                future: Utils.getFlagUrl(channel!.number!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return AppBarNetworkImageHolder(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      boxFit: BoxFit.scaleDown,
                      containerAlignment: Alignment.bottomCenter,
                      iconUrl: CustomIcon.icon_gallery,
                      iconColor: CustomColors.grey!,
                      iconSize: Dimens.space20,
                      boxDecorationColor: CustomColors.baseLightColor!,
                      outerCorner: Dimens.space30,
                      innerCorner: Dimens.space5,
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
                        Config.checkOverFlow ? Const.OVERFLOW : channel!.name!,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space6.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : FlutterLibphonenumber()
                                .formatNumberSync(channel!.number!),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.textPrimaryLightColor,
                              fontFamily: Config.heeboMedium,
                              fontSize: Dimens.space13.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
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
