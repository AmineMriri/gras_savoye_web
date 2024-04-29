import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healio/widgets/nav_bottom_bar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

import '../../models/responses/user/login_response.dart';

class BiometricsScreen extends StatefulWidget {
  final LoginResponse? loginResponse;

  const BiometricsScreen({Key? key, this.loginResponse}) : super(key: key);

  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;

  @override
  void initState() {
    super.initState();
    _checkBiometricsAvailability();
  }

  Future<void> _checkBiometricsAvailability() async {
    bool isSupported;
    try {
      isSupported = await auth.isDeviceSupported();
      _authenticate();
    } on PlatformException catch (e) {
      print('Error checking biometrics availability: $e');
      isSupported = false;
    }
    if (isSupported) {
      print("_checkBiometricsAvailability: _checkBiometrics");
      _checkBiometrics();
    } else {
      print("_checkBiometricsAvailability: _promptToSetPIN");
      // Device does not support biometrics, prompt user to set a PIN
      _promptToSetPIN();
    }
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    /*if (_canCheckBiometrics!) {
      _getAvailableBiometrics();
    }*/
  }

  /* Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
      print(availableBiometrics.length.toString());
    });

    if (_availableBiometrics!.isNotEmpty) {
      _authenticate();
    } else {
      print("_promptToSetPIN cause bio not set");
      // No biometric methods available, prompt user to set a PIN
      _promptToSetPIN();
    }
  }*/

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Determined authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
      return;
    }
    if (!mounted) {
      return;
    }

    if (authenticated) {
      print("success!!!!");
      // Authentication successful, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NavigationBottom(
                  loginResponse: widget.loginResponse,
                )),
      );
    } else {
      print("failed!!!!");
      // Authentication failed, prompt user to authenticate again
      _authenticate();
    }
  }

  Future<void> _promptToSetPIN() async {
    // Show a dialog prompting the user to set a PIN
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, onPopInvoked: (bool didPop) {},
          child: AlertDialog(
            title: const Text('Définir un code PIN'),
            content: const Text(
                'Pour sécuriser votre appareil, veuillez définir un code PIN dans les paramètres de l\'appareil.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to device settings
                  navigateToSettings();
                },
                child: const Text('Paramètres'),
              ),
            ],
          ),
        );
      },
    );
  }

  void navigateToSettings() {
    switch (OpenSettingsPlus.shared) {
      case OpenSettingsPlusAndroid settings:
        settings.biometricEnroll();
        break;
      case OpenSettingsPlusIOS settings:
        settings.faceIDAndPasscode();
        break;
      default:
        throw Exception('Platform not supported');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
