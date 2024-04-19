import 'package:flutter/widgets.dart';
import 'package:shorebird_update_checker/shorebird_update_checker.dart';
import 'package:shorebird_update_checker/src/controllers/update_controller.dart';

class UpdateButton extends StatefulWidget {
  /// A customizable button that reflects the new version check status
  /// and restarts the app when a new version is available.
  const UpdateButton(
      {super.key,
      required this.controller,
      required this.updateAvailableWidget,
      this.checkingForUpdatesWidget = const SizedBox.shrink(),
      this.upToDateWidget = const SizedBox.shrink()});

  ///The controller of the button
  final UpdateController controller;

  /// What to display when the checking of new updates is in progress.
  final Widget checkingForUpdatesWidget;

  /// What to display when the app can be updated
  final Widget Function(bool storesNewVersion, bool shorebirdNewVersion)
      updateAvailableWidget;

  /// What to display when the app is already up to date
  final Widget upToDateWidget;

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        if (widget.controller.isCheckingForUpdates) {
          return widget.checkingForUpdatesWidget;
        }

        if (widget.controller.isNewVersionAvailable) {
          return widget.updateAvailableWidget(
              false, widget.controller.shorebirdIsNewPatchAvailableForDownload);
        }

        return widget.upToDateWidget;
      },
    );
  }
}
