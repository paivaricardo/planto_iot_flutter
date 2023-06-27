import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';
import 'package:planto_iot_flutter/screens/autorizacoes/gerenciar_autorizacoes_screen.dart';
import 'package:planto_iot_flutter/screens/sensores/cadastro_sensor_atuador_screen.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:planto_iot_flutter/utils/google_maps_api_view_widget.dart';
import 'package:planto_iot_flutter/utils/json_leitura_keys_parser.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

import '../../model/leitura_model.dart';

class MonitorarSensorAtuadorEspecificoScreen extends StatefulWidget {
  final String uuid;
  final int isSensorOrAtuador;

  const MonitorarSensorAtuadorEspecificoScreen(
      {required this.uuid, Key? key, required this.isSensorOrAtuador})
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

  bool sensorAtuadorCarregado = false;

  @override
  void initState() {
    super.initState();
    _isSensorOrAtuador = widget.isSensorOrAtuador;
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User?>(context)!;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: buildBody(context, loggedInUser),
    );
  }

  Widget _buildLoadingScreen() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
      height: double.infinity,
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

            sensorAtuadorCarregado = true;

            // Definir a variável que define se se trata de um sensor ou atuador
            _isSensorOrAtuador =
                sensorAtuadorModel!.tipoSensor.idTipoSensor < 20000 ? 1 : 2;

            return MonitorarSensorAtuadorEspecificoCarregado(
              sensorAtuadorModel!,
              isSensorOrAtuador: _isSensorOrAtuador,
            );
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
                Text(
                    _isSensorOrAtuador == 1
                        ? "Monitorar Sensor"
                        : "Controlar Atuador",
                    style: const TextStyle(
                        fontSize: 18.0, fontFamily: 'FredokaOne')),
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
              onPressed: () =>
                  sensorAtuadorCarregado ? _showMoreActionsMenu(context) : null,
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
            content: const SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'O usuário não possui permissão para acessar os dados do sensor, ou o sensor não foi corretamente cadastrado.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  void _showMoreActionsMenu(BuildContext context) {
    final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
    final appBarHeight = appBarRenderBox.size.height;

    final double topPadding = MediaQuery.of(context).padding.top;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        appBarRenderBox.localToGlobal(Offset(10, appBarHeight + topPadding),
            ancestor: overlay),
        appBarRenderBox.localToGlobal(
            appBarRenderBox.size.topRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('Editar cadastro'),
        ),
        const PopupMenuItem<String>(
          value: 'manage',
          child: Text('Gerenciar autorizações'),
        ),
      ],
      elevation: 8,
    ).then((value) {
      if (value == 'edit') {
        // Handle the 'Editar cadastro' option
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => CadastroSensorAtuadorScreen(
                      uuid: widget.uuid,
                      loggedInUseremail: loggedInUser!.email!,
                      isSensorOrAtuador: _isSensorOrAtuador,
                      isUpdate: true,
                    )))
            .then((value) => setState(() {}));
      } else if (value == 'manage') {
        // Handle the 'Gerenciar autorizações' option
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => GerenciarAutorizacoesScreen(
                  uuidSensorAtuador: widget.uuid,
                    )))
            .then((value) => setState(() {}));
      }
    });
  }
}

class MonitorarSensorAtuadorEspecificoCarregado extends StatefulWidget {
  final int isSensorOrAtuador;
  final SensorAtuadorModel sensorAtuadorCarregado;

  const MonitorarSensorAtuadorEspecificoCarregado(this.sensorAtuadorCarregado,
      {required this.isSensorOrAtuador, super.key});

  @override
  State<MonitorarSensorAtuadorEspecificoCarregado> createState() =>
      _MonitorarSensorAtuadorEspecificoCarregadoState();
}

