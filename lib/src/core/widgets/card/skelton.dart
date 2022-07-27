import 'package:flutter/material.dart';

class Skelton extends StatelessWidget {
  const Skelton({super.key, required this.height, required this.width});
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(height: height, width: width),
    );
  }
}
