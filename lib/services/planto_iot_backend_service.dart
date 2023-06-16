import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';

import '../config/app_config.dart';
import '../model/usuario_model.dart';

class BackendService {
  static Future<UsuarioModel?> checkUser() async {
    try {
      print("Iniciando a chegagem de  usuário...");

      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      final url =
          Uri.http(AppConfig.backendAuthority, "/verificar-cadastrar-usuario");

      final requestBody = jsonEncode({
        'email_usuario': firebaseUser.email,
        'nome_usuario': firebaseUser.displayName,
        'id_perfil': 4
      });

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: requestBody);

      final jsonResponse = jsonDecode(response.body);
      final usuario = UsuarioModel.fromJson(
          jsonResponse['usuario']); // Create UsuarioModel from JSON

      print(
          "Usuário verificado/cadastrado com sucesso na base de dados do Planto IoT! Dados: ${usuario.toString()}");

      return usuario;
    } catch (e) {
      print("Erro ao verificar/cadastrar usuário : $e");
      return null;
    }
  }

  static Future<List<SensorAtuadorModel>>
      listarSensoresAtuadoresConectadosUsuario(String emailUsuario) async {
    final url = Uri.http(
        AppConfig.backendAuthority,
        "/listar-sensores-atuadores-conectados",
        {"email_usuario": emailUsuario});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      final List<SensorAtuadorModel> listaSensoresAtuadores =
          List<SensorAtuadorModel>.from(jsonResponse.map(
              (sensorAtuadorObjetoJson) =>
                  SensorAtuadorModel.fromJson(sensorAtuadorObjetoJson)));

      return listaSensoresAtuadores;
    } else {
      throw Exception("Falha ao listar sensores e atuadores conectados");
    }
  }

  static Future<Map<String, dynamic>> verificarSensorAtuador(
      {required uuid, required String email}) async {
    final url =
        Uri.http(AppConfig.backendAuthority, "/verificar-sensor-atuador/$uuid");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // Verificar se o usuário tem autorização para acessar o sensor
      final autorizacoes = jsonResponse['autorizacoes'];
      bool hasAuthorization = false;
      int idPerfilAutorizacao = 0;

      for (var autorizacao in autorizacoes) {
        final usuario = autorizacao['usuario'];
        final emailUsuario = usuario['email_usuario'];
        if (emailUsuario == email) {
          hasAuthorization = true;
          idPerfilAutorizacao = autorizacao['perfil_autorizacao']['id_perfil_autorizacao'];
          break;
        }
      }

      if (!hasAuthorization) {
        return {
          "status": 2,
          "content": jsonResponse,
        };
      }

      final sensorAtuadorFoiCadastrado =
          jsonResponse['sensor_atuador_foi_cadastrado'];
      if (sensorAtuadorFoiCadastrado == false && idPerfilAutorizacao == 2) {
        return {
          "status": 3,
          "content": jsonResponse,
        };
      } else if (sensorAtuadorFoiCadastrado == false && idPerfilAutorizacao == 1) {
        return {
          "status": 4,
          "content": jsonResponse,
        };
      } else {
        return {
          "status": 5,
          "content": jsonResponse,
        };
      }
    } else if (response.statusCode == 400) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final error = jsonResponse['detail']['error'];
      if (error ==
          "O sensor ou atuador informado não existe na base de dados") {
        return {
          "status": 1,
          "content": jsonResponse,
        };
      } else {
        throw Exception("Falha ao verificar sensor e atuador");
      }
    } else {
      throw Exception("Falha ao verificar sensor e atuador");
    }
  }

  static Future<Map<String, dynamic>> conectarSensorAtuadorUsuario(
      {required String uuid, required String email}) async {
    final url = Uri.http(AppConfig.backendAuthority,
        "/conectar-sensor-atuador/$uuid", {"email_usuario": email});

    final response = await http.put(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse;
    } else {
      throw Exception("Falha ao conectar com o sensor/atuador");
    }
  }
}
