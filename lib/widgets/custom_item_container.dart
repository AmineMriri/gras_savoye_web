import 'package:flutter/material.dart';

import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomItemContainer extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppTextStyles appTextStyles;
  final String imgAsset;
  final String heading;
  final String subHeading;
  final String detailsPrimary;
  final String detailsSecondary;
  final bool hasArrowForward;

  const CustomItemContainer({
    required this.themeProvider,
    required this.appTextStyles,
    required this.imgAsset,
    required this.heading,
    required this.subHeading,
    required this.detailsPrimary,
    required this.detailsSecondary,
    required this.hasArrowForward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 15, left: 15, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      imgAsset,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          heading,
                          style: appTextStyles.onyxSemiBold14,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          subHeading,
                          style: appTextStyles.graniteGreyRegular14,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: themeProvider.bubbles),
              child: Column(
                children: [
                  Text(
                    detailsPrimary,
                    style: appTextStyles.ateneoBlueBold20,
                  ),
                  Text(
                    detailsSecondary,
                    style: appTextStyles.ateneoBlueRegular14,
                  ),
                ],
              ),
            ),
            hasArrowForward ? Row(
              children: [
                const SizedBox(width: 5,),
                Icon(Icons.arrow_forward_ios, color: themeProvider.cadetGrey, size: 10,),
                const SizedBox(width: 5,),
              ],
            ) : Container(),
          ],
        ));
  }
}
