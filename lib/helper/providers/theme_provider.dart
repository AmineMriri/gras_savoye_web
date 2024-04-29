import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  //late bool _isDarkMode;
  late Color _ateneoBlue;
  late Color _ghostWhite;
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

  Color get ghostWhite => _ghostWhite;

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

  ///theme and update colors
  /*void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _initializeColors();
    notifyListeners();
  }*/

  void _initializeColors() {
    _ateneoBlue = const Color(0xff003B79);
    _ghostWhite = const Color(0xffF8F9FB);
    _onyx = const Color(0xff35383D);
    _graniteGrey = const Color(0xff615E67);
    _cadetGrey = const Color(0xff9CA3AF);
    _lightSilver = const Color(0xffD1D5DB);
    _bubbles = const Color(0xffE2F3FF);
    _spanishGreen = const Color(0xff028D4C);
    _uclaGold = const Color(0xffFDB400);
    _red = const Color(0xffE47B73);
    _brightGrey = const Color(0xffE5E7EB);
    _blue = const Color(0xff619DDC);
  }
}

extension ThemeProviderExtension on BuildContext {
  ThemeProvider get themeProvider => Provider.of<ThemeProvider>(this);
}
