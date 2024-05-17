import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healio/helper/app_text_styles.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/responses/user/forgot_pwd_response.dart';
import 'package:healio/widgets/custom_button.dart';
import 'package:healio/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_view_model.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_info_dialog.dart';

class ForgotPwdScreen extends StatefulWidget {
  const ForgotPwdScreen({super.key});

  @override
  State<ForgotPwdScreen> createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  late String email;
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  late UserViewModel userViewModel;
  bool _isLoading = false;
  late ThemeProvider themeProvider;
  String? _selectedDbVal;

  @override
  void initState() {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    AppTextStyles appTextStyles = AppTextStyles(context);
    themeProvider = context.themeProvider;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double availableHeight = screenHeight - appBarHeight;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: themeProvider.onyx,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
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
                          Center(
                            child:
                                Image.asset("assets/images/app_icon.png", width: 200),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Ne vous inquiétez pas, nous vous aiderons à vous connecter",
                            textAlign: TextAlign.center,
                            style: appTextStyles.graniteGreyRegular16,
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
                          ///TEXT FIELD
                          CustomTextField(
                            hint: "john.doe@example.com",
                            icon: Icons.email_outlined,
                            inputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
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
                            height: 36,
                          ),

                          ///BUTTON
                          Row(
                            children: [
                              Expanded(
                                child: CustomElevatedButton(
                                    txt: "Envoyer",
                                    txtStyle: appTextStyles.whiteSemiBold16,
                                    btnColor: themeProvider.ateneoBlue,
                                    btnWidth: double.maxFinite,
                                    onPressed: () {
                                      if(!_isLoading){
                                        if (keyForm.currentState!.validate()){
                                          keyForm.currentState!.save();
                                          print("form is valid");
                                          forgotPwdCall(email);
                                        }else{
                                          print("form is not valid");
                                        }
                                      }
                                      //Navigator.of(context).pop();
                                    }
                                ),
                              ),
                            ],
                          ),
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
    );
  }

  void forgotPwdCall(String email) async {
    setState(() {
      _isLoading = true;
    });
    try {
      ForgotPwdResponse forgotPwdResponse=await userViewModel.forgotPwd(email);
      switch (forgotPwdResponse.res_code) {
        case 1:
          Fluttertoast.showToast(
              msg: "Un email vous a été envoyé",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: themeProvider.cadetGrey,
              fontSize: 16.0
          );
          Navigator.of(context).pop();
          break;
        case 3:
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
        default:
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
      }
    } catch (error) {
      print("Error: $error");
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }
}
