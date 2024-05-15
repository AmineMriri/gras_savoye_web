import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/appointments/appointments_list.dart';
import 'package:healio/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/providers/tab_provider.dart';
import '../../view_models/user_view_model.dart';
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
  late UserViewModel userViewModel;

  double fontSizeRatio = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
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
        backgroundColor: themeProvider.ghostWhite,
        appBar: CustomAppBar(
          title: "Mes RDVs",
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
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            onPressed: () {
              userViewModel.performLogout(context);
            },
          ), icon: null,
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
}
