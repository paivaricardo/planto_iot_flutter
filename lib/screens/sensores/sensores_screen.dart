import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';
import 'package:planto_iot_flutter/screens/sensores/monitorar_sensor_atuador_especifico_screen.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

import 'conectar_sensores_screen.dart';

class SensoresScreen extends StatefulWidget {
  const SensoresScreen({Key? key}) : super(key: key);

  @override
  State<SensoresScreen> createState() => _SensoresScreenState();
}

class _SensoresScreenState extends State<SensoresScreen> {
  late User loggedInUser;

  late Future<List<SensorAtuadorModel>>
  _futureListarSensoresAtuadoresConectadosUsuario;

  Future<List<SensorAtuadorModel>>
  _loadListarSensoresAtuadoresConectadosUsuario() {
    return BackendService.listarSensoresAtuadoresConectadosUsuario(
        loggedInUser.email!);
  }

  @override
  void didChangeDependencies() {
    loggedInUser = Provider.of<User?>(context)!;

    _futureListarSensoresAtuadoresConectadosUsuario =
        _loadListarSensoresAtuadoresConectadosUsuario();
    super.didChangeDependencies();
  }

  void reloadSensoresAtuadoresConectadosList() {
    setState(() {
      _futureListarSensoresAtuadoresConectadosUsuario =
          _loadListarSensoresAtuadoresConectadosUsuario();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          reloadSensoresAtuadoresConectadosList();
        },
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
              firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: _futureListarSensoresAtuadoresConectadosUsuario,
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
                          style: TextStyle(
                              fontFamily: 'Josefin Sans',
                              fontSize: 16.0,
                              color: Colors.white),
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
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                } else if (snapshot.hasData) {
                  final listaSensoresAtuadores = snapshot.data!;
                  return ListaSensoresAtuadores(
                      reloadSensoresAtuadoresConectadosList:
                          reloadSensoresAtuadoresConectadosList,
                      listaSensoresAtuadores: listaSensoresAtuadores);
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Erro ao carregar dados de sensores: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chamar a tela para conexão a novos sensores e atuadores
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const ConectarSensoresScreen()))
              .then((value) => reloadSensoresAtuadoresConectadosList());
        },
        child: const Icon(Icons.add),
      ),
    );
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
                Text("Sensores e Atuadores",
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

class ListaSensoresAtuadores extends StatefulWidget {
  final void Function() reloadSensoresAtuadoresConectadosList;

  final List<SensorAtuadorModel> listaSensoresAtuadores;

  const ListaSensoresAtuadores(
      {super.key, required this.reloadSensoresAtuadoresConectadosList, required this.listaSensoresAtuadores});

  @override
  State<ListaSensoresAtuadores> createState() => _ListaSensoresAtuadoresState();
}

class _ListaSensoresAtuadoresState extends State<ListaSensoresAtuadores> {
  @override
  Widget build(BuildContext context) {
    return widget.listaSensoresAtuadores.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: const [
                Icon(Icons.eco_rounded, size: 128.0, color: Colors.white),
                Text(
                  'Você ainda não possui sensores ou atuadores conectados. Clique no botão + para adicionar.',
                  style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      fontSize: 32,
                      color: Colors.white),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: widget.listaSensoresAtuadores.length,
            itemBuilder: (context, index) {
              final sensorAtuador = widget.listaSensoresAtuadores[index];
              return Card(
                child: ListTile(
                  leading: sensorAtuador.tipoSensor.idTipoSensor < 20000
                      ? const Icon(Icons.sensors)
                      : const Icon(Icons.settings_remote),
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
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    int isSensorOrAtuador =
                        sensorAtuador.tipoSensor.idTipoSensor < 20000 ? 1 : 2;

                    // Chamar a tela de detalhes do sensor ou do atuador
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                MonitorarSensorAtuadorEspecificoScreen(
                                  uuid: sensorAtuador.uuidSensorAtuador,
                                  isSensorOrAtuador: isSensorOrAtuador,
                                )))
                        .then((value) => widget.reloadSensoresAtuadoresConectadosList());
                  },
                ),
              );
            });
  }
}
