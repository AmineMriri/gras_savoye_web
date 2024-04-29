import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/appointments/apt_details_screen.dart';
import 'package:healio/widgets/custom_percent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper/app_text_styles.dart';
import '../../widgets/custom_bottom_sheet_text_field.dart';
import '../../widgets/custom_item_container.dart';
import '../../widgets/custom_yes_no_dialog.dart';

class AptItem extends StatelessWidget {
  const AptItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.phone_rounded,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) async {
              final url=Uri.parse('tel:+216 52221191');
              if(await canLaunchUrl(url)){
                await launchUrl(url);
              }else{
                throw 'Failed to launch $url';
              }
            },
          ),
          SlidableAction(
            backgroundColor: themeProvider.uclaGold,
            foregroundColor: Colors.white,
            icon: Icons.directions_rounded,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) async {
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
          SlidableAction(
            backgroundColor: themeProvider.red,
            foregroundColor: Colors.white,
            icon: Icons.cancel_rounded,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) {
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
            },
          ),

        ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const AptDetailsScreen())),
        child: CustomItemContainer(
          appTextStyles: appTextStyles,
          themeProvider: themeProvider,
          imgAsset: 'assets/images/blank_profile_pic.png',
          heading: "Dr. Foulen Ben Flen",
          subHeading: "Généraliste",
          detailsPrimary: "23",
          detailsSecondary: "Fév",
          hasArrowForward: true,
        ),
      ),
    );
  }

  /*void _showDeleteDialog(BuildContext context,ThemeProvider themeProvider, AppTextStyles appTextStyles) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomYesNoDialog(
          title: 'Annuler mon RDV',
          content: 'Êtes-vous sûr?',
          onYesPressed: () async {
            // cancel RDV
            print("cancel rdv");
          },
          primaryColor: themeProvider.red,
          themeProvider: themeProvider,
          appTextStyles: appTextStyles,
        );
      },
    );
  }*/
}
