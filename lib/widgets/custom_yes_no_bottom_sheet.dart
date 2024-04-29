import 'package:healio/helper/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import 'custom_button.dart';

class CustomYesNoBottomSheet {
  static void show({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required AppTextStyles appTextStyles,
    required String title,
    required Future<dynamic>? Function()? onNoPressed,
    required Future<dynamic>? Function()? onYesPressed,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeProvider.ghostWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Text(
                  title,
                  style: appTextStyles.onyxSemiBold14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        txt: "Non",
                        txtStyle: appTextStyles.whiteSemiBold16,
                        onPressed: onNoPressed,
                        btnColor: themeProvider.red,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomElevatedButton(
                        txt: "Oui",
                        txtStyle: appTextStyles.whiteSemiBold16,
                        onPressed: onNoPressed,
                        btnColor: themeProvider.ateneoBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
