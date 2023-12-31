class UpdateCheckerConfig {
  final bool enableAppStoreUpdateChecker;
  final bool enableShorebirdUpdateChecker;

  final bool forceAppStoreUpdate;
  final bool forceShorebirdUpdate;

  const UpdateCheckerConfig({
    this.enableAppStoreUpdateChecker = true,
    this.enableShorebirdUpdateChecker = true,
    this.forceAppStoreUpdate = false,
    this.forceShorebirdUpdate = false,
  });
}
