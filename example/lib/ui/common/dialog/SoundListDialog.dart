import "package:audioplayers/audioplayers.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/notification_provider/NotificationProvider.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/SoundMapperUtils.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/allContact/Contact.dart";
import "package:mvp/viewObject/model/sound/Sound.dart";

class SoundListDialog extends StatefulWidget {
  const SoundListDialog({
    Key? key,
    required this.notificationProvider,
    required this.onItemTap,
    required this.animationController,
  }) : super(key: key);

  final NotificationProvider notificationProvider;
  final Function(Contacts) onItemTap;
  final AnimationController animationController;
  @override
  SoundListDialogState createState() => SoundListDialogState();
}

class SoundListDialogState extends State<SoundListDialog> {
  List<Sound?> selectedSoundList = SoundMapperUtils.getSoundsList();
  AudioPlayer advancedPlayer = AudioPlayer(
    playerId: "RingtoneSetting",
  );

  @override
  void initState() {
    super.initState();
    final ring = widget.notificationProvider.getSelectedSound();
    if (ring != null) {
      for (int i = 0; i < selectedSoundList.length; i++) {
        if (ring == selectedSoundList[i]!.assetUrl) {
          selectedSoundList[i]!.isChecked = true;
          setState(() {});
          break;
        }
      }
    } else {
      selectedSoundList[0]!.isChecked = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    advancedPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height.h,
      width: MediaQuery.of(context).size.width.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space15.r),
          topRight: Radius.circular(Dimens.space15.r),
        ),
        color: CustomColors.transparent,
      ),
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Scaffold(
        backgroundColor: CustomColors.transparent,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width.w,
                  kToolbarHeight.h + Dimens.space20.h),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.space15.r),
                    topRight: Radius.circular(Dimens.space15.r),
                  ),
                  color: CustomColors.mainBackgroundColor,
                ),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h,
                    Dimens.space0.w, Dimens.space10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: CustomColors.mainBackgroundColor,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space8.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
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
                                      : Utils.getString("back"),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        color: CustomColors.loadingCircleColor,
                                        fontFamily: Config.manropeRegular,
                                        fontSize: Dimens.space16.sp,
                                        fontWeight: FontWeight.w500,
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
                            : Utils.getString("phoneRingtone"),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomColors.textBoldColor,
                              fontFamily: Config.manropeRegular,
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1.h,
              thickness: Dimens.space1.h,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  shrinkWrap: true,
                  itemCount: selectedSoundList.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center,
                      ),
                      onPressed: () {
                        for (final element in selectedSoundList) {
                          element!.isChecked = false;
                        }
                        setState(() {});
                        if (selectedSoundList[index]!.isChecked!) {
                          selectedSoundList[index]!.isChecked = false;
                        } else {
                          selectedSoundList[index]!.isChecked = true;
                          widget.notificationProvider.replaceSelectedSound(
                              selectedSoundList[index]!.assetUrl!);
                        }
                        setState(() {});
                        advancedPlayer.play(
                          AssetSource(selectedSoundList[index]!.fileName!),
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space10.h,
                                Dimens.space0.w,
                                Dimens.space10.h,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                      Dimens.space14.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: CustomCheckBox(
                                      width: Dimens.space20,
                                      height: Dimens.space20,
                                      boxFit: BoxFit.contain,
                                      iconUrl: Icons.fiber_manual_record,
                                      iconColor: CustomColors.white,
                                      selectedColor: CustomColors.mainColor,
                                      unSelectedColor:
                                          CustomColors.secondaryColor,
                                      isChecked:
                                          selectedSoundList[index]!.isChecked,
                                      iconSize: Dimens.space12,
                                      assetHeight: Dimens.space10,
                                      assetWidth: Dimens.space10,
                                      onCheckBoxTap: (value) {
                                        for (final element
                                            in selectedSoundList) {
                                          element!.isChecked = false;
                                        }
                                        setState(() {});
                                        if (selectedSoundList[index]!
                                            .isChecked!) {
                                          selectedSoundList[index]!.isChecked =
                                              false;
                                        } else {
                                          selectedSoundList[index]!.isChecked =
                                              true;
                                          widget.notificationProvider
                                              .replaceSelectedSound(
                                                  selectedSoundList[index]!
                                                      .assetUrl!);
                                        }
                                        setState(() {});
                                        advancedPlayer.play(
                                          AssetSource(selectedSoundList[index]!
                                              .fileName!),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                      Dimens.space10.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      selectedSoundList[index]!.name!,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: CustomColors.textSenaryColor,
                                            fontFamily: Config.manropeRegular,
                                            fontSize: Dimens.space16.sp,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
