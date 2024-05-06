import 'package:flutter/material.dart';

import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';
import 'custom_button.dart';

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required String title,
    required String btnTxt,
    required Widget content,
    required double hPadding,
    required bool hasResetBtn,

    required ThemeProvider themeProvider,
    required void Function()? onPressed,
    required void Function()? onClosePressed,
  }) {
    AppTextStyles appTextStyles = AppTextStyles(context);

    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: BoxDecoration(
                  color: themeProvider.ghostWhite,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close_rounded, color: themeProvider.onyx,),
                            onPressed: onClosePressed,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: hPadding,
                      ),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: appTextStyles.onyxBold20,
                          ),
                          const SizedBox(height: 30),
                          content,
                          const SizedBox(height: 30),
                          CustomElevatedButton(
                            txt: btnTxt,
                            txtStyle: appTextStyles.whiteSemiBold16,
                            btnColor: themeProvider.ateneoBlue,
                            btnWidth: double.maxFinite,
                            btnHeight: 56,
                            onPressed: onPressed,
                          ),
                          /*if(hasResetBtn)
                            Column(
                              children: [
                                const SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: ()=>null,
                                  child: Text(
                                    "Réinitialiser les filtres",
                                    textAlign: TextAlign.center,
                                    style: appTextStyles.underlinedTextStyle,
                                  ),
                                ),
                              ],
                            ),*/
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
