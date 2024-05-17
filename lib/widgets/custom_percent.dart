import 'package:flutter/material.dart';
import 'package:healio/helper/app_text_styles.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../views/responsive.dart';

class CustomPercent extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppTextStyles appTextStyles;
  final double totalDep;
  final double totalPec;

  const CustomPercent(
      {super.key, required this.themeProvider, required this.appTextStyles, required this.totalDep, required this.totalPec});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$totalPec DT / ",
              style: Responsive.isMobile(context)?appTextStyles.ateneoBlueSemiBold12:appTextStyles.ateneoBlueSemiBold14,
            ),
            Text(
              "$totalDep DT",
              style:Responsive.isMobile(context)?appTextStyles.redSemiBold12:appTextStyles.redSemiBold14,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: totalPec/totalDep,
          barRadius: const Radius.circular(12),
          backgroundColor: themeProvider.red,
          progressColor: themeProvider.spanishGreen,
        ),
      ],
    );
    /*
    * Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$totalPec DT",
              style: appTextStyles.spanishGreenSemiBold12,
            ),
            Text(
              " / $totalDep DT",
              style: appTextStyles.graniteGreySemiBold12,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: totalPec/totalDep,
          barRadius: const Radius.circular(12),
          backgroundColor: themeProvider.ghostWhite,
          progressColor: themeProvider.spanishGreen,
        ),
      ],
    );*/
  }
}
