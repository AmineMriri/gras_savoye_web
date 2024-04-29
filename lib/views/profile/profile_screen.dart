import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/app_text_styles.dart';
import '../../helper/date_utils.dart';
import '../../models/responses/user/get_profile_response.dart';
import '../../view_models/user_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import 'package:intl/intl.dart';

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
                color: themeProvider.blue,
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
          appBar: CustomAppBar(
            title: "Mon Profil",
            icon: CustomAppBarButton(
              iconData: Icons.logout_rounded,
              themeProvider: themeProvider,
              isTransform: true,
              onPressed: () {
                performLogout();
              },
            ),
            themeProvider: themeProvider,
          ),
          body: isLoading ? Center(
            child: SpinKitCircle(
                color: themeProvider.blue,
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
                      height: 40,
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

  Future<void> fetchProfile() async {
    try {
      GetProfileResponse getProfileResponse=await userViewModel.getProfile(int.parse(userId!));
      switch (getProfileResponse.res_code) {
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
