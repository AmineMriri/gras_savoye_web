import 'package:healio/helper/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:healio/views/responsive.dart';
import '../helper/app_text_styles.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget? icon;
  final ThemeProvider themeProvider;
  final TabBar? tabBar;
  final Widget? trailing;

  const CustomAppBar({
    required this.title,
    required this.icon,
    required this.themeProvider,
    this.tabBar,
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => tabBar == null
      ? const Size.fromHeight(kToolbarHeight)
      : Size.fromHeight(kToolbarHeight + tabBar!.preferredSize.height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late ValueNotifier<bool> isDialOpen;

  @override
  void initState() {
    super.initState();
    isDialOpen = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    AppTextStyles appTextStyles = AppTextStyles(context);
    final themeProvider = widget.themeProvider;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.title,
        style: Responsive.isMobile(context)?appTextStyles.ateneoBlueBold20:appTextStyles.ateneoBlueBold24,
      ),
      centerTitle: true,
      leading: Row(
        children: [
          const SizedBox(width: 15),
          SizedBox(
            width: 40,
            child: widget.icon ?? Image.asset("assets/images/logo.png",),
          ),
        ],
      ),

      bottom: widget.tabBar,
      actions: [if (widget.trailing != null) widget.trailing!],
    );
  }
}
