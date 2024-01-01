class UpdateCheckerConfig {
  final bool enableAppStoreUpdateChecker;
  final bool enableShorebirdUpdateChecker;

  final bool forceAppStoreUpdate;
  final bool forceShorebirdUpdate;

  final String? androidAppId;
  final String iOSAppId;

  const UpdateCheckerConfig({
    required this.iOSAppId,
    this.androidAppId,
    this.enableAppStoreUpdateChecker = true,
    this.enableShorebirdUpdateChecker = true,
    this.forceAppStoreUpdate = false,
    this.forceShorebirdUpdate = false,
  });
}
