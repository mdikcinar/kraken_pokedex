import 'package:flutter/material.dart';
import 'package:kraken_pokedex/src/core/extensions/context_extension.dart';

class CustomInkwell extends StatelessWidget {
  const CustomInkwell({
    super.key,
    required this.onTap,
    required this.child,
    this.padding,
    this.disableTapEffect = false,
    this.borderRadius,
  });
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Widget child;
  final bool disableTapEffect;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: disableTapEffect ? Colors.transparent : null,
      splashColor: disableTapEffect ? Colors.transparent : null,
      highlightColor: disableTapEffect ? Colors.transparent : null,
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(context.lowRadius),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.normalPadding),
        child: child,
      ),
    );
  }
}
