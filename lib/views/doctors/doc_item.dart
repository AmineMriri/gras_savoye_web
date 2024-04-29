import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/appointments/add_apt_screen.dart';
import 'package:healio/views/doctors/doc_profile_screen.dart';
import 'package:healio/widgets/custom_item_container.dart';
import '../../helper/app_text_styles.dart';

class DocItem extends StatelessWidget {
  const DocItem({Key? key}) : super(key: key);

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
            icon: Icons.schedule_rounded,
            label: 'Planifier un RDV',
            onPressed: (BuildContext context) {
              /*CustomYesNoBottomSheet.show(
                  context: context,
                  themeProvider: themeProvider,
                  appTextStyles: appTextStyles,
                  title: "Suppression de l'annonce",
                  onNoPressed: (){},
                  onYesPressed: (){}
              );*/
              /*final tabControllerProvider = Provider.of<TabControllerProvider>(context, listen: false);
              tabControllerProvider.setTab(2);*/
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddAptScreen()));
            },
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const DocProfileScreen())),
        child: CustomItemContainer(
          appTextStyles: appTextStyles,
          themeProvider: themeProvider,
          imgAsset: 'assets/images/blank_profile_pic.png',
          heading: "Dr. Foulen Ben Flen",
          subHeading: "Généraliste",
          detailsPrimary: "5",
          detailsSecondary: "Km",
          hasArrowForward: true,
        ),
      ),
    );
  }
}
