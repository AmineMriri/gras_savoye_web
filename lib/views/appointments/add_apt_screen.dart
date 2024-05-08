import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/models/doctor.dart';
import 'package:healio/models/responses/appointment/av_dates_response.dart';
import 'package:healio/models/responses/appointment/av_time_slots_response.dart';
import 'package:healio/models/responses/appointment/book_apt_reponse.dart';
import 'package:healio/view_models/appointment_view_model.dart';
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
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late AppointmentViewModel appointmentViewModel;
  bool isLoadingDays = true;
  bool isSlotsHidden = true;
  bool isLoadingSlots = false;
  bool isErrorDays = false;
  List<dynamic> dates=[];
  List<dynamic> slots=[];

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
            backgroundColor: themeProvider.ghostWhite,
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
                    ? SpinKitCircle(color: themeProvider.blue, size: 50.0,)
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
                    child: Column(
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
                            print('Selected patient value: $selectedValue');
                          },
                        ),
                        /*Container(
                              margin: const EdgeInsets.fromLTRB(35, 5, 25, 0),
                              child:
                              TextFormField(
                                //controller: messageController,
                                style: appTextStyles.greyLight13,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                maxLength: 3000,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Le message ne doit pas être vide";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: themeProvider.lightSilver,
                                        width: 1,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: themeProvider.red,
                                        width: 1,
                                      ),
                                    ),
                                    errorStyle: appTextStyles.redLight13,
                                    hintText: 'Saisissez le motif du RDV ...',
                                    hintStyle: appTextStyles.cadetGreyLight13,
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                ),
                              ),
                            ),*/
                        /*const SizedBox(
                              height: 15,
                            ),
                            //SEARCH ICON CONTAINER
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: themeProvider.ateneoBlue,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.search_rounded,
                                    color: themeProvider.bubbles,
                                  ),
                                  onPressed: ()=>null,
                                ),
                              ),
                            ),*/
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
                              child: const CircularProgressIndicator(),
                            ) : _buildTimeList(themeProvider, appTextStyles, width),
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
                              return "Le motif ne doit pas être vide";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value){
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
                                  onPressed: () => null),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                /*if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: SpinKitCircle(
                          color: themeProvider.blue,
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

  int selectedIndex = -1;
  String _selectedTime = "";

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
      height: calcHeight, // Set a fixed height or adjust as needed
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust the number of columns as needed
          mainAxisSpacing: 10.0, // Spacing between rows
          crossAxisSpacing: 10.0, // Spacing between columns
          childAspectRatio: ratio, // Adjust aspect ratio of each grid item
        ),
        itemCount: slots.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                _selectedTime = slots[selectedIndex];
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
          selectedIndex = -1;
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          fetchTimeSlots(selectedDay);
        });
      },
    );
  }
}
