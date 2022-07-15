import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  saveData() async {
    final storage = await SharedPreferences.getInstance();
    storage.setString();
  }
}
