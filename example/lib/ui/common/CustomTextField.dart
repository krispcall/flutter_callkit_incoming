import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/ui/common/NoLeadingSpaceFormatter.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;

  final String? titleText;
  final String? subTitle;
  final bool showSubTitle;
  final bool isForCountry;
  final FocusNode? focusNodeNext;
  final FocusNode? focusNode;

  const CustomTextField({
    required this.textEditingController,
    required this.containerFillColor,
    required this.borderColor,
    this.hintText,
    this.hintFontColor = const Color(0xFF857F96),
    this.hintFontSize = Dimens.space16,
    this.hintFontStyle = FontStyle.normal,
    this.hintFontWeight = FontWeight.normal,
    this.hintFontFamily = Config.heeboRegular,
    this.titleText,
    this.subTitle,
    this.showSubTitle = false,
    this.titleFont = Config.heeboRegular,
    this.titleFontSize = Dimens.space14,
    this.titleFontStyle = FontStyle.normal,
    this.titleFontWeight = FontWeight.normal,
    this.titleTextColor = const Color(0xFF564D6D),
    this.subtitleFont = Config.heeboRegular,
    this.subtitleFontSize = Dimens.space13,
    this.subtitleFontStyle = FontStyle.normal,
    this.subtitleFontWeight = FontWeight.normal,
    this.subtitleTextColor = const Color(0xFF857F96),
    this.titleMarginLeft = Dimens.space0,
    this.titleMarginRight = Dimens.space0,
    this.titleMarginTop = Dimens.space0,
    this.titleMarginBottom = Dimens.space0,
    this.obscure = false,
    this.inputFontColor = const Color(0xFF251A43),
    this.inputFontSize = Dimens.space16,
    this.inputFontFamily = Config.heeboRegular,
    this.inputFontStyle = FontStyle.normal,
    this.inputFontWeight = FontWeight.normal,
    this.readOnly = false,
    this.height = Dimens.space52,
    this.showTitle = false,
    this.keyboardType = TextInputType.text,
    this.prefix = false,
    this.suffix = false,
    this.autoFocus = false,
    this.codes,
    this.selectedCountryCode,
    this.onPrefixTap,
    this.textInputAction = TextInputAction.done,
    this.onSuffixTap,
    this.corner = Dimens.space10,
    this.borderWidth = Dimens.space1,
    this.isForCountry = true,
    this.focusNodeNext,
    this.focusNode,
    this.maxLength,
    this.onChanged,
  });

  // For Title

  final String titleFont;
  final double titleFontSize;
  final Color titleTextColor;
  final FontWeight titleFontWeight;
  final FontStyle titleFontStyle;
  final double titleMarginLeft;
  final double titleMarginRight;
  final double titleMarginTop;
  final double titleMarginBottom;

  //For Subtitle
  final String subtitleFont;
  final double subtitleFontSize;
  final Color subtitleTextColor;
  final FontWeight subtitleFontWeight;
  final FontStyle subtitleFontStyle;

  //For Hint
  final String? hintText;
  final Color hintFontColor;
  final double hintFontSize;
  final FontStyle hintFontStyle;
  final FontWeight hintFontWeight;
  final String hintFontFamily;

  //For Input
  final Color inputFontColor;
  final double inputFontSize;
  final String inputFontFamily;
  final FontStyle inputFontStyle;
  final FontWeight inputFontWeight;

  //For Corner
  final double corner;

  //For Container
  final Color containerFillColor;

  //For Border
  final double borderWidth;
  final Color borderColor;

  final double height;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool prefix;
  final bool suffix;
  final List<CountryCode>? codes;
  final CountryCode? selectedCountryCode;
  final Function? onPrefixTap;
  final Function? onSuffixTap;
  final bool autoFocus;
  final bool readOnly;
  final bool obscure;
  final TextInputAction textInputAction;
  final VoidCallback? onChanged;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (showTitle)
          Container(
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            margin: EdgeInsets.fromLTRB(titleMarginLeft.w, titleMarginTop.h,
                titleMarginRight.w, titleMarginBottom.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : titleText!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: titleTextColor,
                          fontFamily: titleFont,
                          fontSize: titleFontSize.sp,
                          fontWeight: titleFontWeight,
                          fontStyle: titleFontStyle,
                        ),
                  ),
                ),
                if (showSubTitle)
                  Expanded(
                    child: Text(
                      Config.checkOverFlow ? Const.OVERFLOW : subTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: subtitleTextColor,
                            fontFamily: subtitleFont,
                            fontSize: subtitleFontSize.sp,
                            fontWeight: subtitleFontWeight,
                            fontStyle: subtitleFontStyle,
                          ),
                    ),
                  )
                else
                  Container(),
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
          width: MediaQuery.of(context).size.width.sw,
          height: height.h,
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: TextField(
            inputFormatters: [
              NoLeadingSpaceFormatter(),
              if (maxLength != null)
                LengthLimitingTextInputFormatter(maxLength),
            ],
            keyboardType: keyboardType,
            readOnly: readOnly,
            textCapitalization: TextCapitalization.words,
            showCursor: true,
            enabled: !readOnly,
            obscureText: obscure,
            controller: textEditingController,
            textInputAction: textInputAction,
            autofocus: autoFocus,
            onChanged: (data) {
              if (onChanged != null) {
                onChanged!();
              }
            },
            focusNode: focusNode,
            onSubmitted: (val) {
              if (focusNodeNext != null) {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(focusNodeNext);
              } else {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: inputFontColor,
                  fontSize: inputFontSize.sp,
                  fontStyle: inputFontStyle,
                  fontFamily: inputFontFamily,
                  fontWeight: FontWeight.normal,
                ),
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(Dimens.space12.w,
                  Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor, width: borderWidth.w),
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.space10.r)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor, width: borderWidth.w),
                borderRadius: BorderRadius.all(Radius.circular(corner.r)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor, width: borderWidth.w),
                borderRadius: BorderRadius.all(Radius.circular(corner.r)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor, width: borderWidth.w),
                borderRadius: BorderRadius.all(Radius.circular(corner.r)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor, width: borderWidth.w),
                borderRadius: BorderRadius.all(Radius.circular(corner.r)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: borderColor, width: borderWidth.w),
                borderRadius: BorderRadius.all(Radius.circular(corner.r)),
              ),
              filled: true,
              fillColor: containerFillColor,
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: hintFontColor,
                    fontFamily: hintFontFamily,
                    fontWeight: hintFontWeight,
                    fontStyle: hintFontStyle,
                    fontSize: hintFontSize.sp,
                  ),
              prefixIcon: prefix
                  ? isForCountry
                      ? InkWell(
                          onTap: () {
                            onPrefixTap!();
                            FocusScope.of(context).unfocus();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: CustomColors
                                          .secondaryColor!), //BorderSide
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space12.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: RoundedNetworkImageHolder(
                                      width: Dimens.space20,
                                      height: Dimens.space20,
                                      boxFit: BoxFit.contain,
                                      containerAlignment:
                                          Alignment.bottomCenter,
                                      iconUrl: CustomIcon.icon_gallery,
                                      iconColor: CustomColors.grey,
                                      iconSize: Dimens.space20,
                                      boxDecorationColor:
                                          CustomColors.mainBackgroundColor,
                                      outerCorner: Dimens.space0,
                                      innerCorner: Dimens.space0,
                                      imageUrl:
                                          selectedCountryCode?.flagUri == null
                                              ? ""
                                              : PSApp.config!.countryLogoUrl! +
                                                  selectedCountryCode!.flagUri!,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: CustomColors.textQuaternaryColor,
                                      size: Dimens.space24.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Icon(
                          CustomIcon.icon_search,
                          size: Dimens.space24.w,
                          color: CustomColors.textQuinaryColor,
                        )
                  : null,
              suffixIcon: suffix
                  ? InkWell(
                      onTap: () {
                        onSuffixTap!();
                      },
                      child: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: Dimens.space20.w,
                        color: obscure
                            ? CustomColors.mainColor
                            : CustomColors.mainColor,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSearchFieldWidgetWithIcon extends StatelessWidget {
  const CustomSearchFieldWidgetWithIcon(
      {this.textEditingController,
      this.animationController,
      this.customIcon,
      this.hint,
      Key? key})
      : super(key: key);

  final TextEditingController? textEditingController;
  final AnimationController? animationController;
  final IconData? customIcon;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: TextField(
        inputFormatters: [
          NoLeadingSpaceFormatter(),
        ],
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: CustomColors.textTertiaryColor,
            fontFamily: Config.heeboRegular,
            fontSize: Dimens.space16.sp,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            Dimens.space15.w,
            Dimens.space15.h,
            Dimens.space15.w,
            Dimens.space15.h,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.redButtonColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
          ),
          filled: true,
          fillColor: CustomColors.baseLightColor,
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: CustomColors.textTertiaryColor,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space16.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal),
          prefixIcon: Icon(
            customIcon,
            size: Dimens.space20.w,
            color: CustomColors.textPrimaryLightColor,
          ),
        ),
      ),
    );
  }
}

