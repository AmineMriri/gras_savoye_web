import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import '../../helper/app_text_styles.dart';
import '../../models/bulletin.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_search_widgets.dart';
import 'bulletin_item.dart';

class BulletinList extends StatefulWidget {
  List<Bulletin> bsList;
  String type;
  Future<void> Function() onRefresh;

  BulletinList(
      {super.key,
      required this.bsList,
      required this.type,
      required this.onRefresh});

  @override
  State<BulletinList> createState() => _BulletinListState();
}

class _BulletinListState extends State<BulletinList> {
  List<Bulletin> filteredBsList = [];
  String? _selectedStateValue;

  @override
  void initState() {
    super.initState();
    filteredBsList.addAll(widget.bsList);
  }

  @override
  Widget build(BuildContext context) {
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
                    CustomSearchWidgets(
                      onChanged: (query) {
                        _filterBsList(query);
                      },
                      searchHint: "Recherche par N° de bulletin",
                      body: Column(
                        children: [
                          CustomDropdown(
                            hint: 'État du bulletin',
                            items: const ['Traité', 'En cours'],
                            selectedValue: _selectedStateValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedStateValue = newValue;
                              });
                            },
                            themeProvider: themeProvider,
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
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: BulletinItem(bs: bs),
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
