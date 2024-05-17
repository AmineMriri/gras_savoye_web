import 'package:flutter/material.dart';
import 'package:healio/models/responses/user/login_response.dart';
import 'package:healio/views/appointments/appointments_screen.dart';
import 'package:healio/views/bulletins/bulletins_screen.dart';
import 'package:healio/views/doctors/doctors_screen.dart';
import 'package:healio/views/notifications/notifications_screen.dart';
import 'package:healio/views/responsive.dart';
import 'package:healio/widgets/Drawer.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/ci.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../helper/providers/tab_provider.dart';
import '../helper/providers/theme_provider.dart';
import '../views/profile/profile_screen.dart';

class NavigationBottom extends StatefulWidget {
  final LoginResponse? loginResponse;
  const NavigationBottom({Key? key, this.loginResponse}) : super(key: key);

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

final GlobalKey<State> addRdvStep1Key = GlobalKey<State>();
final GlobalKey<State> dashboardKey = GlobalKey<State>();

class _NavigationBottomState extends State<NavigationBottom> {
  List<Widget> _buildScreen() {
    return [
      BulletinsScreen(loginResponse: widget.loginResponse,),
      const DoctorsScreen(),
      const AppointmentsScreen(),
      const NotificationsScreen(),
      const ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem(ThemeProvider themeProvider) {
    return [
      PersistentBottomNavBarItem(
        activeColorPrimary: themeProvider.ateneoBlue,
        icon: Iconify(
          selectedIndex == 0 ? Ci.home_fill : Ci.home_outline,
          color: selectedIndex == 0
              ? themeProvider.ateneoBlue
              : themeProvider.graniteGrey,
        ),
      ),
      PersistentBottomNavBarItem(
          activeColorPrimary: themeProvider.ateneoBlue,
          icon: Iconify(
            Carbon.stethoscope,
            color: selectedIndex == 1
                ? themeProvider.ateneoBlue
                : themeProvider.graniteGrey,
          )),
      PersistentBottomNavBarItem(
        activeColorPrimary: themeProvider.ateneoBlue,
        icon: Icon(
          Icons.calendar_month_rounded,
          color: selectedIndex == 2
              ? themeProvider.ateneoBlue
              : themeProvider.graniteGrey,
        ),
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: themeProvider.ateneoBlue,
        icon: Icon(
          selectedIndex == 3
              ? Icons.notifications_rounded
              : Icons.notifications_outlined,
          color: selectedIndex == 3
              ? themeProvider.ateneoBlue
              : themeProvider.graniteGrey,
        ),
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: themeProvider.ateneoBlue,
        icon: Iconify(
          selectedIndex == 4 ? Eva.person_fill : Eva.person_outline,
          color: selectedIndex == 4
              ? themeProvider.ateneoBlue
              : themeProvider.graniteGrey,
        ),
      ),
    ];
  }

  int selectedIndex = 0;

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = context.themeProvider;
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: true,
        child: Scaffold(
          body: Responsive.isMobile(context)?PersistentTabView(
            context,
            controller: tabProvider.controller,
            screens: _buildScreen(),
            items: _navBarItem(themeProvider),
            onItemSelected: (int selectedTab) {
              setState(() {
                selectedIndex = selectedTab;
              });
            },
            navBarHeight: 65,
            backgroundColor: Colors.white,

          )
              :Row(
            children: [
              Expanded(
                  flex: 1,
                  child:  MyDrawer(onItemSelected:  updateSelectedIndex)
              ),
              Expanded(
                flex: 10,
                child: IndexedStack(
                  index: selectedIndex,
                  children: _buildScreen(),
                ),
              ),
              Responsive.isDesktop(context)?
              Expanded(

                flex: 4,
                  child:
              SizedBox(
                // child: Container(
                //   decoration: BoxDecoration(
                //       color : themeProvider.ghostWhite
                //
                //   ),
                // ),
                child: ProfileScreen(),
              )
              ):SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:healio/models/responses/user/login_response.dart';
import 'package:healio/views/appointments/appointments_screen.dart';
import 'package:healio/views/bulletins/bulletins_screen.dart';
import 'package:healio/views/doctors/doctors_screen.dart';
import 'package:healio/views/notifications/notifications_screen.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/ci.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../helper/providers/tab_provider.dart';
import '../helper/providers/theme_provider.dart';
import '../views/profile/profile_screen.dart';

class NavigationBottom extends StatefulWidget {
  final LoginResponse? loginResponse;
  const NavigationBottom({Key? key, this.loginResponse}) : super(key: key);

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

final GlobalKey<State> addRdvStep1Key = GlobalKey<State>();
final GlobalKey<State> dashboardKey = GlobalKey<State>();

class _NavigationBottomState extends State<NavigationBottom> {
  List<Widget> _buildScreen() {
    return [
      BulletinsScreen(loginResponse: widget.loginResponse,),
      const DoctorsScreen(),
      const AppointmentsScreen(),
      const NotificationsScreen(),
      const ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem() {
    return [
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.white,
        icon: Iconify(
          selectedIndex == 0 ? Ci.home_fill : Ci.home_outline,
          color: Colors.white,
        ),
      ),
      PersistentBottomNavBarItem(
          activeColorPrimary: Colors.white,
          icon: Iconify(
            Carbon.stethoscope,
            color: Colors.white,
          )),
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.white,
        icon: Icon(
          Icons.calendar_month_rounded,
          color: Colors.white,
        ),
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.white,
        icon: Icon(
          selectedIndex == 3
              ? Icons.notifications_rounded
              : Icons.notifications_outlined,
          color: Colors.white,
        ),
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: Colors.white,
        icon: Iconify(
          selectedIndex == 4 ? Eva.person_fill : Eva.person_outline,
          color: Colors.white,
        ),
      ),
    ];
  }

  int selectedIndex = 0;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = context.themeProvider;
    final tabProvider = Provider.of<TabProvider>(context, listen: false);
    return Container(
      color: themeProvider.ghostWhite,
      child: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: true,
        child: Scaffold(
          body: PersistentTabView(
            context,
            controller: tabProvider.controller,
            screens: _buildScreen(),
            items: _navBarItem(),
            onItemSelected: (int selectedTab) {
              setState(() {
                selectedIndex = selectedTab;
              });
            },
            navBarHeight: 65,
            backgroundColor: themeProvider.blue,
          ),
        ),
      ),
    );
  }
}*/
