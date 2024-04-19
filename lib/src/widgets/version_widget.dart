import 'package:flutter/widgets.dart';
import 'package:shorebird_update_checker/src/widgets/update_button.dart';

import '../controllers/update_controller.dart';

Widget _emptySizedBox2(int? currentPatchNumber, int shorebirdNewPatchNumber) =>
    const SizedBox.shrink();

Widget _emptySizedBox1(int? currentPatchNumber) => const SizedBox.shrink();

typedef NewVersionBuilder = Widget Function(
    int? currentPatchNumber, int shorebirdNewPatchNumber);

typedef CurrentVersionBuilder = Widget Function(int? currentPatchNumber);

class ShorebirdVersionWidget extends StatefulWidget {
  const ShorebirdVersionWidget(
      {super.key,
      required this.controller,
      this.updateAvailableWidget = _emptySizedBox2,
      this.checkingForUpdatesWidget = _emptySizedBox1,
      this.upToDateWidget = _emptySizedBox1});

  /// The controller of the button
  final UpdateController controller;

  /// What to display when the checking of new updates is in progress.
  final CurrentVersionBuilder checkingForUpdatesWidget;

  /// What to display when the app can be updated
  final NewVersionBuilder updateAvailableWidget;

  /// What to display when the app is already up to date
  final CurrentVersionBuilder upToDateWidget;

  @override
  State<ShorebirdVersionWidget> createState() => _ShorebirdVersionWidgetState();
}

class _ShorebirdVersionWidgetState extends State<ShorebirdVersionWidget> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? child) {
        if (widget.controller.isCheckingForUpdates) {
          return widget.checkingForUpdatesWidget(
              widget.controller.shorebirdCurrentPatchNumber);
        }

        if (widget.controller.shorebirdIsNewPatchAvailableForDownload) {
          return widget.updateAvailableWidget(
              widget.controller.shorebirdCurrentPatchNumber,
              widget.controller.shorebirdNewPatchVersion!);
        }

        return widget
            .upToDateWidget(widget.controller.shorebirdCurrentPatchNumber);
      },
    );
  }
}