class _MonitorarSensorAtuadorEspecificoCarregadoState
    extends State<MonitorarSensorAtuadorEspecificoCarregado> {
  User? loggedInUser;

  bool _desconectarButtonProcessing = false;

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User?>(context)!;

    return Column(
      children: [
        _buildSensorAtuadorInfoCard(),
        if (widget.isSensorOrAtuador == 2) _buildAcionarAtuadorCard(),
        widget.isSensorOrAtuador == 1
            ? _buildUltimasLeiturasCard()
            : _buildUltimosAcionamentosCard(),
        _buildCulturaCard(),
        _buildAreaCard(),
        _buildLocalizacaoCard(),
        _buildObservacoesCard(),
        _buildQRCodeCard(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(
            color: Colors.white,
            thickness: 2.0,
          ),
        ),
        _buildDesconectarButton(),
      ],
    );
  }

  _buildSensorAtuadorInfoCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
                "Nome do ${widget.isSensorOrAtuador == 1 ? 'sensor' : 'atuador'}"),
            subtitle: SelectableText(widget.sensorAtuadorCarregado.nomeSensor),
          ),
          ListTile(
            title: const Text('UUID'),
            subtitle:
                SelectableText(widget.sensorAtuadorCarregado.uuidSensorAtuador),
          ),
          ListTile(
            title: Text(
                "Tipo de ${widget.sensorAtuadorCarregado == 1 ? 'sensor' : 'atuador'}"),
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24.0, 12.0, 0),
              child: SizedBox(
                width: 128,
                height: 20,
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FadeAnimatedText('AO VIVO',
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Josefin Sans',
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              const ListTile(
                  leading: Icon(Icons.table_chart_rounded),
                  title: Text('Últimas leituras')),
              UltimasLeiturasStatefulWidget(
                sensorAtuadorModel: widget.sensorAtuadorCarregado,
                loggedInUser: loggedInUser!,
              ),
            ],
          ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 320,
              width: 320,
              child: GoogleMapsApiViewWidget(
                  latitude: widget.sensorAtuadorCarregado.latitude,
                  longitude: widget.sensorAtuadorCarregado.longitude),
            ),
          ),
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
                title: SelectableText(
                    widget.sensorAtuadorCarregado.observacoes ?? '')),
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

  _buildUltimosAcionamentosCard() {
    return Card(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24.0, 12.0, 0),
              child: SizedBox(
                width: 128,
                height: 20,
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FadeAnimatedText('AO VIVO',
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Josefin Sans',
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              const ListTile(
                  leading: Icon(Icons.table_chart_rounded),
                  title: Text('Últimos acionamentos')),
              UltimasLeiturasStatefulWidget(
                sensorAtuadorModel: widget.sensorAtuadorCarregado,
                tipoSinalFiltragem: 50000,
                loggedInUser: loggedInUser!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildDesconectarButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: _desconectarButtonProcessing
              ? () {}
              : () async {
                  // Desconectar o sensor
                  setState(() {
                    _desconectarButtonProcessing = true;
                  });

                  try {
                    Map<String, dynamic> desconectarSensoresAtuadoresResposta =
                        await BackendService.desconectarSensorAtuadorUsuario(
                            uuid:
                                widget.sensorAtuadorCarregado.uuidSensorAtuador,
                            email: loggedInUser!.email!);

                    if (desconectarSensoresAtuadoresResposta['cod_status_desconexao'] == 1) {
                      // Sensor desconectado com sucesso
                      setState(() {
                        _desconectarButtonProcessing = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Sensor ${widget.sensorAtuadorCarregado.nomeSensor} desconectado com sucesso."),
                        ),
                      );

                      // Voltar para a tela anterior
                      Navigator.pop(context);
                    } else {
                      // Erro ao desconectar o sensor
                      setState(() {
                        _desconectarButtonProcessing = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Erro ao desconectar o sensor ${widget.sensorAtuadorCarregado.nomeSensor}!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    print(e);

                    setState(() {
                      _desconectarButtonProcessing = false;
                    });

                    // Erro ao desconectar o sensor - Exceção lançada

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Erro (exceção) ao desconectar o sensor ${widget.sensorAtuadorCarregado.nomeSensor}."),
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: _desconectarButtonProcessing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                          "Desconectando ${widget.isSensorOrAtuador == 1 ? 'sensor' : 'atuador'}"),
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sensors_off_rounded),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                          "Desconectar ${widget.isSensorOrAtuador == 1 ? 'sensor' : 'atuador'}"),
                    ),
                  ],
                )),
    );
  }

  _buildAcionarAtuadorCard() {
    return Card(
      child: Column(
        children: [
          const ListTile(
              leading: Icon(Icons.settings_remote_outlined),
              title: Text('Acionar atuador')),
          AcionarAtuadorWidget(
              sensorAtuadorModel: widget.sensorAtuadorCarregado),
        ],
      ),
    );
  }
}

class UltimasLeiturasStatefulWidget extends StatefulWidget {
  // Informações do sensor que está sendo monitorado
  final SensorAtuadorModel sensorAtuadorModel;

  // Número de leituras passadas
  final int numLeituras;

  // Filtragem de tipo de sinal
  final int tipoSinalFiltragem;

  // Controlar o usuário logado - Obtido pelo Provider
  final User loggedInUser;

  const UltimasLeiturasStatefulWidget({
    required this.sensorAtuadorModel,
    required this.loggedInUser,
    this.numLeituras = 5,
    this.tipoSinalFiltragem = 10000,
    super.key,
  });

  @override
  State<UltimasLeiturasStatefulWidget> createState() =>
      _UltimasLeiturasStatefulWidgetState();
}

