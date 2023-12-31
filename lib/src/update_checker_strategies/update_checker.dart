import 'dart:async';

abstract class UpdateChecker {
  UpdateChecker(this.refresh);
  void Function() refresh;

  bool hasUpdates = false;
  bool readyToInstall = false;

  Future checkForUpdates();
}
