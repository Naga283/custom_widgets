import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AnimatedOpacityToast extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color? textColor;
  final bool isShowRightIcon;
  final VoidCallback onDismissed;
  final Widget? child;

  const AnimatedOpacityToast(
    this.message,
    this.backgroundColor,
    this.textColor, {
    super.key,
    required this.isShowRightIcon,
    required this.onDismissed,
    this.child,
  });

  @override
  State<AnimatedOpacityToast> createState() => _AnimatedOpacityToastState();
}

class _AnimatedOpacityToastState extends State<AnimatedOpacityToast>
    with SingleTickerProviderStateMixin {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        opacity = 1.0;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          opacity = 0.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      onEnd: () {
        if (opacity == 0.0) {
          widget.onDismissed();
        }
      },
      child: widget.child ??
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                  ),
                ),
                // if (widget.isShowRightIcon)
                //   SvgPicturesImage(imageName: svgNewImages.successToastIcon)
              ],
            ),
          ),
    );
  }
}

void nbpCustomToast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
  Color backgroundColor = Colors.black87,
  Color textColor = Colors.white,
  double bottomOffset = 100,
  bool isShowRightIcon = true,
}) {
  final overlay = Overlay.of(context);
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: bottomOffset,
      left: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacityToast(
          message,
          backgroundColor,
          textColor,
          isShowRightIcon: isShowRightIcon,
          onDismissed: () {
            overlayEntry?.remove();
          },
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}

void showFailureToast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
  Color backgroundColor = const Color(0XFFB3261E),
  Color textColor = Colors.white,
  double bottomOffset = 100,
  bool isShowRightIcon = false,
}) {
  final overlay = Overlay.of(context);
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: bottomOffset,
      left: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacityToast(
          message,
          backgroundColor,
          textColor,
          isShowRightIcon: isShowRightIcon,
          onDismissed: () {
            overlayEntry?.remove();
          },
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
