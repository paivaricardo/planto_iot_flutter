class JsonLeituraKeysParser {
  static Map<String, String> keyMap = {
    'percentualUmidadeSolo': 'Umidade Solo (%)',
  };

  static parseJsonLeituraKeys(List<String> keys) {
    return keys.map((key) => keyMap[key] ?? key).toList();
  }
}