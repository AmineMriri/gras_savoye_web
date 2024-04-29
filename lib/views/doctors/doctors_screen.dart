import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/bulletins/bulletin_list.dart';
import 'package:healio/views/doctors/docs_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import '../auth/sign_in_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Médecins",
          icon: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            isTransform: true,
            onPressed: () {
              performLogout();
            },
          ),
          themeProvider: themeProvider,
        ),
        body: const DocsList(),
      ),
    );
  }

  void performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SignInScreen();
        },
      ),
          (_) => false,
    );
  }
}
