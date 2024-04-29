import 'package:flutter/material.dart';
import 'package:healio/helper/app_text_styles.dart';
import 'package:healio/helper/providers/theme_provider.dart';

class CustomYesNoDialog extends StatelessWidget {
  final String title;
  final String content;
  final Future<void> Function()? onYesPressed;
  final Color primaryColor;
  final ThemeProvider themeProvider;
  final AppTextStyles appTextStyles;

  CustomYesNoDialog({
    required this.title,
    required this.content,
    required this.onYesPressed,
    required this.primaryColor,
    required this.themeProvider,
    required this.appTextStyles,
  });


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: appTextStyles.whiteSemiBold16,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                content,
                style: appTextStyles.blackRegular14,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: ()=>Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            'Non',
                            style: appTextStyles.whiteSemiBold14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if (onYesPressed != null) {
                          Navigator.of(context).pop();
                          onYesPressed!();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(12),
                          color: themeProvider.ghostWhite,
                        ),
                        child: Center(
                          child: Text(
                            'Oui',
                            style: appTextStyles.redSemiBold14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
