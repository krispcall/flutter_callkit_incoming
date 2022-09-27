import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:functional_widget_annotation/functional_widget_annotation.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class ConfirmDialogView extends StatefulWidget {
  const ConfirmDialogView(
      {Key? key,
      this.description,
      this.leftButtonText,
      this.rightButtonText,
      this.onAgreeTap})
      : super(key: key);

  final String? description;
  final String? leftButtonText;
  final String? rightButtonText;
  final Function? onAgreeTap;

  @override
  ConfirmDialogViewState createState() => ConfirmDialogViewState();
}

class ConfirmDialogViewState extends State<ConfirmDialogView> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ConfirmDialogView widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CustomColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.space10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(Dimens.space20,
                    Dimens.space20, Dimens.space20, Dimens.space10),
                padding: EdgeInsets.zero,
                child: RoundedNetworkImageHolder(
                  width: Dimens.space24,
                  height: Dimens.space24,
                  iconUrl: Icons.help_outline,
                  iconColor: CustomColors.callDeclineColor,
                  iconSize: Dimens.space20,
                  boxDecorationColor: CustomColors.transparent,
                  imageUrl: "",
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0,
                    Dimens.space20, Dimens.space0),
                padding: EdgeInsets.zero,
                child: Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("confirm"),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeRegular,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0,
                    Dimens.space20, Dimens.space10),
                padding: EdgeInsets.zero,
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : widget.description!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textTertiaryColor,
                      fontFamily: Config.heeboRegular,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
                    Dimens.space0, Dimens.space20),
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(Dimens.space20,
                            Dimens.space0, Dimens.space10, Dimens.space0),
                        padding: EdgeInsets.zero,
                        child: RoundedButtonWidget(
                          width: double.infinity,
                          height: Dimens.space36,
                          buttonBorderColor: CustomColors.mainColor!,
                          buttonBackgroundColor: CustomColors.transparent!,
                          buttonTextColor: CustomColors.textTertiaryColor!,
                          corner: Dimens.space10,
                          buttonText: widget.leftButtonText!,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(Dimens.space0,
                            Dimens.space0, Dimens.space20, Dimens.space0),
                        padding: EdgeInsets.zero,
                        child: RoundedButtonWidget(
                          width: double.infinity,
                          height: Dimens.space36,
                          buttonBackgroundColor: CustomColors.callDeclineColor!,
                          buttonBorderColor: CustomColors.mainColor!,
                          buttonTextColor: CustomColors.white!,
                          corner: Dimens.space10,
                          buttonText: widget.rightButtonText!,
                          onPressed: widget.onAgreeTap!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@swidget
Widget logoutDialog(BuildContext context,
    {String title = "", String description = "", Function? onAgreeTap}) {
  return Dialog(
    backgroundColor: CustomColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.space10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width.w,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space20, Dimens.space0, Dimens.space20),
              padding: EdgeInsets.zero,
              child: Align(
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryColor,
                      fontFamily: Config.manropeBold,
                      fontSize: Dimens.space20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1.h,
              thickness: Dimens.space1.h,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center),
              onPressed: () {
                onAgreeTap!();
              },
              child: Container(
                height: Dimens.space44.h,
                alignment: Alignment.center,
                child: Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("logOut"),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColors.loadingCircleColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: Config.manropeSemiBold,
                        fontSize: Dimens.space15.sp,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
            ),
            Divider(
              color: CustomColors.mainDividerColor,
              height: Dimens.space1.h,
              thickness: Dimens.space1.h,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.center),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                height: Dimens.space44.h,
                alignment: Alignment.center,
                child: Text(
                  Config.checkOverFlow
                      ? Const.OVERFLOW
                      : Utils.getString("cancel"),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: Config.manropeSemiBold,
                        fontSize: Dimens.space15.sp,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
