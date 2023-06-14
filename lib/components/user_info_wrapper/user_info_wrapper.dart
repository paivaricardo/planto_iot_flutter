import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/model/usuario_model.dart';
import 'package:planto_iot_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

class UserInfoWrapper extends StatelessWidget {
  const UserInfoWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UsuarioModel>(
      future: BackendService.checkUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erro ao buscar informações do usuário.');
        } else {
          final usuarioDatabase = snapshot.data;

          if (usuarioDatabase != null) {

            // Aqui, será configurado um Provider, que irá disponibilizar as informações do usuário cadastrado na base de dados para os widgets filhos.
            return Provider<UsuarioModel>.value(
              value: usuarioDatabase,
              child: DashboardScreen(),
            );
          } else {
            return const Text('Erro ao buscar informações do usuário.');
          }
        }
      },
    );
  }
}
