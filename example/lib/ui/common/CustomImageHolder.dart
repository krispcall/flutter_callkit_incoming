import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/custom_icon/CustomIcon.dart";

class RoundedNetworkImageHolder extends StatelessWidget {
  const RoundedNetworkImageHolder({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onTap,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
    this.containerAlignment = Alignment.center,
  }) : super(key: key);

  final String? imageUrl;
  final double width;
  final double height;
  final double iconSize;
  final Function? onTap;
  final BoxFit boxFit;
  final IconData? iconUrl;
  final Color? iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color? boxDecorationColor;
  final Alignment? containerAlignment;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl == "") {
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(
              Radius.circular(outerCorner.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            child: Container(
              width: width.w,
              height: height.w,
              alignment: containerAlignment,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              decoration: BoxDecoration(
                color: boxDecorationColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(outerCorner.r),
                ),
              ),
              child: Icon(
                iconUrl,
                size: iconSize.w,
                color: iconColor,
              ),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner.r))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            child: CachedNetworkImage(
              placeholder: (BuildContext context, String url) {
                return Container(
                  width: width.w,
                  height: height.w,
                  alignment: containerAlignment,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    color: boxDecorationColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(outerCorner.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(innerCorner.r),
                    child: Container(
                      width: width.w,
                      height: height.w,
                      alignment: containerAlignment,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      decoration: BoxDecoration(
                        color: boxDecorationColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(outerCorner.r),
                        ),
                      ),
                      child: Icon(
                        iconUrl,
                        size: iconSize.w,
                        color: iconColor,
                      ),
                    ),
                  ),
                );
              },
              fit: boxFit,
              imageUrl: imageUrl!.trim(),
              height: height.w,
              width: width.w,
              memCacheHeight: 500,
              errorWidget: (BuildContext context, String? url, Object? error) =>
                  Container(
                width: width.w,
                height: height.w,
                alignment: containerAlignment,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                decoration: BoxDecoration(
                  color: boxDecorationColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(outerCorner.r),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(innerCorner.r),
                  child: Container(
                    width: width.w,
                    height: height.w,
                    alignment: containerAlignment,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    decoration: BoxDecoration(
                      color: boxDecorationColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(outerCorner.r),
                      ),
                    ),
                    child: Icon(
                      iconUrl,
                      size: iconSize.w,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class AppBarNetworkImageHolder extends StatelessWidget {
  const AppBarNetworkImageHolder({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onTap,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
    this.containerAlignment = Alignment.center,
  }) : super(key: key);

  final String? imageUrl;
  final double width;
  final double height;
  final double iconSize;
  final Function? onTap;
  final BoxFit boxFit;
  final IconData? iconUrl;
  final Color? iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color? boxDecorationColor;
  final Alignment? containerAlignment;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl == "") {
      return InkWell(
        onTap: () {
          onTap ?? onTap!();
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: Center(
            child: SizedBox(
              width: iconSize.w,
              height: iconSize.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerCorner.r),
                child: Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onTap ?? onTap!();
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner.r))),
          child: Center(
            child: SizedBox(
              width: iconSize.w,
              height: iconSize.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerCorner.r),
                child: CachedNetworkImage(
                  placeholder: (BuildContext context, String url) {
                    return Icon(
                      iconUrl,
                      size: iconSize.w,
                      color: iconColor,
                    );
                  },
                  fit: boxFit,
                  imageUrl: imageUrl!.trim(),
                  height: height.w,
                  width: width.w,
                  memCacheHeight: 500,
                  errorWidget:
                      (BuildContext context, String? url, Object? error) => Icon(
                    iconUrl,
                    size: iconSize.w,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RoundedAssetImageHolder extends StatelessWidget {
  const RoundedAssetImageHolder({
    Key? key,
    required this.assetUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onTap,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
    this.containerAlignment = Alignment.center,
    this.applyFactor = false,
  }) : super(key: key);

  final String? assetUrl;
  final double? width;
  final double? height;
  final double? iconSize;
  final Function? onTap;
  final BoxFit? boxFit;
  final IconData? iconUrl;
  final Color? iconColor;
  final double? outerCorner;
  final double? innerCorner;
  final Color? boxDecorationColor;
  final Alignment? containerAlignment;
  final bool? applyFactor;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == null || assetUrl == "") {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width!.w,
          height: height!.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: Icon(
              iconUrl,
              size: iconSize!.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width!.w,
          height: height!.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: Image.asset(
              assetUrl!,
              width: applyFactor! ? width!.w * 0.6 : width!.w,
              height: applyFactor! ? height!.w * 0.6 : height!.w,
              fit: boxFit,
            ),
          ),
        ),
      );
    }
  }
}

class RoundedNetworkSvgHolder extends StatelessWidget {
  const RoundedNetworkSvgHolder({
    Key? key,
    required this.imageUrl,
    required this.containerWidth,
    required this.containerHeight,
    required this.imageWidth,
    required this.imageHeight,
    required this.iconUrl,
    required this.iconSize,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onTap,
    this.iconColor = Colors.white,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = Colors.white,
  }) : super(key: key);

  final String imageUrl;
  final double containerWidth;
  final double containerHeight;
  final double imageWidth;
  final double imageHeight;
  final double iconSize;
  final Function? onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color boxDecorationColor;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == "") {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: Container(
            alignment: Alignment.center,
            width: imageWidth.w,
            height: imageHeight.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerCorner.r),
              child: SvgPicture.network(
                imageUrl,
                fit: boxFit,
                clipBehavior: Clip.antiAlias,
                placeholderBuilder: (BuildContext context) => Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RoundedAssetSvgHolder extends StatelessWidget {
  const RoundedAssetSvgHolder({
    Key? key,
    required this.assetUrl,
    required this.containerWidth,
    required this.containerHeight,
    required this.imageWidth,
    required this.imageHeight,
    required this.iconUrl,
    required this.iconSize,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onTap,
    this.iconColor = Colors.white,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = Colors.white,
  }) : super(key: key);

  final String assetUrl;
  final double containerWidth;
  final double containerHeight;
  final double imageWidth;
  final double imageHeight;
  final double iconSize;
  final Function? onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color boxDecorationColor;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == "") {
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: Container(
            alignment: Alignment.center,
            width: imageWidth.w,
            height: imageHeight.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerCorner.r),
              child: SvgPicture.asset(
                assetUrl,
                fit: boxFit,
                clipBehavior: Clip.antiAlias,
                cacheColorFilter: true,
                placeholderBuilder: (BuildContext context) => Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class PlainAssetImageHolder extends StatelessWidget {
  const PlainAssetImageHolder({
    Key? key,
    required this.assetUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    required this.assetWidth,
    required this.assetHeight,
    this.containerAlignment = Alignment.center,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onTap,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final Alignment? containerAlignment;
  final String? assetUrl;
  final double? width;
  final double? height;
  final double? assetWidth;
  final double? assetHeight;
  final double? iconSize;
  final Function? onTap;
  final BoxFit? boxFit;
  final IconData? iconUrl;
  final Color? iconColor;
  final double? outerCorner;
  final double? innerCorner;
  final Color? boxDecorationColor;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == null || assetUrl == "") {
      return GestureDetector(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width!.w,
          height: height!.h,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: Icon(
              iconUrl,
              size: iconSize!.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width!.w,
          height: height!.h,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: Image.asset(
              assetUrl!,
              fit: boxFit,
              width: assetWidth!.w,
              height: assetHeight!.h,
              cacheHeight: 2048,
            ),
          ),
        ),
      );
    }
  }
}

class PlainAssetSvgImageHolder extends StatelessWidget {
  const PlainAssetSvgImageHolder({
    Key? key,
    required this.assetUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    required this.assetWidth,
    required this.assetHeight,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onTap,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final String assetUrl;
  final double width;
  final double height;
  final double assetWidth;
  final double assetHeight;
  final double iconSize;
  final Function? onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color boxDecorationColor;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == "") {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width.w,
          height: height.h,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width.w,
          height: height.h,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            child: SvgPicture.asset(
              assetUrl,
              fit: boxFit,
              width: assetWidth.w,
              height: assetHeight.h,
            ),
          ),
        ),
      );
    }
  }
}

class PlainFileImageHolder extends StatelessWidget {
  const PlainFileImageHolder(
      {Key? key,
      required this.width,
      required this.height,
      required this.fileUrl,
      required this.iconUrl,
      required this.iconSize,
      this.iconColor = const Color(0xFF613494),
      this.boxDecorationColor = const Color(0xFFF3F2F4),
      this.containerAlignment = Alignment.center,
      this.corner = Dimens.space16,
      this.onTap,
      this.boxFit = BoxFit.cover,
      this.outerCorner,
      this.innerCorner})
      : super(key: key);

  final double width;
  final double height;
  final BoxFit boxFit;
  final String fileUrl;
  final IconData iconUrl;
  final double iconSize;
  final Color iconColor;
  final Function? onTap;
  final double corner;
  final double? outerCorner;
  final double? innerCorner;
  final Color boxDecorationColor;
  final Alignment containerAlignment;

  @override
  Widget build(BuildContext context) {
    if (fileUrl == "") {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: Container(
              width: width.w,
              height: height.w,
              alignment: containerAlignment,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              decoration: BoxDecoration(
                color: boxDecorationColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(outerCorner!.r),
                ),
              ),
              child: Icon(
                iconUrl,
                size: iconSize.w,
                color: iconColor,
              ),
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner),
              child: Image.file(
                File(fileUrl),
                width: width,
                height: height,
                fit: boxFit,
                cacheWidth: 500,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class PlainFileImageHolderSVG extends StatelessWidget {
  const PlainFileImageHolderSVG(
      {Key? key,
      required this.width,
      required this.height,
      required this.fileUrl,
      required this.iconUrl,
      required this.iconSize,
      this.iconColor = const Color(0xFF613494),
      this.boxDecorationColor = const Color(0xFFF3F2F4),
      this.containerAlignment = Alignment.center,
      this.corner = Dimens.space16,
      this.onTap,
      this.boxFit = BoxFit.cover,
      this.outerCorner,
      this.innerCorner})
      : super(key: key);

  final double width;
  final double height;
  final BoxFit boxFit;
  final String fileUrl;
  final String iconUrl;
  final double iconSize;
  final Color iconColor;
  final Function? onTap;
  final double corner;
  final double? outerCorner;
  final double? innerCorner;
  final Color boxDecorationColor;
  final Alignment containerAlignment;

  @override
  Widget build(BuildContext context) {
    if (fileUrl == "") {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: SvgPicture.asset(
              iconUrl,
              fit: BoxFit.cover,
              clipBehavior: Clip.antiAlias,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner!.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner),
              child: Image.file(
                File(fileUrl),
                width: width,
                height: height,
                fit: boxFit,
                cacheWidth: 500,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class TextHolder extends StatelessWidget {
  const TextHolder({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.containerColor,
    required this.textColor,
    required this.fontSize,
    this.borderWidth = Dimens.space0,
    this.borderColor = Colors.transparent,
    this.fontFamily = Config.heeboRegular,
    this.fontWeight = FontWeight.normal,
    this.corner = Dimens.space16,
  }) : super(key: key);

  final double width;
  final double height;
  final String text;
  final double fontSize;
  final double borderWidth;
  final Color containerColor;
  final Color borderColor;
  final Color textColor;
  final String fontFamily;
  final FontWeight fontWeight;
  final double corner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.w,
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.all(
            Radius.circular(corner.r),
          ),
          border: Border.all(
            width: borderWidth.w,
            color: borderColor,
          )),
      child: Text(
        Config.checkOverFlow ? Const.OVERFLOW : text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: textColor,
              fontFamily: fontFamily,
              fontSize: fontSize.sp,
              fontWeight: fontWeight,
              fontStyle: FontStyle.normal,
            ),
      ),
    );
  }
}

class RoundedNetworkImageTextHolder extends StatelessWidget {
  const RoundedNetworkImageTextHolder({
    Key? key,
    required this.imageUrl,
    required this.text,
    required this.textColor,
    required this.width,
    required this.height,
    this.fontFamily = Config.heeboRegular,
    this.fontWeight = FontWeight.normal,
    this.fontSize = Dimens.space14,
    this.iconColor = Colors.white,
    this.iconSize = Dimens.space20,
    this.iconUrl = CustomIcon.icon_plus,
    this.corner = Dimens.space16,
    this.onTap,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final String imageUrl;
  final String text;
  final Color textColor;
  final String fontFamily;
  final FontWeight fontWeight;
  final double fontSize;
  final double width;
  final double height;
  final Function? onTap;
  final BoxFit boxFit;
  final double corner;
  final Color boxDecorationColor;
  final IconData iconUrl;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == "") {
      if (text == "") {
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Container(
            width: width.w,
            height: height.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(corner.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner.r),
              child: Icon(
                iconUrl,
                size: iconSize.r,
                color: iconColor,
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Container(
            width: width.w,
            height: height.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(corner.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner.r),
              child: Text(
                Config.checkOverFlow
                    ? Const.OVERFLOW
                    : Config.checkOverFlow
                        ? Const.OVERFLOW
                        : text.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: textColor,
                    fontFamily: fontFamily,
                    fontSize: fontSize.sp,
                    fontWeight: fontWeight),
              ),
            ),
          ),
        );
      }
    } else {
      return GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: CustomColors.bottomAppBarColor,
            borderRadius: BorderRadius.all(Radius.circular(corner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(corner.r),
            child: CachedNetworkImage(
              placeholder: (BuildContext context, String url) {
                return Center(
                  child: Text(
                    Config.checkOverFlow ? Const.OVERFLOW : text.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: textColor,
                        fontFamily: fontFamily,
                        fontSize: fontSize.sp,
                        fontWeight: fontWeight),
                  ),
                );
              },
              fit: boxFit,
              imageUrl: imageUrl,
              memCacheHeight: 500,
              height: height.w,
              width: width.w,
              errorWidget: (BuildContext context, String url, Object? error) =>
                  Center(
                child: Text(
                  Config.checkOverFlow ? Const.OVERFLOW : text.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: textColor,
                        fontFamily: fontFamily,
                        fontSize: fontSize.sp,
                        fontWeight: fontWeight,
                      ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RoundedAssetImageTextHolder extends StatelessWidget {
  const RoundedAssetImageTextHolder({
    Key? key,
    required this.imageUrl,
    required this.text,
    required this.textColor,
    required this.width,
    required this.height,
    this.fontFamily = Config.heeboRegular,
    this.fontWeight = FontWeight.normal,
    this.fontSize = Dimens.space14,
    this.iconColor = Colors.white,
    this.iconSize = Dimens.space20,
    this.iconUrl = CustomIcon.icon_plus,
    this.corner = Dimens.space16,
    this.onTap,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final String imageUrl;
  final String text;
  final Color textColor;
  final String fontFamily;
  final FontWeight fontWeight;
  final double fontSize;
  final double width;
  final double height;
  final Function? onTap;
  final BoxFit boxFit;
  final double corner;
  final Color boxDecorationColor;
  final IconData iconUrl;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == "") {
      if (text == "") {
        return InkWell(
          onTap: () {
            onTap!();
          },
          child: Container(
            width: width.w,
            height: height.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(corner.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner.r),
              child: Icon(
                iconUrl,
                size: iconSize.r,
                color: iconColor,
              ),
            ),
          ),
        );
      } else {
        return InkWell(
          onTap: () {
            onTap!();
          },
          child: Container(
            width: width.w,
            height: height.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(corner.r)),
            ),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Config.checkOverFlow
                      ? Const.OVERFLOW
                      : text.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: textColor,
                  fontFamily: fontFamily,
                  fontSize: fontSize.sp,
                  fontWeight: fontWeight),
            ),
          ),
        );
      }
    } else {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: CustomColors.bottomAppBarColor,
            borderRadius: BorderRadius.all(Radius.circular(corner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(corner.r),
            child: Image.asset(
              imageUrl,
              fit: boxFit,
              width: width.w,
              height: height.w,
              cacheHeight: 2048,
            ),
          ),
        ),
      );
    }
  }
}

class RoundedAssetSVGTextHolder extends StatelessWidget {
  const RoundedAssetSVGTextHolder({
    Key? key,
    required this.text,
    required this.textColor,
    required this.containerWidth,
    required this.containerHeight,
    required this.imageWidth,
    required this.imageHeight,
    required this.assetUrl,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.fontFamily = Config.heeboRegular,
    this.fontWeight = FontWeight.normal,
    this.fontSize = Dimens.space14,
    this.iconColor = Colors.white,
    this.iconSize = Dimens.space20,
    this.iconUrl = CustomIcon.icon_plus,
    this.corner = Dimens.space16,
    this.onTap,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final String text;
  final Color textColor;
  final String fontFamily;
  final FontWeight fontWeight;
  final double fontSize;
  final Function? onTap;
  final BoxFit boxFit;
  final double corner;
  final Color boxDecorationColor;
  final IconData iconUrl;
  final Color iconColor;
  final double iconSize;
  final double containerWidth;
  final double containerHeight;
  final double imageWidth;
  final double imageHeight;
  final double outerCorner;
  final double innerCorner;
  final String assetUrl;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == "") {
      if (text == "") {
        return InkWell(
          onTap: () {
            onTap!();
          },
          child: Container(
            width: containerWidth.w,
            height: containerHeight.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(corner.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner.r),
              child: Icon(
                iconUrl,
                size: iconSize.r,
                color: iconColor,
              ),
            ),
          ),
        );
      } else {
        return InkWell(
          onTap: () {
            onTap!();
          },
          child: Container(
            width: containerWidth.w,
            height: containerHeight.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              borderRadius: BorderRadius.all(Radius.circular(corner.r)),
            ),
            child: Text(
              Config.checkOverFlow
                  ? Const.OVERFLOW
                  : Config.checkOverFlow
                      ? Const.OVERFLOW
                      : text.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: textColor,
                  fontFamily: fontFamily,
                  fontSize: fontSize.sp,
                  fontWeight: fontWeight),
            ),
          ),
        );
      }
    } else {
      return InkWell(
        onTap: () {
          onTap!();
        },
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: Container(
            alignment: Alignment.center,
            width: imageWidth.w,
            height: imageHeight.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerCorner.r),
              child: SvgPicture.asset(
                assetUrl,
                fit: boxFit,
                clipBehavior: Clip.antiAlias,
                cacheColorFilter: true,
                placeholderBuilder: (BuildContext context) => Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.isChecked,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    required this.assetWidth,
    required this.assetHeight,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.onCheckBoxTap,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.selectedColor = const Color(0xFFF3F2F4),
    this.unSelectedColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final bool? isChecked;
  final double? width;
  final double? height;
  final double? assetWidth;
  final double? assetHeight;
  final double? iconSize;
  final Function(bool)? onCheckBoxTap;
  final BoxFit? boxFit;
  final IconData? iconUrl;
  final Color? iconColor;
  final double? outerCorner;
  final double? innerCorner;
  final Color? selectedColor;
  final Color? unSelectedColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCheckBoxTap!(isChecked!);
      },
      child: Container(
        width: width!.w,
        height: height!.w,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        decoration: BoxDecoration(
            color: isChecked! ? selectedColor : CustomColors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner!.r)),
            border: Border.all(
              color: isChecked! ? selectedColor! : unSelectedColor!,
              width: Dimens.space2.w,
            )),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerCorner!.r),
          child: Icon(
            iconUrl,
            size: iconSize!.w,
            color: isChecked! ? iconColor : CustomColors.transparent,
          ),
        ),
      ),
    );
  }
}
