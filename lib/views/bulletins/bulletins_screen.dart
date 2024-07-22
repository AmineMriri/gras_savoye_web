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
  List<Widget> tabs = [];
  late BulletinViewModel bulletinViewModel;
  late UserViewModel userViewModel;
  List<Bulletin> bsList = [];
  late AppTextStyles appTextStyles;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    bulletinViewModel = Provider.of<BulletinViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
     tabs = getTabs();
    _tabController = TabController(length: 3, vsync: this);
     _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    Map<String, dynamic>? userData;
    if (widget.loginResponse != null) {
      userData = getUserDataFromPreviousScreen();
    } else {
      userData = await getUserDataFromSharedPref();
    }

    if (userData != null && userData['id'] != null) {
      userId = userData['id'];
      setupTabController();
      // Fetch data for the first tab initially
      await fetchBSForSelectedTab(0);
    }
// =======
    // if (widget.loginResponse != null) {
    //   userData = getUserDataFromPreviousScreen();
    // } else {
    //   userData = await getUserDataFromSharedPref();
    // }
    // if (userData != null) {
    //   if (userData['id'] != null) {
    //     userId = userData['id'];
    //     fetchBS();
    //   }
    //   if (userData['name'] != null) {
    //     name = userData['name'];
    //   }
    //   setupTabContoller();
    // }
    // fetchBS();
    // setupTabContoller();
// >>>>>>> web
  }

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

    Map<String, dynamic> userData = {};

    if (id != null) {
      userData['id'] = id;
    }

    if (name != null) {
      userData['name'] = name;
    }

    return userData.isNotEmpty ? userData : null;
  }

  void setupTabController() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          isLoading = true;
          isError = false;
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
      case 2:
        status = null;
        break;
    }
    await fetchBS(status);
  }

  Future<void> fetchBS(String? status) async {
    try {
      List<Bulletin> fetchedList = [];
//        Fetch bulletin list based on status
//       ListBulletinsResponse bulletinResponse = status == null
//           ? await bulletinViewModel.getBulletins(userId!)
//           : await bulletinViewModel.getBulletinsByStatus(userId!, status.trim().toLowerCase());

      ListBulletinsResponse bulletinResponse = ListBulletinsResponse(
        res_code: 1,
        bulletins: [
          /// MOHAMED
          Bulletin(
            bsId: 490259,
            numBs: "240001550",
            dateMaladie: DateTime(2024, 04, 01).toString(),
            dateReglement: '',
            patient: "SAHRAOUI MOHAMED",
            prestataire: "adherent",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 350.0,
            totalPec: 212.0,
            state: "En cours",
            isCV: false, 
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],
          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "adherent",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "adherent",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "adherent",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "adherent",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "adherent",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "adherent",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          ///SONIA
          Bulletin(
            bsId: 490259,
            numBs: "240001550",
            dateMaladie: DateTime(2024, 04, 01).toString(),
            dateReglement: '',
            patient: "SAHRAOUI MOHAMED",
            prestataire: "conjoint",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 350.0,
            totalPec: 212.0,
            state: "En cours",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "conjoint",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "conjoint",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "conjoint",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "conjoint",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "conjoint",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "conjoint",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          /// ENFANT
          Bulletin(
            bsId: 490259,
            numBs: "240001550",
            dateMaladie: DateTime(2024, 04, 01).toString(),
            dateReglement: '',
            patient: "SAHRAOUI MOHAMED",
            prestataire: "enfant",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 350.0,
            totalPec: 212.0,
            state: "En cours",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "enfants",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "enfants",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "enfants",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "enfants",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "enfants",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),
          Bulletin(
            bsId: 250563,
            numBs: "1708700",
            dateMaladie: DateTime(2023, 12, 21).toString(),
            dateReglement: DateTime(2024, 2, 16).toString(),
            patient: "SAHRAOUI MOHAMED",
            prestataire: "enfants",
            adherent: "SAHRAOUI MOHAMED",
            totalDep: 210.647,
            totalPec: 177.582,
            state: "Traité",
            isCV: false,
            prestations: [Prestation(discipline: "pharmacie", prestationName: "pharmacie", montant: 999.999, pec: 999.999)],

          ),

        ],
      );


      setState(() {
        if (bulletinResponse.res_code == 1) {
          bsList = bulletinResponse.bulletins;
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
            tabs: tabs,
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
            ? SpinKitCircle(color: themeProvider.blue.withOpacity(0.6), size: 50.0)
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
}

