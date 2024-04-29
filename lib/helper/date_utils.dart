import 'package:intl/intl.dart';

String formatDate(String dateString) {
  // Parse the input date string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

  // Return the formatted date string
  return formattedDate;
}