class CustomSearchFieldWidgetWithIconColor extends StatelessWidget {
  const CustomSearchFieldWidgetWithIconColor(
      {this.textEditingController,
      this.animationController,
      this.customIcon,
      this.hint,
      Key? key})
      : super(key: key);

  final TextEditingController? textEditingController;
  final AnimationController? animationController;
  final IconData? customIcon;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      color: CustomColors.baseLightColor,
      child: TextField(
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: CustomColors.textTertiaryColor,
            fontFamily: Config.heeboRegular,
            fontSize: Dimens.space14.sp,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            Dimens.space15.w,
            Dimens.space0.h,
            Dimens.space15.w,
            Dimens.space0.h,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space6.r)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space6.r)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.redButtonColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space6.r)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space6.r)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space6.r)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: CustomColors.callInactiveColor!, width: Dimens.space1.w),
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space6.r)),
          ),
          filled: true,
          fillColor: CustomColors.white,
          hintText: hint,
          isDense: true,
          alignLabelWithHint: true,
          hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: CustomColors.textTertiaryColor,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space14.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal),
          prefixIcon: Icon(
            customIcon,
            size: Dimens.space14.w,
            color: CustomColors.textPrimaryLightColor,
          ),
        ),
      ),
    );
  }
}

class PhoneNumberTextFieldWidget extends StatefulWidget {
  const PhoneNumberTextFieldWidget({
    required this.textEditingController,
    required this.containerFillColor,
    required this.borderColor,
    required this.validationKey,
    required this.validator,
    this.hintText,
    this.hintFontColor = const Color(0xFF857F96),
    this.hintFontSize = Dimens.space16,
    this.hintFontStyle = FontStyle.normal,
    this.hintFontWeight = FontWeight.normal,
    this.hintFontFamily = Config.heeboRegular,
    this.titleText,
    this.subTitle,
    this.showSubTitle = false,
    this.titleFont = Config.heeboRegular,
    this.titleFontSize = Dimens.space14,
    this.titleFontStyle = FontStyle.normal,
    this.titleFontWeight = FontWeight.normal,
    this.titleTextColor = const Color(0xFF564D6D),
    this.subtitleFont = Config.heeboRegular,
    this.subtitleFontSize = Dimens.space13,
    this.subtitleFontStyle = FontStyle.normal,
    this.subtitleFontWeight = FontWeight.normal,
    this.subtitleTextColor = const Color(0xFF857F96),
    this.titleMarginLeft = Dimens.space0,
    this.titleMarginRight = Dimens.space0,
    this.titleMarginTop = Dimens.space0,
    this.titleMarginBottom = Dimens.space0,
    this.obscure = false,
    this.inputFontColor = const Color(0xFF251A43),
    this.inputFontSize = Dimens.space16,
    this.inputFontFamily = Config.heeboRegular,
    this.inputFontStyle = FontStyle.normal,
    this.inputFontWeight = FontWeight.normal,
    this.readOnly = false,
    this.height = Dimens.space54,
    this.showTitle = false,
    this.keyboardType = TextInputType.text,
    this.prefix = false,
    this.suffix = false,
    this.autoFocus = false,
    this.onPrefixTap,
    this.textInputAction = TextInputAction.done,
    this.onSuffixTap,
    this.corner = Dimens.space10,
    this.borderWidth = Dimens.space1,
    this.isForCountry = true,
    this.focusNodeNext,
    this.focusNode,
    this.maxLength,
    this.onChanged,
    this.provider,
    this.selectedCountryCode,
    this.changeFocus,
  });

