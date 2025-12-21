import 'package:flutter/material.dart';
import 'package:nbp_custom_widgets/src/controller/form_field_controller.dart';

class UrbanTeacherRadioButton extends StatefulWidget {
  const UrbanTeacherRadioButton({
    super.key,
    required this.options,
    required this.onChanged,
    required this.controller,
    required this.optionHeight,
    required this.textStyle,
    this.optionWidth,
    this.selectedTextStyle,
    this.textPadding = EdgeInsets.zero,
    this.buttonPosition = RadioButtonPosition.left,
    this.direction = Axis.vertical,
    required this.radioButtonColor,
    this.inactiveRadioButtonColor,
    this.toggleable = false,
    this.horizontalAlignment = WrapAlignment.start,
    this.verticalAlignment = WrapCrossAlignment.start,
  });

  final List<String> options;
  final Function(String?)? onChanged;
  final FormFieldController<String> controller;
  final double optionHeight;
  final double? optionWidth;
  final TextStyle textStyle;
  final TextStyle? selectedTextStyle;
  final EdgeInsetsGeometry textPadding;
  final RadioButtonPosition buttonPosition;
  final Axis direction;
  final Color radioButtonColor;
  final Color? inactiveRadioButtonColor;
  final bool toggleable;
  final WrapAlignment horizontalAlignment;
  final WrapCrossAlignment verticalAlignment;

  @override
  State<UrbanTeacherRadioButton> createState() =>
      _UrbanTeacherRadioButtonState();
}

class _UrbanTeacherRadioButtonState extends State<UrbanTeacherRadioButton> {
  bool get enabled => widget.onChanged != null;
  FormFieldController<String> get controller => widget.controller;
  void Function()? _listener;

  @override
  void initState() {
    super.initState();
    _maybeSetOnChangedListener();
  }

  @override
  void dispose() {
    _maybeRemoveOnChangedListener();
    super.dispose();
  }

  @override
  void didUpdateWidget(UrbanTeacherRadioButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldWidgetEnabled = oldWidget.onChanged != null;
    if (oldWidgetEnabled != enabled) {
      _maybeRemoveOnChangedListener();
      _maybeSetOnChangedListener();
    }
  }

  void _maybeSetOnChangedListener() {
    if (enabled) {
      _listener = () => widget.onChanged!(controller.value);
      controller.addListener(_listener!);
    }
  }

  void _maybeRemoveOnChangedListener() {
    if (_listener != null) {
      controller.removeListener(_listener!);
      _listener = null;
    }
  }

  List<String> get effectiveOptions =>
      widget.options.isEmpty ? ['[Option]'] : widget.options;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(unselectedWidgetColor: widget.inactiveRadioButtonColor),
      child: RadioGroup<String>.builder(
        direction: widget.direction,
        groupValue: controller.value,
        onChanged: enabled ? (value) => controller.value = value : null,
        activeColor: widget.radioButtonColor,
        toggleable: widget.toggleable,
        textStyle: widget.textStyle,
        selectedTextStyle: widget.selectedTextStyle ?? widget.textStyle,
        textPadding: widget.textPadding,
        optionHeight: widget.optionHeight,
        optionWidth: widget.optionWidth,
        horizontalAlignment: widget.horizontalAlignment,
        verticalAlignment: widget.verticalAlignment,
        items: effectiveOptions,
        itemBuilder: (item) =>
            RadioButtonBuilder(item, buttonPosition: widget.buttonPosition),
      ),
    );
  }
}

enum RadioButtonPosition {
  right,
  left,
}

class RadioButtonBuilder<T> {
  RadioButtonBuilder(
    this.description, {
    this.buttonPosition = RadioButtonPosition.left,
  });

  final String description;
  final RadioButtonPosition buttonPosition;
}

class RadioButton<T> extends StatelessWidget {
  const RadioButton({
    super.key,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.buttonPosition,
    required this.activeColor,
    required this.toggleable,
    required this.textStyle,
    required this.selectedTextStyle,
    required this.textPadding,
    this.shouldFlex = false,
  });

  final String description;
  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final RadioButtonPosition buttonPosition;
  final Color activeColor;
  final bool toggleable;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final EdgeInsetsGeometry textPadding;
  final bool shouldFlex;

  @override
  Widget build(BuildContext context) {
    final selectedStyle = selectedTextStyle;
    final isSelected = value == groupValue;
    Widget radioButtonText = Padding(
      padding: textPadding,
      child: Text(
        description,
        style: isSelected ? selectedStyle : textStyle,
      ),
    );
    if (shouldFlex) {
      radioButtonText = Flexible(child: radioButtonText);
    }
    return InkWell(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (buttonPosition == RadioButtonPosition.right) radioButtonText,
          Radio<T>(
            groupValue: groupValue,
            onChanged: onChanged,
            value: value,
            activeColor: activeColor,
            toggleable: toggleable,
          ),
          if (buttonPosition == RadioButtonPosition.left) radioButtonText,
        ],
      ),
    );
  }
}

class RadioGroup<T> extends StatelessWidget {
  const RadioGroup.builder({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.items,
    required this.itemBuilder,
    required this.direction,
    required this.optionHeight,
    required this.horizontalAlignment,
    required this.activeColor,
    required this.toggleable,
    required this.textStyle,
    required this.selectedTextStyle,
    required this.textPadding,
    this.optionWidth,
    this.verticalAlignment = WrapCrossAlignment.center,
  });

  final T? groupValue;
  final List<T> items;
  final RadioButtonBuilder Function(T value) itemBuilder;
  final void Function(T?)? onChanged;
  final Axis direction;
  final double optionHeight;
  final double? optionWidth;
  final WrapAlignment horizontalAlignment;
  final WrapCrossAlignment verticalAlignment;
  final Color activeColor;
  final bool toggleable;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final EdgeInsetsGeometry textPadding;

  List<Widget> get _group => items.map(
        (item) {
          final radioButtonBuilder = itemBuilder(item);
          return SizedBox(
            height: optionHeight,
            width: optionWidth,
            child: RadioButton(
              description: radioButtonBuilder.description,
              value: item,
              groupValue: groupValue,
              onChanged: onChanged,
              buttonPosition: radioButtonBuilder.buttonPosition,
              activeColor: activeColor,
              toggleable: toggleable,
              textStyle: textStyle,
              selectedTextStyle: selectedTextStyle,
              textPadding: textPadding,
              shouldFlex: optionWidth != null,
            ),
          );
        },
      ).toList();

  @override
  Widget build(BuildContext context) => direction == Axis.horizontal
      ? Wrap(
          direction: direction,
          alignment: horizontalAlignment,
          children: _group,
        )
      : Wrap(
          direction: direction,
          crossAxisAlignment: verticalAlignment,
          children: _group,
        );
}
