import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/user_info_wrapper/user_info_wrapper.dart';
import 'package:planto_iot_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:planto_iot_flutter/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

// Este Widget é o primeiro a ser renderizado pelo App. Ele verifica se o usuário está logado e, caso esteja, redireciona para o Dashboard. Se não, redireciona para a tela de login. O usuário é obtido a partir do serviço de autenticação do Firebase.
class AuthWrapperComponent extends StatelessWidget {
  const AuthWrapperComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Variável que armazena informações do usuário logado, oriundas do StreamProvider (Firebase Authentication).
    final User? loggedInUser = Provider.of<User?>(context);

    if (loggedInUser == null) {
      // Se o usuário não estiver logado, retorna o widget de login
      return const LoginScreen();
    } else {
     // Se o usuário estiver logado, retorna o UserInfoWrapper, widget the buscará informações sobre o usuário na base de dados do Planto IoT
        return const UserInfoWrapper();
    }
  }
}
