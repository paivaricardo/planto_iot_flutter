import 'package:planto_iot_flutter/version_info/version_info_model.dart';

class VersionInfoMain {
  static VersionInfo currentVersion = versionHistory.first;

  static List<VersionInfo> versionHistory = [
    VersionInfo(
        versionName: "0.15.0",
        versionNumberPlayStore: "18",
        date: "06/07/2023",
        notes:
        "Alteração dos ícones para refletir melhor a diversidade de sensores e atuadores. Alteração da lógica do programa para permitir que qualquer usuário complete o cadastro de um sensor pré-cadastrado, tornando-se, no processo, o proprietário do sensor."),
    VersionInfo(
        versionName: "0.14.0",
        versionNumberPlayStore: "17",
        date: "03/07/2023",
        notes:
        "Atualização do link para acesso ao backend para um endereço seguro (https)."),
    VersionInfo(
        versionName: "0.13.1",
        versionNumberPlayStore: "16",
        date: "30/06/2023",
        notes:
        "Atualização do link para visualização do vídeo instrucional na tela de dashboard."),
    VersionInfo(
        versionName: "0.13.0",
        versionNumberPlayStore: "15",
        date: "30/06/2023",
        notes:
        "Implementação do link para visualização do vídeo instrucional na tela de dashboard."),
    VersionInfo(
        versionName: "0.12.0",
        versionNumberPlayStore: "14",
        date: "29/06/2023",
        notes:
        "Implementação da geração de gráficos de relatório da leitura de sensores na tela de monitoramento de sensores. Geração de PDF dos gráficos de leitura. Correção do bug no pré-cadastro de sensores e atuadores."),
    VersionInfo(
        versionName: "0.11.0",
        versionNumberPlayStore: "13",
        date: "27/06/2023",
        notes:
        "Acréscimo da funcionalidade de imprimir QR codes na tela de monitorar sensor/atuador específico. Acréscimo dos RefreshIndicatores na lista de sensores e também na tela de monitorar sensor/atuador específico. Correção de bug ao pré-cadastrar sensor, que sempre alterava o tipo de sensor para sensor de umidade do solo."),
    VersionInfo(
        versionName: "0.10.2",
        versionNumberPlayStore: "12",
        date: "27/06/2023",
        notes:
        "Correção de bugs na tela de pré-cadastro, na seleção Dropdown de tipo de sensor. Correção de bug na parte de autorizações."),
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
