import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/area_model.dart';
import 'package:planto_iot_flutter/model/cultura_model.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_info_model.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

import '../../model/sensor_atuador_cadastro_completo_model.dart';

class CadastroSensorAtuadorScreen extends StatefulWidget {
  final String uuid;
  final String loggedInUseremail;

  const CadastroSensorAtuadorScreen({
    Key? key,
    required this.uuid,
    required this.loggedInUseremail,
  }) : super(key: key);

  @override
  State<CadastroSensorAtuadorScreen> createState() =>
      _CadastroSensorAtuadorScreenState();
}

class _CadastroSensorAtuadorScreenState
    extends State<CadastroSensorAtuadorScreen> {
  // Usuário logado - obtido pelo Provider
  User? loggedInUser;

  // Chamadas de API para carregar dados do sensor, culturas e áreas
  late Future<Map<String, dynamic>> _sensorInfoFuture;
  late Future<List<CulturaModel>> _culturasFuture;
  late Future<List<AreaModel>> _areasFuture;

  // Chave do formulário
  final _formKey = GlobalKey<FormState>();

  // Controllers para os campos do formulário
  final TextEditingController _nomeSensorController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _idAreaController = TextEditingController();
  final TextEditingController _idCulturaController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  // Informações iniciais do sensor
  SensorAtuadorInfoModel? _sensorAtuadorInitialInfo;

  // Armazena a informação acerca do processamento do formulário
  bool _isProcessing = false;

  // Controla se o sensor/atuador está sendo cadastrado ou atualizado
  bool _isUpdate = false;

  // Controla se se trata de cadastro de sensor ou de um atuador. 1 para sensor, 2 para atuador
  int _controleSensorAtuador = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _sensorInfoFuture = BackendService.verificarSensorAtuador(
      uuid: widget.uuid,
      email: widget.loggedInUseremail,
    );
    _culturasFuture = BackendService.obterTodasCulturas();
    _areasFuture = BackendService.obterTodasAreas();
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator(),
          Text(
            "Carrendo dados do sensor...",
            style: TextStyle(color: Colors.white, fontFamily: "Josefin Sans"),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _sensorInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final sensorBackendInfo = snapshot.data!;

                // Verifica se o sensor/atuador já foi cadastrado ou se é o primeiro cadastro
                if (sensorBackendInfo['content']['sensor_atuador_foi_cadastrado']) {
                  _isUpdate = true;
                }

                _sensorAtuadorInitialInfo = SensorAtuadorInfoModel.fromJson(
                    sensorBackendInfo['content']['sensor_atuador_info']);

                if (_sensorAtuadorInitialInfo == null) {
                  return const Text('Sensor não encontrado');
                }

                _loadFields(_sensorAtuadorInitialInfo);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de Sensor/Atuador:',
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          fontWeight: FontWeight.bold),
                    ),
                    SelectableText(
                      _sensorAtuadorInitialInfo!.tipoSensor.nomeTipoSensor,
                      style: const TextStyle(fontFamily: 'Josefin Sans'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'UUID:',
                        style: TextStyle(
                            fontFamily: 'Josefin Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SelectableText(
                      _sensorAtuadorInitialInfo!.uuidSensorAtuador,
                      style: const TextStyle(fontFamily: 'Josefin Sans'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Usuário cadastrante:',
                        style: TextStyle(
                            fontFamily: 'Josefin Sans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SelectableText(
                      _sensorAtuadorInitialInfo!.usuarioCadastrante != null
                          ? _sensorAtuadorInitialInfo!
                              .usuarioCadastrante!.nomeUsuario
                          : loggedInUser!.displayName ??
                              'Usuário não encontrado',
                      style: const TextStyle(fontFamily: 'Josefin Sans'),
                    ),
                  ],
                );
              }
            },
          ),
          TextFormField(
            controller: _nomeSensorController,
            decoration:
                const InputDecoration(labelText: 'Nome do Sensor ou Atuador'),
            maxLength: 255,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome do sensor';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _latitudeController,
            decoration: const InputDecoration(labelText: 'Latitude'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a latitude';
              }

              if (double.tryParse(value) == null) {
                return 'Por favor, insira um valor numérico';
              }

              if (double.parse(value) < -90 || double.parse(value) > 90) {
                return 'Por favor, insira um valor entre -90 e 90';
              }

              return null;
            },
          ),
          TextFormField(
            controller: _longitudeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Longitude'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a longitude';
              }

              if (double.tryParse(value) == null) {
                return 'Por favor, insira um valor numérico';
              }

              if (double.parse(value) < -180 || double.parse(value) > 180) {
                return 'Por favor, insira um valor entre -180 e 180';
              }

              return null;
            },
          ),
          ElevatedButton.icon(
              onPressed: _handleMapButtonPressed,
              icon: const Icon(Icons.map_rounded),
              label: const Text("Localizar no mapa")),
          FutureBuilder<List<CulturaModel>>(
            future: _culturasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final culturas = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Cultura"),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _sensorAtuadorInitialInfo?.idCultura,
                              hint: const Text('Selecione a cultura'),
                              items: culturas.map((cultura) {
                                return DropdownMenuItem<int>(
                                  value: cultura.idCultura,
                                  child: Text(cultura.nomeCultura),
                                );
                              }).toList(),
                              onChanged: (value) {
                                // Handle the selected culture value
                                _idCulturaController.text = value.toString();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor, selecione a cultura';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          FutureBuilder<List<AreaModel>>(
            future: _areasFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final areas = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Área"),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _sensorAtuadorInitialInfo?.idArea,
                              hint: const Text('Selecione a área'),
                              items: areas.map((area) {
                                return DropdownMenuItem<int>(
                                  value: area.idArea,
                                  child: Text(area.nomeArea),
                                );
                              }).toList(),
                              onChanged: (value) {
                                // Handle the selected area value
                                _idAreaController.text = value.toString();
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor, selecione a área';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          TextFormField(
            controller: _observacoesController,
            decoration: const InputDecoration(labelText: 'Observações'),
            keyboardType: TextInputType.multiline,
            maxLength: 1000,
            minLines: 1,
            maxLines: 10,
          ),
          ElevatedButton(
            onPressed: _isProcessing ? () {} : _submitCadastroForm,
            child: _isProcessing
                ? Row(
                    children: const [
                      SizedBox(
                        width: 10.0,
                        height: 10.0,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Text('Processando...'),
                      )
                    ],
                  )
                : const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  void _submitCadastroForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Setar o estado como processando. Isso será refletido no botão de cadastro, que não deixará o usuário clicar novamente
        setState(() {
          _isProcessing = true;
        });

        // Após a validação, criar um objeto SensorAtuadorCadastroCompletoModel com os dados do formulário
        final SensorAtuadorCadastroCompletoModel
            sensorAtuadorCadastroCompletoSubmit =
            SensorAtuadorCadastroCompletoModel(
          idSensorAtuador: _sensorAtuadorInitialInfo!.idSensorAtuador,
          uuidSensorAtuador: _sensorAtuadorInitialInfo!.uuidSensorAtuador,
          nomeSensor: _nomeSensorController.text,
          latitude: double.parse(_latitudeController.text),
          longitude: double.parse(_longitudeController.text),
          emailUsuarioCadastrante:
              _sensorAtuadorInitialInfo!.usuarioCadastrante != null
                  ? _sensorAtuadorInitialInfo!.usuarioCadastrante!.emailUsuario
                  : loggedInUser!.email!,
          idArea: int.parse(_idAreaController.text),
          idCultura: int.parse(_idCulturaController.text),
          observacoes: _observacoesController.text.isEmpty
              ? null
              : _observacoesController.text,
        );

        // Realizar a chamada de serviço do backend para cadastrar o sensor/atuador, ou atualizar o cadastro (o endpoint chamado é o mesmo)
        final Map<String, dynamic> backendServiceResponse =
            await BackendService.cadastrarSensorAtuador(
          sensorAtuadorCadastroCompletoSubmit,
        );

        // Determinar mensagem acerca de estado de conexão com o sensor em questão
        final int mensagemConexaoSensor =
            backendServiceResponse['conexao_usuario_sensor']
                ['cod_status_conexao'];

        bool showMensagemConexaoSensor = false;

        if (mensagemConexaoSensor == 1) {
          showMensagemConexaoSensor = true;
        }

        // Mostar uma mensagem de sucesso ao usuário
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Column(
            children: [
              Text(_isUpdate
                  ? 'Sensor/atuador atualizado com sucesso!'
                  : 'Sensor/atuador cadastrado com sucesso!'),
              Visibility(
                  visible: showMensagemConexaoSensor,
                  child: const Text(
                      'O sensor/atuador foi conectado com sucesso ao usuário!'))
            ],
          )),
        );

        //  Retornar para a tela de listagem de sensores/atuadores
        Navigator.of(context).pop();
      }
    } catch (e) {
      //  Retornoar o estado do botão de cadastro para o estado inicial
      setState(() {
        _isProcessing = false;
      });

      // Mostrar uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_isUpdate
                ? 'Erro ao atualizar o sensor/atuador'
                : 'Erro ao cadastrar o sensor/atuador')),
      );
    }
  }

  void _handleMapButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Funcionalidade a ser implementada futuramente!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = Provider.of<User?>(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _sensorInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return _buildForm();
        }
      },
    );
  }

  _buildAppBar() {
    return AppBar(
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
                child: Text("Cadastrar sensor/atuador",
                    style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
              ),
            ),
          ],
        ),
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

  void _loadFields(SensorAtuadorInfoModel? sensorAtuadorInitialInfo) {
    if (sensorAtuadorInitialInfo != null) {
      _nomeSensorController.text =
          sensorAtuadorInitialInfo.nomeSensor?.toString() ?? "";
      _latitudeController.text =
          sensorAtuadorInitialInfo.latitude?.toString() ?? "";
      _longitudeController.text =
          sensorAtuadorInitialInfo.longitude?.toString() ?? "";
      _idCulturaController.text =
          sensorAtuadorInitialInfo.idCultura?.toString() ?? "";
      _idAreaController.text =
          sensorAtuadorInitialInfo.idArea?.toString() ?? "";
      _observacoesController.text =
          sensorAtuadorInitialInfo.observacoes?.toString() ?? "";
    }
  }
}
