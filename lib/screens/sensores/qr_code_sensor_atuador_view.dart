import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_precadastrado_info_model.dart';
import 'package:planto_iot_flutter/screens/sensores/pdf_qr_code_sensor_atuador_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeSensorAtuadorView extends StatelessWidget {
  final SensorAtuadorPrecadastradoInfoModel sensorAtuadorPrecadastradoInfoModel;

  const QRCodeSensorAtuadorView(
      {required this.sensorAtuadorPrecadastradoInfoModel, super.key});

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlantoIOTTitleComponent(size: 18),
                Text("Pré-cadastro concluído",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      persistentFooterButtons: [
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PDFQRCodeSensorAtuadorView(
                        sensorAtuadorPrecadastradoInfoModel:
                            sensorAtuadorPrecadastradoInfoModel,
                      )));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Gerar PDF: '),
                Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Colors.redAccent,
                ),
              ],
            )),
      ],
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

  _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
          firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Pré-cadastro realizado com sucesso!',
                style: TextStyle(
                    fontFamily: 'Josefin Sans',
                    fontSize: 16.0,
                    color: Colors.white)),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                sensorAtuadorPrecadastradoInfoModel.nomeTipoSensor,
                style: const TextStyle(
                    fontFamily: 'Josefin Sans',
                    fontSize: 32.0,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Data do pré-cadastro: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(sensorAtuadorPrecadastradoInfoModel.dataPrecadastroSensor.toLocal())}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Text(
              'UUID: ${sensorAtuadorPrecadastradoInfoModel.uuidSensorAtuador}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QrImageView(
                data: sensorAtuadorPrecadastradoInfoModel.uuidSensorAtuador,
                version: QrVersions.auto,
                size: 280.0,
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
