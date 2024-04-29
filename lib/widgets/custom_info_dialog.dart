import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';

import '../helper/app_text_styles.dart';

class CustomDialog extends StatelessWidget {
  final String title, content, positiveBtnText;
  final GestureTapCallback positiveBtnPressed;

  CustomDialog({
    required this.title,
    required this.content,
    required this.positiveBtnText,
    required this.positiveBtnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context, themeProvider, appTextStyles),
    );
  }
  Widget _buildDialogContent(BuildContext context, ThemeProvider themeProvider, AppTextStyles appTextStyles) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: appTextStyles.onyxBold16,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                content,
                style: appTextStyles.graniteGreyRegular14,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: positiveBtnPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: themeProvider.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    positiveBtnText,
                    style: appTextStyles.whiteSemiBold14.copyWith(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        CircleAvatar(
          maxRadius: 40.0,
          backgroundColor: themeProvider.red,
          child: const Icon(Icons.error, color: Colors.white,),
        ),
      ],
    );
  }
}