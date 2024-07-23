import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/bulletin.dart';
import 'package:healio/models/prestation.dart';
import 'package:healio/models/responses/bulletin/list_bulletins_response.dart';
import 'package:healio/view_models/bulletin_view_model.dart';
import 'package:healio/view_models/user_view_model.dart';
import 'package:healio/views/bulletins/attach_bulletin_screen.dart';
import 'package:healio/views/bulletins/bulletin_list.dart';
import 'package:healio/views/responsive.dart';
import 'package:healio/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/app_text_styles.dart';
import '../../helper/service_locator.dart';
import '../../models/responses/user/family_members_response.dart';
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


  // List<Widget> tabs = [];
  late BulletinViewModel bulletinViewModel;
  late UserViewModel userViewModel;
  List<Bulletin> bsList = [];
  late AppTextStyles appTextStyles;
  bool isLoading = true;
  bool isError = false;
//////////////////////////////////
  Map<int, String> listBenef = {};
  bool isLoadingFamily = true;
  bool isErrorFamily = false;
  late String? selectedDbValue;
  int countBsOngoing = 0;
  int countBsHandled = 0;
  int countBsTotal = 0;

  @override
  void initState() {
    super.initState();
    bulletinViewModel = Provider.of<BulletinViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    //////////////////////////////////
    // tabs = getTabs();
    _tabController = TabController(length: 3, vsync: this);
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {

   ///////////////////////
    // Map<String, dynamic>? userData;
    // if (widget.loginResponse != null) {
    //   userData = getUserDataFromPreviousScreen();
    // } else {
    //   userData = await getUserDataFromSharedPref();
    // }
    selectedDbValue = await getSelectedValue();
    Map<String, dynamic>? userData = await getUserDataFromSharedPref();


    if (userData != null && userData['id'] != null) {
      userId = userData['id'];
      setupTabController();
      // Fetch data for the first tab initially
      await fetchBSForSelectedTab(0);
    }
  }
///////////////////////
  Map<String, dynamic>? getUserDataFromPreviousScreen() {
    String? id = widget.loginResponse!.id;
    String? name = widget.loginResponse!.name;

    Map<String, dynamic> userData = {};
    if (id != null) {
      userData['id'] = id;
    }
    if (name != null) {
      userData['name'] = name;
    }

    return userData.isNotEmpty ? userData : null;
  }


  Future<Map<String, dynamic>?> getUserDataFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    String? name = prefs.getString('name');
//////////////////
  //   Map<String, dynamic> userData = {};
  //
  //   if (id != null) {
  //     userData['id'] = id;
  //   }
  //
  //   if (name != null) {
  //     userData['name'] = name;
  //   }
  //
  //   return userData.isNotEmpty ? userData : null;
  // }
    if (id == null && name == null) {
      return null;
    }

    return {'id': id, 'name': name};
  }

  void setupTabController() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          isLoading = true;
          isError = false;
          isLoadingFamily = true;

          isErrorFamily = false;
        });
        fetchBSForSelectedTab(_tabController.index);
      }
    });
  }

  Future<void> fetchBSForSelectedTab(int index) async {
    String? status;
    switch (index) {
      case 0:
        status = 'traité';
        break;
      case 1:
        status = 'en cours';
        break;
      default :
        status = null;
        break;
    }
    await fetchBS(status);
    await fetchFamilyMembers();
  }
  Future<void> fetchFamilyMembers() async {
    try {
      FamilyMembersResponse familyResponse = await userViewModel.getFamilyMembers(int.parse(userId!), selectedDbValue!);
      if (familyResponse.resCode == 1) {
        setState(() {
          listBenef = {
            if (familyResponse.name != null) familyResponse.id!: familyResponse.name!,
            if (familyResponse.conjoint != null) familyResponse.conjointId!: familyResponse.conjoint!,
            ...{for (var child in familyResponse.children!) child.id: child.name},
            ...{for (var parent in familyResponse.parents!) parent.id: parent.name},
          };
          isLoadingFamily = false;
          isErrorFamily = false;
        });
      } else {
        setState(() {
          isLoadingFamily = false;
          isErrorFamily = true;
        });
      }
    } catch (e) {
      print("Error fetching family members: $e");
      setState(() {
        isLoadingFamily = false;
        isErrorFamily = true;
      });
    }
  }


  Future<void> fetchBS(String? status) async {
    try {
      ListBulletinsResponse bulletinResponse = await bulletinViewModel.getBulletinsByStatus(userId!, status?.trim().toLowerCase(), selectedDbValue!);



      setState(() {
        if (bulletinResponse.resCode == 1) {
          bsList = bulletinResponse.bulletins;

          countBsOngoing = bulletinResponse.totalEnCours ?? 0;
          countBsHandled = bulletinResponse.totalTraite ?? 0;
          countBsTotal = bulletinResponse.totalAll ?? 0;

          isLoading = false;
          isError = false;
        } else {
          isLoading = false;
          isError = true;
        }
      });
    } catch (error) {
      print("Error: $error");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  List<Widget> getTabs() {
    return [
      Tab(
        child: Row(
          children: [
            Text("Traité"),
            const SizedBox(width: 5),
            customBadge("0"), // Placeholder badge count
          ],
        ),
      ),
      Tab(
        child: Row(
          children: [
            Text("En Cours"),
            const SizedBox(width: 5),
            customBadge("0"), // Placeholder badge count
          ],
        ),
      ),
      Tab(
        child: Row(
          children: [
            Text("Tous"),
            const SizedBox(width: 5),
            customBadge("0"), // Placeholder badge count
          ],
        ),
      ),
    ];
  }

  Widget customBadge(String content) {
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
      badgeStyle: const badges.BadgeStyle(badgeColor: Color(0xff002891)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = context.themeProvider;
    appTextStyles = AppTextStyles(context);
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Mes Bulletins",
          themeProvider: themeProvider,
          tabBar: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: themeProvider.ateneoBlue,
            labelColor: themeProvider.ateneoBlue,
            unselectedLabelColor: themeProvider.cadetGrey,
            tabs: getTabs(),
            tabAlignment: TabAlignment.center,
          ),
          trailing: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            onPressed: () {
              userViewModel.performLogout(context);
            },
          ),
          icon: null,
        ),
        body: isLoading
            ? SpinKitCircle(
            color: themeProvider.blue.withOpacity(0.6), size: 50.0)
            : isError
            ? ErrorDisplayAndRefresh(appTextStyles, themeProvider, () async {
          setState(() {
            isLoading = true;
            isError = false;
          });
          await fetchBSForSelectedTab(_tabController.index);
        })
            :
        BulletinList(
          bsList: bsList,
          onRefresh: () async {
            setState(() {
              isLoading = true;
              isError = false;
            });
            await fetchBSForSelectedTab(_tabController.index);
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: themeProvider.ateneoBlue,
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AttachBulletinScreen()));
          },
          child: const Icon(
            Icons.attach_file_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Future<String?> getSelectedValue() async {

    if(Responsive.isMobile(context) && !kIsWeb)
    {
      final selectedValueService = locator<SelectedDbValueService>();

      return await selectedValueService.getSelectedValue();
    }else{
      final SelectedDbValueService = "backoffice_Gras_2";
      return SelectedDbValueService;
    }
  }



}
