import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/screens/sensores/precadastrar_sensores_screen.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:planto_iot_flutter/utils/qr_view_scanner.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'cadastro_sensor_atuador_screen.dart';

class ConectarSensoresScreen extends StatefulWidget {
  const ConectarSensoresScreen({Key? key}) : super(key: key);

  @override
  State<ConectarSensoresScreen> createState() => _ConectarSensoresScreenState();
}

class _ConectarSensoresScreenState extends State<ConectarSensoresScreen> {
  @override
  Widget build(BuildContext context) {
    final User loggedInUser = Provider.of<User?>(context)!;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
            firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              ConectarSensorAtuadorForm(loggedInUseremail: loggedInUser.email!),
        ),
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
              children: [
                PlantoIOTTitleComponent(size: 18),
                Text("Conectar Sensor/Atuador",
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
          IconButton(
              onPressed: () => _showMoreActionsMenu(context),
              icon: const Icon(Icons.more_vert_rounded,
                  color: Colors.white, size: 24)),
        ],
        flexibleSpace: const PlantoIOTAppBarBackground());
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
          value: 'precadastrar',
          child: Text('Pré-cadastrar sensor/atuador'),
        ),
      ],
      elevation: 8,
    ).then((value) {
      if (value == 'precadastrar') {
        // Handle the 'Editar cadastro' option
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => const PrecadastrarSensoresScreen()))
            .then((value) => setState(() {}));
      }
    });
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

class ConectarSensorAtuadorForm extends StatefulWidget {
  final String loggedInUseremail;

  const ConectarSensorAtuadorForm({
    Key? key,
    required this.loggedInUseremail,
  }) : super(key: key);

  @override
  _ConectarSensorAtuadorFormState createState() =>
      _ConectarSensorAtuadorFormState();
}

class _ConectarSensorAtuadorFormState extends State<ConectarSensorAtuadorForm> {
  TextEditingController _qrCodeFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isConnecting = false;

  @override
  void dispose() {
    _qrCodeFieldController.dispose();
    super.dispose();
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
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && !_isConnecting) {
                setState(() {
                  _isConnecting = true;
                });

                String uuid = _qrCodeFieldController.text;
                // Use the 'uuid' variable for further processing
                print('UUID: $uuid');

                //  Chamar o backend para verificar o uuid do sensor ou atuador que foi inserido.
                Map<String, dynamic> result =
                    await BackendService.verificarSensorAtuador(
                        uuid: uuid, email: widget.loggedInUseremail);

                switch (result['status']) {
                  // 1 - Sensor/atuador não encontrado na base de dados
                  case 1:
                    mostraDialogoInfo(context,
                        titleMessage:
                            'O sensor/atuador não foi localizado na base de dados.',
                        contentMessage:
                            'Após busca em nossa base de dados, não localizamos o sensor ou atuador com o UUID informado. Verifique se o UUID foi digitado corretamente ou procure a equipe do Planto IoT para resolver o problema. A depender do caso, pode ser necessário realizar pré-cadastro do sensor/atuador desejado.');
                    break;

                  // 2 - Sensor/atuador encontrado, mas o usuário não possui permissão para acessá-lo
                  case 2:
                    mostraDialogoInfo(context,
                        titleMessage: 'Autorização negada.',
                        contentMessage:
                            'O sensor ou atuador existe na nossa base de dados, mas o usuário não possui permissão para acessá-lo. No caso, é necessário que o administrador do sensor/atuador habilite seu e-mail para acesso ao dispositivo.');
                    break;

                  // 3 - Sensor/atuador encontrado e o usuário possui NÃO permissão de administrador sobre o sensor, mas o cadastro não está completo. Redireciona para completar o cadastro do sensor
                  case 3:
                    mostraDialogoInfo(context,
                        titleMessage: 'Sensor/Atuador não cadastrado',
                        contentMessage:
                            'O sensor ou atuador existe na nossa base de dados e você possui permissão para acessá-lo, mas é necessário que o cadastro do sensor/atuador seja concluído por uma pessoa com poderes de administrador. No caso, contacte o administrador do sensor para concluir o cadastro.');
                    break;

                  // 4 - Sensor/atuador encontrado e o usuário possui permissão de ADMINISTRADOR sobre o sensor, mas o cadastro não está completo. Redireciona para completar o cadastro do sensor
                  case 4:
                    int isSensorOrAtuador = result['content']
                                ['sensor_atuador_info']['id_tipo_sensor'] <
                            20000
                        ? 1
                        : 2;

                    bool isUpdate =
                        !result['content']['sensor_atuador_foi_cadastrado'];

                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CadastroSensorAtuadorScreen(
                                  uuid: uuid,
                                  isSensorOrAtuador: isSensorOrAtuador,
                                  loggedInUseremail: widget.loggedInUseremail,
                                  isUpdate: isUpdate,
                                )));
                    break;

                  // 5 - Sensor/atuador encontrado e o usuário possui permissão para acessá-lo, e o cadastro está completo. Realiza a conexão com o sensor imediatamente. Se uma conexão com o sensor já existe, não haverá alterações na aplicação.
                  default:
                    Map<String, dynamic> conectarSensoresAtuadoresResposta =
                        await BackendService.conectarSensorAtuadorUsuario(
                            uuid: uuid, email: widget.loggedInUseremail);

                    if (conectarSensoresAtuadoresResposta[
                            'cod_status_conexao'] ==
                        1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Sensor/atuador conectado com sucesso!')),
                      );
                      Navigator.of(context).pop();
                    } else if (conectarSensoresAtuadoresResposta[
                            'cod_status_conexao'] ==
                        2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Sensor/atuador já está conectado ao usuário.')),
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Erro ao tentar conectar o sensor/atuador ao usuário.')),
                      );
                    }
                }

                setState(() {
                  _isConnecting = false;
                });

                print(result);
              }
            },
            child: _isConnecting
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
                      child: Text('Conectando...'),
                    )
                  ]) // Show CircularProgressIndicator when connecting
                : const Text('Conectar'),
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
}
