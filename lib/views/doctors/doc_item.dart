/*import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/views/appointments/add_apt_screen.dart';
import 'package:healio/widgets/custom_doc_item_container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper/app_text_styles.dart';

class DocItem extends StatelessWidget {
  //final Doctor doctor;
  const DocItem({Key? key,})
      : super(key: key);

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
            icon: Icons.schedule,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAptScreen(docId: doctor.docId,)));
            },
          ),
          SlidableAction(
            backgroundColor: themeProvider.bubbles,
            foregroundColor: themeProvider.ateneoBlue,
            icon: Icons.email_rounded,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) async {
              final url=Uri.parse('mailto: test@example.com');
              if(await canLaunchUrl(url)){
                await launchUrl(url);
              }else{
                throw 'Failed to launch $url';
              }
            },
          ),
          SlidableAction(
            backgroundColor: themeProvider.blue.withOpacity(0.6),
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
        ],
      ),
      child: CustomDocItemContainer(
        appTextStyles: appTextStyles,
        themeProvider: themeProvider,
        imgAsset: 'assets/images/blank_profile_pic.png',
      ),

      /*InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DocProfileScreen(docId: doctor.docId))),
        child: CustomDocItemContainer(
          appTextStyles: appTextStyles,
          themeProvider: themeProvider,
          imgAsset: 'assets/images/blank_profile_pic.png',
          doctor: doctor,
        ),
      ),*/
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/views/appointments/add_apt_screen.dart';
import 'package:healio/widgets/custom_doc_item_container.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper/app_text_styles.dart';

class DocItem extends StatelessWidget {
  final Doctor doctor;
  const DocItem({Key? key, required this.doctor})
      : super(key: key);

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
            icon: Icons.schedule,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAptScreen(docId: doctor.docId,)));
            },
          ),
          SlidableAction(
            backgroundColor: themeProvider.bubbles,
            foregroundColor: themeProvider.ateneoBlue,
            icon: Icons.email_rounded,
            padding: const EdgeInsets.all(0),
            onPressed: (BuildContext context) async {
              final url=Uri.parse('mailto:${doctor.email}');
              if(await canLaunchUrl(url)){
                await launchUrl(url);
              }else{
                throw 'Failed to launch $url';
              }
            },
          ),
          SlidableAction(
            backgroundColor: themeProvider.blue.withOpacity(0.6),
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
        ],
      ),
      child: CustomDocItemContainer(
        appTextStyles: appTextStyles,
        themeProvider: themeProvider,
        imgAsset: 'assets/images/blank_profile_pic.png',
        doctor: doctor,
      ),

      /*InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DocProfileScreen(docId: doctor.docId))),
        child: CustomDocItemContainer(
          appTextStyles: appTextStyles,
          themeProvider: themeProvider,
          imgAsset: 'assets/images/blank_profile_pic.png',
          doctor: doctor,
        ),
      ),*/
    );
  }
}
