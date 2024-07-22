import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/tab_provider.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/views/responsive.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/app_text_styles.dart';
import '../../helper/service_locator.dart';
import '../../models/responses/doctor/list_doctors_response.dart';
import '../../view_models/doctor_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import '../../widgets/custom_search_dropdown_button.dart';
import '../../widgets/custom_search_widgets.dart';
import '../../widgets/error_display_and_refresh.dart';
import '../auth/sign_in_screen.dart';
import 'doc_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../widgets/empty_list_refresh.dart';



class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  late ThemeProvider themeProvider;
  late AppTextStyles appTextStyles;
  late DoctorViewModel doctorViewModel;
  late UserViewModel userViewModel;
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
  List<String> gouvernoratList = [
    "Ariana",
    "Béja",
    "Ben Arous",
    "Bizerte",
    "El Kef",
    "Gabes",
    "Gafsa",
    "Jendouba",
    "Kairouan",
    "Kesserine",
    "Kebili",
    "Mahdia",
    "Manouba",
    "Medenine",
    "Monastir",
    "Nabeul",
    "Sfax",
    "Sidi Bouzid",
    "Siliana",
    "Sousse",
    "Tataouine",
    "Tozeur",
    "Tunis",
    "Zaghouan"
  ];

  String selectedGouvernorat = "";


  String selectedRegion="";
  String selectedSpeciality="";
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _limitPerPage = 30;
  late String? selectedDbValue;
  bool isFiltered=false;
  GlobalKey paginatorKey = GlobalKey();


  @override
  void initState() {
    super.initState();

  }

  Future<void> fetchDoctors(int page, int pageSize) async {
    try {
      selectedDbValue = await getSelectedValue();
      setState(() {
        isLoading = true;
        isError = false;

        // _currentPage = 1;
        // _totalPages = 1;
        // _totalCount = 0;
      });

      final listDoctorsResponse =
       await doctorViewModel.getDoctors(page, pageSize,'backoffice_Gras_2');

      // await doctorViewModel.getDoctors(page, pageSize, selectedDbValue!);
      if (listDoctorsResponse.resCode == 1) {
          doctorsList = listDoctorsResponse.doctors;

        setState(() {
          _totalPages = listDoctorsResponse.totalPages ?? 0;
          _totalCount = listDoctorsResponse.totalCount ?? 0;
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
  }

  Future<String?> getSelectedValue() async {

    if(Responsive.isMobile(context))
      {
        final selectedValueService = locator<SelectedDbValueService>();

        return await selectedValueService.getSelectedValue();
      }else{
      final SelectedDbValueService = "backoffice_Gras_2";
      return SelectedDbValueService;
    }


  }


  // Future<void> fetchDoctors(int page, int pageSize) async {
  //   try {
  //     //ListDoctorsResponse listDoctorsResponse=await doctorViewModel.getDoctors(2,1);
  //     ListDoctorsResponse listDoctorsResponse=await doctorViewModel.getDoctors(page, pageSize,'backoffice_Gras_2');
  //   switch (listDoctorsResponse.resCode) {
  //       case 1:
  //       // retrieve bs list
  //         doctorsList = listDoctorsResponse.doctors;
  //         setState(() {
  //           isLoading = false;
  //           isError = false;
  //         });
  //         break;
  //       case -1:
  //         setState(() {
  //           isError = true;
  //           isLoading = false;
  //         });
  //         break;
  //       default:
  //         setState(() {
  //           isError = true;
  //           isLoading = false;
  //         });
  //     }
  //   } catch (error) {
  //     print("Error: $error");
  //     setState(() {
  //       isError = true;
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> searchDocByName(String docName) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      setState(() {
        isLoading = true;
        isError = false;
        _currentPage = 1;
        _totalPages = 1;
        _totalCount = 0;
      });
      final listDoctorsResponse = await doctorViewModel.searchDoctors(docName, 1, _limitPerPage);
      // final listDoctorsResponse = await doctorViewModel.searchDoctors(
      //
      //     docName, _currentPage, _limitPerPage, selectedDbValue!);

      if (listDoctorsResponse.resCode == 1) {
        setState(() {
          doctorsList = listDoctorsResponse.doctors;
          _totalPages = listDoctorsResponse.totalPages ?? 0;
          _totalCount = listDoctorsResponse.totalCount ?? 0;
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
  }


  Future<void> filterDoctors(String gouvernorat, String specialty) async {
    try {
      setState(() {
        searchController.text = "";
        isLoading = true;
        isError = false;
        _currentPage = 1;
        _totalPages = 1;
        _totalCount = 0;
      });
      final listDoctorsResponse = await doctorViewModel.filterDoctors(gouvernorat, specialty, 1, _limitPerPage);
      //final listDoctorsResponse = await doctorViewModel.filterDoctors(
      //
      //           gouvernorat, specialty, _currentPage, _limitPerPage, selectedDbValue!);

      if (listDoctorsResponse.resCode == 1) {
        setState(() {
          doctorsList = listDoctorsResponse.doctors;
          _totalPages = listDoctorsResponse.totalPages;
          _totalCount = listDoctorsResponse.totalCount;
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
  }

  void _onGouvernoratChanged(String selectedValue) {

    setState(() {

      selectedGouvernorat = selectedValue;

      //selectedDelegation = "";

      //currentDelegationList = delegationData[selectedValue]?? [];

    });

  }

  @override
  Widget build(BuildContext context) {
    doctorViewModel = Provider.of<DoctorViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    fetchDoctors(1,_limitPerPage);
    themeProvider = context.themeProvider;
    appTextStyles = AppTextStyles(context);
    return SafeArea(
      // top: true,
      // left: false,
      // right: false,
      // bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Médecins",
          themeProvider: themeProvider, icon: null,
          trailing: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            onPressed: () {
              userViewModel.performLogout(context);
            },
          ),
        ),
        body: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Responsive.isMobile(context)?SizedBox():SizedBox(height: 40,),
                    Responsive.isMobile(context)?
                    CustomSearchWidgets(
                      controller: searchController,
                      onPressedFilter: ()=>{
                      if (selectedGouvernorat.isNotEmpty || selectedSpeciality.isNotEmpty) {
                      _currentPage=1,
                      paginatorKey = GlobalKey(),
                      filterDoctors(selectedGouvernorat, selectedSpeciality),
                      Navigator.pop(context),
                      }else {
                       Navigator.pop(context),
                      }},
                      onPressedSearch: ()=>{
                        if(searchController.text.isNotEmpty){
                                isFiltered=true,
                                _currentPage=1,
                                paginatorKey = GlobalKey(),
                              setState(() {
                                  }),
                                searchDocByName((searchController.text).trim()),
                        }},
                      searchHint: "Recherche par nom du médecin",
                      body: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomSearchDropdown(
                                  list: gouvernoratList,
                                  themeProvider: themeProvider,
                                  appTextStyles: appTextStyles,
                                  hint: 'Gouvernorat',
                                  notFoundString: 'Aucune',
                                  onValueChanged: _onGouvernoratChanged,
                                ),
                              ),
                            ],
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
                    )
                    :Row(
                      children: [
                        Expanded(flex :2, child: SizedBox()),
                         Expanded(
                           flex : 20,
                           child:CustomSearchWidgets(
                           controller: searchController,
                           onPressedFilter: ()=>{
                             if (selectedGouvernorat.isNotEmpty || selectedSpeciality.isNotEmpty) {
                               _currentPage=1,
                               paginatorKey = GlobalKey(),
                               filterDoctors(selectedGouvernorat, selectedSpeciality),
                               Navigator.pop(context),
                             }else {
                               Navigator.pop(context),
                             }
                           },
                           onPressedSearch: ()=>{
                             if(searchController.text.isNotEmpty){
                               isFiltered=true,
                               _currentPage=1,
                               paginatorKey = GlobalKey(),
                               setState(() {
                               }),
                               searchDocByName((searchController.text).trim()),
                             }},
                           searchHint: "Recherche par nom du médecin",
                           body: null,), ),
                        Expanded(flex : 1 , child: SizedBox()),
                        Expanded(
                            flex: 20,
                            child:  CustomSearchDropdown(
                            list: gouvernoratList,
                            themeProvider: themeProvider,
                            appTextStyles: appTextStyles,
                            hint: 'Gouvernorat',
                            notFoundString: 'Aucune',
                            onValueChanged: _onGouvernoratChanged,
                          ),),
                        Expanded(flex : 1 , child: SizedBox()),

                        Expanded(
                          flex: 20,
                          child: CustomSearchDropdown(
                          list: specialitiesList,
                          themeProvider: themeProvider,
                          appTextStyles: appTextStyles,
                          hint: 'Spécialité',
                          notFoundString: 'Aucune',
                          onValueChanged: (selectedValue) {
                            selectedSpeciality=selectedValue;
                          },
                        ),

                        ),
                        Expanded(flex :2, child: SizedBox()),
                      ],
                    ),

                    Responsive.isMobile(context)?const SizedBox(
                      height: 10,
                    ): const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: isFiltered,
                          child: InkWell(
                            onTap: (){
                              refresh();
                            },
                            child: Text(
                              "Réinitialiser",
                              style: appTextStyles.ateneoBlueMediumUnderlined12,
                            ),
                          ),
                        ),
                        Text(
                          "Résultat: $_totalCount Médecins",
                          style: appTextStyles.ateneoBlueMedium12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Expanded(child: SpinKitCircle(color: themeProvider.blue.withOpacity(0.6), size: 50.0,))
                  : isError
                  ? Expanded(
                child: ErrorDisplayAndRefresh(appTextStyles, themeProvider, () async {
                  setState(() {
                    refresh();
                  });
                }),
              )
                  : Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: refresh,
                      child: doctorsList.isEmpty
                          ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                            height: MediaQuery.of(context).size.height -
                                kToolbarHeight * 6,
                            alignment: Alignment.center,
                            child: Center(
                                child: EmptyListRefresh(
                                    'Aucun médecin n\'a été  trouvé !',
                                    appTextStyles))),
                      )
                          : Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: SizedBox()
                              ),
                              Expanded(
                                flex:20,
                                child: ListView.builder(
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
                              Expanded(
                                  flex: 1,
                                  child: SizedBox()
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
              if(_totalPages>1)
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: NumberPaginator(
                    key: paginatorKey,
                    numberPages: _totalPages,
                    onPageChange: (int index) {
                      _currentPage = index + 1;
                      if (selectedGouvernorat.isNotEmpty || selectedSpeciality.isNotEmpty) {
                        filterDoctors(selectedGouvernorat, selectedSpeciality);
                      } else if (searchController.text.isNotEmpty) {
                        searchDocByName((searchController.text).trim());
                      } else {
                        fetchDoctors(_currentPage, _limitPerPage);
                      }
                    },
                    config: NumberPaginatorUIConfig(
                      //height: 40,
                        buttonShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        buttonSelectedBackgroundColor: themeProvider.ateneoBlue,
                        buttonUnselectedForegroundColor: themeProvider.ateneoBlue
                    ),
                  ),
                ),
            ],
          ),

      ),
    );
  }

  Future<void> refresh() async {
    searchController.text = "";
    selectedSpeciality = "";
    selectedGouvernorat = "";
    setState(() {
      _currentPage=1;
      paginatorKey = GlobalKey();
    });
    // Call appropriate method based on current search/filter state
    if (selectedGouvernorat.isNotEmpty || selectedSpeciality.isNotEmpty) {
      filterDoctors(selectedGouvernorat, selectedSpeciality);
    } else if (searchController.text.isNotEmpty) {
      searchDocByName((searchController.text).trim());
    } else {
      fetchDoctors(1, _limitPerPage);
      isFiltered=false;
    }
  }
}
