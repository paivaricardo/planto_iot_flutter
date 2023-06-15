import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/model/usuario_model.dart';
import 'package:planto_iot_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

class UserInfoWrapper extends StatelessWidget {
  const UserInfoWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Variável que armazena informações do usuário logado, oriundas do StreamProvider (Firebase Authentication).
    final UsuarioModel? fetchedDatabaseUser = Provider.of<UsuarioModel?>(context);

    if (fetchedDatabaseUser == null) {
      // Se o usuário não , retorna o widget de login
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              children: const [
                CircularProgressIndicator(),
                Text("Buscando informações do usuário..."),
              ],
            ),
          ),
        ),
      );
    } else {
      // Se o usuário estiver logado, retorna o UserInfoWrapper, widget the buscará informações sobre o usuário na base de dados do Planto IoT
      return const DashboardScreen();
    }
  }
}
