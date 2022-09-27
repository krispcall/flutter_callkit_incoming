import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/utils/Utils.dart";

class Toast {
  static void show(String msg, BuildContext context, {Function? onTap}) {
    dismiss();
    Toast._createView(msg, context, onTap!);
    Future.delayed(const Duration(seconds: 3), () {
      Toast.dismiss();
    });
  }

  static OverlayEntry? _overlayEntry;
  static bool isVisible = false;

  static Future<void> _createView(
    String msg,
    BuildContext context,
    Function onTap,
  ) async {
    final overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _ToastAnimatedWidget(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  CustomColors.d_text_senary_color_sec,
                  CustomColors.d_text_senary_color_sec,
                  CustomColors.textSenaryColor!,
                  CustomColors.textSenaryColor!
                ],
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: 180 * math.pi / 180,
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.white,
                                      fontFamily: Config.manropeSemiBold,
                                      fontSize: Dimens.space15.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                            text: Config.checkOverFlow ? Const.OVERFLOW : msg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: Dimens.space80.sp,
                  child: GestureDetector(
                    onTap: () {
                      dismiss();
                      onTap();
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        Config.checkOverFlow
                            ? Const.OVERFLOW
                            : Utils.getString("unblock"),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: CustomColors.loadingCircleColor,
                              fontFamily: Config.manropeSemiBold,
                              fontSize: Dimens.space15.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    isVisible = true;
    overlayState!.insert(_overlayEntry!);
  }

  static void dismiss() {
    if (!isVisible) {
      return;
    }
    isVisible = false;
    _overlayEntry?.remove();
  }
}

class _ToastAnimatedWidget extends StatefulWidget {
  const _ToastAnimatedWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastAnimatedWidget>
    with SingleTickerProviderStateMixin {
  bool get _isVisible => true; //update this value later

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        left: 14,
        right: 14,
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _isVisible ? 1.0 : 0.0,
          child: widget.child,
        ));
  }
}
