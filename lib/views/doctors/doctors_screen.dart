import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/app_text_styles.dart';
import '../../models/responses/doctor/list_doctors_response.dart';
import '../../view_models/doctor_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import '../../widgets/custom_search_dropdown_button.dart';
import '../../widgets/custom_search_widgets.dart';
import '../../widgets/error_display_and_refresh.dart';
import '../auth/sign_in_screen.dart';
import 'doc_item.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  late ThemeProvider themeProvider;
  late AppTextStyles appTextStyles;
  late DoctorViewModel doctorViewModel;
  List<Doctor> doctorsList = [];
  bool isLoading = true;
  bool isError = false;
  TextEditingController searchController = TextEditingController();
  List<String> specialitiesList = [
    'Généraliste',
    'ORL',
    'Dentiste',
    'Radiologue',
  ];
  List<String> regionsList = [
    'Ariana',
    'Tunis',
    'Bizerte',
    'Nabeul',
  ];
  String selectedRegion="";
  String selectedSpeciality="";

  @override
  void initState() {
    super.initState();
    doctorViewModel = Provider.of<DoctorViewModel>(context, listen: false);
    fetchDoctors();
  }

  /*Future<void> fetchDoctors(int page, int pageSize) async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
      });

      final listDoctorsResponse =
      await doctorViewModel.getDoctors(page, pageSize);

      if (listDoctorsResponse.res_code == 1) {
        setState(() {
          doctorsList = listDoctorsResponse.doctors;
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }*/


  Future<void> fetchDoctors() async {
    try {
      //ListDoctorsResponse listDoctorsResponse=await doctorViewModel.getDoctors(2,1);
      ListDoctorsResponse listDoctorsResponse=await doctorViewModel.getDoctors();
    switch (listDoctorsResponse.res_code) {
        case 1:
        // retrieve bs list
          doctorsList = listDoctorsResponse.doctors;
          setState(() {
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

  Future<void> searchDocByName(String docName) async {
    try {
      setState(() {
        isError = false;
        isLoading = true;
      });
      ListDoctorsResponse listDoctorsResponse=await doctorViewModel.searchDoctors(docName);
      switch (listDoctorsResponse.res_code) {
        case 1:
        // retrieve bs list
          doctorsList = listDoctorsResponse.doctors;
          setState(() {
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

  Future<void> filterDoctors(String region, String speciality) async {
    try {
      setState(() {
        isError = false;
        isLoading = true;
      });
      ListDoctorsResponse listDoctorsResponse=await doctorViewModel.filterDoctors(region, speciality);
      switch (listDoctorsResponse.res_code) {
        case 1:
        // retrieve bs list
          doctorsList = listDoctorsResponse.doctors;
          setState(() {
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
  Widget build(BuildContext context) {
    themeProvider = context.themeProvider;
    appTextStyles = AppTextStyles(context);
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Médecins",
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
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomSearchWidgets(
                    controller: searchController,
                    onPressedFilter: ()=>{
                      filterDoctors(selectedRegion,selectedSpeciality)
                    },
                    onPressedSearch: ()=>{
                      searchDocByName(searchController.text)
                    },
                    searchHint: "Recherche par nom du médecin",
                    body: Column(
                      children: [
                        CustomSearchDropdown(
                          list: regionsList,
                          themeProvider: themeProvider,
                          appTextStyles: appTextStyles,
                          hint: 'Région',
                          notFoundString: 'Aucune',
                          onValueChanged: (selectedValue) {
                            selectedRegion=selectedValue;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomSearchDropdown(
                          list: specialitiesList,
                          themeProvider: themeProvider,
                          appTextStyles: appTextStyles,
                          hint: 'Spécialité',
                          notFoundString: 'Aucune',
                          onValueChanged: (selectedValue) {
                            selectedSpeciality=selectedValue;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: refresh,
                        child: Text(
                          "Réinitialiser",
                          style: appTextStyles.ateneoBlueMediumUnderlined12,
                        ),
                      ),
                      Text(
                        "Résultat: ${doctorsList.length} Médecins",
                        style: appTextStyles.ateneoBlueMedium12,
                      ),
                    ],
                  )
                ],
              ),
            ),
            isLoading
                ? Expanded(child: SpinKitCircle(color: themeProvider.blue, size: 50.0,))
                : isError
                ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                    () async {
                  setState(() {
                    refresh();
                  });
                })
                : Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: refresh,
                    child: doctorsList.isEmpty
                        ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(
                          'Aucun médecin n\'a été  trouvé!',
                          textAlign: TextAlign.center,
                          style: appTextStyles.blueSemiBold16,
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: doctorsList.length,
                      itemBuilder: (context, index) {
                        final doctor = doctorsList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: DocItem(doctor: doctor),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refresh() async {
    searchController.text="";
    setState(() {
      isLoading = true;
      isError = false;
    });
    await fetchDoctors();
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
