class AppConfig {
  static bool isDebug = bool.fromEnvironment('dart.vm.product') == false;
  static const bool? isDebugOverride = null;

  static String get backendAuthority {
    if (isDebugOverride != null) {
      isDebug = isDebugOverride!;
    }

    return isDebug
        ? '<debug_host>:<debug_port>'
        : '<release_host>:<release_port>';
  }
}
