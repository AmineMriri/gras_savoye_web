import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:healio/helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomSearchDropdown extends StatelessWidget {
  final List<String> list;
  final ThemeProvider themeProvider;
  final AppTextStyles appTextStyles;
  final String hint;
  final String notFoundString;
  final Function(String) onValueChanged;

  const CustomSearchDropdown({
    required this.list,
    required this.themeProvider,
    required this.appTextStyles,
    required this.hint,
    required this.notFoundString,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      hintText: hint,
      noResultFoundText: notFoundString,
      searchHintText: "",
      items: list,
      excludeSelected: false,
      decoration: CustomDropdownDecoration(
        searchFieldDecoration: SearchFieldDecoration(
          hintStyle: appTextStyles.graniteGreyRegular14,
          textStyle: appTextStyles.graniteGreyRegular14,
          fillColor: themeProvider.bubbles,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: themeProvider.ateneoBlue,
          ),
          suffixIcon: null,
        ),
        listItemStyle: appTextStyles.graniteGreyRegular14,
        hintStyle: appTextStyles.ateneoBlueRegular14,
        closedBorderRadius: BorderRadius.circular(12),
        closedFillColor: themeProvider.bubbles,
        expandedBorderRadius: BorderRadius.circular(12),
        headerStyle: appTextStyles.ateneoBlueRegular14,
        closedSuffixIcon: Icon(
          Icons.expand_more_rounded,
          color: themeProvider.ateneoBlue,
        ),
        expandedSuffixIcon: Icon(
          Icons.expand_less_rounded,
          color: themeProvider.ateneoBlue,
        ),
      ),
      onChanged: (value) {
        onValueChanged(value);
      },
    );
  }
}
