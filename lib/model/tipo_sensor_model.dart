class TipoSensorModel {
  final String nomeTipoSensor;
  final int idTipoSensor;

  TipoSensorModel({
    required this.nomeTipoSensor,
    required this.idTipoSensor,
  });

  factory TipoSensorModel.fromJson(Map<String, dynamic> json) {
    return TipoSensorModel(
      nomeTipoSensor: json['nome_tipo_sensor'],
      idTipoSensor: json['id_tipo_sensor'],
    );
  }
}
