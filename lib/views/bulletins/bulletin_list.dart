import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/bulletins/expandable_bs_item.dart';
import 'package:healio/views/responsive.dart';
import '../../helper/app_text_styles.dart';
import '../../models/bulletin.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_search_widgets.dart';

class BulletinList extends StatefulWidget {
  List<Bulletin> bsList;
  Future<void> Function() onRefresh;

  BulletinList(
      {super.key,
      required this.bsList,
      required this.onRefresh});

  @override
  State<BulletinList> createState() => _BulletinListState();
}

class _BulletinListState extends State<BulletinList> {
  List<Bulletin> filteredBsList = [];
  String? selectedStateValue;

  @override
  void initState() {
    super.initState();
    filteredBsList.addAll(widget.bsList);
  }

  @override
  Widget build(BuildContext context) {
    print("ui updated");
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return widget.bsList.isEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Center(
              child: Text(
                'Aucun bulletin de soin n\'a été  trouvé!',
                textAlign: TextAlign.center,
                style: appTextStyles.blueSemiBold16,
              ),
            ),
          )
        : Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Responsive.isMobile(context)?CustomSearchWidgets(
                      onChanged: (query) {
                        _filterBsList(query);
                      },
                      searchHint: "Recherche par N° de bulletin",
                      onPressedFilter: (){},
                      body: Column(
                        children: [
                          CustomDropdown(
                            hint: 'Bénéficiaire',
                            items: const ['Mohamed', 'Nour', 'Yassine'],
                            selectedValue: selectedStateValue,
                            themeProvider: themeProvider,
                            onChanged: null,
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
                    )
                        :Row(
                      children: [
                        Expanded(
                          flex: 26,
                          child: CustomSearchWidgets(
                            onChanged: (query) {
                              _filterBsList(query);
                            },
                            searchHint: "Recherche par N° de bulletin",
                            onPressedFilter: (){},
                            body: null,
                          ),
                        ),
                        Expanded(flex : 1 , child: SizedBox()),
                        Expanded(flex : 16, child: CustomDropdown(
                          hint: 'Bénéficiaire',
                          items: const ['Mohamed', 'Nour', 'Yassine'],
                          selectedValue: selectedStateValue,
                          themeProvider: themeProvider,
                          onChanged: null,
                        ),),
                        Expanded(flex : 1 , child: SizedBox()),
                        Expanded(
                          flex: 16,
                            child: CustomDatePicker(
                              themeProvider: themeProvider,
                              appTextStyles: appTextStyles,
                              title: "Date min",
                              onValueChanged: (selectedValue) {
                                print('Selected min value: $selectedValue');
                              },
                            )),
                        Expanded(flex : 1 , child: SizedBox()),
                        Expanded(
                          flex: 16,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Résultat: ${filteredBsList.length} bulletins de soin",
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
                        itemCount: filteredBsList.length,
                        itemBuilder: (context, index) {
                          final bs = filteredBsList[index];
                          return Container(
                            margin: Responsive.isMobile(context)?EdgeInsets.symmetric(horizontal:15):EdgeInsets.symmetric(horizontal:80),
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: ExpandableBulletinItem(bs: bs),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  void _filterBsList(String query) {
    filteredBsList.clear();
    if (query.isNotEmpty) {
      filteredBsList.addAll(widget.bsList
          .where((bs) => bs.numBs.toLowerCase().contains(query.toLowerCase())));
    } else {
      filteredBsList.addAll(widget.bsList);
    }
  }
}
