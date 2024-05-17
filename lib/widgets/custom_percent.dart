import 'package:flutter/material.dart';
import 'package:healio/helper/app_text_styles.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
              style: appTextStyles.ateneoBlueSemiBold12,
            ),
            Text(
              "$totalDep DT",
              style: appTextStyles.blueSemiBold12,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(0, 4), // Vertical shadow offset
                blurRadius:7, // Blur radius changes position of shadow
              ),
            ],
          ),
          child: LinearPercentIndicator(
            lineHeight: 8,
            percent: totalPec/totalDep,
            barRadius: const Radius.circular(12),

            backgroundColor: themeProvider.blue.withOpacity(0.6),
            progressColor: themeProvider.ateneoBlue.withOpacity(0.9),
          ),
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
