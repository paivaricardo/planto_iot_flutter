class AppConfig {
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

  static String get backendAuthority {
    return isDebug ? '<debug_host>:<debug_port>' : '<release_host>:<release_port>';
  }
}
