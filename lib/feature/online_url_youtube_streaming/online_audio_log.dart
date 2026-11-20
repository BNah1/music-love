import 'package:flutter/foundation.dart';

/// Debug breadcrumbs without printing signed, short-lived stream URLs.
class OnlineAudioLog {
  OnlineAudioLog._();

  static void event(String stage, [String? detail]) {
    if (!kDebugMode) return;
    debugPrint('[ONLINE_AUDIO] $stage${detail == null ? '' : ' | $detail'}');
  }

  static void error(String stage, Object error) {
    if (!kDebugMode) return;
    final safeMessage = error.toString().replaceAll(
      RegExp(r'https?://[^\s]+'),
      '[URL hidden]',
    );
    event(stage, '${error.runtimeType}: $safeMessage');
  }
}
