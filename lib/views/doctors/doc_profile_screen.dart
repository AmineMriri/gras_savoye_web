import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/models/responses/doctor/details_doctor_reponse.dart';
import 'package:healio/view_models/doctor_view_model.dart';
import 'package:healio/widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper/app_text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_display_and_refresh.dart';
import '../appointments/add_apt_screen.dart';

class DocProfileScreen extends StatefulWidget {
  final int docId;
  const DocProfileScreen({super.key, required this.docId});

  @override
  State<DocProfileScreen> createState() => _DocProfileScreenState();
}

class _DocProfileScreenState extends State<DocProfileScreen> {
  late ValueNotifier<bool> isDialOpen;
  late DoctorViewModel doctorViewModel;
  late String name;
  late String speciality;
  late String address;
  late String phone;
  late String email;
  bool isLoading=true;
  bool isError=false;

  @override
  void initState() {
    super.initState();
    isDialOpen = ValueNotifier<bool>(false);
    doctorViewModel = Provider.of<DoctorViewModel>(context, listen: false);
    fetchDoctorDetails();
  }
  @override
  Widget build(BuildContext context) {
    AppTextStyles appTextStyles = AppTextStyles(context);
    final themeProvider = context.themeProvider;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "",
          icon: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: themeProvider.onyx,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          themeProvider: themeProvider,
          /*trailing: Padding(
            padding: const EdgeInsets.all(5),
            child: SpeedDial(
              overlayOpacity: 0.3,
              icon: Icons.more_vert_rounded,
              backgroundColor: themeProvider.bubbles,
              foregroundColor: themeProvider.ateneoBlue,
              activeBackgroundColor: themeProvider.bubbles,
              activeForegroundColor: themeProvider.ateneoBlue,
              activeIcon: Icons.close,
              overlayColor: Colors.black,
              spacing: 5,
              direction: SpeedDialDirection.down,
              openCloseDial: isDialOpen,
              onPress: () {
                isDialOpen.value = !isDialOpen.value;
              },
              elevation: 0,
              children: [
                SpeedDialChild(
                  elevation: 0,
                  foregroundColor: themeProvider.bubbles,
                  backgroundColor: themeProvider.ateneoBlue,
                  child: const Icon(Icons.phone_rounded),
                  onTap: () {
                    // Handle onTap for the first child
                  },
                ),
                SpeedDialChild(
                  elevation: 0,
                  foregroundColor: themeProvider.bubbles,
                  backgroundColor: themeProvider.ateneoBlue,
                  child: const Icon(Icons.email_rounded),
                  onTap: () {
                    // Handle onTap for the first child
                  },
                ),
                SpeedDialChild(
                  elevation: 0,
                  foregroundColor: themeProvider.bubbles,
                  backgroundColor: themeProvider.ateneoBlue,
                  child: const Icon(Icons.directions_rounded),
                  onTap: () {
                    // Handle onTap for the first child
                  },
                ),
              ],
            ),
          ),*/
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: isLoading ? Center(
            child: SpinKitCircle(
                color: themeProvider.blue,
                size: 50.0
            ),
          ) : isError
              ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                  () async {
                setState(() {
                  refresh();
                });
              })
              : SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///HEADING
                /*ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/blank_profile_pic.png',
                      height: 200,
                      width: 200,
                    )
                ),*/
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/blank_profile_pic.png',
                            height: 200,
                            width: 200,
                          )
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        name,
                        style: appTextStyles.ateneoBlueBold20,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomAppBarButton(
                      iconData: Icons.phone_rounded,
                      themeProvider: themeProvider,
                      onPressed: () async {
                        final url=Uri.parse('tel:+216 $phone');
                        if(await canLaunchUrl(url)){
                        await launchUrl(url);
                        }else{
                        throw 'Failed to launch $url';
                        }
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomAppBarButton(
                      iconData: Icons.email_rounded,
                      themeProvider: themeProvider,
                      onPressed: () async {
                        final url=Uri.parse('mailto:$email');
                        if(await canLaunchUrl(url)){
                        await launchUrl(url);
                        }else{
                        throw 'Failed to launch $url';
                        }
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomAppBarButton(
                      iconData: Icons.directions_rounded,
                      themeProvider: themeProvider,
                      onPressed: () async {
                        const latitude = 36.831491;
                        const longitude = 10.308273;
                        final mapUrl = Uri.parse('https://maps.google.com/?q=$latitude,$longitude');

                        if (await canLaunchUrl(mapUrl)) {
                          await launchUrl(mapUrl);
                        } else {
                          throw 'Failed to launch $mapUrl';
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomCard(
                  appTextStyles,
                  themeProvider,
                  "Spécialité",
                  Text(
                    speciality,
                    style: appTextStyles.graniteGreyRegular14,
                  ),
                  null,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomCard(
                  appTextStyles,
                  themeProvider,
                  "Coordonnées",
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            color: themeProvider.graniteGrey,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "+216 $phone",
                            style: appTextStyles.graniteGreyRegular14,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.email_rounded,
                            color: themeProvider.graniteGrey,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            email,
                            style: appTextStyles.graniteGreyRegular14,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: themeProvider.graniteGrey,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                address,
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                          Text(
                            "(5 Km)",
                            style: appTextStyles.graniteGreyRegular14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  null,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                          txt: "Planifier un RDV",
                          txtStyle: appTextStyles.whiteSemiBold16,
                          btnColor: themeProvider.ateneoBlue,
                          btnWidth: double.maxFinite,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAptScreen(docId: widget.docId,)));
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    print("refreshed doc details !!!!");
    setState(() {
      isLoading = true;
      isError = false;
    });
    await fetchDoctorDetails();
  }

  Future<void> fetchDoctorDetails() async {
    try {
      DetailsDoctorResponse detailsDoctorResponse=await doctorViewModel.getDoctorDetails(widget.docId);
      switch (detailsDoctorResponse.resCode) {
        case 1:
        // retrieve doctor details
          name=detailsDoctorResponse.doctor!.name ?? "";
          speciality=detailsDoctorResponse.doctor!.speciality ?? "";
          address=detailsDoctorResponse.doctor!.address ?? "";
          email=detailsDoctorResponse.doctor!.email ?? "";
          phone=detailsDoctorResponse.doctor!.phone ?? "";
          setState(() {
            isLoading=false;
            isError=false;
          });
          break;
        case -1:
          setState(() {
            isError=true;
            isLoading=false;
          });
          break;
        default:
          setState(() {
            isError=true;
            isLoading=false;
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
}