  final TextEditingController textEditingController;
  final GlobalKey<FormState> validationKey;

  final String? titleText;
  final String? subTitle;
  final bool showSubTitle;
  final bool isForCountry;
  final FocusNode? focusNodeNext;
  final FocusNode? focusNode;

  // For Title

  final String titleFont;
  final double titleFontSize;
  final Color titleTextColor;
  final FontWeight titleFontWeight;
  final FontStyle titleFontStyle;
  final double titleMarginLeft;
  final double titleMarginRight;
  final double titleMarginTop;
  final double titleMarginBottom;

  //For Subtitle
  final String subtitleFont;
  final double subtitleFontSize;
  final Color subtitleTextColor;
  final FontWeight subtitleFontWeight;
  final FontStyle subtitleFontStyle;

  //For Hint
  final String? hintText;
  final Color hintFontColor;
  final double hintFontSize;
  final FontStyle hintFontStyle;
  final FontWeight hintFontWeight;
  final String hintFontFamily;

  //For Input
  final Color inputFontColor;
  final double inputFontSize;
  final String inputFontFamily;
  final FontStyle inputFontStyle;
  final FontWeight inputFontWeight;

  //For Corner
  final double corner;

  //For Container
  final Color containerFillColor;

  //For Border
  final double borderWidth;
  final Color borderColor;

