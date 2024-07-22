import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/providers/theme_provider.dart';
import '../models/menu_modal.dart';
import '../views/auth/sign_in_screen.dart';
import '../views/responsive.dart';




class MyDrawer extends StatefulWidget{
  final int initialSelectedIndex=0;

  final Function(int) onItemSelected;

  const MyDrawer({Key? key, required this.onItemSelected}) : super(key: key);


  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  void onItemSelected(int index) {
    // Call the callback function provided in the constructor
    widget.onItemSelected(index);
  }

  List<MenuModel> menu = [
    MenuModel(icon: 'assets/svg/home-svg.svg', title: "Mes Bulletins"),
    MenuModel(icon: 'assets/svg/doctor-svg.svg', title: "Doctors"),
    MenuModel(icon: 'assets/svg/calendar-svg.svg', title: "Mes RDVs"),
    MenuModel(icon: 'assets/svg/notification-svg.svg', title: "Notifications"),
    MenuModel(icon: 'assets/svg/profile-svg.svg', title: "Profile"),
    // MenuModel(icon: 'assets/svg/signout.svg', title: "Déconnexion"),

  ];

  late int selected = 0;

  int hover = 0;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelectedIndex;
  }

@override
Widget build (BuildContext context){
  final themeProvider = Provider.of<ThemeProvider>(context);

  return Container(
    height: MediaQuery.of(context).size.height,
    // decoration: BoxDecoration(color: appTheme.blueGray),
    decoration: BoxDecoration(
        color : Colors.white
    ),

    child: Container(

      child:
      Padding(

        padding: const EdgeInsets.all(15.0),
        child:
        SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 40 : 80,
                ),
                for (var i = 0; i < (Responsive.isDesktop(context)?menu.length-1:menu.length); i++)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      color: selected == i ? themeProvider.lightSilver : Colors.transparent,
                    ),
                    child: InkWell(
                      onHover: (value) {
                        setState(() {
                          if (value) {
                            hover = i;
                          } else {
                            hover = -1;
                          }
                        });
                      },
                      onTap: () {
                        setState(() {
                          selected = i;
                          switch (i) {
                            case 0:
                              onItemSelected(0);
                              break;

                            case 1:
                              onItemSelected(1);
                              break;

                            case 2:
                              onItemSelected(2);
                              break;

                            case 3:
                              onItemSelected(3);
                              break;

                            case 4:
                              onItemSelected(4);
                              break;
                            case 5 :
                              performLogout();
                              onItemSelected(5);
                              break;
                          }

                          // widget.navigate(i);
                        });
                      },
                      child:
                      // Responsive.isTablet(context) ?
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13, vertical: 7),
                            child: SvgPicture.asset(
                              menu[i].icon,
                              color: selected == i
                                  // ? Colors.white
                                ?themeProvider.ateneoBlue
                                  : hover == i
                                  // ? appTheme.whiteA700
                              // ? Colors.white
                                ?themeProvider.ateneoBlue
                              // : lightBlueGray,
                              : Color(0xFF8F95B2),
                              height:25,
                              width:25,
                            ),
                          ),
                          // Text(
                          //   menu[i].title,
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: selected == i
                          //           ? Colors.white
                          //           : hover == i
                          //           // ? appTheme.whiteA700
                          //           ? Colors.white
                          //           // : lightBlueGray,
                          //           : Color(0xFF8F95B2),
                          //
                          //       fontWeight: FontWeight.w600),
                          // )
                        ],
                      )
                      //     : Row(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      //       child:
                      //       SvgPicture.asset(
                      //         menu[i].icon,
                      //         color: selected == i
                      //             // ? Colors.white
                      //             ?themeProvider.ateneoBlue
                      //             : hover == i
                      //             // ? appTheme.whiteA700
                      //             // ? Colors.white
                      //             ?themeProvider.ateneoBlue
                      //             // : lightBlueGray,
                      //             : Color(0xFF8F95B2),
                      //         height:25,
                      //         width:25,
                      //       ),
                      //     ),
                      //     // Text(
                      //     //   menu[i].title,
                      //     //   style: TextStyle(
                      //     //       fontSize: 16,
                      //     //       color: selected == i
                      //     //           ? Colors.white
                      //     //           : hover == i
                      //     //       // ? appTheme.whiteA700
                      //     //           ? Colors.white
                      //     //       // : lightBlueGray,
                      //     //           : Color(0xFF8F95B2),
                      //     //       fontWeight: FontWeight.w600),
                      //     // )
                      //   ],
                      // ),
                    ),
                  ),
              ],
            )),
      ),
    ),
  );
}
  void performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SignInScreen();
        },
      ),
          (_) => false,
    );
  }
}


