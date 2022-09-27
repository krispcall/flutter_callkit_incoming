import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/country/CountryListProvider.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/utils/DeBouncer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:provider/provider.dart";

class CountryCodeSelectorDialog extends StatefulWidget {
  const CountryCodeSelectorDialog(
      {Key? key,
      this.countryCodeList,
      this.selectedCountryCode,
      required this.onSelectCountryCode})
      : super(key: key);
  final List<CountryCode>? countryCodeList;
  final Function(CountryCode) onSelectCountryCode;
  final CountryCode? selectedCountryCode;

  @override
  _CountryCodeSelectorDialogState createState() =>
      _CountryCodeSelectorDialogState();
}

class _CountryCodeSelectorDialogState extends State<CountryCodeSelectorDialog>
    with SingleTickerProviderStateMixin {
  CountryRepository? countryRepository;
  CountryListProvider? countryListProvider;

  ValueHolder? valueHolder;
  AnimationController? animationController;

  final TextEditingController controllerSearchCountry = TextEditingController();
  final List<CountryCode> _searchResult = [];
  final ScrollController scrollController = ScrollController();

  int start = 0, end = 20;

  final _debounce = DeBouncer(milliseconds: 500);

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    for (final element in widget.countryCodeList!) {
      element.flagUri!.replaceRange(0, 15, "assets/flags/");
    }

    _searchResult.addAll(widget.countryCodeList!);

    controllerSearchCountry.addListener(() {
      _debounce.run(() {
        if (controllerSearchCountry.text.isEmpty) {
          _searchResult.clear();
          _searchResult.addAll(widget.countryCodeList!.getRange(start, end));
          setState(() {});
        } else {
          _searchResult.clear();
          _searchResult.addAll(widget.countryCodeList!
              .where(
                (country) =>
                    country.name!
                        .toLowerCase()
                        .contains(controllerSearchCountry.text.toLowerCase()) ||
                    country.code!
                        .toLowerCase()
                        .contains(controllerSearchCountry.text.toLowerCase()) ||
                    country.dialCode!
                        .toLowerCase()
                        .contains(controllerSearchCountry.text.toLowerCase()),
              )
              .toList());
          setState(() {});
        }
      });
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          start = end;
          end += 10;
          _searchResult.addAll(widget.countryCodeList!.getRange(start, end));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    countryRepository = Provider.of<CountryRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    return ChangeNotifierProvider<CountryListProvider>(
      lazy: false,
      create: (BuildContext context) {
        countryListProvider =
            CountryListProvider(countryListRepository: countryRepository);
        return countryListProvider!;
      },
      child: Consumer<CountryListProvider>(builder:
          (BuildContext context, CountryListProvider? provider, Widget? child) {
        if (widget.countryCodeList != null &&
            widget.countryCodeList!.isNotEmpty) {
          return Container(
            height: ScreenUtil().screenHeight - Dimens.space50.h,
            width: ScreenUtil().screenWidth,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                    Dimens.space16.w,
                    Dimens.space20.h,
                    Dimens.space16.w,
                    Dimens.space20.h,
                  ),
                  alignment: Alignment.center,
                  height: Dimens.space52.h,
                  child: TextField(
                    controller: controllerSearchCountry,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: CustomColors.textSenaryColor,
                          fontFamily: Config.heeboRegular,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space16.sp,
                          fontStyle: FontStyle.normal,
                        ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(
                        Dimens.space0.w,
                        Dimens.space0.h,
                        Dimens.space0.w,
                        Dimens.space0.h,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.callInactiveColor!,
                          width: Dimens.space1.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space10.r),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.callInactiveColor!,
                          width: Dimens.space1.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space10.r),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.callInactiveColor!,
                          width: Dimens.space1.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space10.r),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.callInactiveColor!,
                          width: Dimens.space1.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space10.r),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.callInactiveColor!,
                          width: Dimens.space1.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space10.r),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: CustomColors.callInactiveColor!,
                          width: Dimens.space1.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimens.space10.r),
                        ),
                      ),
                      filled: true,
                      prefixIconConstraints: BoxConstraints(
                        minWidth: Dimens.space40.w,
                        maxWidth: Dimens.space40.w,
                        maxHeight: Dimens.space20.h,
                        minHeight: Dimens.space20.h,
                      ),
                      prefixIcon: Container(
                        alignment: Alignment.center,
                        width: Dimens.space20.w,
                        height: Dimens.space20.w,
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        margin: EdgeInsets.fromLTRB(Dimens.space15.w,
                            Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
                        child: Icon(
                          CustomIcon.icon_search,
                          size: Dimens.space16.w,
                          color: CustomColors.textTertiaryColor,
                        ),
                      ),
                      fillColor: CustomColors.baseLightColor,
                      hintText: Utils.getString("selectCountryCode"),
                      hintStyle:
                          Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: CustomColors.textTertiaryColor,
                                fontFamily: Config.heeboRegular,
                                fontWeight: FontWeight.normal,
                                fontSize: Dimens.space16.sp,
                                fontStyle: FontStyle.normal,
                              ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: _searchResult.length,
                    itemBuilder: (context, position) {
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space16.w,
                                    Dimens.space14.h,
                                    Dimens.space16.w,
                                    Dimens.space14.h),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    widget.selectedCountryCode != null &&
                                            widget.selectedCountryCode!.code ==
                                                _searchResult[position].code
                                        ? CustomColors.baseLightColor
                                        : CustomColors.transparent,
                              ),
                              onPressed: () {
                                widget.onSelectCountryCode(
                                    _searchResult[position]);
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space12.w,
                                        Dimens.space0.h),
                                    alignment: Alignment.center,
                                    child: RoundedNetworkImageHolder(
                                      imageUrl: PSApp.config!.countryLogoUrl! +
                                          _searchResult[position].flagUri!,
                                      width: Dimens.space24,
                                      height: Dimens.space24,
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
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Config.checkOverFlow
                                            ? Const.OVERFLOW
                                            : "${_searchResult[position].dialCode} (${_searchResult[position].name}) ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.normal)
                                            .copyWith(
                                              color: widget.selectedCountryCode !=
                                                          null &&
                                                      widget.selectedCountryCode!
                                                              .id ==
                                                          _searchResult[
                                                                  position]
                                                              .id
                                                  ? CustomColors
                                                      .textPrimaryColor
                                                  : CustomColors
                                                      .textPrimaryLightColor,
                                              fontFamily:
                                                  Config.manropeSemiBold,
                                              fontWeight: FontWeight.normal,
                                              fontSize: Dimens.space16.sp,
                                              fontStyle: FontStyle.normal,
                                            ),
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: CustomColors.callInactiveColor,
                            height: Dimens.space1.h,
                            thickness: Dimens.space1.h,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            height: ScreenUtil().screenHeight - Dimens.space50.h,
            width: ScreenUtil().screenWidth,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: SpinKitCircle(
              color: CustomColors.mainColor,
            ),
          );
        }
      }),
    );
  }
}
