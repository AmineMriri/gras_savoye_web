import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/appointments/appointments_list.dart';
import 'package:healio/widgets/custom_app_bar.dart';

class AptArchiveScreen extends StatefulWidget {
  const AptArchiveScreen({Key? key}) : super(key: key);

  @override
  State<AptArchiveScreen> createState() => _AptArchiveScreenState();
}

class _AptArchiveScreenState extends State<AptArchiveScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: themeProvider.ghostWhite,
        appBar: CustomAppBar(
          title: "Archives",
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
        body: const AppointmentsList(),
      ),
    );
  }
}
