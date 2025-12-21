import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NbpCheckBox extends StatelessWidget {
  const NbpCheckBox({
    super.key,
    this.shape,
    this.onChanged,
    required this.value,
    required this.title,
    this.textStyle,
    this.onTap,
    this.activeColor,
    this.showUnderline = true,
    this.height,
    this.scale,
    this.htmlCol,
    this.width,
    this.checkCol,
    this.borderCol,
    this.fillCol,
  });

  final OutlinedBorder? shape;
  final Function(bool?)? onChanged;
  final bool value;
  final String title;
  final TextStyle? textStyle;
  final Function()? onTap;
  final Color? activeColor;
  final bool showUnderline;
  final double? height;
  final double? scale;
  final Color? htmlCol;
  final double? width;
  final Color? checkCol;
  final Color? borderCol;
  final Color? fillCol;

  Future<void> _launchURL(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final fallbackLaunched =
          await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!fallbackLaunched) {
        debugPrint("❌ Still couldn't launch $url");
      }
    }
  }

  List<InlineSpan> _parseHtmlLinks(String htmlText, TextStyle defaultStyle) {
    final spans = <InlineSpan>[];
    final linkRegex =
        RegExp(r"<a\s+href='(.*?)'>(.*?)</a>", caseSensitive: false);
    int lastMatchEnd = 0;

    for (final match in linkRegex.allMatches(htmlText)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: htmlText.substring(lastMatchEnd, match.start),
          style: defaultStyle,
        ));
      }

      final url = match.group(1)!;
      final label = match.group(2)!;

      spans.add(
        TextSpan(
          text: label,
          style: defaultStyle.copyWith(
            color: htmlCol ?? Colors.blue,
            decoration: showUnderline ? TextDecoration.underline : null,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < htmlText.length) {
      spans.add(TextSpan(
        text: htmlText.substring(lastMatchEnd),
        style: defaultStyle,
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = textStyle;

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Theme(
          data: ThemeData(
            checkboxTheme: CheckboxThemeData(
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: shape ?? const CircleBorder(),
            ),
            unselectedWidgetColor: Colors.green,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Transform.scale(
              scale: scale ?? 1,
              child: Checkbox(
                value: value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                onChanged: onChanged,
                side: WidgetStateBorderSide.resolveWith(
                  (states) {
                    // Check if the checkbox is selected or has any other state (like unselected, pressed, etc.)
                    // In ALL cases, return a white border.
                    return BorderSide(
                      width: 1,
                      color: borderCol ??
                          Colors.black, // <--- Border is ALWAYS white
                    );
                  },
                ),
                fillColor: WidgetStatePropertyAll(
                  value
                      ? fillCol ?? (activeColor ?? Colors.blue)
                      : fillCol ?? Colors.white,
                ),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                activeColor: activeColor ?? Colors.green,
                checkColor: checkCol ?? Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width ?? 40,
          // ✅ Safe alternative to Flexible
          child: GestureDetector(
            onTap: onTap,
            child: RichText(
              text: TextSpan(
                style: defaultStyle,
                children: _parseHtmlLinks(
                    title,
                    defaultStyle ??
                        TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        )),
              ),
            ),
          ),
        ),
      ],
    );

    // Always return without Flexible on the outside
    return height != null ? SizedBox(height: height, child: content) : content;
  }
}
