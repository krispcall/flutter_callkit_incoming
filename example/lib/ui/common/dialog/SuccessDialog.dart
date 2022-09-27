import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class SuccessDialog extends StatefulWidget {
  const SuccessDialog({required this.message});

  final String message;

  @override
  SuccessDialogState createState() => SuccessDialogState();
}

class SuccessDialogState extends State<SuccessDialog> {
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

  final SuccessDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                  iconUrl: Icons.check_circle,
                  iconColor: CustomColors.callAcceptColor,
                  iconSize: Dimens.space20,
                  boxDecorationColor: CustomColors.transparent,
                  imageUrl: "",
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0,
                        Dimens.space0, Dimens.space0),
                    padding: EdgeInsets.zero,
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("success"),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeRegular,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0,
                    Dimens.space20.w, Dimens.space10),
                padding: EdgeInsets.zero,
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : widget.message,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textTertiaryColor,
                      fontFamily: Config.heeboRegular,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0,
                      Dimens.space0, Dimens.space20.w),
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w,
                          Dimens.space0, Dimens.space20.w, Dimens.space0),
                      padding: EdgeInsets.zero,
                      width: Dimens.space60.w,
                      child: RoundedButtonWidget(
                        width: double.infinity,
                        height: Dimens.space36,
                        buttonBackgroundColor: CustomColors.callAcceptColor!,
                        buttonBorderColor: CustomColors.callAcceptColor!,
                        buttonTextColor: CustomColors.white!,
                        corner: Dimens.space10,
                        buttonText: Utils.getString("ok").toUpperCase(),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
