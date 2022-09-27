import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/config/CustomColors.dart";
import "package:mvp/constant/Dimens.dart";
import "package:mvp/ui/common/CustomImageHolder.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";

class WorkspaceListItemView extends StatelessWidget {
  const WorkspaceListItemView({
    Key? key,
    required this.workspace,
    required this.animationController,
    required this.animation,
    required this.index,
    required this.count,
    required this.defaultWorkspace,
    required this.onWorkspaceTap,
  }) : super(key: key);

  final LoginWorkspace workspace;
  final AnimationController animationController;
  final Animation<double> animation;
  final int index;
  final int count;
  final String defaultWorkspace;
  final Function onWorkspaceTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext? context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space14.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RoundedNetworkImageTextHolder(
                    width: Dimens.space46,
                    height: Dimens.space46,
                    text: workspace.title!.isEmpty ? "" : workspace.title![0],
                    textColor: workspace.status == "Active"
                        ? CustomColors.mainColor!
                        : Colors.white,
                    fontFamily: Config.heeboExtraBold,
                    fontSize: Dimens.space24,
                    iconSize: Dimens.space30,
                    boxDecorationColor: workspace.status == "Active"
                        ? CustomColors.white!
                        : CustomColors.grey!,
                    corner: Dimens.space15,
                    imageUrl: workspace.status == "Active"
                        ? workspace.photo ?? ""
                        : "",
                    onTap: () {
                      onWorkspaceTap();
                    },
                  ),
                  if (workspace.id == defaultWorkspace)
                    Stack(
                      children: [
                        Container(
                          width: Dimens.space48.w,
                          height: Dimens.space48.w,
                          decoration: BoxDecoration(
                            color: CustomColors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space15.r),
                            ),
                            border: Border.all(
                              color: CustomColors.mainColor!,
                              width: Dimens.space3.r,
                            ),
                          ),
                        ),
                        Container(
                          width: Dimens.space48.w,
                          height: Dimens.space48.w,
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          decoration: BoxDecoration(
                            color: CustomColors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space15.r),
                            ),
                            border: Border.all(
                              color: CustomColors.bottomAppBarColor!,
                              width: Dimens.space2,
                            ),
                          ),
                        )
                      ],
                    )
                  else
                    Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
