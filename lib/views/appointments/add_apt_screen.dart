import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/appointment.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/models/responses/appointment/av_dates_response.dart';
import 'package:healio/models/responses/appointment/av_time_slots_response.dart';
import 'package:healio/models/responses/appointment/book_apt_reponse.dart';
import 'package:healio/view_models/appointment_view_model.dart';
import 'package:healio/views/responsive.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../helper/app_text_styles.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_info_dialog.dart';
import '../../widgets/custom_multiline_text_field.dart';
import '../../widgets/custom_search_dropdown_button.dart';
import '../../widgets/error_display_and_refresh.dart';

class AddAptScreen extends StatefulWidget {
  final int docId;

  const AddAptScreen({super.key, required this.docId});

  @override
  State<AddAptScreen> createState() => _AddAptScreenState();
}

class _AddAptScreenState extends State<AddAptScreen> {

  List<String> patientsList = [
    'Ahmed',
    'Yassine',
    'Yasmine',
    'Sarah',
  ];

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  String _selectedPatient="";
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  int selectedSlotIndex = -1;
  String _selectedTime = "";
  String _motif="";
  late AppointmentViewModel appointmentViewModel;
  bool isLoadingDays = true;
  bool isSlotsHidden = true;
  bool isLoadingSlots = false;
  bool isErrorDays = false;
  List<dynamic> dates=[];
  List<dynamic> slots=[];
  bool _selectedPatientError=false;
  bool _selectedDayError=false;
  bool _selectedTimeError=false;

  @override
  void initState() {
    super.initState();
    appointmentViewModel = Provider.of<AppointmentViewModel>(context, listen: false);
    fetchDates();
  }