  final double height;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool prefix;
  final bool suffix;
  final Function? onPrefixTap;
  final Function? onSuffixTap;
  final bool autoFocus;
  final bool readOnly;
  final bool obscure;
  final TextInputAction textInputAction;
  final VoidCallback? onChanged;
  final int? maxLength;
  final CountryListProvider? provider;
  final CountryCode? selectedCountryCode;
  final String? Function(String?) validator;
  final VoidCallback? changeFocus;

  @override
  _PhoneNumberTextFieldWidgetState createState() {
    return _PhoneNumberTextFieldWidgetState();
  }
}

class _PhoneNumberTextFieldWidgetState
    extends State<PhoneNumberTextFieldWidget> {
  FocusNode focusNode = FocusNode();
  Color focusColor = CustomColors.baseLightColor!;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        focusColor = CustomColors.white!;
      });
    } else {
      setState(() {
        focusColor = CustomColors.baseLightColor!;
      });
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (widget.showTitle)
          Container(
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            margin: EdgeInsets.fromLTRB(
                widget.titleMarginLeft.w,
                widget.titleMarginTop.h,
                widget.titleMarginRight.w,
                widget.titleMarginBottom.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : widget.titleText!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: widget.titleTextColor,
                          fontFamily: widget.titleFont,
                          fontSize: widget.titleFontSize.sp,
                          fontWeight: widget.titleFontWeight,
                          fontStyle: widget.titleFontStyle,
                        ),
                  ),
                ),
                if (widget.showSubTitle)
                  Text(Config.checkOverFlow ? Const.OVERFLOW : widget.subTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: widget.subtitleTextColor,
                            fontFamily: widget.subtitleFont,
                            fontSize: widget.subtitleFontSize.sp,
                            fontWeight: widget.subtitleFontWeight,
                            fontStyle: widget.subtitleFontStyle,
                          ))
                else
                  Container(),
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space6.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Form(
            key: widget.validationKey,
            child: TextFormField(
              inputFormatters: [
                NoLeadingSpaceFormatter(),
                if (widget.maxLength != null)
                  LengthLimitingTextInputFormatter(widget.maxLength),
              ],
              keyboardType: widget.keyboardType,
              readOnly: widget.readOnly,
              textCapitalization: TextCapitalization.words,
              showCursor: true,
              enabled: !widget.readOnly,
              obscureText: widget.obscure,
              controller: widget.textEditingController,
              textInputAction: widget.textInputAction,
              autofocus: widget.autoFocus,
              onChanged: (data) {
                widget.onChanged!();
              },
              focusNode: focusNode,
              validator: widget.validator,
              onEditingComplete: () {
                widget.changeFocus!();
              },
              // onSubmitted: (val) {
              //   if (widget.focusNodeNext != null) {
              //     FocusScope.of(context).unfocus();
              //     FocusScope.of(context).requestFocus(widget.focusNodeNext);
              //   } else {
              //     FocusScope.of(context).unfocus();
              //     FocusScope.of(context).requestFocus(FocusNode());
              //   }
              // },
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: widget.inputFontColor,
                    fontSize: widget.inputFontSize.sp,
                    fontStyle: widget.inputFontStyle,
                    fontFamily: widget.inputFontFamily,
                    fontWeight: FontWeight.normal,
                  ),
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                fillColor: focusColor,
                contentPadding: EdgeInsets.fromLTRB(Dimens.space12.w,
                    Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.space10.r),
                  ),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: CustomColors.mainColor!,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: CustomColors.callInactiveColor!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: CustomColors.callInactiveColor!,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: Colors.red,
                  ),
                ),
                filled: true,
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: widget.hintFontColor,
                      fontFamily: widget.hintFontFamily,
                      fontWeight: widget.hintFontWeight,
                      fontStyle: widget.hintFontStyle,
                      fontSize: widget.hintFontSize.sp,
                    ),
                errorStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryErrorColor,
                      fontSize: Dimens.space14.sp,
                      fontStyle: FontStyle.normal,
                      fontFamily: Config.heeboRegular,
                      fontWeight: FontWeight.normal,
                    ),
                prefixIcon: InkWell(
                  onTap: () {
                    widget.onPrefixTap!();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: StreamBuilder<String>(
                          stream: widget
                              .provider!.streamControllerCountryFlagUrl!.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            String flagUrl = "";
                            if (snapshot.hasData) {
                              flagUrl = snapshot.data!;
                            } else {
                              if (widget.isForCountry) {
                                flagUrl = PSApp.config!.countryLogoUrl! +
                                    widget.selectedCountryCode!.flagUri!;
                              }
                            }

                            return RoundedNetworkImageHolder(
                              width: Dimens.space20,
                              height: Dimens.space16,
                              boxFit: BoxFit.contain,
                              containerAlignment: Alignment.bottomCenter,
                              iconUrl: CustomIcon.icon_gallery,
                              iconColor: CustomColors.grey,
                              iconSize: Dimens.space16,
                              boxDecorationColor:
                                  CustomColors.mainBackgroundColor,
                              outerCorner: Dimens.space0,
                              innerCorner: Dimens.space0,
                              imageUrl: flagUrl,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        alignment: Alignment.center,
                        child: Icon(
                          CustomIcon.icon_arrow_down,
                          color: CustomColors.textQuaternaryColor,
                          size: Dimens.space16.r,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextForm extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> validationKey;
  final BuildContext context;
  final TextInputType keyboardType;
  final String hint;
  final String validatorErrorText;
  final Color inputFontColor;
  final double inputFontSize;
  final FontStyle inputFontStyle;
  final String inputFontFamily;
  final Color hintFontColor;
  final String hintFontFamily;
  final FontWeight hintFontWeight;
  final FontStyle hintFontStyle;
  final double titleFontSize;
  final Color titleFontColor;
  final String titleFontFamily;
  final FontWeight titleFontWeight;
  final FontStyle titleFontStyle;
  final TextInputAction textInputAction;
  final Function? onSuffixTap;
  final String? Function(String?) validator;
  final bool suffix;
  final AutovalidateMode autoValidateMode;
  final bool obscure;
  final bool autofocus;
  final bool hideKeyboardSuffixIconClick;
  final FocusNode focusNode;
  final String title;
  final String titleSub;
  final Color focusColor;
  final VoidCallback? changeFocus;
  final bool readOnly;

  const CustomTextForm({
    required this.controller,
    required this.focusNode,
    required this.validator,
    required this.validationKey,
    required this.context,
    required this.keyboardType,
    required this.hint,
    required this.validatorErrorText,
    required this.inputFontColor,
    required this.inputFontSize,
    required this.inputFontStyle,
    required this.inputFontFamily,
    required this.hintFontColor,
    required this.hintFontFamily,
    required this.hintFontWeight,
    required this.hintFontStyle,
    required this.titleFontColor,
    required this.titleFontSize,
    required this.titleFontFamily,
    required this.titleFontWeight,
    required this.titleFontStyle,
    required this.textInputAction,
    required this.focusColor,
    this.title = "",
    this.titleSub = "",
    this.onSuffixTap,
    this.suffix = false,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.obscure = false,
    this.autofocus = false,
    this.hideKeyboardSuffixIconClick = false,
    this.changeFocus,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Visibility(
                visible: title.isNotEmpty,
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: titleFontSize.sp,
                        color: titleFontColor,
                        fontFamily: titleFontFamily,
                        fontWeight: titleFontWeight,
                        fontStyle: titleFontStyle,
                      ),
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              child: Visibility(
                visible: titleSub.isNotEmpty,
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : titleSub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: Dimens.space13.sp,
                        color: CustomColors.textPrimaryLightColor,
                        fontFamily: Config.heeboRegular,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space6.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Form(
            key: validationKey,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              autovalidateMode: autoValidateMode,
              readOnly: readOnly,
              focusNode: focusNode,
              obscureText: obscure,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: inputFontColor,
                    fontSize: inputFontSize.sp,
                    fontStyle: inputFontStyle,
                    fontFamily: inputFontFamily,
                    fontWeight: FontWeight.normal,
                  ),
              onEditingComplete: () {
                changeFocus!();
              },
              validator: validator,
              autofocus: autofocus,
              decoration: InputDecoration(
                isDense: true,
                errorMaxLines: 1,
                counterText: "",
                filled: true,
                fillColor: focusColor,
                contentPadding: EdgeInsets.fromLTRB(Dimens.space16.w,
                    Dimens.space14.h, Dimens.space16.w, Dimens.space14.h),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.space10.r),
                  ),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: CustomColors.mainColor!,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: CustomColors.callInactiveColor!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: CustomColors.callInactiveColor!,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  borderSide: BorderSide(
                    width: Dimens.space1.w,
                    color: Colors.red,
                  ),
                ),
                errorStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: CustomColors.textPrimaryErrorColor,
                      fontSize: Dimens.space14.sp,
                      fontStyle: FontStyle.normal,
                      fontFamily: Config.heeboRegular,
                      fontWeight: FontWeight.normal,
                    ),
                hintText: hint,
                hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: hintFontColor,
                      fontFamily: hintFontFamily,
                      fontWeight: hintFontWeight,
                      fontStyle: hintFontStyle,
                      fontSize: inputFontSize.sp,
                    ),
                suffixIcon: suffix
                    ? InkWell(
                        onTap: () {
                          onSuffixTap!();
                          if (hideKeyboardSuffixIconClick) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: Dimens.space20.w,
                          color: obscure
                              ? CustomColors.textSenaryColor
                              : CustomColors.textSenaryColor,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
