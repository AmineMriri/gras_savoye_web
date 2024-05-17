import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/bulletin.dart';
import 'package:healio/views/responsive.dart';
import 'package:healio/widgets/container_rounded_corners.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import '../../helper/app_text_styles.dart';
import '../../helper/date_utils.dart';
import '../../models/prestation.dart';
import '../../view_models/bulletin_view_model.dart';
import '../../widgets/custom_percent.dart';

class ExpandableBulletinItem extends StatefulWidget {
  final Bulletin bs;

  const ExpandableBulletinItem({Key? key, required this.bs}) : super(key: key);

  @override
  _ExpandableBulletinItemState createState() => _ExpandableBulletinItemState();
}

class _ExpandableBulletinItemState extends State<ExpandableBulletinItem> {
  bool _isExpanded = false;
  late BulletinViewModel bulletinViewModel;

  @override
  Widget build(BuildContext context) {
    bulletinViewModel = Provider.of<BulletinViewModel>(context, listen: false);
    final themeProvider = context.watch<ThemeProvider>();
    final appTextStyles = AppTextStyles(context);
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: isInProgress(widget.bs.state) ? themeProvider.uclaGold : themeProvider.spanishGreen,
                  width: 10.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "N°: ${widget.bs.numBs}",
                  style: Responsive.isMobile(context)?appTextStyles.onyxSemiBold14:appTextStyles.onyxSemiBold18,
                ),
                const SizedBox(height: 20),
                cardContent(themeProvider, appTextStyles, isInProgress(widget.bs.state)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(widget.bs.dateMaladie),
                      style: Responsive.isMobile(context)?appTextStyles.ateneoBlueRegular12:appTextStyles.ateneoBlueRegular14,
                    ),
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: themeProvider.graniteGrey,
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 20),
                  buildDataTable(appTextStyles, themeProvider),
                  if(!isInProgress(widget.bs.state))
                    Column(
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            InkWell(
                              onTap: ()=>requestPermission(fetchAndSaveDocument(context, widget.bs.bsId, widget.bs.numBs, 'Quittance')),
                              child: ContainerRoundedCorners(
                                  "Contre visite",
                                  appTextStyles.whiteRegular10,
                                  themeProvider.blue,
                                  const Icon(Icons.file_download_outlined,color: Colors.white,)
                              ),
                            ),
                            const SizedBox(width: 10,),
                            InkWell(
                              onTap: ()=>requestPermission(fetchAndSaveDocument(context, widget.bs.bsId, widget.bs.numBs, 'Quittance')),
                              child: ContainerRoundedCorners(
                                  "Quittance",
                                  appTextStyles.whiteRegular10,
                                  themeProvider.blue,
                                  const Icon(Icons.file_download_outlined,color: Colors.white,)
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                ],
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isInProgress(widget.bs.state) ? themeProvider.uclaGold : themeProvider.spanishGreen,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                widget.bs.state,
                style: appTextStyles.whiteSemiBold10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchAndSaveDocument(BuildContext context, int bsId, String bsNum, String type) async {
    try {
      File file = await bulletinViewModel.getBsDocument(bsId, bsNum, type);
      String filepath=file.path;
      OpenFile.open(filepath);
      print('Document path at: $filepath');

    } catch (e) {
      print('Error fetching or saving document: $e');
    }
  }
  /*
  * Future<void> requestPermission(void Function() fetchAndSaveDocument) async {
    const permission = Permission.storage;

    if (await permission.isGranted == false) {
      final result = await permission.request();
      if (result.isGranted) {
        fetchAndSaveDocument(); // Corrected: Call the function
      } else if (result.isDenied || result.isPermanentlyDenied) {
        // Show a SnackBar or a dialog informing the user about the need for storage permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cette action nécessite l\'accès au stockage.'),
            duration: Duration(milliseconds: 3000),
          ),
        );
      }
    } else {
      fetchAndSaveDocument(); // Already granted, directly call the function
    }
  }*/
  Future<void> requestPermission(void fetchAndSaveDocument) async {
    const permission = Permission.storage;

    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        fetchAndSaveDocument;
      } else if (result.isDenied) {
        print("result.isDenied");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cette action nécessite l\'accès au stockage.'),
            duration: Duration(milliseconds: 3000),
          ),
        );
      } else if (result.isPermanentlyDenied) {
        print("result.isPermanentlyDenied");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cette action nécessite l\'accès au stockage.'),
            duration: Duration(milliseconds: 3000),
          ),
        );
      }
    }
  }

  Widget cardContent(ThemeProvider themeProvider, AppTextStyles appTextStyles, bool inProgress) {
    bool hasObservation = widget.bs.prestations.any((prestation) => prestation.observation != null);
    return inProgress
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Montant dépensé : ",
          style: Responsive.isMobile(context)?appTextStyles.onyxSemiBold12:appTextStyles.onyxSemiBold16,
        ),
        Text(
          "${widget.bs.totalDep} DT",
          style: Responsive.isMobile(context)?appTextStyles.uclaGoldSemiBold12:appTextStyles.uclaGoldSemiBold16,
        ),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        hasObservation ? Icon(Icons.circle_notifications_rounded, color: themeProvider.red,):Container(),
        CustomPercent(
          themeProvider: themeProvider,
          appTextStyles: appTextStyles,
          totalDep: widget.bs.totalDep,
          totalPec: widget.bs.totalPec,
        )
      ],
    );
  }

  bool isInProgress(String state) {
    return state.toLowerCase() == "en cours";
  }

  Widget buildDataTable(AppTextStyles appTextStyles, ThemeProvider themeProvider) {
    final List<Prestation> prestations = widget.bs.prestations;
    bool isInProgress = widget.bs.state.toLowerCase() == "en cours";
    int numColumns = isInProgress ? 2 : 3;

    List<Widget> rows = [];
    rows.add(buildTitlesRow(appTextStyles, numColumns));

    // Loop through prestations and build rows accordingly
    for (int i = 0; i < prestations.length; i++) {
      Prestation prestation = prestations[i];
      // Build data row using prestation data
      Map<String, String> rowData = {
        "prestation": prestation.prestationName,
        "depense": "${prestation.montant} DT",
        "rembourse": "${prestation.pec} DT"
      };
      Widget dataRow = buildDataRow(appTextStyles, rowData, numColumns);
      rows.add(dataRow);

      // Check conditions to insert observation row after specific data row
      if (prestations[i].observation!=null) {
        Widget observationRow =
        buildObservationRow(themeProvider, appTextStyles, "Prestation non remboursable");
        rows.add(observationRow);
      }
    }

    // Add divider after the last data row if there are any data rows
    if (prestations.isNotEmpty) {
      rows.add(Divider(
        color: themeProvider.bubbles,
        thickness: 1.0,
        height: 1.0,
      ));
    }

    rows.add(buildTotalRow(appTextStyles, numColumns));

    // Build the ListView with the constructed rows
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: rows,
    );
  }

  Widget buildTitlesRow(AppTextStyles appTextStyles, int numColumns) {
    List<String> titles = ["Prestation", "Dépensé"];
    if (numColumns == 3) {
      titles.add("Remboursé");
    }

    return Row(
      children: titles.map((title) {
        return buildTitleCell(appTextStyles, title);
      }).toList(),
    );
  }

  Widget buildDataRow(AppTextStyles appTextStyles, Map<String, String> rowData, int numColumns) {
    List<String> data = [rowData['prestation']!, rowData['depense']!];
    if (numColumns == 3) {
      data.add(rowData['rembourse']!);
    }

    return Row(
      children: data.map((text) {
        return buildDataCell(appTextStyles, text);
      }).toList(),
    );
  }

  Widget buildTotalRow(AppTextStyles appTextStyles, int numColumns) {
    List<Map<String, dynamic>> totals = [
//       {"label": "${widget.bs.totalDep} DT", "textStyle": appTextStyles.redBold10},
//       {"label": "${widget.bs.totalPec} DT", "textStyle": appTextStyles.greenBold10}
      {"label": "238,895 DT", "textStyle": Responsive.isMobile(context)?appTextStyles.redBold10:appTextStyles.redBold14},
      {"label": "155,401 DT", "textStyle": Responsive.isMobile(context)?appTextStyles.greenBold10:appTextStyles.greenBold14}
    ];
    totals.insert(0, {"label": "Total", "textStyle": appTextStyles.graniteGreyBold12});

    if (numColumns == 2) {
      totals.removeAt(2);
    }

    return Row(
      children: totals.map((total) {
        return buildTotalCell(total['textStyle'], total['label']);
      }).toList(),
    );
  }

  Widget buildDataCell(AppTextStyles appTextStyles, String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        child: Text(
          text,
          textAlign: TextAlign.start,

          style: Responsive.isMobile(context)?appTextStyles.graniteGreyMedium10:appTextStyles.graniteGreyMedium14,
        ),
      ),
    );
  }

  Widget buildTotalCell(TextStyle textStyle, String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: textStyle,
        ),
      ),
    );
  }

  Widget buildTitleCell(AppTextStyles appTextStyles, String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        child: Text(
          title,
          textAlign: TextAlign.start,
          style: appTextStyles.graniteGreyBold12,
        ),
      ),
    );
  }

  Widget buildObservationRow(ThemeProvider themeProvider, AppTextStyles appTextStyles, String obs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: Row(
        children: [
          Icon(Icons.circle_notifications_rounded, color: themeProvider.red, size: 20,),
          Text(
            "Observation: $obs",
            style:Responsive.isMobile(context)?appTextStyles.redMedium10:appTextStyles.redMedium12,
          ),
        ],
      ),
    );
  }


}
