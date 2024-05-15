import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/widgets/custom_apt_item_container.dart';
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
            backgroundColor: themeProvider.blue,
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
            backgroundColor: themeProvider.uclaGold,
            foregroundColor: Colors.white,
            icon: Icons.email_rounded,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) async {
              final url=Uri.parse('mailto: example@gmail.com');
              if(await canLaunchUrl(url)){
                await launchUrl(url);
              }else{
                throw 'Failed to launch $url';
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
      child: CustomAptItemContainer(
        appTextStyles: appTextStyles,
        themeProvider: themeProvider,
        imgAsset: 'assets/images/blank_profile_pic.png',
      ),
      /*child: InkWell(
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
      ),*/
    );
  }

}
