import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PlantoIOTTitleComponent(size: 18),
              Text("Sobre",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
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
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text("Versão: 0.1.0",
                      style: TextStyle(
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
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                      "0.1.0 (18/03/2023): Primeira versão do aplicativo Planto IoT. Implementada a funcionada de login e cadastro via provedor de identidade do Google. Implementado o dashboard e placeholders para as funcionalidades de sensores, configurações. Implementada a funcionalidade de logout.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontFamily: 'Josefin Sans',
                          color: Colors.white,
                          fontSize: 18.0)),
                ),
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
}
