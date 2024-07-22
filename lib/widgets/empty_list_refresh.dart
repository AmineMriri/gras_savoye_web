import 'package:flutter/material.dart';
import 'package:healio/helper/app_text_styles.dart';
import 'package:healio/helper/providers/theme_provider.dart';

Widget EmptyListRefresh(String title, AppTextStyles appTextStyles){
  return Center(
    child: FractionallySizedBox(
      widthFactor: 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          Text(
            title,
            maxLines: 3,
            style: appTextStyles.onyxBold18,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30,),
          Image.asset('assets/images/empty.png'),
        ],
      ),
    ),
  );
}