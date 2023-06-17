class SensorAtuadorCadastroCompletoModel {
  int idSensorAtuador;
  String uuidSensorAtuador;
  String nomeSensor;
  double latitude;
  double longitude;
  String emailUsuarioCadastrante;
  int idArea;
  int idCultura;
  String? observacoes;

  SensorAtuadorCadastroCompletoModel({
    required this.idSensorAtuador,
    required this.uuidSensorAtuador,
    required this.nomeSensor,
    required this.latitude,
    required this.longitude,
    required this.emailUsuarioCadastrante,
    required this.idArea,
    required this.idCultura,
    this.observacoes,
  });

  factory SensorAtuadorCadastroCompletoModel.fromJson(
      Map<String, dynamic> json) {
    return SensorAtuadorCadastroCompletoModel(
      idSensorAtuador: json['id_sensor_atuador'],
      uuidSensorAtuador: json['uuid_sensor_atuador'],
      nomeSensor: json['nome_sensor'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      emailUsuarioCadastrante: json['email_usuario_cadastrante'],
      idArea: json['id_area'],
      idCultura: json['id_cultura'],
      observacoes: json['observacoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_sensor_atuador': idSensorAtuador,
      'uuid_sensor_atuador': uuidSensorAtuador,
      'nome_sensor': nomeSensor,
      'latitude': latitude,
      'longitude': longitude,
      'email_usuario_cadastrante': emailUsuarioCadastrante,
      'id_area': idArea,
      'id_cultura': idCultura,
      'observacoes': observacoes,
    };
  }
}
