import 'package:flutter/material.dart';

class NbpTextFieldHeading extends StatelessWidget {
  const NbpTextFieldHeading({
    super.key,
    required this.title,
    this.isItRequired,
    this.titleStyle,
    this.starColor,
    this.padding,
    this.starTextStyle,
  });

  final String? title;
  final bool? isItRequired;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;
  final Color? starColor;
  final TextStyle? starTextStyle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 9.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
                text: title ?? "",
                style: titleStyle ?? TextStyle(fontWeight: FontWeight.w500)),
            TextSpan(
              text: (isItRequired ?? false) ? "*" : "",
              style: starTextStyle ??
                  TextStyle(
                    color: starColor ?? Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
