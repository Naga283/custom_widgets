import 'package:flutter/material.dart';

class NbpDottedLines extends StatelessWidget {
  const NbpDottedLines({
    super.key,
    this.axis = Axis.horizontal,
    this.dashColor = Colors.grey,
    this.dashWidth = 4,
    this.dashHeight = 1,
    this.gap = 4,
    this.totalLength,
  });

  final Axis axis;
  final Color dashColor;
  final double dashWidth;
  final double dashHeight;
  final double gap;
  final double? totalLength;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final length = totalLength ??
            (axis == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight);
        final dashCount = (length / (dashWidth + gap)).floor();

        return Flex(
          direction: axis,
          mainAxisSize: MainAxisSize.max,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: axis == Axis.horizontal ? dashWidth : dashHeight,
              height: axis == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: dashColor),
              ),
            );
          })
              .expand((widget) => [widget, SizedBox(width: gap, height: gap)])
              .toList()
            ..removeLast(), // Remove trailing gap
        );
      },
    );
  }
}
