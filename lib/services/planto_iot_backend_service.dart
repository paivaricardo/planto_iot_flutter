import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:planto_iot_flutter/model/sensor_atuador_cadastro_completo_model.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';

import '../config/app_config.dart';
import '../model/area_model.dart';
import '../model/cultura_model.dart';
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
          idPerfilAutorizacao =
              autorizacao['perfil_autorizacao']['id_perfil_autorizacao'];
          break;
        }
      }

      // Status 2 - Usuário não tem autorização para acessar o sensor
      if (!hasAuthorization) {
        return {
          "status": 2,
          "content": jsonResponse,
        };
      }

      // Status 3 - Sensor/atuador não foi cadastrado, e o usuário não é administrador
      final sensorAtuadorFoiCadastrado =
          jsonResponse['sensor_atuador_foi_cadastrado'];
      if (sensorAtuadorFoiCadastrado == false && idPerfilAutorizacao == 2) {
        return {
          "status": 3,
          "content": jsonResponse,
        };
      }else if (sensorAtuadorFoiCadastrado == false &&
          idPerfilAutorizacao == 1) {
        // Status 4 - Sensor/atuador não foi cadastrado e usuário é administrador
        return {
          "status": 4,
          "content": jsonResponse,
        };
      } else {
        // Status 5 - Sensor/atuador foi cadastrado corretamente, e o usuário tem autorização para acessá-lo
        return {
          "status": 5,
          "content": jsonResponse,
        };
      }
    } else if (response.statusCode == 400) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final error = jsonResponse['detail']['error'];

      // Status 1 - Sensor/atuador não existe na base de dados
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

  static Future<List<CulturaModel>> obterTodasCulturas() async {
    final url = Uri.http(AppConfig.backendAuthority, "/culturas");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      final List<CulturaModel> culturas = List<CulturaModel>.from(
          jsonResponse.map(
              (culturaObjetoJson) => CulturaModel.fromJson(culturaObjetoJson)));

      return culturas;
    } else {
      throw Exception("Falha ao obter culturas do backend.");
    }
  }

  static Future<List<AreaModel>> obterTodasAreas() async {
    final url = Uri.http(AppConfig.backendAuthority, "/areas");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      final List<AreaModel> areas = List<AreaModel>.from(jsonResponse
          .map((areaObjetoJson) => AreaModel.fromJson(areaObjetoJson)));

      return areas;
    } else {
      throw Exception("Falha ao obter áreas do backend");
    }
  }

  static Future<Map<String, dynamic>> cadastrarSensorAtuador(
      SensorAtuadorCadastroCompletoModel
          sensorAtuadorCadastroCompletoModel) async {
    final url =
        Uri.http(AppConfig.backendAuthority, "/cadastrar-sensor-atuador");

    final requestBody = jsonEncode(sensorAtuadorCadastroCompletoModel.toJson());

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: requestBody);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse;
    } else {
      throw Exception(
          "[BackendServiço - Erro] Falha ao cadastrar sensor/atuador");
    }
  }
}
