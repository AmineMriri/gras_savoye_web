import 'package:healio/helper/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import '../helper/app_text_styles.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget icon;
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
      backgroundColor: themeProvider.ghostWhite,
      elevation: 0,
      title: Text(
        widget.title,
        style: appTextStyles.onyxBold20,
      ),
      centerTitle: true,
      leading: widget.icon,
      bottom: widget.tabBar,
      actions: [if (widget.trailing != null) widget.trailing!],
    );
  }
}
