import 'package:healio/helper/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  final BuildContext context;

  AppTextStyles(this.context);

  static const TextStyle _baseExtraBoldTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w800,
  );

  static const TextStyle _baseBoldTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _baseSemiBoldTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _baseMediumTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _baseRegularTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _baseLightTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w300,
  );

  TextStyle get onyxBold24 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.onyx,
      fontSize: 24,
    );
  }

  TextStyle get onyxBold20 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.onyx,
      fontSize: 20,
    );
  }

  TextStyle get onyxBold16 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.onyx,
      fontSize: 16,
    );
  }

  TextStyle get ateneoBlueBold20 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 20,
    );
  }

  TextStyle get graniteGreyRegular16 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.graniteGrey,
      fontSize: 16,
    );
  }

  TextStyle get cadetGreyLight13 {
    final themeProvider = context.themeProvider;
    return _baseLightTextStyle.copyWith(
      color: themeProvider.cadetGrey,
      fontSize: 13,
    );
  }

  TextStyle get redLight13 {
    final themeProvider = context.themeProvider;
    return _baseLightTextStyle.copyWith(
      color: themeProvider.red,
      fontSize: 12,
    );
  }

  TextStyle get whiteSemiBold16 {
    return _baseSemiBoldTextStyle.copyWith(
      color: Colors.white,
      fontSize: 16,
    );
  }

  TextStyle get graniteGreyRegular14 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.graniteGrey,
      fontSize: 14,
    );
  }

  TextStyle get graniteGreyRegularUnderline14 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.graniteGrey,
      fontSize: 14,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle get ateneoBlueMedium12 {
    final themeProvider = context.themeProvider;
    return _baseMediumTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 12,
    );
  }

  TextStyle get onyxSemiBold14 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.onyx,
      fontSize: 14,
    );
  }

  TextStyle get onyxSemiBold16 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.onyx,
      fontSize: 16,
    );
  }

  TextStyle get bubblesSemiBold14 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.bubbles,
      fontSize: 14,
    );
  }

  TextStyle get ateneoBlueSemiBold14 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 14,
    );
  }

  TextStyle get uclaGoldSemiBold12 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.uclaGold,
      fontSize: 12,
    );
  }

  TextStyle get blueSemiBold12 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.blue.withOpacity(0.6),
      fontSize: 12,
    );
  }

  TextStyle get spanishGreenSemiBold12 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.spanishGreen,
      fontSize: 12,
    );
  }

  TextStyle get ateneoBlueSemiBold12 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 12,
    );
  }

  TextStyle get redSemiBold12 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.red,
      fontSize: 12,
    );
  }

  TextStyle get onyxSemiBold12 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.onyx,
      fontSize: 12,
    );
  }

  TextStyle get graniteGreySemiBold12 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.graniteGrey,
      fontSize: 12,
    );
  }

  TextStyle get ateneoBlueRegular12 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 12,
    );
  }

  TextStyle get whiteSemiBold10 {
    return _baseSemiBoldTextStyle.copyWith(
      color: Colors.white,
      fontSize: 10,
    );
  }
  TextStyle get whiteBold10 {
    return _baseBoldTextStyle.copyWith(
      color: Colors.white,
      fontSize: 10,
    );
  }

  TextStyle get whiteRegular10 {
    return _baseRegularTextStyle.copyWith(
      color: Colors.white,
      fontSize: 10,
    );
  }

  TextStyle get whiteSemiBold14 {
    return _baseSemiBoldTextStyle.copyWith(
      color: Colors.white,
      fontSize: 14,
    );
  }
  TextStyle get redSemiBold14 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.red,
      fontSize: 14,
    );
  }

  TextStyle get blueSemiBold16 {
    final themeProvider = context.themeProvider;
    return _baseMediumTextStyle.copyWith(
      color: themeProvider.blue,
      fontSize: 16,
    );
  }

  TextStyle get ateneoBlueSemiBold13 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 13,
    );
  }

  TextStyle get cadetGreySemiBold13 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.cadetGrey,
      fontSize: 13,
    );
  }

  TextStyle get cadetGreyMedium14 {
    final themeProvider = context.themeProvider;
    return _baseMediumTextStyle.copyWith(
      color: themeProvider.cadetGrey,
      fontSize: 14,
    );
  }

  TextStyle get graniteGreyBold12 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.graniteGrey,
      fontSize: 12,
    );
  }

  TextStyle get graniteGreyMedium10 {
    final themeProvider = context.themeProvider;
    return _baseMediumTextStyle.copyWith(
      color: themeProvider.graniteGrey,
      fontSize: 10,
    );
  }

  TextStyle get redBold10 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.red,
      fontSize: 10,
    );
  }

  TextStyle get greenBold10 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.spanishGreen,
      fontSize: 10,
    );
  }

  TextStyle get redMedium10 {
    final themeProvider = context.themeProvider;
    return _baseMediumTextStyle.copyWith(
      color: themeProvider.red,
      fontSize: 10,
    );
  }


  TextStyle get greyLight13 {
    return _baseLightTextStyle.copyWith(
      color: Colors.grey.shade800,
      fontSize: 13,
    );
  }

  TextStyle get ateneoBlueBold18 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 18,
    );
  }

  TextStyle get ateneoBlueBold10 {
    final themeProvider = context.themeProvider;
    return _baseBoldTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 10,
    );
  }

  TextStyle get spanishGreenRegular14 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.spanishGreen,
      fontSize: 14,
    );
  }

  TextStyle get redRegular14 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.red,
      fontSize: 14,
    );
  }

  TextStyle get ateneoBlueRegular14 {
    final themeProvider = context.themeProvider;
    return _baseRegularTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 14,
    );
  }
  TextStyle get blackRegular14 {
    return _baseRegularTextStyle.copyWith(
      fontSize: 14,
    );
  }
  TextStyle get ateneoBlueSemiBoldUnderlined16 {
    final themeProvider = context.themeProvider;
    return _baseSemiBoldTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 16,
      decoration: TextDecoration.underline,
    );
  }

  TextStyle get ateneoBlueMediumUnderlined12 {
    final themeProvider = context.themeProvider;
    return _baseMediumTextStyle.copyWith(
      color: themeProvider.ateneoBlue,
      fontSize: 12,
      decoration: TextDecoration.underline,
    );
  }
}
