import 'dart:math';
import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/doctors/doc_item.dart';
import '../../helper/app_text_styles.dart';
import '../../widgets/custom_search_dropdown_button.dart';
import '../../widgets/custom_search_widgets.dart';

class DocsList extends StatefulWidget {
  const DocsList({super.key});

  @override
  State<DocsList> createState() => _DocsListState();
}

class _DocsListState extends State<DocsList> {
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
                "Résultat: 10 Médecins",
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
                      child: const DocItem(),
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

  Future<void> _onRefresh() async {}
}
