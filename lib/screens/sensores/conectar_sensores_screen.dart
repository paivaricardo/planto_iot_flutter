import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
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
                  child: Text("Conectar sensores",
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
          child:
              ConectarSensorAtuadorForm(loggedInUseremail: loggedInUser.email!),
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
            onPressed: () {
              // Implementar a lógica de escaneamento do QR Code aqui
            },
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
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroSensorAtuadorScreen(uuid: uuid, loggedInUseremail: widget.loggedInUseremail,)));
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
                            content: Text(
                                'Sensor/atuador conectado com sucesso!')),
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
                ? Row(mainAxisSize: MainAxisSize.min, children: const [
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
