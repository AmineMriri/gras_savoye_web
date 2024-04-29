import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomMultilineTextField extends StatefulWidget {
  final String hint;
  final ThemeProvider themeProvider;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  TextEditingController? contr;
  TextInputAction textInputAction;

  CustomMultilineTextField({
    required this.hint,
    required this.themeProvider,
    this.validator,
    this.onSaved,
    this.contr,
    required this.textInputAction,
  });

  @override
  _CustomMultilineTextFieldState createState() => _CustomMultilineTextFieldState();
}

class _CustomMultilineTextFieldState extends State<CustomMultilineTextField> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = widget.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return TextFormField(
      cursorColor: themeProvider.ateneoBlue,
      controller: widget.contr,
      textInputAction: widget.textInputAction,
      style: appTextStyles.greyLight13,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      maxLength: 3000,
      validator: widget.validator,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: themeProvider.lightSilver,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: themeProvider.red,
            width: 1,
          ),
        ),
        errorStyle: appTextStyles.redLight13,
        hintText: widget.hint,
        hintStyle: appTextStyles.cadetGreyLight13,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
