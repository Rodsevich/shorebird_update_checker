import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'update_checker.dart';

class AppStoreUpdateChecker extends UpdateChecker {
  AppStoreUpdateChecker(super.refresh);

  final upgrader = Upgrader();

  @override
  Future checkForUpdates() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    hasUpdateFailed = prefs.getBool(UpdateChecker.hasUpdateFailedKey) ?? false;
    if (hasUpdateFailed) {
      return;
    }

    try {
      checkCount++;
      await upgrader.initialize();
      hasUpdates = upgrader.shouldDisplayUpgrade();
      refresh();
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      if (checkCount < 5) {
        await checkForUpdates();
      } else {
        prefs.setBool(UpdateChecker.hasUpdateFailedKey, true);
      }
    }
  }
}
