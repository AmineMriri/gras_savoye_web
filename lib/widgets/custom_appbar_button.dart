import 'package:flutter/material.dart';
import '../helper/providers/theme_provider.dart';
import 'dart:math' as math;

class CustomAppBarButton extends StatelessWidget {
  final IconData iconData;
  final ThemeProvider themeProvider;
  final bool isTransform;
  final void Function()? onPressed;

  const CustomAppBarButton(
      {super.key,
      required this.iconData,
      required this.themeProvider,
      required this.isTransform,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeProvider.bubbles,
      ),
      child: IconButton(
        icon: Transform(
          alignment: Alignment.center,
          transform: isTransform ? Matrix4.rotationY(math.pi) : Matrix4.identity(),
          child: Icon(
            iconData,
            color: themeProvider.ateneoBlue,
            size: 24,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
