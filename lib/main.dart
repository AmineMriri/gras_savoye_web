import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/view_models/appointment_view_model.dart';
import 'package:healio/view_models/bulletin_view_model.dart';
import 'package:healio/view_models/doctor_view_model.dart';
import 'package:healio/view_models/user_view_model.dart';
import 'package:healio/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helper/dependency_injection.dart';
import 'helper/providers/tab_controller_provider.dart';
import 'helper/providers/tab_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TabControllerProvider>(
            create: (_) => TabControllerProvider()),
        ChangeNotifierProvider<TabProvider>(create: (_) => TabProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => BulletinViewModel()),
        ChangeNotifierProvider(create: (_) => DoctorViewModel()),
        ChangeNotifierProvider(create: (_) => AppointmentViewModel()),
      ],
      child: const MyApp(),
    ),
  );
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      //initialBinding: InitDep(),
      title: 'Healio',
      //theme: ThemeController().getThemeData(context),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
    );
  }
}
