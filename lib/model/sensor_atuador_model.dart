import 'package:planto_iot_flutter/model/tipo_sensor_model.dart';
import 'package:planto_iot_flutter/model/usuario_model.dart';

import 'area_model.dart';
import 'cutura_model.dart';

class SensorAtuadorModel {
  final int idSensorAtuador;
  final double latitude;
  final DateTime dataCadastroSensor;
  final int idUsuarioCadastrante;
  final int idCultura;
  final String uuidSensorAtuador;
  final String nomeSensor;
  final double longitude;
  final DateTime dataPrecadastroSensor;
  final int idArea;
  final int idTipoSensor;
  final CulturaModel cultura;
  final UsuarioModel usuarioCadastrante;
  final TipoSensorModel tipoSensor;
  final AreaModel area;

  SensorAtuadorModel({
    required this.idSensorAtuador,
    required this.latitude,
    required this.dataCadastroSensor,
    required this.idUsuarioCadastrante,
    required this.idCultura,
    required this.uuidSensorAtuador,
    required this.nomeSensor,
    required this.longitude,
    required this.dataPrecadastroSensor,
    required this.idArea,
    required this.idTipoSensor,
    required this.cultura,
    required this.usuarioCadastrante,
    required this.tipoSensor,
    required this.area,
  });

  factory SensorAtuadorModel.fromJson(Map<String, dynamic> json) {
    return SensorAtuadorModel(
      idSensorAtuador: json['id_sensor_atuador'],
      latitude: json['latitude'],
      dataCadastroSensor: DateTime.parse(json['data_cadastro_sensor']),
      idUsuarioCadastrante: json['id_usuario_cadastrante'],
      idCultura: json['id_cultura'],
      uuidSensorAtuador: json['uuid_sensor_atuador'],
      nomeSensor: json['nome_sensor'],
      longitude: json['longitude'],
      dataPrecadastroSensor: DateTime.parse(json['data_precadastro_sensor']),
      idArea: json['id_area'],
      idTipoSensor: json['id_tipo_sensor'],
      cultura: CulturaModel.fromJson(json['cultura']),
      usuarioCadastrante: UsuarioModel.fromJson(json['usuario_cadastrante']),
      tipoSensor: TipoSensorModel.fromJson(json['tipo_sensor']),
      area: AreaModel.fromJson(json['area']),
    );
  }
}