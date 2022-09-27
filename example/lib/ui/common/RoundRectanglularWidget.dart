import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/constant/Dimens.dart";

class RoundRectangularWidget extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color? color;
  final Function? onTap;

  const RoundRectangularWidget(
      {Key? key, required this.child, required this.height,  required this.width, required this.color, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: width!.w,
      height: height!.h,
      margin: EdgeInsets.symmetric(horizontal: Dimens.space6.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space10.w),
          topRight: Radius.circular(Dimens.space10.w),
          bottomLeft: Radius.circular(Dimens.space10.w),
          bottomRight: Radius.circular(Dimens.space10.w),
        ),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.w)),
        child: InkWell(
          onTap: () {
            onTap!();
          },
          child: child,
        ),
      ),
    );
  }
}
