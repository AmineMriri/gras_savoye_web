import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/widgets/custom_card.dart';
import 'package:healio/widgets/custom_dropdown_button.dart';
import 'package:provider/provider.dart';

import '../../helper/app_text_styles.dart';
import '../../widgets/custom_app_bar.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';


import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_text_field.dart';
import 'package:path/path.dart' as p;

class AttachBulletinScreen extends StatefulWidget {
  const AttachBulletinScreen({Key? key}) : super(key: key);

  @override
  _AttachBulletinScreenState createState() => _AttachBulletinScreenState();
}

class _AttachBulletinScreenState extends State<AttachBulletinScreen> {
  late AppTextStyles appTextStyles;
  late ThemeProvider themeProvider;
  FilePickerResult? result;
  List<File> files = [];
  String? benefVal;
  List<String> benefList = ["Assure", "Conjoint", "Enfant", "Parent"];
  String? enfantVal;
  String? parentVal;
  List<String> enfantsList = ["Enfant 1", "Enfant 2", "Enfant 3"];
  List<String> parentsList = ["Parent 1", "Parent 2"];
  bool isEnfant = false;
  bool isParent = false;

  // CloudinaryPublic cloudinary = CloudinaryPublic('dydeeb12j', '_uploadPreset');

  /// push a document into cloudinar
  // Future<void> uploadFile(File file) async {
  //   if (!file.existsSync()) {
  //     print('File does not exist: ${file.path}');
  //     return;
  //   }
  //   final response = await cloudinary.uploadFile(
  //     CloudinaryFile.fromFile(file.path),
  //   );
  //   print('Upload response: $response');
  // }

  /// push a list of files inito cloudinary
  // Future<void> uploadFiles(List<File> files) async {
  //   for (File file in files) {
  //     await uploadFile(file);
  //   }
  // }

  ///Take an image Func
  Future<File?> captureImage() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

    if (pickedFile != null) {
      setState(() {});
      files.add(File(pickedFile.path));
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  /// Pick an image or a pdf
  Future<File?> pickFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
      allowMultiple: true,
    );
    if (result == null) {
      print("Aucun fichier sélectionné");
    } else {
      for (int i = 0; i < result!.files.length; i++) {
        files.add(File(result!.files[i].name));
      }

      setState(() {});
      for (var element in result!.files) {
        print(element.name);
        print(element.path);
      }
    }
    /*ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text('fichiers sélectionnés avec succès'),
        duration: Duration(milliseconds: 450),


      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    appTextStyles = AppTextStyles(context);
    themeProvider = context.read<ThemeProvider>();
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Attacher un Bulletin",
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: "N° bulletin",
                          //contr: emailController,
                          icon: Icons.tag,
                          inputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          themeProvider: themeProvider,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Le numéro ne doit pas être vide";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String? value) {
                            //email = value!;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomDatePicker(
                          themeProvider: themeProvider,
                          appTextStyles: appTextStyles,
                          title: "Date maladie",
                          onValueChanged: (selectedValue) {
                            print('Selected value: $selectedValue');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomDropdown(
                    hint: "Bénéficiaire",
                    items: benefList,
                    themeProvider: themeProvider,
                    selectedValue: benefVal,
                    onChanged: (String? selectedValue) {
                      setState(() {
                        benefVal = selectedValue;
                        isEnfant = selectedValue == "Enfant";
                        isParent = selectedValue == "Parent";
                      });
                      print('Selected value: $selectedValue');
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: isEnfant,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomDropdown(
                      hint: "Nom du Patient",
                      items: enfantsList,
                      themeProvider: themeProvider,
                      selectedValue: enfantVal,
                      onChanged: (String? selectedValue) {
                        setState(() {
                          enfantVal = selectedValue;
                        });
                        print('Selected value: $selectedValue');
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: isParent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomDropdown(
                      hint: "Nom du Patient",
                      items: parentsList,
                      themeProvider: themeProvider,
                      selectedValue: parentVal,
                      onChanged: (String? selectedValue) {
                        setState(() {
                          parentVal = selectedValue;
                        });
                        print('Selected value: $selectedValue');
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                /** ATTACH FILES **/
                InkWell(
                  onTap: () => pickFile(),
                  child: DottedBorder(
                    color: themeProvider.lightSilver,
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.picture_as_pdf_rounded,
                                color: themeProvider.cadetGrey,
                              ),
                              Icon(
                                Icons.image_rounded,
                                color: themeProvider.cadetGrey,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Cliquez ici pour joindre votre bulletin",
                            style: appTextStyles.cadetGreyMedium14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: Divider(
                    color: themeProvider.lightSilver,
                  )),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    "OU",
                    style: appTextStyles.cadetGreyMedium14,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                      child: Divider(
                    color: themeProvider.lightSilver,
                  )),
                ]),
                const SizedBox(
                  height: 10,
                ),
                /** TAKE A PICTURE **/
                InkWell(
                  onTap: () => captureImage(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: themeProvider.bubbles,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: themeProvider.ateneoBlue,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                            child: Text(
                          "Vous voulez prendre une photo ?",
                          style: appTextStyles.ateneoBlueMedium12,
                          overflow: TextOverflow.ellipsis,
                        ))
                      ],
                    ),
                  ),
                ),

                /** SELECTED FILES LIST **/
                const SizedBox(
                  height: 10,
                ),
                CustomCard(
                  appTextStyles,
                  themeProvider,
                  "Fichiers attachés",
                  files.length == 0
                      ? Center(
                          child: Text(
                            "Aucun fichier n'a été attaché",
                            style: appTextStyles.cadetGreyMedium14,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: files.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    isDocument(files[index]) ? Icons.document_scanner_rounded: Icons.image_rounded,
                                    color: themeProvider.cadetGrey,
                                  ),
                                  const SizedBox(width: 10,),
                                  Flexible(
                                    child: Text(
                                      files[index].path ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: appTextStyles.cadetGreyMedium14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  null,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Clear list of files
                    Expanded(
                      flex: 1,
                      child: CustomElevatedButton(
                          txt: "Effacer",
                          txtStyle: appTextStyles.whiteSemiBold16,
                          btnColor: themeProvider.red,
                          btnWidth: double.maxFinite,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Fichiers effacés avec succès'),
                                duration: Duration(milliseconds: 450),
                              ),
                            );
                            setState(() {
                              files.clear();
                            });
                          }),
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    /// Send the files to odoo
                    Expanded(
                      flex: 1,
                      child: CustomElevatedButton(
                          txt: "Envoyer",
                          txtStyle: appTextStyles.whiteSemiBold16,
                          btnColor: themeProvider.blue,
                          btnWidth: double.maxFinite,
                          onPressed: () {
                            if (files.isNotEmpty) {
                              if (files.length > 1) {
                                try {
                                  // uploadFiles(files);
                                  setState(() {
                                    files.clear();
                                  });
                                } on Exception catch (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'vous ne pouviez pas télécharger de fichiers !'),
                                      duration: Duration(milliseconds: 450),
                                    ),
                                  );
                                  rethrow;
                                }
                              } else {
                                // uploadFile(files[0]);
                                setState(() {
                                  files.clear();
                                });
                              }
                              ;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'veuillez joindre un fichier et réessayer !'),
                                  duration: Duration(milliseconds: 450),
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isDocument(File file) {
    String fileExtension = p.extension(file.path);
    return fileExtension.toLowerCase()=='.pdf';
  }
}
