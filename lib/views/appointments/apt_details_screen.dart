import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/widgets/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper/app_text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_appbar_button.dart';
import '../../widgets/custom_bottom_sheet_text_field.dart';
import '../../widgets/custom_button.dart';
import '../appointments/add_apt_screen.dart';

class AptDetailsScreen extends StatefulWidget {
  const AptDetailsScreen({super.key});

  @override
  State<AptDetailsScreen> createState() => _AptDetailsScreenState();
}

class _AptDetailsScreenState extends State<AptDetailsScreen> {
  late ValueNotifier<bool> isDialOpen;

  @override
  void initState() {
    super.initState();
    isDialOpen = ValueNotifier<bool>(false);
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
        backgroundColor: themeProvider.ghostWhite,
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
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///HEADING
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/images/blank_profile_pic.png',
                                height: 100,
                                width: 100,
                              )
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dr. Foulen Ben Foulen",
                                style: appTextStyles.onyxBold16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Dentiste",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: themeProvider.graniteGrey,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "4 Rue XYZ, Ariana",
                                    style: appTextStyles.graniteGreyRegular14,
                                  ),
                                ],
                              ),
                            ],
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
                            final url=Uri.parse('tel:+216 52221191');
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
                            final url=Uri.parse('mailto:example.test@testing.com');
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
                      "Détails du RDV",
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                              Text(
                                "23 Février 2024",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Heure",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                              Text(
                                "16h 30min",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomCard(
                      appTextStyles,
                      themeProvider,
                      "Détails du patient",
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nom",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                              Text(
                                "Foulena El Fouleni",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Genre",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                              Text(
                                "Femme",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Age",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                              Text(
                                "34 ans",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                            ],
                          ),
                        ],
                      ),
                      null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomCard(
                      appTextStyles,
                      themeProvider,
                      "Motif du RDV",
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean auctor quis ligula vitae scelerisque.",
                        style: appTextStyles.graniteGreyRegular14,
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
                              txt: "Annuler le RDV",
                              txtStyle: appTextStyles.whiteSemiBold16,
                              btnColor: themeProvider.red,
                              btnWidth: double.maxFinite,
                              onPressed: () {
                                CustomBottomSheetTextField.show(
                                    appTextStyles: appTextStyles,
                                    themeProvider: themeProvider,
                                    context: context,
                                    title: "Message de l’annulation",
                                    onPressed: () {
                                      print("envoyer clicked");
                                    },
                                    btnTxt: 'Envoyer',
                                    hintText: 'Saisissez le message de l\'annulation',
                                    errorTxt: 'Le message ne doit pas être vide'
                                );
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
}
