import 'package:flutter/material.dart';

class NbpElevatedBtn extends StatefulWidget {
  const NbpElevatedBtn({
    super.key,
    required this.text,
    required this.onTap,
    required this.controllers,
    required this.validators,
    this.textStyle,
    this.height,
    this.width,
    this.externalTriggers = const [],
    this.bgColor,
    this.borderRadius,
    this.buttonStyle,
    this.childWidget,
  });

  final String text;
  final Future<void> Function() onTap;
  final List<TextEditingController> controllers;
  final List<bool Function(String)> validators;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final List<Object> externalTriggers;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final ButtonStyle? buttonStyle;
  final Widget? childWidget;

  @override
  State<NbpElevatedBtn> createState() => _NbpElevatedBtnState();
}

class _NbpElevatedBtnState extends State<NbpElevatedBtn> {
  bool isLoading = false;
  bool isDisabled = true;

  @override
  void initState() {
    super.initState();
    for (final controller in widget.controllers) {
      controller.addListener(_validateFields);
    }
    // Also listen to external triggers if they are ValueNotifiers
    for (final trigger in widget.externalTriggers) {
      if (trigger is ValueNotifier<bool>) {
        trigger.addListener(_validateFields);
      }
    }
    _validateFields();
  }

  @override
  void didUpdateWidget(covariant NbpElevatedBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.externalTriggers.toString() !=
        widget.externalTriggers.toString()) {
      _validateFields();
    }
  }

  void _validateFields() {
    final allValid = List.generate(widget.controllers.length, (index) {
      final text = widget.controllers[index].text.trim();
      final isValid = widget.validators[index](text);
      return isValid;
    }).every((e) => e == true);

    // 👇 Check externalTriggers too
    final allExternalTrue = widget.externalTriggers.isEmpty ||
        widget.externalTriggers.every((trigger) {
          if (trigger is bool) return trigger;
          if (trigger is ValueNotifier<bool>) return trigger.value;
          return true;
        });

    final shouldEnable = allValid && allExternalTrue;

    if (isDisabled != !shouldEnable) {
      setState(() => isDisabled = !shouldEnable);
    }
  }

  Future<void> _handleTap() async {
    if (isDisabled || isLoading) return;

    setState(() => isLoading = true);

    try {
      await widget.onTap();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    for (final controller in widget.controllers) {
      controller.removeListener(_validateFields);
    }
    for (final trigger in widget.externalTriggers) {
      if (trigger is ValueNotifier<bool>) {
        trigger.removeListener(_validateFields);
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 40,
      height: widget.height ?? 52,
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : _handleTap,
        style: widget.buttonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor:
                  isDisabled ? Colors.grey : widget.bgColor ?? Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(40),
              ),
            ),
        child: isLoading
            ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : widget.childWidget ??
                Text(
                  widget.text,
                  style: widget.textStyle ??
                      TextStyle(
                        color: isDisabled ? Colors.blue : Colors.white,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
      ),
    );
  }
}
