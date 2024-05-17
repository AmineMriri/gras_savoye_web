/*import 'package:flutter/material.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/widgets/container_rounded_corners.dart';

import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomDocItemContainer extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppTextStyles appTextStyles;
  final String imgAsset;

  const CustomDocItemContainer({
    super.key,
    required this.themeProvider,
    required this.appTextStyles,
    required this.imgAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 15, left: 15, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imgAsset,
                      height: 85,
                      width: 85,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dr. Foulen El Fouleni",
                        style: appTextStyles.onyxSemiBold14,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            ContainerRoundedCorners(
                                "Radiologue",
                                appTextStyles.ateneoBlueBold10,
                                themeProvider.bubbles,
                                null),
                          const SizedBox(width: 10,),
                          ContainerRoundedCorners(
                              "5 Km",
                              appTextStyles.whiteSemiBold10,
                              themeProvider.blue.withOpacity(0.6),
                              null),
                        ],
                      ),
                      const SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: themeProvider.graniteGrey, size: 18,),
                            const SizedBox(width: 10,),
                            Text("Ariana, Tunis", style: appTextStyles.graniteGreyRegular14,)
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 5,),
                Icon(Icons.arrow_forward_ios, color: themeProvider.cadetGrey, size: 10,),
                const SizedBox(width: 5,),
              ],
            )          ],
        ),

    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/widgets/container_rounded_corners.dart';

import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomDocItemContainer extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppTextStyles appTextStyles;
  final String imgAsset;
  final Doctor doctor;

  const CustomDocItemContainer({
    super.key,
    required this.themeProvider,
    required this.appTextStyles,
    required this.imgAsset,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 15, left: 15, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imgAsset,
                      height: 85,
                      width: 85,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        doctor.name,
                        style: appTextStyles.onyxSemiBold14,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(doctor.speciality != null)
                            ContainerRoundedCorners(
                                doctor.speciality!,
                                appTextStyles.ateneoBlueBold10,
                                themeProvider.bubbles,
                                null),
                          const SizedBox(width: 10,),
                          ContainerRoundedCorners(
                              "5 Km",
                              appTextStyles.whiteSemiBold10,
                              themeProvider.blue.withOpacity(0.6),
                              null),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      if(doctor.address!=null)
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: themeProvider.graniteGrey, size: 18,),
                            const SizedBox(width: 10,),
                            Text(doctor.address!, style: appTextStyles.graniteGreyRegular14,)
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 5,),
                Icon(Icons.arrow_forward_ios, color: themeProvider.cadetGrey, size: 10,),
                const SizedBox(width: 5,),
              ],
            )          ],
        ),

    );
  }
}
