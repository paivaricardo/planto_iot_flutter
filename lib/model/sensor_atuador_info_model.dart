import 'package:planto_iot_flutter/model/area_model.dart';
import 'package:planto_iot_flutter/model/cultura_model.dart';
import 'package:planto_iot_flutter/model/tipo_sensor_model.dart';
import 'package:planto_iot_flutter/model/usuario_model.dart';

class SensorAtuadorInfoModel {
  final String uuidSensorAtuador;
  final String? nomeSensor;
  final double? longitude;
  final DateTime dataPrecadastroSensor;
  final int? idArea;
  final int idTipoSensor;
  final int idSensorAtuador;
  final double? latitude;
  final DateTime? dataCadastroSensor;
  final int? idUsuarioCadastrante;
  final int? idCultura;
  final CulturaModel? cultura;
  final UsuarioModel? usuarioCadastrante;
  final TipoSensorModel tipoSensor;
  final AreaModel? area;
  final String? observacoes;

  SensorAtuadorInfoModel({
    required this.uuidSensorAtuador,
    this.nomeSensor,
    this.longitude,
    required this.dataPrecadastroSensor,
    this.idArea,
    required this.idTipoSensor,
    required this.idSensorAtuador,
    this.latitude,
    this.dataCadastroSensor,
    this.idUsuarioCadastrante,
    this.idCultura,
    this.cultura,
    this.usuarioCadastrante,
    required this.tipoSensor,
    this.area,
    this.observacoes,
  });

  factory SensorAtuadorInfoModel.fromJson(Map<String, dynamic> json) {
    return SensorAtuadorInfoModel(
      uuidSensorAtuador: json['uuid_sensor_atuador'],
      nomeSensor: json['nome_sensor'],
      longitude: json['longitude'],
      dataPrecadastroSensor: DateTime.parse(json['data_precadastro_sensor']),
      idArea: json['id_area'],
      idTipoSensor: json['id_tipo_sensor'],
      idSensorAtuador: json['id_sensor_atuador'],
      latitude: json['latitude'],
      dataCadastroSensor: json['data_cadastro_sensor'] != null
          ? DateTime.parse(json['data_cadastro_sensor'])
          : null,
      idUsuarioCadastrante: json['id_usuario_cadastrante'],
      idCultura: json['id_cultura'],
      cultura: json['cultura'] != null
          ? CulturaModel.fromJson(json['cultura'])
          : null,
      usuarioCadastrante: json['usuario_cadastrante'] != null
          ? UsuarioModel.fromJson(json['usuario_cadastrante'])
          : null,
      tipoSensor: TipoSensorModel.fromJson(json['tipo_sensor']),
      area: json['area'] != null ? AreaModel.fromJson(json['area']) : null,
      observacoes: json['observacoes'],
    );
  }
}
