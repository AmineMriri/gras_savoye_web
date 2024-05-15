import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/providers/tab_provider.dart';
import '../../helper/providers/theme_provider.dart';
import '../../view_models/user_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import '../auth/sign_in_screen.dart';
import 'notif_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
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
          title: 'Notifications',
          icon: null,
          trailing: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            onPressed: () {
              userViewModel.performLogout(context);
            },
          ),
          /*onLogout: () {

          },*/
          themeProvider: themeProvider,
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: NotifItem(isRead: generateRandomBool()));
          },
        ),
      ),
    );
  }

  bool generateRandomBool() {
    Random random = Random();
    return random.nextBool();
  }
}
