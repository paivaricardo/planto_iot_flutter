import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../model/usuario_model.dart';
import 'firebase_auth_service.dart';

class BackendService {
  static Future<UsuarioModel> checkUser() async {
    final user = FirebaseAuthService.currentUser;
    final url = Uri.parse('${AppConfig.backendUri}/verificar-cadastrar-usuario');

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
  }
}