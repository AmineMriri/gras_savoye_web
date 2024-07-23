import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/date_utils.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/prestation.dart';
import 'package:healio/widgets/custom_percent.dart';
import 'package:provider/provider.dart';
import '../../helper/app_text_styles.dart';
import '../../helper/service_locator.dart';
import '../../models/responses/bulletin/details_bulletin_reponse.dart';
import '../../view_models/bulletin_view_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/error_display_and_refresh.dart';
import '../responsive.dart';

class BulletinDetailsScreen extends StatefulWidget {
  final int idBs;
  final String numBs;
  final String patient;
  //final double totalDep;
  //final double totalPec;
  final String dateMaladie;
  //final bool inProgress;
  const BulletinDetailsScreen({super.key, required this.idBs, required this.numBs, required this.patient, /*required this.totalDep, required this.totalPec,*/ required this.dateMaladie, /*required this.inProgress*/});

  @override
  State<BulletinDetailsScreen> createState() => _BulletinDetailsScreenState();
}

class _BulletinDetailsScreenState extends State<BulletinDetailsScreen> {

  late BulletinViewModel bulletinViewModel;
  bool isLoading=true;
  bool isError=false;
  late double totalDep;
  late double totalPec;
  late bool inProgress;
  List<Prestation> prestationsList = [];

  @override
  void initState() {
    super.initState();
    bulletinViewModel = Provider.of<BulletinViewModel>(context, listen: false);
    fetchBSDetails();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double availableHeight = screenHeight - appBarHeight;
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
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: availableHeight,
          ),
          child: RefreshIndicator(
            onRefresh: refreshBSDetails,
            child: isLoading ? Center(
              child: SpinKitCircle(
                  color: themeProvider.blue,
                  size: 50.0
              ),
            ) : isError
                ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                    () async {
                  setState(() {
                    refreshBSDetails();
                  });
                })
                : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeProvider.bubbles,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Bulletin de soin N°: ${widget.numBs}",
                            style: appTextStyles.ateneoBlueBold18,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Bénéficiaire :\n${widget.patient}",
                            style: appTextStyles.onyxSemiBold14,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          inProgress
                              ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Montant dépensé : ",
                                    style: appTextStyles.onyxSemiBold12,
                                  ),
                                  Text(
                                    "$totalDep DT",
                                    style: appTextStyles.uclaGoldSemiBold12,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: themeProvider.uclaGold,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'En cours',
                                  style: appTextStyles.whiteSemiBold10,
                                ),
                              ),
                            ],
                          )
                              : CustomPercent(
                            themeProvider: themeProvider,
                            appTextStyles: appTextStyles,
                            totalDep: totalDep,
                            totalPec: totalPec,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: !inProgress
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date maladie: ${formatDate(widget.dateMaladie)}",
                                style: appTextStyles.graniteGreyRegular14,
                              ),
                              if (!inProgress)
                                GestureDetector(
                                  onTap: () => print("GestureDetector"),
                                  child: Icon(
                                    Icons.download_for_offline_rounded,
                                    color: themeProvider.spanishGreen,
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Prestations du bulletin",
                      style: appTextStyles.ateneoBlueSemiBoldUnderlined16,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    prestationsList.isEmpty ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Center(
                        child: Text(
                          'Aucune prestation n\'a été  trouvée!',
                          textAlign: TextAlign.center,
                          style: appTextStyles.blueSemiBold16,),
                      ),
                    )
                        : ListView.builder(
                      itemCount: prestationsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final prestation=prestationsList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: CustomCard(
                            appTextStyles,
                            themeProvider,
                            prestation.prestationName,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dépensé: ${prestation.montant} DT",
                                  style: appTextStyles.graniteGreyRegular14,
                                ),
                                if (!inProgress)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Remboursé: ${prestation.pec} DT",
                                        style: appTextStyles.spanishGreenRegular14,
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            inProgress || prestation.observation == null || prestation.observation!.isEmpty
                                ? null
                                : Row(
                              children: [
                                Icon(Icons.notification_important_rounded, color: themeProvider.red,),
                                const SizedBox(width: 5,),
                                Text(
                                  "Observation: ${prestation.observation}",
                                  style: appTextStyles.redRegular14,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshBSDetails() async {
    print("refreshed list !!!!");
    print(prestationsList.toString());
    setState(() {
      isLoading = true;
      isError = false;
    });
    await fetchBSDetails();
  }

  Future<void> fetchBSDetails() async {
    try {
      DetailsBulletinResponse detailsBulletinResponse=await bulletinViewModel.getBulletinDetails(widget.idBs,getDbSelectedValue()!);
      switch (detailsBulletinResponse.resCode) {
        case 1:
        // retrieve bs details
          prestationsList=detailsBulletinResponse.prestations;
          if(detailsBulletinResponse.totalDep != null){
            totalDep=detailsBulletinResponse.totalDep!;
          }
          if(detailsBulletinResponse.totalPec != null){
            totalPec=detailsBulletinResponse.totalPec!;
          }
          if(detailsBulletinResponse.state != null){
            inProgress=isInProgress(detailsBulletinResponse.state!);
          }
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

  bool isInProgress(String state){
    return state.toLowerCase()=="en cours";
  }
  String? getDbSelectedValue() {
    if(Responsive.isMobile(context) && !kIsWeb)
    {
      final selectedValueService = locator<SelectedDbValueService>();
      return selectedValueService.selectedValue;
    }else{
      final SelectedDbValueService = "backoffice_Gras_2";
      return SelectedDbValueService;
    }
  }

}
