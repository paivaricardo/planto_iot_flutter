import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

import '../../model/sensor_atuador_model.dart';

class GerenciarAutorizacoesScreen extends StatefulWidget {
  final String uuidSensorAtuador;

  const GerenciarAutorizacoesScreen(
      {required this.uuidSensorAtuador, super.key});

  @override
  State<GerenciarAutorizacoesScreen> createState() =>
      _GerenciarAutorizacoesScreenState();
}

class _GerenciarAutorizacoesScreenState
    extends State<GerenciarAutorizacoesScreen> {
  // Informações do sensor que está sendo monitorado
  SensorAtuadorModel? sensorAtuadorModel;

  late User loggedInUser;

  late Future<Map<String, dynamic>> _verificarSensorAtuadorFuture;

  @override
  void didChangeDependencies() {
    loggedInUser = Provider.of<User?>(context)!;
    _verificarSensorAtuadorFuture = _loadVerificarSensorAtuadorFuture();
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> _loadVerificarSensorAtuadorFuture() {
    return BackendService.verificarSensorAtuador(
        uuid: widget.uuidSensorAtuador, email: loggedInUser.email!);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                PlantoIOTTitleComponent(size: 18),
                Text("Gerenciar autorizações",
                    style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => _showHelpDialog(context),
              icon: const Icon(Icons.help_outline_rounded,
                  color: Colors.white, size: 24)),
        ],
        flexibleSpace: const PlantoIOTAppBarBackground());
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User?>(context)!;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
          firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            SingleChildScrollView(child: _buildGerenciarAutorizacoesMainBody()),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Text(
              'Sobre',
              style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Esta tela permite que você cadastre, monitore e controle seus sensores e atuadores para uso agrícola. Ainda está em construção. Volte em breve para novidades.',
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0),
                  )
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

  Widget _buildLoadingScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircularProgressIndicator(
          color: Colors.white,
        ),
        Text(
          "Carregando dados...",
          style: TextStyle(color: Colors.white, fontFamily: "Josefin Sans"),
        )
      ],
    );
  }

  Widget _buildErrorScren(Object? error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Erro ao carregar dados do sensor: ${error.toString()}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  _buildGerenciarAutorizacoesMainBody() {
    return FutureBuilder(
      future: _verificarSensorAtuadorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScren(snapshot.error);
        } else if (snapshot.hasData) {
          // Carregar os dados do sensor cadastrado
          final sensorAtuadorBackendInfo = snapshot.data!;

          if (sensorAtuadorBackendInfo['status'] != 1 &&
              sensorAtuadorBackendInfo['status'] != 2) {
            // Carregar as informações do sensor no modelo de dados
            sensorAtuadorModel = SensorAtuadorModel.fromJson(
                sensorAtuadorBackendInfo['content']['sensor_atuador_info']);

            // TODO: Implementar a tela de gerenciamento de autorizações
            return Text("IMPLEMENTAR");
          } else {
            return _buildNotAuthorizedScreen();
          }
        } else {
          return _buildErrorScren(snapshot.error);
        }
      },
    );
  }

  Widget _buildNotAuthorizedScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'O usuário não possui permissão para acessar os dados do sensor.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