  Future<void> fetchDates() async {
    try {
      AvDatesResponse avDatesResponse=await appointmentViewModel.getAvailableDatesForPhysician(widget.docId);

      if (avDatesResponse.resCode == 1) {
        print("list is not empty");
        setState(() {
          dates=avDatesResponse.dates;
          print(dates);
          print(_selectedDay);
          bool isSelectedDayAvailable = dates.any((date) {
            DateTime parsedDate = DateTime.parse(date);
            return parsedDate.year == _selectedDay.year &&
                parsedDate.month == _selectedDay.month &&
                parsedDate.day == _selectedDay.day;
          });
          print(isSelectedDayAvailable);
          if(isSelectedDayAvailable){
            fetchTimeSlots(_selectedDay);
          }
          isLoadingDays = false;
          isErrorDays = false;
        });
      } else if (avDatesResponse.resCode == -1) {
        print("list is empty"); //TODO do something here
        setState(() {
          isLoadingDays = false;
          isErrorDays = false;
        });
      } else {
        print("error when getting list of dates");
        setState(() {
          isLoadingDays = false;
          isErrorDays = true;
        });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isLoadingDays = false;
        isErrorDays = true;
      });
    }
  }

  Future<void> fetchTimeSlots(DateTime selectedDay) async {
    try {
      setState(() {
        isLoadingSlots = true;
        isSlotsHidden = false;
      });
      AvTimeSlotsResponse avTimeSlotsResponse=await appointmentViewModel.getAvailableTimeSlots(widget.docId, selectedDay);

      if (avTimeSlotsResponse.resCode == 1) {
        print("list is not empty");
        setState(() {
          slots=avTimeSlotsResponse.slots;
          print(slots);
          isLoadingSlots = false;
        });
      } else if (avTimeSlotsResponse.resCode == -1) {
        print("list is empty"); //TODO do something here
        setState(() {
          isLoadingSlots = false;
        });
      } else {
        print("error when getting list of time slots");
        setState(() {
          isLoadingSlots = false;
        });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        isLoadingSlots = false;
      });
    }
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: true,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: "Prise de RDV",
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
            body: Stack(
              children: [
                isLoadingDays
                    ? SpinKitCircle(color: themeProvider.blue.withOpacity(0.6), size: 50.0,)
                    : isErrorDays
                    ? ErrorDisplayAndRefresh(appTextStyles, themeProvider,
                        () async {
                      setState(() {
                        fetchDates();
                      });
                    })
                    :
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Responsive.isMobile(context)?
                          /////////////////////////////////////MOBILE//////////////////////////////////
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CustomSearchDropdown(
                            list: patientsList,
                            themeProvider: themeProvider,
                            appTextStyles: appTextStyles,
                            hint: 'Choisissez le patient',
                            notFoundString: 'Aucun',
                            onValueChanged: (selectedValue) {
                              _selectedPatient=selectedValue;
                              setState(() {
                                _selectedPatientError=false;
                              });
                              print('Selected patient value: $_selectedPatient');
                            },
                          ),
                          errorWidget(appTextStyles, "Veuillez sélectionner le patient", _selectedPatientError),
                          const SizedBox(
                            height: 30,
                          ),
                          Text("Sélectionnez une date",
                              style: appTextStyles.onyxSemiBold16),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: calendar(themeProvider, appTextStyles),
                          ),
                          errorWidget(appTextStyles, "Veuillez sélectionner une date", _selectedDayError),
                          const SizedBox(
                            height: 30,
                          ),
                          isSlotsHidden ? Container() :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sélectionnez un créneau",
                                style: appTextStyles.onyxSemiBold16,
                              ),
                              const SizedBox(height: 15),
                              isLoadingSlots ? Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(color: themeProvider.blue,),
                              ) : _buildTimeList(themeProvider, appTextStyles, width),
                              errorWidget(appTextStyles, "Veuillez sélectionner un créneau", _selectedTimeError),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                          Text("Saisissez le motif du RDV",
                              style: appTextStyles.onyxSemiBold16),
                          const SizedBox(height: 10),
                          CustomMultilineTextField(
                            themeProvider: themeProvider,
                            textInputAction: TextInputAction.next,
                            hint: 'Exemple: "bilan de santé annuel"',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir le motif";
                              }  else if (value.length < 20) {
                                return 'Le motif doit contenir au moins 20 caractères';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value){
                              _motif=value ?? "";
                              print(value);
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ///BUTTON
                          Row(
                            children: [
                              Expanded(
                                child: CustomElevatedButton(
                                    txt: "Confirmer",
                                    txtStyle: appTextStyles.whiteSemiBold16,
                                    btnColor: themeProvider.ateneoBlue,
                                    btnWidth: double.maxFinite,
                                  onPressed: () {
                                    if(!formIsInvalid()){
                                      print("patient: $_selectedPatient");
                                      print("date: $_selectedDay");
                                      print("time: $_selectedTime");
                                      print("motif: $_motif");
                                      print("Processing appointment booking...");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      )
                      ///////////////////////////////////////TABLET OR DESKTOP ////////////////////
                          :Column(
                            children: [
                              SizedBox(height: 30,),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 45,),
                                        Text("Sélectionnez une date :",
                                            style: appTextStyles.onyxSemiBold16),
                                        const SizedBox(height: 45),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: calendar(themeProvider, appTextStyles),
                                        ),
                                        errorWidget(appTextStyles, "Veuillez sélectionner une date :", _selectedDayError),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: SizedBox()
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Text("Patient :",
                                              style: appTextStyles.onyxSemiBold16),
                                        ),
                                        Expanded(
                                          flex: 1,
                                            child: SizedBox()
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: CustomSearchDropdown(
                                            list: patientsList,
                                            themeProvider: themeProvider,
                                            appTextStyles: appTextStyles,
                                            hint: 'Choisissez le patient',
                                            notFoundString: 'Aucun',
                                            onValueChanged: (selectedValue) {
                                              _selectedPatient=selectedValue;
                                              setState(() {
                                                _selectedPatientError=false;
                                              });
                                              print('Selected patient value: $_selectedPatient');
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: SizedBox()
                                        )

                                      ],),
                                    errorWidget(appTextStyles, "Veuillez sélectionner le patient", _selectedPatientError),
                                    const SizedBox(
                                      height: 50,
                                    ),

                                    isSlotsHidden ? Container() :
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sélectionnez un créneau",
                                          style: appTextStyles.onyxSemiBold16,
                                        ),
                                        const SizedBox(height: 15),
                                        isLoadingSlots ? Container(
                                          margin: const EdgeInsets.only(bottom: 30),
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(color: themeProvider.blue,),
                                        ) : _buildTimeList(themeProvider, appTextStyles, width),
                                        errorWidget(appTextStyles, "Veuillez sélectionner un créneau", _selectedTimeError),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: SizedBox()
                                        ),
                                        Expanded(
                                          flex: 20,
                                          child: Text("Saisissez le motif du RDV :",
                                              style: appTextStyles.onyxSemiBold16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 40),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                            child: SizedBox()
                                        ),
                                        Expanded(
                                          flex: 20,
                                          child: CustomMultilineTextField(
                                            themeProvider: themeProvider,
                                            textInputAction: TextInputAction.next,
                                            hint: 'Exemple: "bilan de santé annuel"',
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return "Veuillez saisir le motif";
                                              }  else if (value.length < 20) {
                                                return 'Le motif doit contenir au moins 20 caractères';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onSaved: (value){
                                              _motif=value ?? "";
                                              print(value);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: SizedBox()
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ///BUTTON
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: SizedBox()
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: CustomElevatedButton(
                                            txt: "Confirmer",
                                            txtStyle: appTextStyles.whiteSemiBold16,
                                            btnColor: themeProvider.ateneoBlue,
                                            btnWidth: double.maxFinite,
                                            onPressed: () {
                                              if(!formIsInvalid()){
                                                print("patient: $_selectedPatient");
                                                print("date: $_selectedDay");
                                                print("time: $_selectedTime");
                                                print("motif: $_motif");
                                                print("Processing appointment booking...");
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: SizedBox()
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                                            ],
                                                          ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    ),
                  ),
                ),
                /*if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: SpinKitCircle(
                          color: themeProvider.blue.withOpacity(0.6),
                          size: 50.0
                      ),
                    ),
                  ),*/
              ],
            )));
  }

  /*void bookAptCall(int docId, String patient, DateTime date, String motif) async {
    setState(() {
      isLoading = true;
    });
    try {
      BookAptResponse aptResponse=await appointmentViewModel.bookApt(docId, patient, date, motif);
      switch (aptResponse.resCode) {
        case 1:
        //TODO confirm apt book dialog
          break;
        case 0:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Docteur indisponible",
              content:
              "Docteur non disponible à l'horraire choisie!",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
          break;
        case 3:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Mot de passe incorrect!",
              content:
              "Vous avez entré un mauvais mot de passe.",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
          break;
        case 5:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Une erreur s'est produite!",
              content:
              "Une erreur imprévue s'est produite. Veuillez réessayer ultérieurement.",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
          break;
        default:
          showDialog(context: context, builder: (context) {
            return CustomDialog(
              title: "Une erreur s'est produite!",
              content:
              "Veuillez vérifier votre connexion et réessayer.",
              positiveBtnText: "Ok",
              positiveBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          });
      }
    } catch (error) {
      print("Error: $error");
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }*/

  Widget _buildTimeList(
      ThemeProvider themeProvider, AppTextStyles appTextStyles, double width) {
    int count = slots.length;
    const int itemsPerRow = 3;
    const double ratio = 100 / 45;
    const double horizontalPadding = 0;
    final double calcHeight = ((width / itemsPerRow) - (horizontalPadding)) *
        (count / itemsPerRow).ceil() *
        (1 / ratio);
    return SizedBox(
      height: calcHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: ratio,
        ),
        itemCount: slots.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedSlotIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSlotIndex = index;
                _selectedTime = slots[selectedSlotIndex];
                _selectedTimeError = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? themeProvider.ateneoBlue : themeProvider.bubbles,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  slots[index],
                  style: isSelected
                      ? appTextStyles.bubblesSemiBold14
                      : appTextStyles.ateneoBlueSemiBold14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }



  Widget calendar(ThemeProvider themeProvider, AppTextStyles appTextStyles) {
    return TableCalendar(
      availableGestures: AvailableGestures.horizontalSwipe,
      enabledDayPredicate: (DateTime day) {
        // extract year, month, and day from the day parameter
        int year = day.year;
        int month = day.month;
        int dayOfMonth = day.day;

        // convert each allowedDate to date-only DateTime objects
        List<DateTime> allowedDates = dates.map((date) => DateTime.parse(date).toLocal()).toList();

        // check if the day (year, month, day) is in the list of allowed dates
        for (DateTime allowedDate in allowedDates) {
          if (allowedDate.year == year &&
              allowedDate.month == month &&
              allowedDate.day == dayOfMonth) {
            return true;
          }
        }

        return false; // day is not in the list of allowed dates
      },
      headerStyle: HeaderStyle(
        titleTextStyle: appTextStyles.onyxSemiBold12,
        titleCentered: true,
        formatButtonVisible: false,
      ),
      calendarStyle: CalendarStyle(
        cellMargin: const EdgeInsets.all(5.0),
        cellPadding: const EdgeInsets.all(2.0),
        defaultTextStyle: appTextStyles.onyxSemiBold12,
        todayTextStyle: appTextStyles.onyxSemiBold12,
        todayDecoration: BoxDecoration(
            border: Border.all(
              color: themeProvider.ateneoBlue,
            ),
            shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(
            color: themeProvider.ateneoBlue, shape: BoxShape.circle),
        outsideDaysVisible: false,
      ),
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },

      focusedDay: _focusedDay,
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedTime = "";
          selectedSlotIndex = -1;
          _selectedDay = selectedDay;
          _selectedDayError = false;
          _focusedDay = focusedDay;
          fetchTimeSlots(selectedDay);
        });
      },
    );
  }

  bool formIsInvalid() {
    if (_selectedPatient.isEmpty) {
      setState(() {
        _selectedPatientError = true;
      });
    } else{
      setState(() {
        _selectedPatientError = false;
      });
    }

    if (isSlotsHidden) {
      setState(() {
        _selectedDayError = true;
      });
    } else{
      setState(() {
        _selectedDayError = false;
      });
    }

    if (_selectedTime.isEmpty) {
      setState(() {
        _selectedTimeError = true;
      });
    } else{
      setState(() {
        _selectedTimeError = false;
      });
    }
    bool motifError=false;
    if(_formKey.currentState!.validate()){
      motifError=false;
    } else{
      motifError=true;
    }
    return _selectedPatientError || _selectedDayError || _selectedTimeError || motifError;
  }

 Widget errorWidget(AppTextStyles appTextStyles, String msg, bool condition){
    return  Visibility(
      visible: condition,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            msg,
            style: appTextStyles.redLight13,
          )
        ],
      ),
    );
 }
}
