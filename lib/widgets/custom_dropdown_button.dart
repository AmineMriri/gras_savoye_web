import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final ThemeProvider themeProvider;
  final String? selectedValue;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    required this.hint,
    required this.items,
    required this.themeProvider,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }
  @override
  Widget build(BuildContext context) {
    AppTextStyles appTextStyles = AppTextStyles(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        color: widget.themeProvider.bubbles,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: _selectedValue,
        hint: Text(
          widget.hint,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: appTextStyles.ateneoBlueRegular14,
        ),
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: appTextStyles.ateneoBlueRegular14,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
          });
        },
        dropdownColor: widget.themeProvider.bubbles,
        elevation: 8,
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: widget.themeProvider.ateneoBlue,
        ),
        iconSize: 24,
        underline: Container(),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
