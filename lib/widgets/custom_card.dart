import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import '../helper/app_text_styles.dart';

Widget CustomCard(AppTextStyles appTextStyles, ThemeProvider themeProvider,
    String title, Widget body, Widget? observation) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: appTextStyles.onyxSemiBold14,
          ),
        ),
        const SizedBox(height: 7),
        Divider(color: themeProvider.brightGrey, height: 8),
        const SizedBox(height: 7),
        body,
        if (observation != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 7),
              Divider(color: themeProvider.brightGrey, height: 8),
              const SizedBox(height: 7),
              observation,
            ],
          )
      ],
    ),
  );
}
