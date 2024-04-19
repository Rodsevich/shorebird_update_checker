import 'package:flutter/widgets.dart';
import 'package:shorebird_update_checker/src/controllers/update_controller.dart';

typedef UpdateDialogTrigger = Future Function(
    int currentPatchNumber, int newPatchNumber);

class UpdateDialogDispatcher extends StatefulWidget {
  const UpdateDialogDispatcher(
      {super.key,
      required this.child,
      required this.controller,
      required this.updateDialogTrigger});

  final Widget child;
  final UpdateController controller;
  final UpdateDialogTrigger updateDialogTrigger;

  @override
  State<UpdateDialogDispatcher> createState() => _UpdateDialogDispatcherState();
}

class _UpdateDialogDispatcherState extends State<UpdateDialogDispatcher> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.isNewVersionAvailable) {
        widget.updateDialogTrigger(
            widget.controller.shorebirdCurrentPatchNumber!,
            widget.controller.shorebirdNewPatchVersion!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
