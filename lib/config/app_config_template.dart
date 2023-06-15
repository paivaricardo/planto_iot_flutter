class AppConfig {
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

  static String get backendUri {
    return isDebug ? 'http://<debug_url>:<debug_port>' : 'http://<release_url>:<release_port>';
  }
}
