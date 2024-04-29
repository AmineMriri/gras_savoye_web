import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import 'package:healio/views/bulletins/bulletin_list.dart';
import 'package:healio/widgets/custom_app_bar.dart';
import '../../helper/app_text_styles.dart';
import '../../widgets/custom_appbar_button.dart';

class BulletinsArchiveScreen extends StatefulWidget {
  const BulletinsArchiveScreen({Key? key}) : super(key: key);

  @override
  State<BulletinsArchiveScreen> createState() => _BulletinsArchiveScreenState();
}

class _BulletinsArchiveScreenState extends State<BulletinsArchiveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
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
          tabBar: TabBar(
            controller: _tabController,
            // Add TabController
            indicatorColor: themeProvider.ateneoBlue,
            labelColor: themeProvider.ateneoBlue,
            unselectedLabelColor: themeProvider.cadetGrey,
            tabs: const [
              Tab(text: 'Foulena'),
              Tab(text: 'Flen'),
              Tab(text: 'Mes enfants'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            /*BulletinList(),
            BulletinList(),
            BulletinList(),*/
          ],
        ),
      ),
    );
  }
}
