import 'dart:math';
import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/views/doctors/doc_item.dart';
import '../../helper/app_text_styles.dart';
import '../../widgets/custom_search_dropdown_button.dart';
import '../../widgets/custom_search_widgets.dart';

class DocsList extends StatefulWidget {
  List<Doctor> doctorsList;
  Future<void> Function() onRefresh;

  DocsList(
      {super.key,
        required this.doctorsList,
        required this.onRefresh});

  @override
  State<DocsList> createState() => _DocsListState();
}

class _DocsListState extends State<DocsList> {
  List<Doctor> filteredDoctorsList = [];
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

  @override
  void initState() {
    super.initState();
    filteredDoctorsList.addAll(widget.doctorsList);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return filteredDoctorsList.isEmpty
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
        : Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomSearchWidgets(
                onChanged: (query) {
                  //_filterDocsList(query);
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
                        print('Selected region value: $selectedValue');
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
                        print('Selected speciality value: $selectedValue');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Résultat: ${filteredDoctorsList.length} Médecins",
                style: appTextStyles.ateneoBlueMedium12,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: widget.onRefresh,
                child: ListView.builder(
                  itemCount: filteredDoctorsList.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctorsList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: DocItem(doctor: doctor),
                    );
                  },
                ),
              ),
              /*if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),*/
            ],
          ),
        ),
      ],
    );
  }

  /*void _filterDocsList(String query) {
    filteredDocsList.clear();
    if (query.isNotEmpty) {
      filteredDocsList.addAll(widget.docsList
          .where((bs) => bs.numBs.toLowerCase().contains(query.toLowerCase())));
    } else {
      filteredDocsList.addAll(widget.docsList);
    }
  }*/

  bool generateRandomBool() {
    Random random = Random();
    return random.nextBool();
  }
}
