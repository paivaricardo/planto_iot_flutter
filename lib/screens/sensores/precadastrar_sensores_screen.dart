import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_precadastrado_info_model.dart';
import 'package:planto_iot_flutter/model/tipo_sensor_model.dart';
import 'package:planto_iot_flutter/screens/sensores/qr_code_sensor_atuador_view.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:planto_iot_flutter/utils/qr_view_scanner.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PrecadastrarSensoresScreen extends StatefulWidget {
  const PrecadastrarSensoresScreen({Key? key}) : super(key: key);

  @override
  State<PrecadastrarSensoresScreen> createState() =>
      _PrecadastrarSensoresScreenState();
}

class _PrecadastrarSensoresScreenState
    extends State<PrecadastrarSensoresScreen> {
  @override
  Widget build(BuildContext context) {
    final User loggedInUser = Provider.of<User?>(context)!;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, loggedInUser),
    );
  }

  Widget _buildBody(BuildContext context, User loggedInUser) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
          firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrecadastrarSensorAtuadorForm(
            loggedInUseremail: loggedInUser.email!),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlantoIOTTitleComponent(size: 18),
                Text("Pré-cadastrar Sensor/Atuador",
                    style: TextStyle(fontSize: 16.0, fontFamily: 'FredokaOne')),
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
}

class PrecadastrarSensorAtuadorForm extends StatefulWidget {
  final String loggedInUseremail;

  const PrecadastrarSensorAtuadorForm({
    Key? key,
    required this.loggedInUseremail,
  }) : super(key: key);

  @override
  _PrecadastrarSensorAtuadorFormState createState() =>
      _PrecadastrarSensorAtuadorFormState();
}

