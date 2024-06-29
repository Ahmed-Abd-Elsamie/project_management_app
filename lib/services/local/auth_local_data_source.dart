import 'package:hive/hive.dart';
import 'package:project_management_app/core/config/constants/local_boxes.dart';

class AuthLocalDataSource {
  static String getUserToken() {
    return Hive.box(LocalDataSourceBoxes.authBox).get(
      LocalDataSourceKeys.userToken,
      defaultValue: "",
    );
  }

  static Future<void> setUserToken(String token) async {
    await Hive.box(LocalDataSourceBoxes.authBox)
        .put(LocalDataSourceKeys.userToken, token);
  }

  static Map<dynamic, dynamic> getUserData() {
    return Hive.box(LocalDataSourceBoxes.authBox).get(
      LocalDataSourceKeys.userData,
      defaultValue: {},
    );
  }

  static Future<void> setUserData(Map<String, dynamic> userData) async {
    await Hive.box(LocalDataSourceBoxes.authBox)
        .put(LocalDataSourceKeys.userData, userData);
  }

  static Future<void> clearAuthLocalDataSource() async {
    await Hive.box(LocalDataSourceBoxes.authBox).deleteAll([
      LocalDataSourceKeys.userToken,
      LocalDataSourceKeys.userData,
    ]);
  }
}
