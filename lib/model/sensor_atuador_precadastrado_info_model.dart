class SensorAtuadorPrecadastradoInfoModel {
  int idSensorAtuador;
  String uuidSensorAtuador;
  DateTime dataPrecadastroSensor;
  int idTipoSensor;
  String nomeTipoSensor;

  SensorAtuadorPrecadastradoInfoModel({
    required this.idSensorAtuador,
    required this.uuidSensorAtuador,
    required this.dataPrecadastroSensor,
    required this.idTipoSensor,
    required this.nomeTipoSensor,
  });

  factory SensorAtuadorPrecadastradoInfoModel.fromJson(
      Map<String, dynamic> json) {
    return SensorAtuadorPrecadastradoInfoModel(
      idSensorAtuador: json['id_sensor_atuador'],
      uuidSensorAtuador: json['uuid_sensor_atuador'],
      dataPrecadastroSensor: DateTime.parse(json['data_precadastro_sensor']),
      idTipoSensor: json['id_tipo_sensor'],
      nomeTipoSensor: json['nome_tipo_sensor'],
    );
  }
}
