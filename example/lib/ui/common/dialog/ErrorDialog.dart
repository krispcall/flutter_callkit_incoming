import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/ui/common/ButtonWidget.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/Utils.dart";

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({this.message});

  final String? message;

  @override
  ErrorDialogState createState() => ErrorDialogState();
}

class ErrorDialogState extends State<ErrorDialog> {
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

  final ErrorDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
                  iconUrl: Icons.error_outline_rounded,
                  iconColor: CustomColors.callDeclineColor,
                  iconSize: Dimens.space20,
                  boxDecorationColor: CustomColors.transparent,
                  imageUrl: "",
                ),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(Dimens.space20,
                        Dimens.space0, Dimens.space0, Dimens.space0),
                    padding: EdgeInsets.zero,
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("error"),
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
                margin: const EdgeInsets.fromLTRB(Dimens.space20, Dimens.space0,
                    Dimens.space20, Dimens.space10),
                padding: EdgeInsets.zero,
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : widget.message!,
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
                    Expanded(child: Container()),
                    Container(
                      margin: const EdgeInsets.fromLTRB(Dimens.space20,
                          Dimens.space0, Dimens.space20, Dimens.space0),
                      padding: EdgeInsets.zero,
                      child: RoundedButtonWidget(
                        width: Dimens.space80,
                        height: Dimens.space36,
                        buttonBackgroundColor: CustomColors.callDeclineColor!,
                        buttonTextColor: CustomColors.white!,
                        buttonBorderColor: CustomColors.callDeclineColor!,
                        corner: Dimens.space10,
                        buttonText: Utils.getString("ok").toUpperCase(),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
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

void errorAlertDialog({BuildContext? context, String? title, String? errorMsg}) {
  showDialog(
    context: context!,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.fromLTRB(Dimens.space14.w, Dimens.space24.h,
              Dimens.space14.w, Dimens.space24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : title!,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeRegular,
                        fontSize: Dimens.space20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: Dimens.space10.h,
              ),
              Flexible(
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : errorMsg!,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: CustomColors.textTertiaryColor,
                        fontFamily: Config.heeboRegular,
                        fontSize: Dimens.space15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: Dimens.space24.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(Dimens.space20.w,
                        Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("OK").toUpperCase(),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.textPrimaryColor,
                            fontFamily: Config.manropeRegular,
                            fontSize: Dimens.space15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
