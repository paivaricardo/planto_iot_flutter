import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MonitorarSensorAtuadorEspecificoScreen extends StatefulWidget {
  final String uuid;

  const MonitorarSensorAtuadorEspecificoScreen({required this.uuid, Key? key})
      : super(key: key);

  @override
  State<MonitorarSensorAtuadorEspecificoScreen> createState() =>
      _MonitorarSensorAtuadorEspecificoScreenState();
}

class _MonitorarSensorAtuadorEspecificoScreenState
    extends State<MonitorarSensorAtuadorEspecificoScreen> {
  // Informações do sensor que está sendo monitorado
  SensorAtuadorModel? sensorAtuadorModel;

  // Controlar o usuário logado - Obtido pelo Provider
  User? loggedInUser;

  // Controla se se trata de cadastro de sensor ou de um atuador. 1 para sensor, 2 para atuador
  int _isSensorOrAtuador = 1;

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User?>(context)!;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: buildBody(context, loggedInUser),
    );
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

  Widget buildBody(BuildContext context, User? loggedInUser) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
          firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: buildMonitorarSensorAtuadorMainScreen(loggedInUser)),
      ),
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

  Widget buildMonitorarSensorAtuadorMainScreen(User? loggedInUser) {
    return FutureBuilder(
      future: BackendService.verificarSensorAtuador(
          uuid: widget.uuid, email: loggedInUser!.email!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScren(snapshot.error);
        } else if (snapshot.hasData) {
          // Carregar os dados do sensor cadastrado
          final sensorAtuadorBackendInfo = snapshot.data!;

          if (sensorAtuadorBackendInfo['status'] == 5) {
            // Carregar as informações do sensor no modelo de dados
            sensorAtuadorModel = SensorAtuadorModel.fromJson(
                sensorAtuadorBackendInfo['content']['sensor_atuador_info']);

            // Definir a variável que define se se trata de um sensor ou atuador
            _isSensorOrAtuador = sensorAtuadorModel!.idSensorAtuador < 20000 ? 1 : 2 ;

            return MonitorarSensorAtuadorEspecificoCarregado(sensorAtuadorModel!);
          } else {
            return _buildNotAuthorizedScreen();
          }
        } else {
          return _buildErrorScren(snapshot.error);
        }
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PlantoIOTTitleComponent(size: 18),
                Text("Monitorar ${_isSensorOrAtuador == 1 ? 'Sensor' : 'Atuador'}",
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
          IconButton(
              onPressed: () => _showMoreActionsMenu(context),
              icon: const Icon(Icons.more_vert_rounded,
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

  Widget _buildNotAuthorizedScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'O usuário não possui permissão para acessar os dados do sensor, ou o sensor não foi corretamente cadastrado.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  _showMoreActionsMenu(BuildContext context) {}
}

class MonitorarSensorAtuadorEspecificoCarregado extends StatefulWidget {
  final SensorAtuadorModel sensorAtuadorCarregado;

  const MonitorarSensorAtuadorEspecificoCarregado(this.sensorAtuadorCarregado,
      {super.key});

  @override
  State<MonitorarSensorAtuadorEspecificoCarregado> createState() =>
      _MonitorarSensorAtuadorEspecificoCarregadoState();
}

class _MonitorarSensorAtuadorEspecificoCarregadoState
    extends State<MonitorarSensorAtuadorEspecificoCarregado> {
  User? loggedInUser;

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User?>(context)!;

    return Column(
      children: [
        _buildSensorInfoCard(),
        _buildUltimasLeiturasCard(),
        _buildCulturaCard(),
        _buildAreaCard(),
        _buildLocalizacaoCard(),
        _buildObservacoesCard(),
        _buildQRCodeCard(),
      ],
    );
  }

  _buildSensorInfoCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Nome do sensor'),
            subtitle: SelectableText(widget.sensorAtuadorCarregado.nomeSensor),
          ),
          ListTile(
            title: const Text('UUID'),
            subtitle:
                SelectableText(widget.sensorAtuadorCarregado.uuidSensorAtuador),
          ),
          ListTile(
            title: const Text('Tipo de sensor'),
            subtitle: SelectableText(
                widget.sensorAtuadorCarregado.tipoSensor.nomeTipoSensor),
          ),
          ListTile(
            title: const Text('Usuário cadastrante'),
            subtitle: SelectableText(
                widget.sensorAtuadorCarregado.usuarioCadastrante.nomeUsuario),
          ),
          ListTile(
            title: const Text('Data de cadastro'),
            subtitle: SelectableText(widget
                .sensorAtuadorCarregado.usuarioCadastrante.dataCadastro
                .toString()),
          ),
        ],
      ),
    );
  }

  _buildUltimasLeiturasCard() {
    return Card(
      child: Column(
        children: const [
          ListTile(
              leading: Icon(Icons.table_chart_rounded),
              title: Text('Últimas leituras')),
        ],
      ),
    );
  }

  _buildCulturaCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
              leading: const Icon(Icons.eco_rounded),
              title: const Text('Cultura'),
              subtitle: SelectableText(
                  widget.sensorAtuadorCarregado.cultura.nomeCultura)),
        ],
      ),
    );
  }

  _buildAreaCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
              leading: const Icon(Icons.area_chart_rounded),
              title: const Text('Área'),
              subtitle:
                  SelectableText(widget.sensorAtuadorCarregado.area.nomeArea)),
        ],
      ),
    );
  }

  _buildLocalizacaoCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
              leading: const Icon(Icons.map_rounded),
              title: const Text('Latitude e Longitude'),
              subtitle: Text(
                  "Latitude: ${widget.sensorAtuadorCarregado.latitude}, Longitude: ${widget.sensorAtuadorCarregado.longitude}")),
        ],
      ),
    );
  }

  _buildObservacoesCard() {
    return Visibility(
      visible: widget.sensorAtuadorCarregado.observacoes != null &&
          widget.sensorAtuadorCarregado.observacoes!.isNotEmpty,
      child: Card(
        child: Column(
          children: [
            const ListTile(
                leading: Icon(Icons.info_outline_rounded),
                title: Text('Observações')),
            ListTile(
                title:
                    SelectableText(widget.sensorAtuadorCarregado.observacoes ?? '')),
          ],
        ),
      ),
    );
  }

  _buildQRCodeCard() {
    return Card(
      child: Column(
        children: [
          const ListTile(
              leading: Icon(Icons.qr_code_2_rounded), title: Text('QR Code')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: QrImageView(
              data: widget.sensorAtuadorCarregado.uuidSensorAtuador,
              version: QrVersions.auto,
              size: 280.0,
            ),
          )
        ],
      ),
    );
  }
}
