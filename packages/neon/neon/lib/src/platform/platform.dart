import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:neon/src/platform/android.dart';
import 'package:neon/src/platform/linux.dart';

/// Implements platform specific functionality and exposes the availability of certain features.
@immutable
abstract interface class NeonPlatform {
  @visibleForTesting
  factory NeonPlatform.mocked(final NeonPlatform platform) => _platform = platform;

  static NeonPlatform? _platform;

  /// Infers and configures the platform automatically.
  ///
  /// Required to be called before accessing [NeonPlatform.instance].
  static Future<void> setup() async {
    if (Platform.isAndroid) {
      _platform = const AndroidNeonPlatform();
    } else if (Platform.isLinux) {
      _platform = const LinuxNeonPlatform();
    } else {
      throw UnimplementedError('No implementation for platform ${Platform.operatingSystem} found');
    }

    await _platform!.init();
  }

  /// Gets the current instance of [NeonPlatform].
  ///
  /// Make sure [NeonPlatform.setup] has been called before accessing the instance.
  static NeonPlatform get instance {
    if (_platform == null) {
      throw StateError(
        'NeonPlatform has not been set up yet. Please make sure NeonPlatform.setup() has been called before and completed.',
      );
    }

    return _platform!;
  }

  abstract final bool canUseWebView;

  abstract final bool canUseQuickActions;

  abstract final bool canUseSystemTray;

  abstract final bool canUseWindowManager;

  abstract final bool canUseCamera;

  abstract final bool canUsePushNotifications;

  FutureOr<String> get userAccessibleAppDataPath;

  FutureOr<void> init();
}
