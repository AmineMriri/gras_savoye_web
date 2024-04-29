import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/bulletin.dart';
import 'package:healio/widgets/custom_percent.dart';
import '../../helper/app_text_styles.dart';
import '../../helper/date_utils.dart';
import 'bulletin_details_screen.dart';


class BulletinItem extends StatelessWidget {
  final Bulletin bs;
  const BulletinItem({Key? key, required this.bs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return InkWell(
      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BulletinDetailsScreen(
              idBs: bs.bsId,
              numBs: bs.numBs,
              patient:bs.patient,
              //totalDep: bs.totalDep,
              //totalPec: bs.totalPec,
              dateMaladie:bs.dateMaladie,
              //inProgress: isInProgress(bs.state),
          ))),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "N°: ${bs.numBs}",
                  style: appTextStyles.onyxSemiBold14,
                ),
                const SizedBox(height: 20,),
                cardContent(themeProvider,appTextStyles, isInProgress(bs.state)),
                /*const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_pharmacy,color: themeProvider.cadetGrey),
                    const SizedBox(width: 8,),
                    Icon(Icons.medical_services_outlined,color: themeProvider.cadetGrey),
                    const SizedBox(width: 8,),
                    Icon(Icons.vaccines,color: themeProvider.cadetGrey),
                    const SizedBox(width: 8,),
                    Icon(Icons.local_pharmacy,color: themeProvider.cadetGrey),
                    const SizedBox(width: 8,),
                    Icon(Icons.medical_services_outlined,color: themeProvider.cadetGrey),
                    const SizedBox(width: 8,),
                    Icon(Icons.vaccines,color: themeProvider.cadetGrey),
                  ],
                ),*/
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(bs.dateMaladie),
                      style: appTextStyles.ateneoBlueRegular12,
                    ),
                    if(!isInProgress(bs.state))
                      GestureDetector(
                        onTap: ()=>print("GestureDetector"),
                        child: Icon(
                          Icons.download_for_offline_rounded,
                          color: themeProvider.graniteGrey,
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              decoration: BoxDecoration(
                color: isInProgress(bs.state) ? themeProvider.uclaGold : themeProvider.spanishGreen,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                bs.state,
                style: appTextStyles.whiteSemiBold10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardContent(ThemeProvider themeProvider, AppTextStyles appTextStyles, bool inProgress){
    return
      inProgress ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Montant dépensé : ",
            style: appTextStyles.onyxSemiBold12,
          ),
          Text(
            "${bs.totalDep} DT",
            style: appTextStyles.uclaGoldSemiBold12,
          ),
        ],
      )
          : CustomPercent(
            themeProvider: themeProvider,
            appTextStyles: appTextStyles,
            totalDep: bs.totalDep,
            totalPec: bs.totalPec,
          );
  }

  bool isInProgress(String state){
    return state.toLowerCase()=="en cours";
  }
}
