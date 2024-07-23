import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/family_member.dart';
import 'package:healio/views/responsive.dart';
import 'package:healio/widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/app_text_styles.dart';
import '../../helper/date_utils.dart';
import '../../helper/providers/tab_provider.dart';
import '../../helper/service_locator.dart';
import '../../models/responses/user/family_members_response.dart';
import '../../models/responses/user/get_profile_response.dart';
import '../../view_models/user_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';

import '../../widgets/error_display_and_refresh.dart';
import '../auth/sign_in_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserViewModel userViewModel;
  String? userId;
  late Future<void> _userDataFuture;
  bool isLoading=true;
  bool isError=false;
  late GetProfileResponse profileData;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _userDataFuture = initializeUserId();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    return FutureBuilder(
      future: _userDataFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitCircle(
                color: themeProvider.blue.withOpacity(0.6),
                size: 50.0
            ),);
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
    AppTextStyles appTextStyles = AppTextStyles(context);
    final themeProvider = context.themeProvider;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: RefreshIndicator(
        onRefresh: refreshBSDetails,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: Responsive.isDesktop(context)?null:CustomAppBar(

            title: "Mon Profil",
            icon: null,
            trailing: CustomAppBarButton(
              iconData: Icons.logout_rounded,
              themeProvider: themeProvider,
              onPressed: () {
                userViewModel.performLogout(context);
              },
            ),
            themeProvider: themeProvider,
          ),
          body: isLoading ? Center(
            child: SpinKitCircle(
                color: themeProvider.blue.withOpacity(0.6),
                size: 50.0
            ),
          )
              : isError
              ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                  () async {
                    setState(() {
                      refreshBSDetails();
                    });
              })
              : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 110,
                    ),
                    ///HEADING
                    Center(
                      child: Column(
                        children: [
                          Text(
                            profileData.name!,
                            style: appTextStyles.ateneoBlueBold20,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Matricule: ${profileData.matricule!}",
                            style: appTextStyles.graniteGreyRegular14,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomCard(
                      appTextStyles,
                      themeProvider,
                      "Etablissement",
                      Text(
                        profileData.etablissement!,
                        style: appTextStyles.graniteGreyRegular14,
                      ),
                      null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomCard(
                      appTextStyles,
                      themeProvider,
                      "Assurance",
                      Text(
                        profileData.assurance!,
                        style: appTextStyles.graniteGreyRegular14,
                      ),
                      null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomCard(
                      appTextStyles,
                      themeProvider,
                      "Informations personnelles",
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.cake_rounded,
                                color: themeProvider.graniteGrey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "${formatDate(profileData.birthdate!)} / ${calculateAge(profileData.birthdate!)} ans",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email_rounded,
                                color: themeProvider.graniteGrey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                profileData.login!,
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: profileData.conjoint!=null,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: CustomCard(
                          appTextStyles,
                          themeProvider,
                          "Conjoint",
                          Text(
                            profileData.conjoint!.name,
                            style: appTextStyles.graniteGreyRegular14,
                          ),
                          null,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: profileData.enfants!=null && profileData.enfants!.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: CustomCard(
                          appTextStyles,
                          themeProvider,
                          "Enfants",
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: profileData.enfants!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final enfant = profileData.enfants![index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.boy_rounded,
                                        color: themeProvider.graniteGrey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "${enfant.name} (${formatDate(enfant.birthdate)})",
                                        style: appTextStyles.graniteGreyRegular14,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          null,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: profileData.parent!=null && profileData.parent!.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: CustomCard(
                          appTextStyles,
                          themeProvider,
                          "Parents",
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: profileData.parent!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final parent = profileData.parent![index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.family_restroom_rounded,
                                        color: themeProvider.graniteGrey,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "${parent.name} (${formatDate(parent.birthdate)})",
                                        style: appTextStyles.graniteGreyRegular14,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          null,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> refreshBSDetails() async {
    print("refreshed profile !!!!");
    setState(() {
      isLoading = true;
      isError = false;
    });
    await fetchProfile();
  }

//   Future<void> fetchProfile() async {
//     try {
//       // GetProfileResponse getProfileResponse=await userViewModel.getProfile(int.parse(userId!));
//       // print(getProfileResponse.res_code);
//       // print(getProfileResponse.matricule);
//       // print(getProfileResponse.name);
//       // print(getProfileResponse.etablissement);
//       // print(getProfileResponse.assurance);
//       // print(getProfileResponse.birthdate);
//       // print(getProfileResponse.login);
//       // print(getProfileResponse.conjoint);
//       // print(getProfileResponse.enfants);
//       // print(getProfileResponse.parent);
// /*
// I/flutter (28878): 1
// matricule1101
// I/flutter (28878): MOHAMED SAHRAOUI
// I/flutter (28878): BENETTON INDUSTRIELLE TUNISIE SARL
// I/flutter (28878): BH ASSURANCES
// I/flutter (28878): 1973-01-15
// I/flutter (28878): meriambenida@gmail.com
// I/flutter (28878): Family member: {name: SONIA ELJEBRI SAHRAOUI, birthdate: 1978-07-10}
// I/flutter (28878): [Family member: {name: MARIEM SAHRAOUI, birthdate: 2006-06-17}, Family member: {name: MARAM SAHRAOUI, birthdate: 2006-06-17}, Family member: {name: NERMINE SAHRAOUI, birthdate: 2008-12-03}, Family member: {name: SIRINE SAHRAOUI, birthdate: 2014-12-24}, Family member: {name: TAHA SAHRAOUI, birthdate: 2016-07-15}]
// I/flutter (28878): []
// * */
//       GetProfileResponse getProfileResponse = GetProfileResponse(
//         res_code: 1,
//         matricule: "1101",
//         name: "MOHAMED SAHRAOUI",
//         etablissement: "BENETTON INDUSTRIELLE TUNISIE SARL",
//         assurance: "BH ASSURANCES",
//         birthdate: "1973-01-15",
//         login: "meriambenida@gmail.com",
//         conjoint: FamilyMember(
//             name: "SONIA ELJEBRI SAHRAOUI",
//             birthdate: "1978-07-10"
//         ),
//         enfants: [
//           FamilyMember(name: "Mariem SAHRAOUI", birthdate: "2006-06-17"),
//           FamilyMember(name: "MARAM SAHRAOUI", birthdate: "2006-06-17"),
//           FamilyMember(name: "NERMINE SAHRAOUI", birthdate: "2008-12-03"),
//           FamilyMember(name: "SIRINE SAHRAOUI", birthdate: "2014-12-24"),
//           FamilyMember(name: "TAHA SAHRAOUI", birthdate: "2016-07-15"),
//
//         ],
//         parent: [],
//       );
//       switch (getProfileResponse.res_code) {
//         case 1:
//           profileData=getProfileResponse;
//           // retrieve profile
//           print("success profile");
//           setState(() {
//             isLoading=false;
//             isError=false;
//           });
//           break;
//         case -1:
//           print("bad request profile");
//           setState(() {
//             isError=true;
//             isLoading=false;
//           });
//           break;
//         default:
//           print("Internal server error profile");
//           setState(() {
//             isError=true;
//             isLoading=false;
//           });
//       }
//     } catch (error) {
//       print("Error: $error");
//       print("fetch profile");
//
//       setState(() {
//         isError = true;
//         isLoading = false;
//       });
//     }
//   }

  String? getSelectedValue()  {

    if(Responsive.isMobile(context) && !kIsWeb)
    {
      final selectedValueService = locator<SelectedDbValueService>();
      return selectedValueService.selectedValue;
    }else{
      final SelectedDbValueService = "backoffice_Gras_2";
      return SelectedDbValueService;
    }
  }

  Future<void> fetchProfile() async {
    try {
      GetProfileResponse getProfileResponse=await userViewModel.getProfile(int.parse(userId!), getSelectedValue()!);
      FamilyMembersResponse familyMembersResponse=await userViewModel.getFamilyMembers(int.parse(userId!), getSelectedValue()!);
      switch (getProfileResponse.resCode) {
        case 1:
          profileData=getProfileResponse;
          // retrieve profile
          print("success profile");
          setState(() {
            isLoading=false;
            isError=false;
          });
          break;
        case -1:
          print("bad request profile");
          setState(() {
            isError=true;
            isLoading=false;
          });
          break;
        default:
          print("Internal server error profile");
          setState(() {
            isError=true;
            isLoading=false;
          });
      }
    } catch (error) {
      print("Error: $error");
      print("fetch profile");

      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<String?> getUserDataFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    return id;
  }

  Future<void> initializeUserId() async {
    print("testing_states: initializeUserId");
    String? id = await getUserDataFromSharedPref();
    userId = id;
    fetchProfile();
  }

  int calculateAge(String birthDateString) {
    // Parse the birthdate string into a DateTime object
    DateTime birthDate = DateTime.parse(birthDateString);

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in years between the current date and the birthdate
    int age = currentDate.year - birthDate.year;

    // Adjust the age if the birthdate hasn't occurred yet this year
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }

    // Return the calculated age
    return age;
  }

}
