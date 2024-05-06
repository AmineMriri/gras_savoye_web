import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';
import 'custom_bottom_sheet.dart';

class CustomSearchWidgets extends StatefulWidget {
  final void Function(String)? onChanged;
  final void Function()? onPressedSearch;
  final void Function()? onPressedFilter;
  TextEditingController? controller;
  String searchHint;
  Widget body;

  CustomSearchWidgets({
    this.onChanged,
    this.onPressedSearch,
    this.controller,
    required this.onPressedFilter,
    required this.searchHint,
    required this.body,
  });

  @override
  _CustomSearchWidgetsState createState() => _CustomSearchWidgetsState();
}

class _CustomSearchWidgetsState extends State<CustomSearchWidgets> {


  @override
  Widget build(BuildContext context) {
    AppTextStyles appTextStyles = AppTextStyles(context);
    final themeProvider = context.themeProvider;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            cursorColor: themeProvider.ateneoBlue,
            controller: widget.controller,
            onChanged: widget.onChanged,
            style: appTextStyles.greyLight13,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: themeProvider.lightSilver,
                  width: 1,
                ),
              ),
              hintText: widget.searchHint,
              hintStyle: appTextStyles.cadetGreyLight13,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: GestureDetector(
                onTap: widget.onPressedSearch,
                child: Icon(
                  Icons.search,
                  color: themeProvider.blue,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10,),
        Container(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: themeProvider.ateneoBlue,
          ),
            child: IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              onPressed: ()=>CustomBottomSheet.show(
                context: context,
                title: "Filtres",
                btnTxt: "Appliquer",
                hPadding: 30,
                hasResetBtn: true,
                content:  StatefulBuilder(
                    builder: (context, setState) {
                      return widget.body;
                    }
                ),
                onPressed: (){
                  if (widget.onPressedFilter != null) {
                    widget.onPressedFilter!();
                    Navigator.pop(context);
                  }
                },
                onClosePressed: () {
                  Navigator.pop(context);
                },
                themeProvider: themeProvider,
              ),
            ),
        ),
      ],
    );
  }
}
