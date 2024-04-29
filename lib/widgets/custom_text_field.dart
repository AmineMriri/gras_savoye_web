import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';
import '../helper/providers/theme_provider.dart';

class CustomTextField extends StatefulWidget {
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

  CustomTextField({
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
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = widget.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return TextFormField(
      cursorColor: themeProvider.ateneoBlue,
      controller: widget.contr,
      enabled: widget.activated,
      obscureText: widget.obscure != null ? _obscureText : false,
      keyboardType: widget.inputType,
      style: appTextStyles.greyLight13,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
        prefixIcon: widget.icon != null
            ? Icon(
                widget.icon,
                color: themeProvider.cadetGrey,
              )
            : null,
        suffixIcon: widget.obscure != null && widget.obscure == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: themeProvider.cadetGrey,
                ),
              )
            : null,
        suffixText: widget.hasSuffixText != null && widget.hasSuffixText == true
            ? "DT    "
            : null,
        /*errorStyle: TextStyle(
            color: washappAccent.shade100,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: fontSizeRatio*12,
          )*/
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
