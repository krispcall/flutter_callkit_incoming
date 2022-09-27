import "dart:math" show pi;
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class ZoomDrawerController {
  /// callback function to open the drawer
  Function? open;

  /// callback function to close the drawer
  Function? close;

  /// callback function to toggle the drawer
  Function? toggle;

  /// callback function to determine the status of the drawer
  Function? isOpen;

  /// Drawer state notifier
  /// opening, closing, open, closed
  ValueNotifier<DrawerState>? stateNotifier;
}

class ZoomDrawer extends StatefulWidget {
  const ZoomDrawer({
    this.style = DrawerStyle.Style1,
    this.controller,
    required this.menuScreen,
    required this.mainScreen,
    this.mainScreenScale = 0.3,
    this.slideWidth = 275.0,
    this.borderRadius = 16.0,
    this.angle = -12.0,
    this.backgroundColor = const Color(0xffffffff),
    this.shadowLayer1Color,
    this.shadowLayer2Color,
    this.showShadow = false,
    this.openCurve,
    this.closeCurve,
    this.duration,
    this.disableGesture = false,
    this.isRtl = false,
    this.clipMainScreen = true,
    this.swipeOffset = 6.0,
    this.overlayColor,
    this.overlayBlend,
    this.overlayBlur,
    this.mainScreenTapClose = false,
    this.boxShadow,
    this.shrinkMainScreen = false,
    this.drawerStyleBuilder,
  }) : assert(angle <= 0.0 && angle >= -30.0);

  /// Layout style
  final DrawerStyle style;

  /// controller to have access to the open/close/toggle function of the drawer
  final ZoomDrawerController? controller;

  /// Screen containing the menu/bottom screen
  final Widget menuScreen;

  /// Screen containing the main content to display
  final Widget mainScreen;

  /// MainScreen scale factor
  final double mainScreenScale;

  /// Sliding width of the drawer - defaults to 275.0
  final double slideWidth;

  /// Border radius of the slided content - defaults to 16.0
  final double borderRadius;

  /// Rotation angle of the drawer - defaults to -12.0
  final double angle;

  /// Background color of the drawer shadows - defaults to white
  final Color backgroundColor;

  /// First shadow background color
  final Color? shadowLayer1Color;

  /// Second shadow background color
  final Color? shadowLayer2Color;

  /// Depreciated: Set [boxShadow] to show shadow on [mainScreen]
  /// Boolean, whether to show the drawer shadows - Applies to Style1
  final bool showShadow;

  /// Drawer slide out curve
  final Curve? openCurve;

  /// Drawer slide in curve
  final Curve? closeCurve;

  /// Drawer Duration
  final Duration? duration;

  /// Disable swipe gesture
  final bool disableGesture;

  /// display the drawer in RTL
  final bool isRtl;

  /// Depreciated: Set [borderRadius] to 0 instead
  final bool clipMainScreen;

  /// The swipe offset to trigger drawer close
  final double swipeOffset;

  /// Color of the main screen's cover overlay
  final Color? overlayColor;

  /// The BlendMode of the [overlayColor] filter (default BlendMode.screen)
  final BlendMode? overlayBlend;

  /// Apply a Blur amount to the mainScreen
  final double? overlayBlur;

  /// The Shadow of the mainScreenContent
  final List<BoxShadow>? boxShadow;

  /// Close drawer when tapping mainScreen
  final bool mainScreenTapClose;

  /// Shrinks the mainScreen by [slideWidth], good for use on desktop with Style2
  final bool shrinkMainScreen;

  /// Build custom animated style to override [DrawerStyle]
  /// ```dart
  /// drawerStyleBuilder: (context, percentOpen, slideWidth, menuScreen, mainScreen) {
  ///     double slide = slideWidth * percentOpen;
  ///     return Stack(
  ///       children: [
  ///         menuScreen,
  ///         Transform(
  ///           transform: Matrix4.identity()..translate(slide),
  ///           alignment: Alignment.center,
  ///           child: mainScreen,
  ///         )]);
  ///   },
  /// ```
  final DrawerStyleBuilder? drawerStyleBuilder;

  @override
  _ZoomDrawerState createState() => _ZoomDrawerState();

