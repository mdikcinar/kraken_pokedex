import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({super.key, required this.child, this.enabled});
  final Widget child;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.1),
      enabled: enabled ?? true,
      child: child,
    );
  }
}