class _UltimasLeiturasStatefulWidgetState
    extends State<UltimasLeiturasStatefulWidget> {
  // Timer para atualizar as leituras
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Iniciar o timer para atualizar as leituras
    timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Cancelar o timer
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BackendService.listarUltimasLeiturasSensorAtuador(
        uuidSensorAtuador: widget.sensorAtuadorModel.uuidSensorAtuador,
        numLeituras: widget.numLeituras,
        filtragemTipoSinal: widget.tipoSinalFiltragem,
      ),
      builder:
          (BuildContext context, AsyncSnapshot<List<LeituraModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScren(snapshot.error);
        } else if (snapshot.hasData) {
          // Carregar a lista de leituras do sensor
          List<LeituraModel> listaLeituras = snapshot.data!;

          if (listaLeituras.isNotEmpty) {
            return _buildUltimasLeiturasView(listaLeituras);
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(widget.sensorAtuadorModel.idTipoSensor < 20000
                    ? "Não há leituras para este sensor ainda."
                    : "Não há acionamentos registrados para este atuador ainda."),
              ),
            );
          }
        } else {
          return _buildErrorScren(snapshot.error);
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Carregando dados...'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScren(Object? error) {
    return Center(
      child: Text(
        "Erro ao carregar informações do sensor: ${error.toString()}",
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildUltimasLeiturasTable(List<LeituraModel> listaLeituras) {
    final firstLeitura = listaLeituras.first;

    final jsonLeituraKeys = firstLeitura.jsonLeitura.keys.toList();

    final jsonLeituraKeysParsed =
        JsonLeituraKeysParser.parseJsonLeituraKeys(jsonLeituraKeys);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: [
        const DataColumn(label: Text('Data')),
        for (var keyParsed in jsonLeituraKeysParsed)
          DataColumn(label: Text(keyParsed.toString())),
      ], rows: [
        for (var leitura in listaLeituras)
          DataRow(cells: [
            DataCell(Text(
              DateFormat('dd/MM/yyyy HH:mm:ss')
                  .format(leitura.dataHoraLeitura.toLocal()),
            )),
            for (var key in jsonLeituraKeys)
              DataCell(Text(leitura.jsonLeitura[key].toString())),
          ])
      ]),
    );
  }

  Widget _buildUltimasLeiturasView(List<LeituraModel> listaLeituras) {
    return _buildUltimasLeiturasTable(listaLeituras);
  }
}

class AcionarAtuadorWidget extends StatefulWidget {
  final SensorAtuadorModel sensorAtuadorModel;

  const AcionarAtuadorWidget({required this.sensorAtuadorModel, super.key});

  @override
  State<AcionarAtuadorWidget> createState() => _AcionarAtuadorWidgetState();
}

class _AcionarAtuadorWidgetState extends State<AcionarAtuadorWidget> {
  //Chave do formulário
  final _formKey = GlobalKey<FormState>();

  // Controlador do campo de fator de acionamento
  final _fatorAcionamentoController = TextEditingController();

  // Controlar se o formulário está processando ou não
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Limpar o controlador
    _fatorAcionamentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            controller: _fatorAcionamentoController,
            decoration: const InputDecoration(
              labelText: 'Fator de acionamento',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  double.tryParse(value) == null) {
                return 'Por favor, insira um valor numérico,';
              }

              if (double.parse(value) < 0 || double.parse(value) > 10000) {
                return 'Por favor, insira um valor entre 0 e 10000.';
              }

              return null;
            },
          ),
          SizedBox(
            width: double.infinity,
            child: _isProcessing
                ? ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Processando..."),
                        ),
                      ],
                    ))
                : ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });
                        try {
                          // Arredondar o valor numérico encontrado para o inteiro mais próximo
                          final int fatorAcionamento =
                              double.parse(_fatorAcionamentoController.text)
                                  .round();

                          // Se o formulário for válido, acionar o atuador
                          final Map<String, dynamic> responseAtivarAtuador =
                              await _acionarAtuador(fatorAcionamento);

                          // Se o atuador foi acionado com sucesso, mostrar uma mensagem de sucesso
                          if (responseAtivarAtuador['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Atuador acionado com sucesso!')));
                          } else {
                            throw Exception(responseAtivarAtuador['message']);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Erro ao tentar acionar o atuador: ${e.toString()})')));
                        } finally {
                          setState(() {
                            _isProcessing = false;
                          });
                        }
                      }
                    },
                    icon: const Icon(Icons.settings_remote_rounded),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    label: const Text("Acionar atuador")),
          ),
        ]),
      ),
    );
  }

  Future<Map<String, dynamic>> _acionarAtuador(int fatorAcionamento) {
    // Acionar o atuador
    return BackendService.ativarAtuador(
        widget.sensorAtuadorModel.uuidSensorAtuador, fatorAcionamento);
  }
}
