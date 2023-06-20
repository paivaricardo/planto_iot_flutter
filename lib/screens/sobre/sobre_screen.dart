import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/version_info/version_info_main.dart';
import 'package:planto_iot_flutter/version_info/version_info_model.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  child: Text("Sobre",
                      style:
                          TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
                ),
              ),
            ],
          ),
          flexibleSpace: const PlantoIOTAppBarBackground()),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
            firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("Plant",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontFamily: 'FredokaOne',
                                decoration: TextDecoration.none)),
                        Icon(
                          Icons.eco_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(" I",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontFamily: 'FredokaOne',
                                decoration: TextDecoration.none)),
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 64,
                        ),
                        Text("T",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 64,
                                fontFamily: 'FredokaOne',
                                decoration: TextDecoration.none)),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                      "Versão: ${VersionInfoMain.currentVersion.versionName}",
                      style: const TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Text(
                      "Planto IoT é parte de um projeto de conclusão do curso de Ciência de Computação do Centro Universitário de Brasília (CEUB). Esta aplicação permite o monitoramento e o controle de dispositivos conectados à Internet das coisas (IoT) para uso agrícola (tais como sensores de umidade e atuadores de irrigação).",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Colors.white,
                          fontSize: 18.0)),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Text("Equipe de desenvolvimento:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0)),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text("Isadora Montserrat de Freitas Pereira",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Colors.white,
                          fontSize: 18.0)),
                ),
                const Text("Ivan Schwanka Penna",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Josefin Sans',
                        color: Colors.white,
                        fontSize: 18.0)),
                const Text("Moisés Soares Portela",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Josefin Sans',
                        color: Colors.white,
                        fontSize: 18.0)),
                const Text("Ricardo Corrêa Leal Paiva",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Josefin Sans',
                        color: Colors.white,
                        fontSize: 18.0)),
                const Text("Sander Rodrigues Campo Dallorto",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Josefin Sans',
                        color: Colors.white,
                        fontSize: 18.0)),
                const Text("Ulisses de Sousa Penna",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: 'Josefin Sans',
                        color: Colors.white,
                        fontSize: 18.0)),
                const Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: Text("Notas das versões:",
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: VersionInfoMain.versionHistory.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                            "${VersionInfoMain.versionHistory[index].versionName} (${VersionInfoMain.versionHistory[index].date}): ${VersionInfoMain.versionHistory[index].notes}",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontFamily: 'Josefin Sans',
                                color: Colors.white,
                                fontSize: 18.0)),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Voltar")),
                )
              ],
            ),
          ),
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
                    'Esta tela contém informações gerais sobre o aplicativo e o projeto Planto IoT, assim como sobre a equipe de desenvolvimento. Também possui o histórico de versões do aplicativo.',
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
