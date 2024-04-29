import 'package:healio/helper/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import 'custom_button.dart';
import 'custom_multiline_text_field.dart';

class CustomBottomSheetTextField {
  static void show({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required AppTextStyles appTextStyles,
    required String title,
    required String hintText,
    required String btnTxt,
    required String errorTxt,
    required Future<dynamic>? Function()? onPressed,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Text(
                  title,
                  style: appTextStyles.onyxBold20,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                CustomMultilineTextField(
                  themeProvider: themeProvider,
                  textInputAction: TextInputAction.next,
                  hint: hintText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return errorTxt;
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value){
                    print(value);
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                          txt: btnTxt,
                          txtStyle: appTextStyles.whiteSemiBold16,
                          btnColor: themeProvider.red,
                          btnWidth: double.maxFinite,
                          onPressed: onPressed),
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
