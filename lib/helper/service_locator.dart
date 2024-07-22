import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

class SelectedDbValueService {
  late SharedPreferences _prefs;
  String? _selectedValue;

  SelectedDbValueService() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _selectedValue = _prefs.getString('selectedDbValue') ?? '';
  }

  String? get selectedValue => _selectedValue;

  Future<String?> getSelectedValue() async {
    await _init(); // Ensure _prefs is initialized
    return _selectedValue;
  }

  Future<void> setSelectedValue(String value) async {
    await _init(); // Ensure _prefs is initialized
    _selectedValue = value;
    await _prefs.setString('selectedDbValue', value);
  }
}

void setupLocator() {
  locator.registerLazySingleton(() => SelectedDbValueService());
}
