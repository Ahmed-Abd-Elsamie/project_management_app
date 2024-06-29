import 'package:hive/hive.dart';
import 'package:project_management_app/core/config/constants/local_boxes.dart';

class ConfigLocalDataSource {
  static bool isAppFirstOpen() {
    return Hive.box(LocalDataSourceBoxes.configBox).get(
      LocalDataSourceKeys.isFirstOpen,
      defaultValue: true,
    );
  }

  static Future<void> setAppFirstOpen(bool isFirstOpen) async {
    await Hive.box(LocalDataSourceBoxes.configBox)
        .put(LocalDataSourceKeys.isFirstOpen, isFirstOpen);
  }

  static Future<void> clearConfigLocalDataSource() async {
    await Hive.box(LocalDataSourceBoxes.configBox).deleteAll([
      LocalDataSourceKeys.isFirstOpen,
    ]);
  }
}
