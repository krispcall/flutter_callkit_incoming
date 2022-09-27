import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";
import "package:mvp/provider/macros/MacrosProvider.dart";
import "package:mvp/repository/MacrosRepository.dart";
import "package:mvp/ui/common/EmptyViewUiWidget.dart";
import "package:mvp/ui/common/shimmer/ContactShimmer.dart";
import "package:mvp/ui/macros/shimmer/MacrosTileShimmer.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/macros/list/Macro.dart";
import "package:provider/provider.dart";

class MacrosListView extends StatefulWidget {
  const MacrosListView({Key? key, required this.onItemTap, this.onBackTap})
      : super(key: key);

  final Function(Macro)? onItemTap;
  final VoidCallback? onBackTap;

  @override
  MacrosListViewState createState() => MacrosListViewState();
}

class MacrosListViewState extends State<MacrosListView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  TextEditingController textEditingControllerSearchMacors =
      TextEditingController();

  late MacrosRepository? macrosRepository;
  late MacrosProvider macrosProvider;
  bool isEditing = false;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);
    macrosRepository = Provider.of<MacrosRepository>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    textEditingControllerSearchMacors.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimens.space16.w),
            topLeft: Radius.circular(Dimens.space16.w)),
        color: CustomColors.white,
      ),
      alignment: Alignment.topCenter,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Dimens.space60.h,
            alignment: Alignment.topCenter,
            color: CustomColors.transparent,
            padding: const EdgeInsets.fromLTRB(
                Dimens.space0, Dimens.space5, Dimens.space0, Dimens.space5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: Dimens.space70.w,
                  top: Dimens.space0.w,
                  right: Dimens.space70.w,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    width: Dimens.space150.w,
                    height: Dimens.space48.h,
                    child: Text(
                      Config.checkOverFlow
                          ? Const.OVERFLOW
                          : Utils.getString("macros"),
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
                ),
                Positioned(
                  left: Dimens.space0.w,
                  top: Dimens.space0.w,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space8.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    width: Dimens.space60.w,
                    height: Dimens.space48.h,
                    child: TextButton(
                      onPressed: () {
                        widget.onBackTap!();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: CustomColors.transparent,
                        alignment: Alignment.center,
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
                                    fontFamily: Config.manropeBold,
                                    fontSize: Dimens.space15.sp,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
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
          ChangeNotifierProvider<MacrosProvider>(
            lazy: false,
            create: (BuildContext context) {
              macrosProvider = MacrosProvider(
                repository: macrosRepository!,
              );
              macrosProvider.getMacros();
              textEditingControllerSearchMacors.addListener(() {
                if (textEditingControllerSearchMacors.text.isEmpty) {
                  isEditing = false;
                  macrosProvider.getMacros();
                }
              });

              return macrosProvider;
            },
            child: Consumer<MacrosProvider>(
              builder: (BuildContext context, MacrosProvider? provider,
                  Widget? child) {
                animationController!.forward();
                return Expanded(
                    child: provider!.macros!.data != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space15.w,
                                    Dimens.space20.h,
                                    Dimens.space15.w,
                                    Dimens.space20.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: CustomColors.textTertiaryColor!,
                                      width: 0.2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space8.r),
                                  ),
                                  color: CustomColors.baseLightColor,
                                ),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                  ),
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller:
                                        textEditingControllerSearchMacors,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            color: CustomColors.textSenaryColor,
                                            fontFamily: Config.heeboRegular,
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dimens.space14.sp,
                                            fontStyle: FontStyle.normal),
                                    onChanged: (value) {
                                      isEditing = true;
                                      macrosProvider
                                          .searchMacrosFromList(value);
                                    },
                                    onEditingComplete: () {
                                      isEditing = false;
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space13.h,
                                        ),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: Dimens.space0.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(Dimens.space10.r),
                                          ),
                                        ),
                                        hintText:
                                            Utils.getString("searchDetails"),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: Dimens.space0.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(Dimens.space10.r),
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: Dimens.space0.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(Dimens.space10.r),
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: Dimens.space0.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(Dimens.space10.r),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: Dimens.space0.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(Dimens.space10.r),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: Dimens.space0.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(Dimens.space10.r),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: CustomColors.baseLightColor,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color:
                                                  CustomColors.textQuinaryColor,
                                              fontFamily: Config.heeboRegular,
                                              fontWeight: FontWeight.w400,
                                              fontSize: Dimens.space16.sp,
                                              fontStyle: FontStyle.normal,
                                            ),
                                        prefixIcon: Icon(
                                          CustomIcon.icon_search,
                                          size: Dimens.space14,
                                          color: CustomColors.iconColor,
                                        )),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    color: CustomColors.white,
                                    alignment: Alignment.topCenter,
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
                                    child: macrosProvider
                                            .macros!.data!.isNotEmpty
                                        ? ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                height: Dimens.space1,
                                                thickness: Dimens.space1,
                                                color: CustomColors
                                                    .mainDividerColor,
                                              );
                                            },
                                            itemCount: macrosProvider
                                                .macros!.data!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              animationController!.forward();
                                              return MacrosListTile(
                                                value: macrosProvider
                                                    .macros!.data![index],
                                                onItemTap: (value) {
                                                  widget.onItemTap!(value);
                                                },
                                              );
                                            },
                                            physics:
                                                const BouncingScrollPhysics(),
                                          )
                                        : (isEditing
                                            ? Container(
                                                alignment: Alignment.topLeft,
                                                margin: EdgeInsets.fromLTRB(
                                                  Dimens.space20.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                ),
                                                child: Text(
                                                  "Search results not found",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        color: CustomColors
                                                            .textPrimaryLightColor,
                                                        fontFamily:
                                                            Config.heeboRegular,
                                                        fontSize:
                                                            Dimens.space16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                ),
                                              )
                                            : AnimatedBuilder(
                                                animation: animationController!,
                                                builder: (BuildContext context,
                                                    Widget? child) {
                                                  return FadeTransition(
                                                    opacity: Tween<double>(
                                                            begin: 0.0,
                                                            end: 1.0)
                                                        .animate(CurvedAnimation(
                                                            parent:
                                                                animationController!,
                                                            curve: const Interval(
                                                                0.5 * 1, 1.0,
                                                                curve: Curves
                                                                    .fastOutSlowIn))),
                                                    child: Transform(
                                                      transform: Matrix4.translationValues(
                                                          0.0,
                                                          100 *
                                                              (1.0 -
                                                                  Tween<double>(
                                                                          begin:
                                                                              0.0,
                                                                          end:
                                                                              1.0)
                                                                      .animate(CurvedAnimation(
                                                                          parent:
                                                                              animationController!,
                                                                          curve: const Interval(
                                                                              0.5 * 1,
                                                                              1.0,
                                                                              curve: Curves.fastOutSlowIn)))
                                                                      .value),
                                                          0.0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens.space0.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space0.h),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Center(
                                                            child:
                                                                AnimatedBuilder(
                                                              animation:
                                                                  animationController!,
                                                              builder: (BuildContext
                                                                      context,
                                                                  Widget?
                                                                      child) {
                                                                return FadeTransition(
                                                                  opacity:
                                                                      animation,
                                                                  child:
                                                                      Transform(
                                                                    transform: Matrix4
                                                                        .translationValues(
                                                                            0.0,
                                                                            100 *
                                                                                (1.0 - animation.value),
                                                                            0.0),
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .white,
                                                                      margin: EdgeInsets
                                                                          .zero,
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      child:
                                                                          EmptyViewUiWidget(
                                                                        assetUrl:
                                                                            "assets/images/empty_macros.png",
                                                                        title: Utils.getString(
                                                                            "noMacros"),
                                                                        desc: Utils.getString(
                                                                            "macrosDetails"),
                                                                        showButton:
                                                                            false,
                                                                        onPressed:
                                                                            () async {},
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ))),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const ContactSearchShimmer(),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      height: Dimens.space1,
                                      thickness: Dimens.space1,
                                      color: CustomColors.mainDividerColor,
                                    );
                                  },
                                  itemCount: 15,
                                  itemBuilder: (context, index) {
                                    return const MacrosTileShimmer();
                                  },
                                ),
                              ),
                            ],
                          ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MacrosListTile extends StatelessWidget {
  const MacrosListTile({Key? key, this.value, this.onItemTap})
      : super(key: key);

  final Function(Macro)? onItemTap;
  final Macro? value;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onItemTap!(value!);
        },
        style: TextButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: CustomColors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.fromLTRB(
              Dimens.space0.w, Dimens.space0, Dimens.space0, Dimens.space0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.space0.r),
          ),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h,
              Dimens.space0.w, Dimens.space16.h),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h,
                    Dimens.space16.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  value!.title!,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: CustomColors.textPrimaryColor,
                        fontFamily: Config.manropeRegular,
                        fontSize: Dimens.space16.sp,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space8.h,
                    Dimens.space16.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Text(
                  value!.message!,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: CustomColors.textTertiaryColor,
                        fontFamily: Config.heeboRegular,
                        fontSize: Dimens.space14.sp,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
            ],
          ),
        ));
  }
}
