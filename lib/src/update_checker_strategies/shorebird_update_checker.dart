import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'update_checker.dart';

class ShorebirdUpdateChecker implements UpdateChecker {
  ShorebirdUpdateChecker(this.refresh);

  final shorebirdCodePush = ShorebirdCodePush();

  @override
  bool hasUpdates = false;

  @override
  bool readyToInstall = false;

  @override
  void Function() refresh;

  @override
  Future checkForUpdates() async {
    try {
      hasUpdates = await shorebirdCodePush.isNewPatchAvailableForDownload();
      refresh();
      if (hasUpdates) {
        await shorebirdCodePush.downloadUpdateIfAvailable();
        readyToInstall = await shorebirdCodePush.isNewPatchReadyToInstall();
        refresh();
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 60));
      checkForUpdates();
    }
  }
}
