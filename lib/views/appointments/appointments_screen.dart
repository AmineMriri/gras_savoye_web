import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/appointments/appointments_list.dart';
import 'package:healio/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_appbar_button.dart';
import '../auth/sign_in_screen.dart';
import 'apt_archive_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double fontSizeRatio = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

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
          title: "Mes RDVs",
          icon: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            isTransform: true,
            onPressed: () {
              performLogout();
            },
          ),
          themeProvider: themeProvider,
          tabBar: TabBar(
            controller: _tabController,
            // Add TabController
            indicatorColor: themeProvider.ateneoBlue,
            labelColor: themeProvider.ateneoBlue,
            unselectedLabelColor: themeProvider.cadetGrey,
            tabs: const [
              Tab(text: 'Confirmé'),
              Tab(text: 'En attente'),
            ],
          ),
          trailing: CustomAppBarButton(
            iconData: Icons.archive_rounded,
            themeProvider: themeProvider,
            isTransform: false,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AptArchiveScreen()));
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AppointmentsList(),
            AppointmentsList(),
          ],
        ),
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
