import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/services/firebase_auth_service.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

import '../../components/dashboard_button.dart';
import '../../model/usuario_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final UsuarioModel loggedInUser = Provider.of<UsuarioModel?>(context)!;

    return Scaffold(
      appBar: AppBar(
          title: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PlantoIOTTitleComponent(size: 18),
                  IconButton(
                      onPressed: () => _showHelpDialog(context),
                      icon: const Icon(Icons.help_outline_rounded,
                          color: Colors.white, size: 24))
                ],
              ),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Dashboard",
                      style:
                          TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
                ),
              ),
            ],
          ),
          flexibleSpace: const PlantoIOTAppBarBackground()),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
            firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Bem vindo(a), ${loggedInUser.nomeUsuario}!',
                      style: const TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Selecione a opção desejada abaixo:',
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2.0,
                    indent: 16, // Left padding
                    endIndent: 16, // Right padding
                  ),
                  Wrap(alignment: WrapAlignment.spaceBetween, children: [
                    DashboardButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sensores');
                        },
                        title: 'Sensores',
                        icon: Icons.sensors),
                    DashboardButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sobre');
                        },
                        title: 'Sobre',
                        icon: Icons.info_rounded),
                    DashboardButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/configuracoes');
                        },
                        title: 'Configurações',
                        icon: Icons.settings_rounded),
                    DashboardButton(
                        onPressed: () => FirebaseAuthService.signOut(),
                        onLongPress: () =>
                            FirebaseAuthService.signOutSocialProviders(),
                        title: 'Sair',
                        icon: Icons.logout_rounded),
                  ]),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("Versão 0.1.0",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'Josefin Sans'))),
            )
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Text('Dashboard', style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Bem-vindo ao Planto IoT! Esta é a tela inicial do aplicativo, na qual você poderá acessar as principais funcionalidades da aplicação. A seção "sensores" permite você cadastrar novos sensores, bem como monitorar e controlar os existentes. A seção "sobre" contém informações gerais sobre o aplicativo e o projeto Planto IoT, assim como sobre a equipe de desenvolvimento. A seção "configurações" permite que você altere as configurações do aplicativo, como notificações. A seção "sair" permite que você encerre a sua sessão e retorne à tela de login.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0),
                  ),
                  Text(
                    'Dica: pressione longamente o botão "sair" para que você encerre a sua sessão em todas as plataformas de redes sociais.',
                    style: TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}
