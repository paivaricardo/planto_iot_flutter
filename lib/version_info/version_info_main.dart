import 'package:planto_iot_flutter/version_info/version_info_model.dart';

class VersionInfoMain {
  static VersionInfo currentVersion = versionHistory.first;

  static List<VersionInfo> versionHistory = [
    VersionInfo(
        versionName: "0.10.1",
        versionNumberPlayStore: "11",
        date: "27/06/2023",
        notes:
        "Correção de bugs na tela de cadastro de sensores e atuadores."),
    VersionInfo(
        versionName: "0.10.0",
        versionNumberPlayStore: "10",
        date: "26/06/2023",
        notes:
        "Implementada a funcionalidade de pré-cadastro de sensores e atuadores, com geração dos PDFs. Acessível por meio da tela de conexão com sensores/atuadores."),
    VersionInfo(
        versionName: "0.9.0",
        versionNumberPlayStore: "9",
        date: "25/06/2023",
        notes:
        "Implementada tela de controle de autorizações para sensores e atuadores."),
      VersionInfo(
          versionName: "0.8.0",
          versionNumberPlayStore: "8",
          date: "24/06/2023",
          notes:
          "Implementada a funcionalidade de desconectar um sensor/atuador a partir da tela de monitoramento de sensores e atuadores."),
    VersionInfo(
        versionName: "0.7.0",
        versionNumberPlayStore: "7",
        date: "23/06/2023",
        notes:
        "Implementadas telas para gerenciamento de áreas e culturas, acessíveis a partir da tela de cadastro/atualização de cadastro de sensores e atuadores."),
    VersionInfo(
        versionName: "0.6.0",
        versionNumberPlayStore: "6",
        date: "21/06/2023",
        notes:
        "Implementada integração com a API do Google, para seleção de localização do sensor no mapa e para visualização da localização."),
    VersionInfo(
        versionName: "0.5.0",
        versionNumberPlayStore: "5",
        date: "20/06/2023",
        notes:
        "Implementado o leitor de QRCode na tela de conexão com sensores/atuadores."),
    VersionInfo(
        versionName: "0.4.0",
        versionNumberPlayStore: "4",
        date: "20/06/2023",
        notes:
        "Implementada a funcionalidade de ativar atuadores na tela de controle de um atuador específico (acessada por meio da lista de sensores/atuadores conectados."),
    VersionInfo(
        versionName: "0.3.0",
        versionNumberPlayStore: "3",
        date: "19/06/2023",
        notes:
            "Implementada a tabela de últimas leituras do sensor, na tela de detalhamento do sensor."),
    VersionInfo(
        versionName: "0.2.0",
        versionNumberPlayStore: "2",
        date: "18/06/2023",
        notes:
            "Implementada a lista de sensores conectados, tela de conexão a novos sensores, cadastro/atualização de sensores e também tela de informações detalhadas de sensores/atuadores."),
    VersionInfo(
        versionName: "0.1.0",
        versionNumberPlayStore: "1",
        date: "18/03/2023",
        notes:
            "Primeira versão do aplicativo Planto IoT. Implementada a funcionada de login e cadastro via provedor de identidade do Google. Implementado o dashboard e placeholders para as funcionalidades de sensores, configurações. Implementada a funcionalidade de logout."),
  ];
}
