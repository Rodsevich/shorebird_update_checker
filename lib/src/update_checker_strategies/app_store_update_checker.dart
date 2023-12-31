import 'package:upgrader/upgrader.dart';

import 'update_checker.dart';

class AppStoreUpdateChecker implements UpdateChecker {
  AppStoreUpdateChecker(this.refresh);

  final upgrader = Upgrader();

  @override
  bool hasUpdates = false;

  @override
  bool readyToInstall = false;

  @override
  void Function() refresh;

  @override
  Future checkForUpdates() async {
    await upgrader.initialize();
    hasUpdates = upgrader.shouldDisplayUpgrade();
    refresh();
  }
}
