import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';

import '../config/app_config.dart';
import '../model/usuario_model.dart';
import 'firebase_auth_service.dart';

class BackendService {
  static UsuarioModel? loggedInUser;

  static Future<UsuarioModel?> checkUser() async {
    try {
      final user = FirebaseAuthService.currentUser;
      final url = Uri.parse("${AppConfig.backendUri}/verificar-cadastrar-usuario");

      final requestBody = jsonEncode({
        'email_usuario': user?.email,
        'nome_usuario': user?.displayName,
        'id_perfil': 4
      });

      final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: requestBody);

      final jsonResponse = jsonDecode(response.body);
      final usuario = UsuarioModel.fromJson(jsonResponse['usuario']); // Create UsuarioModel from JSON

      return usuario;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<SensorAtuadorModel>> listarSensoresAtuadoresConectadosUsuario(int idUsuario) async {
    final url = Uri.parse("${AppConfig.backendUri}/listar-sensores-atuadores-conectados/$idUsuario");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final List<SensorAtuadorModel> listaSensoresAtuadores = List<SensorAtuadorModel>.from(
          jsonResponse.map((sensorAtuadorObjetoJson) => SensorAtuadorModel.fromJson(sensorAtuadorObjetoJson))
      );

      return listaSensoresAtuadores;
    } else {
      throw Exception("Falha ao listar sensores e atuadores conectados");
    }
  }
}
