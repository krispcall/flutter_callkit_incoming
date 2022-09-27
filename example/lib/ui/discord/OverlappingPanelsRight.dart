import "dart:core";

import "package:flutter/material.dart";

const double bleedWidth = 20;

/// Display sections
enum RevealSide { right, main }

/// Widget to display three view panels with the [OverlappingPanels.main] being
/// in the center, [OverlappingPanels.left] and [OverlappingPanels.right] also
/// revealing from their respective sides. Just like you will see in the
/// Discord mobile app's navigation.
class OverlappingPanelsRight extends StatefulWidget {
  /// The main panel
  final Widget main;

  /// The right panel
  final Widget right;

  /// The offset to use to keep the main panel visible when the left or right
  /// panel is revealed.
  final double restWidth;

  /// A callback to notify when a panel reveal has completed.
  final ValueChanged<RevealSide>? onSideChange;

  const OverlappingPanelsRight({
    required this.main,
    required this.right,
    this.restWidth = 20,
    this.onSideChange,
    Key? key,
  }) : super(key: key);

  static OverlappingPanelsRightState? of(BuildContext context) {
    return context.findAncestorStateOfType<OverlappingPanelsRightState>();
  }

  @override
  State<StatefulWidget> createState() {
    return OverlappingPanelsRightState();
  }
}

class OverlappingPanelsRightState extends State<OverlappingPanelsRight>
    with TickerProviderStateMixin {
  late AnimationController controller;
  double translate = 0;

  double _calculateGoal(double width, int multiplier) {
    if ((multiplier * width) + (-multiplier * widget.restWidth) > 0) {
      return 0.0;
    } else {
      return (multiplier * width) + (-multiplier * widget.restWidth);
    }
  }

  void _onApplyTranslation() {
    final mediaWidth = MediaQuery.of(context).size.width;

    final animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.onSideChange != null) {
          widget.onSideChange!(
            translate == 0 ? RevealSide.main : RevealSide.right,
          );
        }
        animationController.dispose();
      }
    });

    if (translate.abs() >= mediaWidth / 2) {
      final multiplier = translate > 0 ? 1 : -1;
      final goal = _calculateGoal(mediaWidth, multiplier);
      final Tween<double> tween = Tween(begin: translate, end: goal);

      final animation = tween.animate(animationController);

      animation.addListener(() {
        setState(() {
          translate = animation.value;
        });
      });
    } else {
      final animation =
          Tween<double>(begin: translate, end: 0).animate(animationController);

      animation.addListener(() {
        setState(() {
          translate = animation.value;
        });
      });
    }

    animationController.forward();
  }

  void reveal(RevealSide direction) {
    // can only reveal when showing main
    // if (translate != 0) {
    //   return;
    // }

    final mediaWidth = MediaQuery.of(context).size.width;

    final multiplier = direction == RevealSide.main ? 1 : -1;
    final goal = _calculateGoal(mediaWidth, multiplier);

    final animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onApplyTranslation();
        animationController.dispose();
      }
    });

    final animation =
        Tween<double>(begin: translate, end: goal).animate(animationController);

    animation.addListener(() {
      setState(() {
        translate = animation.value;
      });
    });

    animationController.forward();
  }

  void onTranslate(double delta) {
    setState(() {
      translate += delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: translate > 0,
          child: widget.right,
        ),
        Transform.translate(
          offset: Offset(translate, 0),
          child: widget.main,
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (details) {
            if (translate == 0) {
              if (details.delta.dx < 0) {
                onTranslate(details.delta.dx);
              }
            } else {
              onTranslate(details.delta.dx);
            }
          },
          onHorizontalDragEnd: (details) {
            if (translate > 0) {
              _onApplyTranslation();
              translate = 0;
            } else {
              _onApplyTranslation();
              translate = 1;
            }
            setState(() {});
          },
        ),
      ],
    );
  }
}
