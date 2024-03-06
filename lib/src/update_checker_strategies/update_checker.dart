import 'dart:async';

abstract class UpdateChecker {
  UpdateChecker(this.refresh);

  void Function() refresh;
  static const hasUpdateFailedKey = 'hasUpdateFailed';
  bool hasUpdateFailed = false;
  bool hasUpdates = false;
  bool readyToInstall = false;

  int checkCount = 0;

  Future checkForUpdates();
}
