import 'package:flutter/material.dart';
import 'package:healio/helper/app_text_styles.dart';
import 'package:healio/helper/providers/theme_provider.dart';

Widget ErrorDisplayAndRefresh(AppTextStyles appTextStyles, ThemeProvider themeProvider, void Function()? onRefresh){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        Text(
            'Une erreur s\'est produite!',
            style: appTextStyles.blueSemiBold16
        ),
        const SizedBox(height: 15,),
        ElevatedButton(
          onPressed: onRefresh/*() async {
            /*setState(() {
                    isLoading = true;
                  });
                  await _refreshList();
                  setState(() {
                    isLoading = false;
                  });*/
          }*/,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const CircleBorder(),
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeProvider.blue,
            ),
            child: const Center(
              child: Icon(
                Icons.refresh_rounded,
                size: 22,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    ),
  );
}