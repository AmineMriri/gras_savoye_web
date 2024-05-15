import 'package:flutter/material.dart';
import 'package:healio/views/auth/biometrics_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/providers/theme_provider.dart';
import '../widgets/nav_bottom_bar.dart';
import 'auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      color: themeProvider.ghostWhite,
      child: Center(
        child: Image.asset(
          "assets/images/app_icon.png",
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('id')) {
      String userId = prefs.getString('id') ?? '';
      return userId.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> _navigate() async {
    bool isLoggedIn = await isUserLoggedIn();
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => isLoggedIn ? NavigationBottom() : SignInScreen()));
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => isLoggedIn ? const BiometricsScreen() : const SignInScreen()));
  }
}
