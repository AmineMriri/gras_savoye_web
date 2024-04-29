import 'package:flutter/foundation.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class TabProvider extends ChangeNotifier {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  void setTab(int index) {
    controller.index = index;
    notifyListeners();
  }
}
