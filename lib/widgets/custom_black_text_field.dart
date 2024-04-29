import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomBlackTextField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final ThemeProvider themeProvider;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  bool? activated = true;
  bool? obscure = false;
  bool? hasSuffixText;
  TextEditingController? contr;
  TextInputType inputType;
  TextInputAction textInputAction;

  CustomBlackTextField({
    required this.hint,
    required this.icon,
    required this.themeProvider,
    this.validator,
    this.onSaved,
    this.activated,
    this.obscure,
    this.hasSuffixText,
    this.contr,
    required this.inputType,
    required this.textInputAction,
  });

  @override
  _CustomBlackTextFieldState createState() => _CustomBlackTextFieldState();
}

class _CustomBlackTextFieldState extends State<CustomBlackTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = widget.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return
      TextFormField(
        textAlign: TextAlign.start,
      cursorColor: themeProvider.ateneoBlue,
      controller: widget.contr,
      enabled: widget.activated,
      obscureText: widget.obscure != null ? _obscureText : false,
      keyboardType: widget.inputType,
      style: appTextStyles.greyLight13,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(

        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: widget.themeProvider.bubbles,
            width: 1,
          ),
        ),


        hintText: widget.hint,
        hintStyle: appTextStyles.ateneoBlueRegular14,
        filled: true,
        fillColor: widget.themeProvider.bubbles,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.obscure != null && widget.obscure == true)
              IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: themeProvider.cadetGrey,
                ),
              ),
            if (widget.icon != null)
                Icon(
                  widget.icon,
                  color: widget.themeProvider.ateneoBlue,
                ),
          ],
        ),
        suffixText: widget.hasSuffixText != null && widget.hasSuffixText == true
            ? "DT    "
            : null,
      ),
        validator: widget.validator,
        onSaved: widget.onSaved,
      );
  }
}