  /// static function to provide the drawer state
  static _ZoomDrawerState of(BuildContext context) {
    return context.findAncestorStateOfType<State<ZoomDrawer>>()
        as _ZoomDrawerState;
  }
}

class _ZoomDrawerState extends State<ZoomDrawer>
    with SingleTickerProviderStateMixin {
  final Curve _scaleDownCurve = const Interval(0.0, 0.3, curve: Curves.easeOut);
  final Curve _scaleUpCurve = const Interval(0.0, 0.9, curve: Curves.easeOut);
  final Curve _slideOutCurve = const Interval(0.0, 0.9, curve: Curves.easeOut);
  final Curve _slideInCurve =
      const Interval(0.0, 0.9, curve: Curves.easeOut); // Curves.bounceOut
  ColorTween _overlayColor =
      ColorTween(begin: Colors.transparent, end: Colors.black38);

  /// check the slide direction
  late int _rtlSlide;

  late AnimationController _animationController;
  DrawerState _state = DrawerState.closed;

  double get _percentOpen => _animationController.value;

  /// Open drawer
  void open() {
    _animationController.forward();
  }

  /// Close drawer
  void close() {
    _animationController.reverse();
  }

  AnimationController get animationController => _animationController;

  /// Toggle drawer
  void toggle() {
    if (_state == DrawerState.open) {
      close();
    } else if (_state == DrawerState.closed) {
      open();
    }
  }

  /// check whether drawer is open
  bool isOpen() =>
      _state == DrawerState.open /* || _state == DrawerState.opening*/;

  /// Drawer state
  ValueNotifier<DrawerState>? stateNotifier;

  @override
  void initState() {
    super.initState();

    stateNotifier = ValueNotifier(_state);

    /// Initialize the animation controller
    /// add status listener to update the menuStatus
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration is Duration
          ? widget.duration
          : const Duration(milliseconds: 250),
    )..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = DrawerState.opening;
            _updateStatusNotifier();
            break;
          case AnimationStatus.reverse:
            _state = DrawerState.closing;
            _updateStatusNotifier();
            break;
          case AnimationStatus.completed:
            _state = DrawerState.open;
            _updateStatusNotifier();
            break;
          case AnimationStatus.dismissed:
            _state = DrawerState.closed;
            _updateStatusNotifier();
            break;
        }
      });

    /// assign controller function to the widget methods
    if (widget.controller != null) {
      widget.controller!.open = open;
      widget.controller!.close = close;
      widget.controller!.toggle = toggle;
      widget.controller!.isOpen = isOpen;
      widget.controller!.stateNotifier = stateNotifier;
    }
    _rtlSlide = widget.isRtl ? -1 : 1;
  }

  @override
  void didUpdateWidget(covariant ZoomDrawer oldWidget) {
    if (oldWidget.isRtl != widget.isRtl) {
      _rtlSlide = widget.isRtl ? -1 : 1;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateStatusNotifier() {
    stateNotifier!.value = _state;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Build the widget based on the animation value
  ///
  /// * [container] is the widget to be displayed
  ///
  /// * [angle] is the the Z rotation angle
  ///
  /// * [scale] is a string to help identify this animation during
  ///   debugging (used by [toString]).
  ///
  /// * [slide] is the sliding amount of the drawer
  ///
  Widget _zoomAndSlideContent(
    Widget container, {
    double? scale,
    bool isMain = false,
  }) {
    double slidePercent;
    double scalePercent;

    /// determine current slide percent based on the MenuStatus
    switch (_state) {
      case DrawerState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case DrawerState.open:
        slidePercent = 0.9;
        scalePercent = 0.9;
        break;
      case DrawerState.opening:
        slidePercent =
            (widget.openCurve ?? _slideOutCurve).transform(_percentOpen);
        scalePercent = _scaleDownCurve.transform(_percentOpen);
        break;
      case DrawerState.closing:
        slidePercent =
            (widget.closeCurve ?? _slideInCurve).transform(_percentOpen);
        scalePercent = _scaleUpCurve.transform(_percentOpen);
        break;
    }

    /// calculated sliding amount based on the RTL and animation value
    final slideAmount = widget.slideWidth * slidePercent;

    /// calculated scale amount based on the provided scale and animation value
    final contentScale = (scale ?? 1.0) - (0.2 * scalePercent);

    /// calculated radius based on the provided radius and animation value
    final cornerRadius = widget.borderRadius * _percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: isMain
          ? container
          : ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius),
              child: container,
            ),
    );
  }

  /// Builds the layers of decorations on mainScreen
  Widget get mainScreenContent {
    // if (_percentOpen == 0) return widget.mainScreen;
    Widget mainScreenContent = widget.mainScreen;
    if (widget.shrinkMainScreen) {
      final mainSize = MediaQuery.of(context).size.width.w -
          (widget.slideWidth * _percentOpen);
      mainScreenContent = SizedBox(
        width: mainSize,
        child: mainScreenContent,
      );
    }
    if (widget.overlayColor != null) {
      _overlayColor = ColorTween(
        begin: widget.overlayColor!.withOpacity(0.0),
        end: widget.overlayColor,
      );
      mainScreenContent = ColorFiltered(
        colorFilter: ColorFilter.mode(
          _overlayColor.lerp(_percentOpen)!,
          widget.overlayBlend ?? BlendMode.screen,
        ),
        child: mainScreenContent,
      );
    }
    if (widget.mainScreenTapClose && _state == DrawerState.open) {
      mainScreenContent = GestureDetector(
        onTap: () => close(),
        child: AbsorbPointer(child: mainScreenContent),
      );
    }
    if (widget.borderRadius != 0) {
      final cornerRadius = widget.borderRadius * _percentOpen;
      mainScreenContent = ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: mainScreenContent,
      );
    }
    if (widget.boxShadow != null) {
      final cornerRadius = widget.borderRadius * _percentOpen;
      // Could use [hasShadow], but seems redundant
      mainScreenContent = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornerRadius),
          boxShadow: widget.boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                )
              ],
        ),
        child: mainScreenContent,
      );
    }
    if (widget.angle != 0 && widget.style != DrawerStyle.Style1) {
      final rotationAngle =
          (((widget.angle) * pi * _rtlSlide) / 180) * _percentOpen;
      mainScreenContent = Transform.rotate(
        angle: rotationAngle,
        alignment: widget.isRtl
            ? AlignmentDirectional.topEnd
            : AlignmentDirectional.topStart,
        child: mainScreenContent,
      );
    }
    if (widget.overlayBlur != null) {
      final blurAmount = widget.overlayBlur! * _percentOpen;
      mainScreenContent = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: mainScreenContent,
      );
    }
    return mainScreenContent;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disableGesture) return renderLayout();

    return GestureDetector(
      /// Detecting the slide amount to close the drawer in RTL & LTR
      onPanUpdate: (details) {
        if (_state == DrawerState.open &&
            ((details.delta.dx < -widget.swipeOffset && !widget.isRtl) ||
                (details.delta.dx > widget.swipeOffset && widget.isRtl))) {
          toggle();
        }
      },
      child: renderLayout(),
    );
  }

  Widget renderLayout() {
    if (widget.drawerStyleBuilder != null) return renderCustomStyle();
    switch (widget.style) {
      case DrawerStyle.Style1:
        return renderStyle1();
      default:
        return renderStyle1();
    }
  }

  Widget renderCustomStyle() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return widget.drawerStyleBuilder!(context, _percentOpen,
            widget.slideWidth, widget.menuScreen, mainScreenContent);
      },
    );
  }

  Widget renderStyle1() {
    return Stack(
      children: [
        widget.menuScreen,

        /// Displaying the main screen
        AnimatedBuilder(
          animation: _animationController,
          builder: (_, __) => _zoomAndSlideContent(
            mainScreenContent,
            isMain: true,
          ),
        ),
      ],
    );
  }
}

/// Drawer State enum
enum DrawerState { opening, closing, open, closed }

enum DrawerStyle {
  Style1,
}

/// Build custom style with (context, percentOpen, slideWidth, menuScreen, mainScreen) {}
typedef DrawerStyleBuilder = Widget Function(
  BuildContext context,
  double percentOpen,
  double slideWidth,
  Widget menuScreen,
  Widget mainScreen,
);
