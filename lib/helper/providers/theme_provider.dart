import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  //late bool _isDarkMode;
  late Color _ateneoBlue;
  //late Color _ghostWhite;
  late Color _onyx;
  late Color _graniteGrey;
  late Color _cadetGrey;
  late Color _lightSilver;
  late Color _bubbles;
  late Color _spanishGreen;
  late Color _uclaGold;
  late Color _red;
  late Color _brightGrey;
  late Color _blue;
  late Color _disco;
  late Color _turquoise;
  late Color _zaffre;

  ThemeProvider() {
    ///get system brightness
    //Brightness brightness = WidgetsBinding.instance!.window.platformBrightness;

    ///set initial theme mode based on system brightness
    //_isDarkMode = brightness == Brightness.dark;

    ///initialize theme and colors
    _initializeColors();
  }

  ///getters for theme and colors
  //bool get isDarkMode => _isDarkMode;
  Color get ateneoBlue => _ateneoBlue;

  //Color get ghostWhite => _ghostWhite;

  Color get onyx => _onyx;

  Color get graniteGrey => _graniteGrey;

  Color get cadetGrey => _cadetGrey;

  Color get lightSilver => _lightSilver;

  Color get bubbles => _bubbles;

  Color get spanishGreen => _spanishGreen;

  Color get uclaGold => _uclaGold;

  Color get red => _red;

  Color get brightGrey => _brightGrey;

  Color get blue => _blue;

  Color get disco => _disco;

  Color get turquoise => _turquoise;

  Color get zaffre => _zaffre;

  ///theme and update colors
  /*void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _initializeColors();
    notifyListeners();
  }*/

  /*void _initializeColors() {
    _ateneoBlue = const Color(0xff144578);
    _ghostWhite = const Color(0xffEBEEF4);
    _onyx = const Color(0xff35383D);
    _graniteGrey = const Color(0xff615E67);
    _cadetGrey = const Color(0xff9CA3AF);
    _lightSilver = const Color(0xffD1D5DB);
    _bubbles = const Color(0xffDCE1EB);
    _spanishGreen = const Color(0xff4CB383);
    _uclaGold = const Color(0xffF4C187);
    _red = const Color(0xffE47B73);
    _brightGrey = const Color(0xffE5E7EB);
    _blue = const Color(0xff6089B5);
  }*/
  void _initializeColors() {
    _ateneoBlue = const Color(0xff002891);
    //_ghostWhite = const Color(0xffEBEEF4);
    _onyx = const Color(0xff2E2E2E);
    _graniteGrey = const Color(0xff615E67);
    _cadetGrey = const Color(0xff9CA3AF);
    _lightSilver = const Color(0xffD1D5DB);
    _bubbles = const Color(0xffDCE1EB);
    _spanishGreen = const Color(0xff2AC052);
    _uclaGold = const Color(0xffFF4F0D);
    _red = const Color(0xffD7373F);
    _brightGrey = const Color(0xffE5E7EB);
    _blue = const Color(0xff035EF7);

    _disco = const Color(0xff16C1E4);
    _turquoise = const Color(0xff23DFD6);
    _zaffre = const Color(0xff0214BE);
  }
}

extension ThemeProviderExtension on BuildContext {
  ThemeProvider get themeProvider => Provider.of<ThemeProvider>(this);
}
