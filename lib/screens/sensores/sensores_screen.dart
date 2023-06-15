import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

import 'conectar_sensores_screen.dart';

class SensoresScreen extends StatefulWidget {
  const SensoresScreen({Key? key}) : super(key: key);

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  @override
  Widget build(BuildContext context) {
    final User loggedInUser = Provider.of<User?>(context)!;

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
                  child: Text("Sensores",
                      style:
                          TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
                ),
              ),
            ],
          ),
          flexibleSpace: const PlantoIOTAppBarBackground()),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
            firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: BackendService.listarSensoresAtuadoresConectadosUsuario(
                loggedInUser.email!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Carregando dados de sensores...",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erro ao carregar dados de sensores: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                );
              } else if (snapshot.hasData) {
                final listaSensoresAtuadores = snapshot.data!;
                return ListaSensoresAtuadores(
                    listaSensoresAtuadores: listaSensoresAtuadores);
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erro ao carregar dados de sensores: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chamar a tela para conexão a novos sensores e atuadores
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConectarSensoresScreen()));
        },
        child: Icon(Icons.add),
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
}

class ListaSensoresAtuadores extends StatelessWidget {
  final List<SensorAtuadorModel> listaSensoresAtuadores;

  const ListaSensoresAtuadores(
      {super.key, required this.listaSensoresAtuadores});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listaSensoresAtuadores.length,
        itemBuilder: (context, index) {
          final sensorAtuador = listaSensoresAtuadores[index];
          return Card(
            child: ListTile(
              leading: sensorAtuador.tipoSensor.idTipoSensor < 20000
                  ? Icon(Icons.sensors)
                  : Icon(Icons.settings_remote),
              title: Text(sensorAtuador.nomeSensor),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sensorAtuador.uuidSensorAtuador),
                  Text(sensorAtuador.tipoSensor.nomeTipoSensor),
                  Text(sensorAtuador.area.nomeArea),
                  Text(sensorAtuador.cultura.nomeCultura),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Chamar a tela de detalhes do sensor
              },
            ),
          );
        });
  }
}
