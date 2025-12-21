import 'package:flutter/material.dart';

class NbpBottomHorizontalDots extends StatelessWidget {
  const NbpBottomHorizontalDots({
    super.key,
    this.radius,
    this.color,
    this.dotsCount,
  });
  final double? radius;
  final Color? color;
  final int? dotsCount;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        spacing: 32,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(dotsCount ?? 3, (index) {
          return Container(
            width: radius ?? 4.0,
            height: radius ?? 4.0,
            decoration: BoxDecoration(
              color: color ?? Colors.black, // You can choose a suitable color
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
