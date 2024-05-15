import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/appointments/apt_item.dart';
import 'package:healio/widgets/custom_date_picker.dart';

import '../../helper/app_text_styles.dart';
import '../../widgets/custom_search_dropdown_button.dart';
import '../../widgets/custom_search_widgets.dart';

class AppointmentsList extends StatefulWidget {
  const AppointmentsList({super.key});

  @override
  State<AppointmentsList> createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList> {
  String? _selectedSpecialityValue;
  List<String> specialitiesList = [
    'Généraliste',
    'ORL',
    'Dentiste',
    'Radiologue',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomSearchWidgets(
                onChanged: (query) {
                  //_filterAptsList(query);
                },
                searchHint: "Recherche par nom du médecin",
                onPressedFilter: (){},
                body: Column(
                  children: [
                    CustomSearchDropdown(
                      list: specialitiesList,
                      themeProvider: themeProvider,
                      appTextStyles: appTextStyles,
                      hint: 'Spécialité',
                      notFoundString: 'Aucune',
                      onValueChanged: (selectedValue) {
                        _selectedSpecialityValue=selectedValue;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CustomDatePicker(
                              themeProvider: themeProvider,
                              appTextStyles: appTextStyles,
                              title: "Date min",
                              onValueChanged: (selectedValue) {
                                print('Selected min value: $selectedValue');
                              },
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: CustomDatePicker(
                              themeProvider: themeProvider,
                              appTextStyles: appTextStyles,
                              title: "Date max",
                              onValueChanged: (selectedValue) {
                                print('Selected max value: $selectedValue');
                              },
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Résultat: 10 RDVs",
                style: appTextStyles.ateneoBlueMedium12,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: const AptItem(),
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

  /*void _filterAptsList(String query) {
    filteredAptsList.clear();
    if (query.isNotEmpty) {
      filteredAptsList.addAll(widget.aptsList
          .where((bs) => bs.numBs.toLowerCase().contains(query.toLowerCase())));
    } else {
      filteredAptsList.addAll(widget.aptsList);
    }
  }*/

  bool generateRandomBool() {
    Random random = Random();
    return random.nextBool();
  }

  Future<void> _onRefresh() async {}
}
