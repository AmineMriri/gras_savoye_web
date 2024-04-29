import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String txt;
  final TextStyle txtStyle;
  final Color btnColor;
  final double? btnWidth;
  final double? btnHeight;
  final void Function()? onPressed;

  const CustomElevatedButton(
      {super.key,
      required this.txt,
      required this.txtStyle,
      required this.btnColor,
      this.btnWidth,
      this.btnHeight,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: btnColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      onPressed: () => onPressed?.call(),
      child: Align(
        alignment: Alignment.center,
        child: Text(txt, style: txtStyle),
      )

    );
  }
}
