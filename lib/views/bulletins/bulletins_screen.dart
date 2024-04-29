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
  String? conjoint;
  bool? hasChildren;
  bool? hasParents;
  List<Widget> tabs = [];
  late BulletinViewModel bulletinViewModel;
  late UserViewModel userViewModel;
  List<Bulletin> bsList = [];
  List<Bulletin> bsListAdherent = [];
  List<Bulletin> bsListConjoint = [];
  List<Bulletin> bsListChildren = [];
  List<Bulletin> bsListParents = [];
  int tabAdherentCount = 0;
  int tabConjointCount = 0;
  int tabEnfantsCount = 0;
  int tabParentsCount = 0;
  bool isLoading = true;
  bool isError = false;
  late Future<void> _userDataFuture;
  late ThemeProvider themeProvider;
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
    themeProvider = context.themeProvider;
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
        appBar: CustomAppBar(
          title: "Mes Bulletins",
          icon: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            isTransform: true,
            onPressed: () {
              performLogout();
            },
          ),
          themeProvider: themeProvider,
          tabBar: conjoint != null ||
                  (hasChildren != null && hasChildren!) ||
                  (hasParents != null && hasParents!)
              ? TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  indicatorColor: themeProvider.ateneoBlue,
                  labelColor: themeProvider.ateneoBlue,
                  unselectedLabelColor: themeProvider.cadetGrey,
                  tabs: tabs,
                  tabAlignment: TabAlignment.center,
                )
              : null,
          trailing: CustomAppBarButton(
            iconData: Icons.archive_rounded,
            themeProvider: themeProvider,
            isTransform: false,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BulletinsArchiveScreen()));
            },
          ),
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
                    children: getListsBS(),
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
      int counter = 1;
      if (userData['name'] != null) {
        name = userData['name'];
      }
      if (userData['conjoint'] != null) {
        conjoint = userData['conjoint'];
        counter++;
      }
      if (userData['children'] != null) {
        hasChildren = userData['children'];
        if (hasChildren!) {
          counter++;
        }
      }
      if (userData['parents'] != null) {
        hasParents = userData['parents'];
        if (hasParents!) {
          counter++;
        }
      }
      setupTabContoller(counter);
    }
  }

  Map<String, dynamic>? getUserDataFromPreviousScreen() {
    String? id;
    String? name;
    String? conjoint;
    bool? hasChildren;
    bool? hasParents;
    if (widget.loginResponse!.id != null) {
      id = widget.loginResponse!.id!;
    }
    if (widget.loginResponse!.name != null) {
      name = widget.loginResponse!.name!;
    }
    if (widget.loginResponse!.conjoint != null) {
      conjoint = widget.loginResponse!.conjoint;
    }
    if (widget.loginResponse!.child != null) {
      hasChildren = widget.loginResponse!.child!;
    }
    if (widget.loginResponse!.parent != null) {
      hasParents = widget.loginResponse!.parent;
    }
    Map<String, dynamic> userData = {};
    if (id != null) {
      userData['id'] = id;
    }
    if (name != null) {
      userData['name'] = name;
    }
    if (conjoint != null) {
      userData['conjoint'] = conjoint;
    }
    if (hasChildren != null) {
      userData['children'] = hasChildren;
    }
    if (hasParents != null) {
      userData['parents'] = hasParents;
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
    String? conjoint = prefs.getString('conjoint');
    bool? hasChildren = prefs.getBool('children');
    bool? hasParents = prefs.getBool('parents');

    Map<String, dynamic> userData = {};

    if (id != null) {
      userData['id'] = id;
    }

    if (name != null) {
      userData['name'] = name;
    }

    if (conjoint != null) {
      userData['conjoint'] = conjoint;
    }

    if (hasChildren != null) {
      userData['children'] = hasChildren;
    }

    if (hasParents != null) {
      userData['parents'] = hasParents;
    }

    if (userData.isNotEmpty) {
      return userData;
    } else {
      return null;
    }
  }

  List<Widget> getTabs() {
    List<Widget> tabs = [];
    if (name != null) {
      tabs.add(
        Tab(
          child: Row(
            children: [
              Text(name!.toLowerCase().capitalize()),
              const SizedBox(width: 5),
              customBadge(tabAdherentCount.toString())
            ],
          ),
        ),
      );
    }
    if (conjoint != null) {
      tabs.add(
        Tab(
          child: Row(
            children: [
              Text(conjoint!.toLowerCase().capitalize()),
              const SizedBox(width: 5),
              customBadge(tabConjointCount.toString())
            ],
          ),
        ),
      );
    }
    if (hasChildren != null && hasChildren!) {
      tabs.add(
        Tab(
          child: Row(
            children: [
              const Text("Mes enfants"),
              const SizedBox(width: 5),
              customBadge(tabEnfantsCount.toString())
            ],
          ),
        ),
      );
    }
    if (hasParents != null && hasParents!) {
      tabs.add(
        Tab(
          child: Row(
            children: [
              const Text("Mes parents"),
              const SizedBox(width: 5),
              customBadge(tabParentsCount.toString())
            ],
          ),
        ),
      );
    }
    return tabs;
  }

  void setupTabContoller(int count) {
    tabs = getTabs();
    _tabController = TabController(length: count, vsync: this);
  }

  List<Widget> getListsBS() {
    List<Widget> tabs = [
      BulletinList(
        bsList: bsListAdherent,
        type: 'adherent',
        onRefresh: refreshLists,
      )
    ];
    if (conjoint != null) {
      tabs.add(BulletinList(
        bsList: bsListConjoint,
        type: 'conjoint',
        onRefresh: refreshLists,
      ));
    }
    if (hasChildren != null && hasChildren!) {
      tabs.add(BulletinList(
        bsList: bsListChildren,
        type: 'enfants',
        onRefresh: refreshLists,
      ));
    }
    if (hasParents != null && hasParents!) {
      tabs.add(BulletinList(
        bsList: bsListParents,
        type: 'parent',
        onRefresh: refreshLists,
      ));
    }
    return tabs;
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

  Future<void> refreshLists() async {
    setState(() {
      isLoading = true;
      isError = false;
      //reset tabs counts
      tabAdherentCount = 0;
      tabConjointCount = 0;
      tabEnfantsCount = 0;
      tabParentsCount = 0;
      //clear lists
      bsListAdherent.clear();
      bsListConjoint.clear();
      bsListChildren.clear();
      bsListParents.clear();
    });
    await fetchBS();
  }

  Future<void> fetchBS() async {
    try {
      ListBulletinsResponse bulletinResponse =
          await bulletinViewModel.getBulletins(userId!);
      switch (bulletinResponse.res_code) {
        case 1:
          // retrieve bs list
          bsList = bulletinResponse.bulletins;
          int counter = 1;
          setState(() {
            categorizeBSLists();
            tabAdherentCount = bsListAdherent.length;
            tabConjointCount = bsListConjoint.length;
            tabEnfantsCount = bsListChildren.length;
            tabParentsCount = bsListParents.length;
            if (tabConjointCount > 0) {
              counter++;
            }
            if (tabEnfantsCount > 0) {
              counter++;
            }
            if (tabParentsCount > 0) {
              counter++;
            }
            setupTabContoller(counter);
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

  categorizeBSLists() {
    for (var bulletin in bsList) {
      switch (bulletin.prestataire.toLowerCase()) {
        case 'adherent':
          bsListAdherent.add(bulletin);
          break;
        case 'conjoint':
          bsListConjoint.add(bulletin);
          break;
        case 'enfants':
          bsListChildren.add(bulletin);
          break;
        case 'parent':
          bsListParents.add(bulletin);
          break;
        default:
          break;
      }
    }
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
      badgeStyle: const badges.BadgeStyle(badgeColor: Color(0xff9CA3AF)),
    );
  }
}
