import 'package:flutter/material.dart';

Widget ContainerRoundedCorners(String text, TextStyle textStyle, Color backgroundColor, Icon? icon,) {
  return Container(
    padding: const EdgeInsets.all(8,),
    decoration: BoxDecoration(
        color: backgroundColor, borderRadius: BorderRadius.circular(12)),
    child: Row(
      children: [
        icon ?? Container(),
        Text(text, style: textStyle)
      ],
    ),
  );
}
