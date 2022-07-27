// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:kraken_pokedex/src/core/extensions/context_extension.dart';

enum TextSizeEnum {
  extraLow,
  low,
  normal,
  high,
  extraHigh;

  double value(BuildContext context) {
    switch (this) {
      case TextSizeEnum.extraLow:
        return context.extraLowTextSize;
      case TextSizeEnum.low:
        return context.lowTextSize;

      case TextSizeEnum.normal:
        return context.normalTextSize;

      case TextSizeEnum.high:
        return context.highTextSize;

      case TextSizeEnum.extraHigh:
        return context.extraHighTextSize;
    }
  }
}

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  CustomText(
    this.text, {
    super.key,
    this.textColor,
    this.underlined = false,
    this.bold = false,
    this.centerText = false,
    this.textOverflow,
    this.maxLines,
    this.lineThrough = false,
  }) {
    textSizeEnum = TextSizeEnum.normal;
  }
  CustomText.extraHigh(
    this.text, {
    super.key,
    this.textColor,
    this.underlined = false,
    this.bold = false,
    this.centerText = false,
    this.textOverflow,
    this.maxLines,
    this.lineThrough = false,
  }) {
    textSizeEnum = TextSizeEnum.extraHigh;
  }
  CustomText.low(
    this.text, {
    super.key,
    this.textColor,
    this.underlined = false,
    this.bold = false,
    this.centerText = false,
    this.textOverflow,
    this.maxLines,
    this.lineThrough = false,
  }) {
    textSizeEnum = TextSizeEnum.low;
  }
  CustomText.extraLow(
    this.text, {
    super.key,
    this.textColor,
    this.underlined = false,
    this.bold = false,
    this.centerText = false,
    this.textOverflow,
    this.maxLines,
    this.lineThrough = false,
  }) {
    textSizeEnum = TextSizeEnum.extraLow;
  }
  CustomText.custom(
    this.text, {
    super.key,
    this.textColor,
    this.underlined = false,
    this.bold = false,
    this.centerText = false,
    this.textOverflow,
    this.textSize,
    this.maxLines,
    this.lineThrough = false,
  });
  CustomText.high(
    this.text, {
    super.key,
    this.textColor,
    this.underlined = false,
    this.bold = false,
    this.centerText = false,
    this.textOverflow,
    this.maxLines,
    this.lineThrough = false,
  }) {
    textSizeEnum = TextSizeEnum.high;
  }
  final String? text;
  TextSizeEnum? textSizeEnum;
  double? textSize;
  final Color? textColor;
  final bool underlined;
  final bool lineThrough;
  final bool bold;
  final bool centerText;
  final TextOverflow? textOverflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: TextStyle(
        fontSize: textSize ?? textSizeEnum?.value(context) ?? context.normalTextSize,
        color: textColor ?? context.theme.textTheme.displayMedium?.color,
        decoration: underlined
            ? TextDecoration.underline
            : lineThrough
                ? TextDecoration.lineThrough
                : null,
        fontWeight: bold ? FontWeight.bold : null,
      ),
      textAlign: centerText ? TextAlign.center : null,
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
