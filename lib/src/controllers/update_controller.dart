import 'package:flutter/widgets.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../../shorebird_update_checker.dart';

class UpdateController extends ChangeNotifier {
  // bool _storesNewVersion = false;
  int? _shorebirdCurrentPatchNumber;
  int? _shorebirdNewPatchVersion;
  bool _isCheckingForUpdates = false;
  bool _shorebirdIsNewPatchAvailableForDownload = false;
  late bool _isShorebirdAvailable;

  int? get shorebirdCurrentPatchNumber => _shorebirdCurrentPatchNumber;
  int? get shorebirdNewPatchVersion => _shorebirdNewPatchVersion;
  bool get isCheckingForUpdates => _isCheckingForUpdates;
  bool get isNewVersionAvailable => _shorebirdIsNewPatchAvailableForDownload;
  bool get shorebirdIsNewPatchAvailableForDownload =>
      _shorebirdIsNewPatchAvailableForDownload;
  bool get isShorebirdAvailable => _isShorebirdAvailable;
  // String _storesNewVersionName = '';

  /// The controller in charge of checking for updates and updating the UI
  /// of the [UpdateButton] widget.
  UpdateController({required this.currentVersion, required this.config});

  final String currentVersion;
  // bool get storesNewVersion => _storesNewVersion;
  int? get shorebirdNewVersionNumber => _shorebirdCurrentPatchNumber;
  // String get storesNewVersionName => _storesNewVersionName;

  final UpdateCheckerConfig config;
  late ShorebirdCodePush shorebirdCodePush;

  Future<void> updateShorebird({bool restartApp = true}) async {
    if (_shorebirdIsNewPatchAvailableForDownload) {
      await shorebirdCodePush.downloadUpdateIfAvailable();
      notifyListeners();
      if (restartApp && await shorebirdCodePush.isNewPatchReadyToInstall()) {
        Restart.restartApp();
      }
    }
  }

  Future<void> init() async {
    shorebirdCodePush = ShorebirdCodePush();
    _isShorebirdAvailable = shorebirdCodePush.isShorebirdAvailable();
    notifyListeners();
    if (_isShorebirdAvailable) {
      _isCheckingForUpdates = true;
      notifyListeners();
      await Future.wait<void>([
        () async {
          _shorebirdCurrentPatchNumber =
              await shorebirdCodePush.currentPatchNumber();
          notifyListeners();
        }(),
        () async {
          _shorebirdNewPatchVersion = await shorebirdCodePush.nextPatchNumber();
          notifyListeners();
        }(),
        () async {
          _shorebirdIsNewPatchAvailableForDownload =
              await shorebirdCodePush.isNewPatchAvailableForDownload();
          notifyListeners();
        }(),
      ]);
      _isCheckingForUpdates = false;
      notifyListeners();
    }
  }

  //WIP
  // Future<bool> checkForShorebirdUpdates() async {
  //   _isCheckingForUpdates = true;
  //   notifyListeners();

  //   await Future.wait<void>([
  //     () async {
  //       if (config.enableAppStoreUpdateChecker) {
  //         AppStoreUpdateChecker appStoreUpdateChecker =
  //             AppStoreUpdateChecker(() {});
  //         await appStoreUpdateChecker.checkForUpdates();
  //         _storesNewVersion = appStoreUpdateChecker.hasUpdates;
  //       }
  //     }(),
  //     () async {
  //       if (config.enableShorebirdUpdateChecker) {
  //         ShorebirdUpdateChecker shoreUpdateChecker =
  //             ShorebirdUpdateChecker(() {});
  //         await shoreUpdateChecker.checkForUpdates();
  //         _shorebirdNewVersion = shoreUpdateChecker.hasUpdates;
  //       }
  //     }()
  //   ]);

  //   _isCheckingForUpdates = false;
  //   notifyListeners();

  //   return hasNewVersion;
  // }
}
