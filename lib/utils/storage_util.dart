import 'package:shared_preferences/shared_preferences.dart';
class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;


  static  getInstance()  {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = StorageUtil._();
       secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }
  StorageUtil._();

  Future _init() async {
  _preferences = await SharedPreferences.getInstance();
}
  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }
  // put string
  static Future putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value);
  }

  // get bool
  static bool getBool(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences.getBool(key) ?? defValue;
  }
  // put bool
  static Future putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences.setBool(key, value);
  }

  // check if key exists
  static bool checkBool(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences.containsKey(key) ?? defValue;
  }

  // Remove keys
  static Future removeKey(String key, {String defValue = ''}) {
    if (_preferences == null) return null;
    return _preferences.remove(key) ?? defValue;
  }





}