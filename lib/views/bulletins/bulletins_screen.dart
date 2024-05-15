import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/extensions/string_extensions.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/bulletin.dart';
import 'package:healio/models/responses/bulletin/list_bulletins_response.dart';
import 'package:healio/view_models/bulletin_view_model.dart';
import 'package:healio/view_models/user_view_model.dart';
import 'package:healio/views/auth/sign_in_screen.dart';
import 'package:healio/views/bulletins/attach_bulletin_screen.dart';
import 'package:healio/views/bulletins/bulletin_list.dart';
import 'package:healio/views/bulletins/bulletins_archive_screen.dart';
import 'package:healio/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/app_text_styles.dart';
import '../../helper/providers/tab_provider.dart';
import '../../models/responses/user/login_response.dart';
import '../../widgets/custom_appbar_button.dart';
import '../../widgets/error_display_and_refresh.dart';
import 'package:badges/badges.dart' as badges;

class BulletinsScreen extends StatefulWidget {
  final LoginResponse? loginResponse;

  const BulletinsScreen({Key? key, this.loginResponse}) : super(key: key);

  @override
  State<BulletinsScreen> createState() => _BulletinsScreenState();
}

class _BulletinsScreenState extends State<BulletinsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? userId;
  String? name;
  List<Widget> tabs = [];
  late BulletinViewModel bulletinViewModel;
  late UserViewModel userViewModel;
  List<Bulletin> bsList = [];
  bool isLoading = true;
  bool isError = false;
  late Future<void> _userDataFuture;
  late AppTextStyles appTextStyles;

  @override
  void initState() {
    super.initState();
    bulletinViewModel = Provider.of<BulletinViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _userDataFuture = initializeUserData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = context.themeProvider;
    appTextStyles = AppTextStyles(context);
    return FutureBuilder(
      future: _userDataFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(color: themeProvider.blue, size: 50.0),
          );
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          // build UI using data from initializeUserData()
          return buildUI();
        }
      },
    );
  }

  Widget buildUI() {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: themeProvider.ghostWhite,
        appBar: CustomAppBar(
          title: "Mes Bulletins",
          themeProvider: themeProvider,
          tabBar: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorColor: themeProvider.ateneoBlue,
                  labelColor: themeProvider.ateneoBlue,
                  unselectedLabelColor: themeProvider.cadetGrey,
                  tabs: tabs,
                  tabAlignment: TabAlignment.center,
                ),
          trailing: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            onPressed: () {
              userViewModel.performLogout(context);
            },
          ), icon: null,
          /*trailing: CustomAppBarButton(
            iconData: Icons.archive_rounded,
            themeProvider: themeProvider,
            //isTransform: false,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BulletinsArchiveScreen()));
            },
          ),*/
        ),
        body: isLoading
            ? SpinKitCircle(color: themeProvider.blue, size: 50.0)
            : isError
                ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                    () async {
                    setState(() {
                      refreshLists();
                    });
                  })
                : TabBarView(
                    controller: _tabController,
                    children: [
                      BulletinList(
                        bsList: bsList,
                        onRefresh: refreshLists,
                      ),
                      BulletinList(
                        bsList: bsList,
                        onRefresh: refreshLists,
                      ),
                      BulletinList(
                        bsList: bsList,
                        onRefresh: refreshLists,
                      ),
                    ],
                  ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: themeProvider.ateneoBlue,
          elevation: 0,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const AttachBulletinScreen()));
          },
          child: const Icon(
            Icons.attach_file_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> initializeUserData() async {
    Map<String, dynamic>? userData;
    if (widget.loginResponse != null) {
      userData = getUserDataFromPreviousScreen();
    } else {
      userData = await getUserDataFromSharedPref();
    }
    if (userData != null) {
      if (userData['id'] != null) {
        userId = userData['id'];
        fetchBS();
      }
      if (userData['name'] != null) {
        name = userData['name'];
      }
      setupTabContoller();
    }
  }

  Map<String, dynamic>? getUserDataFromPreviousScreen() {
    String? id;
    String? name;
    if (widget.loginResponse!.id != null) {
      id = widget.loginResponse!.id!;
    }
    if (widget.loginResponse!.name != null) {
      name = widget.loginResponse!.name!;
    }
    Map<String, dynamic> userData = {};
    if (id != null) {
      userData['id'] = id;
    }
    if (name != null) {
      userData['name'] = name;
    }
    if (userData.isNotEmpty) {
      return userData;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserDataFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? name = prefs.getString('name');

    Map<String, dynamic> userData = {};

    if (id != null) {
      userData['id'] = id;
    }

    if (name != null) {
      userData['name'] = name;
    }

    if (userData.isNotEmpty) {
      return userData;
    } else {
      return null;
    }
  }

  List<Widget> getTabs() {
    List<Widget> tabs = [];
    tabs.add(
      Tab(
        child: Row(
          children: [
            Text("Traité"),
            const SizedBox(width: 5),
            customBadge(bsList.length.toString())
          ],
        ),
      ),
    );
    tabs.add(
      Tab(
        child: Row(
          children: [
            Text("En Cours"),
            const SizedBox(width: 5),
            customBadge(bsList.length.toString())
          ],
        ),
      ),
    );
    tabs.add(
      Tab(
        child: Row(
          children: [
            Text("Tous"),
            const SizedBox(width: 5),
            customBadge(bsList.length.toString())
          ],
        ),
      ),
    );
    return tabs;
  }

  void setupTabContoller() {
    tabs = getTabs();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> refreshLists() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    await fetchBS();
  }

  Future<void> fetchBS() async {
    try {
      ListBulletinsResponse bulletinResponse =
          await bulletinViewModel.getBulletins(userId!);
      //await bulletinViewModel.getBulletinsByStatus(userId!,"en cours");
      switch (bulletinResponse.res_code) {
        case 1:
          // retrieve bs list
          bsList = bulletinResponse.bulletins;
          int counter = 1;
          setState(() {
            setupTabContoller();
            isLoading = false;
            isError = false;
          });
          break;
        case -1:
          setState(() {
            isError = true;
            isLoading = false;
          });
          break;
        default:
          setState(() {
            isError = true;
            isLoading = false;
          });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget customBadge(
    String content,
  ) {
    return badges.Badge(
      badgeContent: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
      badgeStyle: const badges.BadgeStyle(badgeColor:  Color(0xff035EF7)),
    );
  }
}