class _PrecadastrarSensorAtuadorFormState
    extends State<PrecadastrarSensorAtuadorForm> {
  final TextEditingController _qrCodeFieldController = TextEditingController();
  final TextEditingController _tipoSensorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  bool _generateUUIDAutomatically = true;
  late Future<List<TipoSensorModel>> _tipoSensorFuture;

  @override
  void didChangeDependencies() {
    _tipoSensorFuture = _loadTipoSensoresFuture();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _qrCodeFieldController.dispose();
    super.dispose();
  }

  Future<List<TipoSensorModel>> _loadTipoSensoresFuture() async {
    return BackendService.getTiposSensores();
  }

  void _scanQRCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const QRViewScanner(); // Replace with your QR code scanner widget
        },
      ),
    ).then((resultQRCode) {
      if (resultQRCode != null) {
        // Handle the scanned QR code result here
        setState(() {
          _qrCodeFieldController.text = resultQRCode.code!.toString();
        });
      }
    });
  }

  String? _validateUuid(String? value) {
    try {
      if (value == null || value.isEmpty) {
        return "UUID não pode ser vazio.";
      }

      // Use the 'uuid' package to validate the UUID format
      Uuid.parse(value);

      return null;
    } catch (e) {
      return "UUID inválido.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTipoSensorFormField(),
          _buildGenerateUUIDAutomaticallyFormField(),
          _buildInputUUIDFormField(),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              Future<Map<String, dynamic>> precadastrarFuture;

              if (_formKey.currentState!.validate() && !_isProcessing) {
                try {
                  setState(() {
                    _isProcessing = true;
                  });

                  if (!_generateUUIDAutomatically) {
                    final String uuid = _qrCodeFieldController.text;
                    print('UUID: $uuid');

                    precadastrarFuture =
                        BackendService.precadastrarSensorAtuador(
                            idSensorAtuador: _tipoSensorController.text,
                            uuid: uuid,
                            email: widget.loggedInUseremail);
                  } else {
                    precadastrarFuture =
                        BackendService.precadastrarSensorAtuador(
                            idSensorAtuador: _tipoSensorController.text,
                            email: widget.loggedInUseremail);
                  }
                  // Use the 'uuid' variable for further processing

                  //  Chamar o backend para verificar o uuid do sensor ou atuador que foi inserido.
                  final Map<String, dynamic> result = await precadastrarFuture;

                  switch (result['status']) {
                    // 1 - Sensor/atuador já existe com o mesmo UUID na base de dados
                    case 1:
                      mostraDialogoInfo(context,
                          titleMessage:
                              'Já existe um sensor/atuador com o UUID informado na base de dados.',
                          contentMessage:
                              'Digite outro UUID ou gere um novo automaticamente, para finalizar o pré-cadastro do sensor/atuador.');
                      break;
                    //    2 - O sensor/atuador foi pré-cadastrado com sucesso
                    case 2:
                      // Transformar as informações do sensor/atuador em um modelo de dados
                      SensorAtuadorPrecadastradoInfoModel
                          sensorAtuadorPrecadastradoInfo =
                          SensorAtuadorPrecadastradoInfoModel.fromJson(
                              result['sensor_atuador_precadastrado_info']);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'O sensor/atuador foi pré-cadastrado com sucesso.')));

                      Navigator.of(context).pop();

                      // Mostra o PDF com o QR Code do sensor/atuador pré-cadastrado
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => QRCodeSensorAtuadorView(
                                sensorAtuadorPrecadastradoInfoModel:
                                    sensorAtuadorPrecadastradoInfo,
                              )));
                      break;
                    default:
                      mostraDialogoInfo(context,
                          titleMessage:
                              'Ocorreu um erro ao pré-cadastrar o sensor/atuador.',
                          contentMessage:
                              'Tente novamente mais tarde ou entre em contato com a equipe do Planto IoT.');
                  }

                  setState(() {
                    _isProcessing = false;
                  });

                  print(result);
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'Ocorreu um erro ao pré-cadastrar o sensor/atuador.')));

                  setState(() {
                    _isProcessing = false;
                  });
                }
              }
            },
            child: _isProcessing
                ? const Row(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text('Processando...'),
                    )
                  ]) // Show CircularProgressIndicator when connecting
                : const Text('Pré-cadastrar'),
          ),
        ],
      ),
    );
  }

  void mostraDialogoInfo(BuildContext context,
      {required String titleMessage, required String contentMessage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.info_outline_rounded,
              color: Colors.green, size: 24),
          title: Text(titleMessage),
          content: Text(contentMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  _buildTipoSensorFormField() {
    return FutureBuilder(
      future: _tipoSensorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final tiposSensores = snapshot.data!;

          // Atualizar o valor do tipo de sensor/atuador selecionado
          _tipoSensorController.text = tiposSensores.first.idTipoSensor.toString();

          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tipo de sensor/atuador",
                  style: TextStyle(color: Colors.white),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: DropdownButtonFormField<int>(
                          value: _tipoSensorController.text.isEmpty
                              ? null
                              : int.parse(_tipoSensorController.text),
                          hint: const Text(
                            'Selecione o tipo de sensor/atuador',
                            style: TextStyle(color: Colors.white),
                          ),
                          items: tiposSensores.map((tipoSensor) {
                            return DropdownMenuItem<int>(
                              value: tipoSensor.idTipoSensor,
                              child: Text(
                                tipoSensor.nomeTipoSensor,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          onChanged: (value) {
                            // Alterar o valor do controlador tipo de sensor/atuador
                            _tipoSensorController.text = value.toString();
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, selecione o tipo de sensor';
                            }

                            if (_tipoSensorController.text.isEmpty) {
                              return 'Por favor, selecione o tipo de sensor';
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _buildGenerateUUIDAutomaticallyFormField() {
    return Row(
      children: [
        const Text(
          "Gerar UUID automaticamente? ",
          style: TextStyle(fontFamily: 'Josefin Sans', color: Colors.white),
        ),
        Checkbox(
            value: _generateUUIDAutomatically,
            onChanged: (bool? value) {
              setState(() {
                _generateUUIDAutomatically = value!;
              });
            }),
      ],
    );
  }

  _buildInputUUIDFormField() {
    return Visibility(
      visible: !_generateUUIDAutomatically,
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: _qrCodeFieldController,
            validator: _validateUuid,
            maxLength: 36,
            decoration: const InputDecoration(
              labelText: 'UUID do sensor',
              hintText: 'Escaneie ou digite o UUID do sensor/atuador',
              labelStyle: TextStyle(
                  fontFamily: "Josefin Sans",
                  fontSize: 16.0,
                  color: Colors.white),
              hintStyle: TextStyle(
                  fontFamily: "Josefin Sans",
                  fontSize: 16.0,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: _scanQRCode,
            icon: const Icon(Icons.qr_code),
            label: const Text('Escanear QR Code'),
          ),
        ],
      ),
    );
  }
}
