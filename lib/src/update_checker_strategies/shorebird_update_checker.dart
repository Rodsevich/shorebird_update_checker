import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'update_checker.dart';

class ShorebirdUpdateChecker extends UpdateChecker {
  ShorebirdUpdateChecker(super.refresh);

  final shorebirdCodePush = ShorebirdCodePush();

  @override
  Future checkForUpdates() async {
    try {
      checkCount++;
      if (hasUpdates) {
        final updated = await shorebirdCodePush.isNewPatchReadyToInstall();
        if (updated) {
          readyToInstall = true;
          refresh();
          return;
        }
      }

      hasUpdates = await shorebirdCodePush.isNewPatchAvailableForDownload();
      refresh();
      if (hasUpdates) {
        await shorebirdCodePush.downloadUpdateIfAvailable();
        readyToInstall = await shorebirdCodePush.isNewPatchReadyToInstall();
        refresh();
      }
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      if (checkCount < 5) {
        await checkForUpdates();
      }
    }
  }
}
