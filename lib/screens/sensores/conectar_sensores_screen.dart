import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:provider/provider.dart';

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
          child: ConectarSensorAtuadorForm(loggedInUseremail: loggedInUser.email!),
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
            title: const Text('Sobre', style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Esta tela permite que você cadastre, monitore e controle seus sensores e atuadores para uso agrícola. Ainda está em construção. Volte em breve para novidades.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0),
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

  @override
  void dispose() {
    _qrCodeFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _qrCodeFieldController,
          decoration: const InputDecoration(
            labelText: 'UUID do sensor',
            hintText: 'Escaneie ou digite o UUID do sensor/atuador',
            labelStyle: TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0, color: Colors.white),
            hintStyle: TextStyle(fontFamily: "Josefin Sans", fontSize: 16.0, color: Colors.white),
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton.icon(
          onPressed: () {
            // Implementar a lógica de escaneamento do QR Code aqui
          },
          icon: Icon(Icons.qr_code),
          label: Text('Escanear QR Code'),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            String uuid = _qrCodeFieldController.text;
            // Use the 'uuid' variable for further processing
            print('UUID: $uuid');
          },
          child: Text('Conectar'),
        ),
      ],
    );
  }
}


