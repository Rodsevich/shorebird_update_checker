import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:store_redirect/store_redirect.dart';

import '../config/update_checker_config.dart';
import '../update_checker_strategies/update_checker_strategies.dart';

class CheckForUpdatesWidget extends StatefulWidget {
  const CheckForUpdatesWidget({
    super.key,
    required this.child,
    required this.config,
  });

  factory CheckForUpdatesWidget.builder(
    BuildContext context,
    Widget? child, {
    required UpdateCheckerConfig config,
  }) =>
      CheckForUpdatesWidget(
        config: config,
        child: child,
      );

  final Widget? child;
  final UpdateCheckerConfig config;

  @override
  State<CheckForUpdatesWidget> createState() => _CheckForUpdatesWidgetState();
}

class _CheckForUpdatesWidgetState extends State<CheckForUpdatesWidget> {
  late ShorebirdUpdateChecker shoreUpdateChecker;
  late AppStoreUpdateChecker appStoreUpdateChecker;

  @override
  void initState() {
    super.initState();

    shoreUpdateChecker = ShorebirdUpdateChecker(() => setState(() {}));
    appStoreUpdateChecker = AppStoreUpdateChecker(() => setState(() {}));

    () async {
      await appStoreUpdateChecker.checkForUpdates();
      if (!appStoreUpdateChecker.hasUpdates) {
        await shoreUpdateChecker.checkForUpdates();
      }
    }();
  }

  bool get isArabic {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar';
  }

  String get updateInstalled {
    if (isArabic) {
      return 'تم تثبيت التحديث!';
    } else {
      return 'Update installed!';
    }
  }

  String get restartApp {
    if (isArabic) {
      return 'أعد تشغيل التطبيق';
    } else {
      return 'Restart App';
    }
  }

  String get downloadingUpdate {
    if (isArabic) {
      return 'جاري تحميل التحديث...';
    } else {
      return 'Downloading update...';
    }
  }

  String get updateAvailablePleaseUpdateFromAppStore {
    if (isArabic) {
      return 'تحديث متوفر. يرجى التحديث من متجر التطبيقات';
    } else {
      return 'Update available. Please update from the app store';
    }
  }

  String get openAppStore {
    if (isArabic) {
      return 'افتح متجر التطبيقات';
    } else {
      return 'Open App Store';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.child != null) widget.child!,
          if (appStoreUpdateChecker.hasUpdates)
            ..._buildForAppStore()
          else if (shoreUpdateChecker.hasUpdates)
            ..._buildForShore(),
        ],
      ),
    );
  }

  _buildUpdate(List<Widget> children) => [
        const ColoredBox(color: Colors.black54),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            blendMode: BlendMode.srcOver,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    ),
                    child: Column(
                      key: ValueKey(
                          'readyToInstall: ${shoreUpdateChecker.readyToInstall}'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ];

  _buildForAppStore() => _buildUpdate([
        Text(
          updateAvailablePleaseUpdateFromAppStore,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => StoreRedirect.redirect(
            androidAppId: widget.config.androidAppId,
            iOSAppId: widget.config.iOSAppId,
          ),
          child: Text(openAppStore),
        ),
      ]);

  _buildForShore() => _buildUpdate(
        [
          if (shoreUpdateChecker.readyToInstall) ...[
            Text(
              updateInstalled,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: Restart.restartApp,
              child: Text(restartApp),
            ),
          ] else ...[
            Text(
              downloadingUpdate,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              backgroundColor:
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            ),
          ]
        ],
      );
}
