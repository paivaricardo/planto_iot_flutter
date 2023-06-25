import 'package:planto_iot_flutter/model/perfil_autorizacao_model.dart';
import 'package:planto_iot_flutter/model/usuario_model.dart';

class AutorizacaoSensorModel {
  int idAutorizacaoSensor;
  int idSensorAtuador;
  UsuarioModel usuario;
  PerfilAutorizacaoModel perfilAutorizacao;
  bool visualizacaoAtiva;

  AutorizacaoSensorModel({
    required this.idAutorizacaoSensor,
    required this.idSensorAtuador,
    required this.usuario,
    required this.perfilAutorizacao,
    required this.visualizacaoAtiva,
  });

  factory AutorizacaoSensorModel.fromJson(Map<String, dynamic> json) {
    return AutorizacaoSensorModel(
      idAutorizacaoSensor: json['id_autorizacao_sensor'],
      idSensorAtuador: json['id_sensor_atuador'],
      usuario: UsuarioModel.fromJson(json['usuario']),
      perfilAutorizacao:
          PerfilAutorizacaoModel.fromJson(json['perfil_autorizacao']),
      visualizacaoAtiva: json['visualizacao_ativa'],
    );
  }
}
