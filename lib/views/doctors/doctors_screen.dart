import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/views/doctors/docs_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/app_text_styles.dart';
import '../../models/responses/doctor/list_doctors_response.dart';
import '../../view_models/doctor_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import '../../widgets/error_display_and_refresh.dart';
import '../auth/sign_in_screen.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  late ThemeProvider themeProvider;
  late AppTextStyles appTextStyles;
  late DoctorViewModel doctorViewModel;
  List<Doctor> doctorsList = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    doctorViewModel = Provider.of<DoctorViewModel>(context, listen: false);
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      //ListDoctorsResponse listDoctorsResponse=await doctorViewModel.getDoctors(2,1);
      ListDoctorsResponse listDoctorsResponse=await doctorViewModel.getDoctors();
    switch (listDoctorsResponse.res_code) {
        case 1:
        // retrieve bs list
          doctorsList = listDoctorsResponse.doctors;
          setState(() {
            isLoading = false;
            isError = false;
          });
          break;
        case -1:
          setState(() {
            isError = true;
            isLoading = false;
          });
          break;
        default:
          setState(() {
            isError = true;
            isLoading = false;
          });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = context.themeProvider;
    appTextStyles = AppTextStyles(context);
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Médecins",
          icon: CustomAppBarButton(
            iconData: Icons.logout_rounded,
            themeProvider: themeProvider,
            isTransform: true,
            onPressed: () {
              performLogout();
            },
          ),
          themeProvider: themeProvider,
        ),
        body: isLoading
            ? SpinKitCircle(color: themeProvider.blue, size: 50.0)
            : isError
            ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                () async {
              setState(() {
                refresh();
              });
            })
            : DocsList(doctorsList: doctorsList,onRefresh: refresh,),
      ),
    );
  }

  Future<void> refresh() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    await fetchDoctors();
  }

  void performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SignInScreen();
        },
      ),
          (_) => false,
    );
  }
}
