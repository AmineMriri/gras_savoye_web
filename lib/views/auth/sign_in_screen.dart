import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/models/responses/user/login_response.dart';
import 'package:healio/views/auth/forgot_pwd_screen.dart';
import 'package:healio/helper/app_text_styles.dart';
import 'package:healio/widgets/custom_button.dart';
import 'package:healio/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/providers/theme_provider.dart';
import '../../view_models/user_view_model.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_info_dialog.dart';
import '../../widgets/nav_bottom_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late UserViewModel userViewModel;
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  late String email;
  late String password;
  String? _selectedDbVal;
  bool _isLoading = false;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    AppTextStyles appTextStyles = AppTextStyles(context);
    final themeProvider = context.themeProvider;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double availableHeight = screenHeight - appBarHeight;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: WillPopScope(
        onWillPop: () async {
          // exit the app when back button is pressed
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: availableHeight,
                ),
                child: Form(
                  key: keyForm,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///HEADING
                            Column(
                              children: [
                                Center(
                                  child: Image.asset("assets/images/app_icon.png",
                                      width: 200),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Veuillez vous connecter",
                                  textAlign: TextAlign.center,
                                  style: appTextStyles.graniteGreyRegular16,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.6,
                              child: CustomDropdown(
                                hint: 'Votre assurance',
                                items: const ['Gras Savoye', 'We Cover'],
                                selectedValue: _selectedDbVal,
                                themeProvider: themeProvider,
                                onChanged: null,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ///TEXT FIELDS
                            Column(
                              children: [
                                CustomTextField(
                                  hint: "john.doe@example.com",
                                  contr: emailController,
                                  icon: Icons.email_outlined,
                                  inputType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  themeProvider: themeProvider,
                                  validator: (value){
                                    RegExp regex = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                    if(value!.isEmpty){
                                      return "L'adresse mail ne doit pas être vide";
                                    } else if (!regex.hasMatch(value)) {
                                      return "L'adresse mail doit être une adresse valide ";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (String? value) {
                                    email = value!;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  hint: "**********",
                                  contr: pwdController,
                                  icon: Icons.lock_outline_rounded,
                                  inputType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  themeProvider: themeProvider,
                                  obscure: true,
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return "Le mot de passe ne doit pas être vide";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (String? value) {
                                    password = value!;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 36,
                            ),

                            ///BUTTONS
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomElevatedButton(
                                          txt: "Se connecter",
                                          txtStyle: appTextStyles.whiteSemiBold16,
                                          btnColor: themeProvider.ateneoBlue,
                                          btnWidth: double.maxFinite,
                                          onPressed: () {
                                            if(!_isLoading){
                                              if (keyForm.currentState!.validate()){
                                                keyForm.currentState!.save();
                                                signInCall(email, password);
                                              }
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPwdScreen())),
                                  child: Text(
                                    "Mot de passe oublié ?",
                                    textAlign: TextAlign.center,
                                    style:
                                        appTextStyles.graniteGreyRegularUnderline14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: SpinKitCircle(
                      color: themeProvider.blue.withOpacity(0.6),
                      size: 50.0
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  void signInCall(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      LoginResponse loginResponse=await userViewModel.signIn(email, password);
      switch (loginResponse.res_code) {
        case 1:
        // Save user id to shared pref
          saveUserData(loginResponse);
          //Navigate to home screen
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder:
                      (context) => NavigationBottom(loginResponse: loginResponse)
              ));
          /*Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder:
                      (context) => BiometricsScreen(loginResponse: loginResponse)
              ));*/
          break;
        case 0:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Compte introuvable",
              content:
              "Aucun compte avec cette adresse n'a été trouvé!",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
          break;
        case 3:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Mot de passe incorrect!",
              content:
              "Vous avez entré un mauvais mot de passe.",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
          break;
        case 5:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Une erreur s'est produite!",
              content:
              "Une erreur imprévue s'est produite. Veuillez réessayer ultérieurement.",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
          break;
        default:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Une erreur s'est produite!",
              content:
              "Veuillez vérifier votre connexion et réessayer.",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
      }
    } catch (error) {
      print("Error: $error");
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void saveUserData(LoginResponse loginResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (loginResponse.id != null) {
      await prefs.setString('id', loginResponse.id!);
    }
    if (loginResponse.name != null) {
      await prefs.setString('name', loginResponse.name!);
    }
    if (loginResponse.conjoint != null) {
      await prefs.setString('conjoint', loginResponse.conjoint!);
    }
    if (loginResponse.child != null) {
      await prefs.setBool('children', loginResponse.child!);
    }
    if (loginResponse.parent != null) {
      await prefs.setBool('parents', loginResponse.parent!);
    }
  }


}
