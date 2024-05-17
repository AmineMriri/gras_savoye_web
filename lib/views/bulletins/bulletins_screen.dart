import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/extensions/string_extensions.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/bulletin.dart';
import 'package:healio/models/prestation.dart';
import 'package:healio/models/responses/bulletin/list_bulletins_response.dart';
import 'package:healio/view_models/bulletin_view_model.dart';
import 'package:healio/view_models/user_view_model.dart';
import 'package:healio/views/auth/sign_in_screen.dart';
import 'package:healio/views/bulletins/attach_bulletin_screen.dart';
import 'package:healio/views/bulletins/bulletin_list.dart';
import 'package:healio/views/bulletins/bulletins_archive_screen.dart';
import 'package:healio/views/responsive.dart';
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
  //String? name;
  List<Widget> tabs = [];
  late BulletinViewModel bulletinViewModel;
  late UserViewModel userViewModel;
  List<Bulletin> bsList = [];
  List<Bulletin> bsListTraite = [];
  List<Bulletin> bsListEnCours = [];
  Map<String, bool> isLoadingMap = {
    'bsList': true,
    'bsListTraite': true,
    'bsListEnCours': true,
  };

  Map<String, bool> isErrorMap = {
    'bsList': false,
    'bsListTraite': false,
    'bsListEnCours': false,
  };

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
          trailing: Responsive.isMobile(context)?CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            onPressed: () {
              userViewModel.performLogout(context);
            },
          ):null,
          icon: null,
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
        body: isLoadingMap.containsValue(true)
            ? SpinKitCircle(color: themeProvider.blue, size: 50.0)
            : isErrorMap.containsValue(true)
                ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                    () async {
                    setState(() {
                      refreshLists();
                    });
                  })

                : Container(
                  padding:Responsive.isMobile(context)?null:
                  EdgeInsets.symmetric(horizontal: 40),
                  child: TabBarView(
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
        await fetchBS(null, 'bsList');
        await fetchBS('traité', 'bsListTraite');
        await fetchBS('en cours', 'bsListEnCours');
      }
      /*if (userData['name'] != null) {
        name = userData['name'];
      }*/
      setupTabContoller();
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
            customBadge(bsListTraite.length.toString())
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
            customBadge(bsListEnCours.length.toString())
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
      isLoadingMap['bsList'] = true;
      isErrorMap['bsList'] = false;
      isLoadingMap['bsListTraite'] = true;
      isErrorMap['bsListTraite'] = false;
      isLoadingMap['bsListEnCours'] = true;
      isErrorMap['bsListEnCours'] = false;
    });
    // Fetch data for each bulletin list separately
    await fetchBS(null, 'bsList');
    await fetchBS('traité', 'bsListTraite');
    await fetchBS('en cours', 'bsListEnCours');
  }

  Future<void> fetchBS(String? status, String listName) async {
    try {
      List<Bulletin> fetchedList = [];
//       // Fetch bulletin list based on status
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

      switch (bulletinResponse.res_code) {
        case 1:
          fetchedList = bulletinResponse.bulletins;
          break;
        case -1:
          isErrorMap[listName] = true;
          break;
        default:
          isErrorMap[listName] = true;
          break;
      }

      setState(() {
        isLoadingMap[listName] = false;
        if (listName == 'bsList') {
          bsList = fetchedList;
        } else if (listName == 'bsListTraite') {
          bsListTraite = fetchedList;
        } else if (listName == 'bsListEnCours') {
          bsListEnCours = fetchedList;
        }
      });
    } catch (error) {
      print("Error: $error");
      setState(() {
        isErrorMap[listName] = true;
        isLoadingMap[listName] = false;
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
