import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/dialog/BlockContactDialog.dart";
import "package:mvp/ui/common/dialog/DeleteContactDialog.dart";
import "package:mvp/utils/Utils.dart";

class ContactDeleteBlockDialog extends StatefulWidget {
  final bool blocked;
  final Function(bool) onBlockTap;
  final VoidCallback onDeleteTap;

  const ContactDeleteBlockDialog({
    Key? key,
    required this.blocked,
    required this.onBlockTap,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  ContactDeleteBlockDialogState createState() =>
      ContactDeleteBlockDialogState();
}

class ContactDeleteBlockDialogState extends State<ContactDeleteBlockDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.fromLTRB(
          Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width.w,
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.circular(Dimens.space16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space30.w,
                        Dimens.space0.h, Dimens.space30.w, Dimens.space0.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.center,
                  ),
                  onPressed: showBlockContactDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedNetworkImageHolder(
                        width: Dimens.space30,
                        height: Dimens.space52,
                        iconUrl: Icons.block,
                        iconColor: widget.blocked
                            ? CustomColors.startButtonColor
                            : CustomColors.textTertiaryColor,
                        iconSize: Dimens.space20,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        boxDecorationColor: CustomColors.transparent,
                        imageUrl: "",
                      ),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: widget.blocked
                                          ? CustomColors.startButtonColor
                                          : CustomColors.textTertiaryColor,
                                      fontFamily: Config.manropeRegular,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                            text: Config.checkOverFlow
                                ? Const.OVERFLOW
                                : widget.blocked
                                    ? Utils.getString("unblock")
                                    : Utils.getString("blockContact1"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: CustomColors.callInactiveColor,
                  height: Dimens.spaceHalf.h,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(Dimens.space30.w,
                        Dimens.space0.h, Dimens.space30.w, Dimens.space0.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.center,
                  ),
                  onPressed: showDeleteContactDialog,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedNetworkImageHolder(
                        width: Dimens.space30,
                        height: Dimens.space52,
                        iconUrl: CustomIcon.icon_trash_outlined,
                        iconColor: CustomColors.callDeclineColor,
                        iconSize: Dimens.space20,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        boxDecorationColor: CustomColors.transparent,
                        imageUrl: "",
                      ),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: CustomColors.textPrimaryErrorColor,
                                      fontFamily: Config.manropeRegular,
                                      fontSize: Dimens.space13.sp,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                    ),
                            text: Config.checkOverFlow
                                ? Const.OVERFLOW
                                : Utils.getString("deleteContact"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.space16.h),
          Container(
            width: MediaQuery.of(context).size.width.w,
            height: Dimens.space50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.space16.r),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.center,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                height: Dimens.space48.h,
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space10.h,
                    Dimens.space10.w, Dimens.space10.h),
                child: Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("cancel"),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeSemiBold,
                        fontSize: Dimens.space15.sp,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(height: Dimens.space32.h),
        ],
      ),
    );
  }

  Future<void> showDeleteContactDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DeleteContactDialog(
          onDeleteTap: () {
            widget.onDeleteTap();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> showBlockContactDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space16.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlockContactDialog(
          isBlocked: widget.blocked,
          onBlockTap: (value) {
            widget.onBlockTap(value);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
