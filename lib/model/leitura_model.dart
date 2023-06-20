class LeituraModel {
  int idSensorAtuador;
  int idLeituraAtuacao;
  int idTipoSinal;
  DateTime dataHoraLeitura;
  Map<String, dynamic> jsonLeitura;

  LeituraModel({
    required this.idSensorAtuador,
    required this.idLeituraAtuacao,
    required this.idTipoSinal,
    required this.dataHoraLeitura,
    required this.jsonLeitura,
  });

  factory LeituraModel.fromJson(Map<String, dynamic> json) {
    return LeituraModel(
      idSensorAtuador: json['id_sensor_atuador'],
      idLeituraAtuacao: json['id_leitura_atuacao'],
      idTipoSinal: json['id_tipo_sinal'],
      dataHoraLeitura: DateTime.parse(json['data_hora_leitura']),
      jsonLeitura: json['json_leitura'],
    );
  }
}
