import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_model.dart';
import 'package:printing/printing.dart';

class PDFRelatorioLeituraSensorView extends StatelessWidget {
  final SensorAtuadorModel sensorAtuadorModel;
  final Uint8List relatorioImagebytes;
  final DateTime dataInicialLeitura;
  final DateTime dataFinalLeitura;

  const PDFRelatorioLeituraSensorView(
      {required this.sensorAtuadorModel,
      required this.relatorioImagebytes,
      required this.dataInicialLeitura,
      required this.dataFinalLeitura,
      super.key});

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlantoIOTTitleComponent(size: 18),
                Text("PDF do Relatório",
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
            'relatorio_${sensorAtuadorModel.idTipoSensor < 20000 ? "sensor" : "atuador"}-${sensorAtuadorModel.uuidSensorAtuador.substring(0, 8)}.pdf',
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
    final pdf =
        pw.Document(title: 'relatorio-${sensorAtuadorModel.uuidSensorAtuador}');

    pdf.addPage(pw.Page(
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.josefinSansMedium(),
          bold: await PdfGoogleFonts.fredokaBold(),
          icons: await PdfGoogleFonts.materialIcons(),
        ),
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              _buildPlantoIoTTitlePDFComponent(),
              pw.Text("Relatório de Leituras do Sensor",
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.SizedBox(height: 20),
              _buildPDFSensorDescriptionComponent(),
              pw.SizedBox(height: 20),
              _buildPDFDataIniciaisFinaisLeituraComponent(),
              pw.SizedBox(height: 20),
              _buildPDFRelatorioImageComponent(),
            ],
          );
        }));

    return pdf.save();
  }

  pw.Widget _buildPlantoIoTTitlePDFComponent() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
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
          const pw.IconData(0xe8b8),
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

  pw.Widget _buildPDFSensorDescriptionComponent() {
    return pw.Container(
      child: pw.Column(
        children: [
          pw.Text("Dados do Sensor",
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              )),
          pw.Row(
            children: [
              pw.Text("Nome do sensor: ",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Expanded(
                child: pw.Text(sensorAtuadorModel.nomeSensor,
                    style: const pw.TextStyle(
                      fontSize: 16,
                    )),
              ),
            ],
          ),
          pw.Row(
            children: [
              pw.Text("Tipo: ",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text(sensorAtuadorModel.tipoSensor.nomeTipoSensor,
                  style: const pw.TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
          pw.Row(
            children: [
              pw.Text("Área: ",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text(sensorAtuadorModel.area.nomeArea,
                  style: const pw.TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
          pw.Row(
            children: [
              pw.Text("Cultura: ",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
              pw.Text(sensorAtuadorModel.cultura.nomeCultura,
                  style: const pw.TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPDFDataIniciaisFinaisLeituraComponent() {
    return pw.Container(
        child: pw.Column(
      children: [
        pw.Row(children: [
          pw.Text("Data inicial da leitura: ",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              )),
          pw.Text(DateFormat('dd/MM/yyyy').format(dataInicialLeitura),
              style: const pw.TextStyle(
                fontSize: 16,
              )),
        ]),
        pw.Row(children: [
          pw.Text(
            "Data final da leitura: ",
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(DateFormat('dd/MM/yyyy').format(dataFinalLeitura),
              style: const pw.TextStyle(fontSize: 16)),
        ]),
      ],
    ));
  }

  pw.Widget _buildPDFRelatorioImageComponent() {
    return pw.Container(
      child: pw.FittedBox(
          child: pw.Image(
        pw.MemoryImage(relatorioImagebytes),
      )),
    );
  }
}
