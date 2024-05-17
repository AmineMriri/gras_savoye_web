import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomDatePicker extends StatefulWidget {
  final ThemeProvider themeProvider;
  final AppTextStyles appTextStyles;
  final String title;
  final Function(DateTime) onValueChanged;

  const CustomDatePicker({
    required this.themeProvider,
    required this.appTextStyles,
    required this.title,
    required this.onValueChanged,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          confirmText: "Valider",
          cancelText: "Annuler",
          locale: const Locale('fr', 'FR'),
          builder: (BuildContext context, Widget? child) {
            return DatePickerTheme(
              data: DatePickerThemeData(
                  backgroundColor: Colors.white,
                  headerForegroundColor: Colors.white,
                  headerBackgroundColor: widget.themeProvider.ateneoBlue,
                  elevation: 0,
                  dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return widget.themeProvider.onyx;
                  }),
                  dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return widget.themeProvider.ateneoBlue;
                    }
                    return Colors.white;
                  }),
                  dayOverlayColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.transparent;
                    }
                    return widget.themeProvider.ateneoBlue;
                  }),
                  todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return widget.themeProvider.ateneoBlue;
                    }
                    return Colors.white;
                  }),
                  todayForegroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return widget.themeProvider.ateneoBlue;
                  }),
                  confirmButtonStyle: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return widget.themeProvider.ateneoBlue;
                      }
                      return widget.themeProvider.ateneoBlue;
                    }),
                    textStyle: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return widget.appTextStyles.ateneoBlueSemiBold13;
                      }
                      return widget.appTextStyles.ateneoBlueSemiBold13;
                    }),
                  ),
                  cancelButtonStyle: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return widget.themeProvider.blue;
                      }
                      return widget.themeProvider.blue;
                    }),
                    textStyle: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return widget.appTextStyles.ateneoBlueSemiBold13;
                      }
                      return widget.appTextStyles.ateneoBlueSemiBold13;
                    }),
                  )
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null && pickedDate != _selectedDate) {
          setState(() {
            _selectedDate = pickedDate;
            widget.onValueChanged(_selectedDate!);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: widget.themeProvider.bubbles,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}"
                  : widget.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: widget.appTextStyles.ateneoBlueRegular12,
            ),
            Icon(
              Icons.calendar_month_outlined,
              color: widget.themeProvider.ateneoBlue,
            ),
          ],
        ),
      ),
    );
  }
}
