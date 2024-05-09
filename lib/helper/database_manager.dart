import 'package:odoo_rpc/odoo_rpc.dart';
import '../helper/config.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  late final OdooClient _odooClient;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal() {
    _odooClient = OdooClient(AppConfig.localServerUrl);
  }

  OdooClient get odooClient => _odooClient;

  Future<void> authenticate() async {
    try {
      await _odooClient.authenticate(
          'odoo_test', AppConfig.localDbUsername, AppConfig.localDbPassword);
    } catch (e) {
      print("Error authenticating with database: $e");
      rethrow;
    }
  }
}
