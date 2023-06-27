import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_precadastrado_info_model.dart';
import 'package:printing/printing.dart';

class PDFQRCodeSensorAtuadorView extends StatelessWidget {
  final SensorAtuadorPrecadastradoInfoModel sensorAtuadorPrecadastradoInfoModel;

  PDFQRCodeSensorAtuadorView(
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
                Text("PDF do QR Code",
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

  _buildBody(BuildContext context) {
    return PdfPreview(
        pdfFileName:
            'qr_code_${sensorAtuadorPrecadastradoInfoModel.idTipoSensor < 20000 ? "sensor" : "atuador"}-${sensorAtuadorPrecadastradoInfoModel.uuidSensorAtuador.substring(0, 8)}.pdf',
        canDebug: false,
        initialPageFormat: PdfPageFormat.a4,
        build: (PdfPageFormat format) => _generatePdfLayout(format));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Future<Uint8List> _generatePdfLayout(PdfPageFormat format) async {
    final pdf = pw.Document(
        title:
            'qr_code_sensor_atuador-${sensorAtuadorPrecadastradoInfoModel.uuidSensorAtuador}');

    pdf.addPage(pw.Page(
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.josefinSansMedium(),
          bold: await PdfGoogleFonts.fredokaBold(),
          icons: await PdfGoogleFonts.materialIcons(),
        ),
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    _buildPlantoIoTTitlePDFComponent(),
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.qrCode(),
                      data:
                          sensorAtuadorPrecadastradoInfoModel.uuidSensorAtuador,
                      width: 200,
                      height: 200,
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 10),
                      child: pw.SizedBox(
                        width: 200,
                        child: pw.Expanded(
                          child: pw.Text(
                            sensorAtuadorPrecadastradoInfoModel
                                .uuidSensorAtuador,
                            style: const pw.TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                pw.Expanded(
                  child: pw.Text(
                    textAlign: pw.TextAlign.center,
                    sensorAtuadorPrecadastradoInfoModel.nomeTipoSensor,
                    style: const pw.TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ],
            ),
          );
        }));

    return pdf.save();
  }

  _buildPlantoIoTTitlePDFComponent() {
    return pw.Row(
      children: [
        pw.Text("Plant",
            style: pw.TextStyle(
              fontSize: 40,
              fontWeight: pw.FontWeight.bold,
            )),
        pw.Icon(
          const pw.IconData(0xea35),
          size: 40,
        ),
        pw.Text(" I",
            style: pw.TextStyle(
              fontSize: 40,
              fontWeight: pw.FontWeight.bold,
            )),
        pw.Icon(
          pw.IconData(0xe8b8),
          size: 40,
        ),
        pw.Text("T",
            style: pw.TextStyle(
              fontSize: 40,
              fontWeight: pw.FontWeight.bold,
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
}
