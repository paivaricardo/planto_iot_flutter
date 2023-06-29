# Planto IoT (Aplicação mobile em Flutter)

Repositório para armazenar o projeto Flutter (Dart) do sistema Planto IoT (plataforma e monitoramento e controle de dispositivos IoT para a agricultura de precisão). O aplicativo permite controlar e monitorar dispositivos de IoT para a agricultura de precisão.


# Descrição do app

O Planto IoT é um aplicativo móvel que permite monitorar e controlar sensores e atuadores utilizados na agricultura. Com uma interface intuitiva e fácil de usar, você pode realizar diversas tarefas para otimizar a produção agrícola.

Recursos do aplicativo:

Login de Usuário: Faça login facilmente usando sua conta do Google.

Registro de Sensores e Atuadores: Cadastre e gerencie sensores e atuadores, incluindo informações como nome, localização (latitude e longitude) e tipo de sensor.

Associação de Sensores/Atuadores: Associe sensores e atuadores a usuários, áreas, culturas e tipos de sensores. Você pode ter várias áreas sob seus cuidados e personalizar as configurações de cada uma.

Atribuição de Perfis: Atribua diferentes papéis aos usuários para estabelecer suas permissões e níveis de acesso.

Cadastro de Culturas e Áreas: Cadastre diferentes tipos de culturas e áreas para melhor organização e controle do monitoramento.

Cadastro de Tipos de Sensores e Atuadores: Adicione novos tipos de sensores e atuadores ao sistema para ampliar suas opções de monitoramento.

Cadastro de Tipos de Sinais: Registre os tipos de sinais enviados pelos sensores e atuadores para uma análise mais precisa das leituras e respostas.

Registro de Leituras: Registre as leituras realizadas pelos sensores e as respostas dos atuadores para acompanhar o desempenho do sistema.

Com o Planto IoT, você terá controle total sobre o monitoramento agrícola, permitindo uma gestão eficiente e otimizada. Baixe o aplicativo agora e comece a aproveitar todos esses recursos para impulsionar sua produção agrícola!


# Notas das versões

**

**0.11.0 (13) 27/06/2023**: Acréscimo da funcionalidade de imprimir QR codes na tela de monitorar sensor/atuador específico. Acréscimo dos RefreshIndicatores na lista de sensores e também na tela de monitorar sensor/atuador específico. Correção de bug ao pré-cadastrar sensor, que sempre alterava o tipo de sensor para sensor de umidade do solo.

**0.10.1 (11) (27/06/2023)**: Correção de bugs no pré-cadastro de sensores/atuadores.

**0.10.0 (26/06/2023)**: Implementada a funcionalidade de pré-cadastro de sensores e atuadores, com geração dos PDFs. Acessível por meio da tela de conexão com sensores/atuadores.

**0.8.0 (24/06/2023)**: Implementada a funcionalidade de desconectar um sensor/atuador a partir da tela de monitoramento de sensores e atuadores.

**0.7.0 (23/06/2023)**: Implementadas telas para gerenciamento de áreas e culturas, acessíveis a partir da tela de cadastro/atualização de cadastro de sensores e atuadores.

**0.6.0 (21/06/2023)**: Implementada integração com a API do Google, para seleção de localização do sensor no mapa e para visualização da localização.

**0.4.0 (20/06/2023)**: 

**0.3.0 (19/06/2023)**: Implementada a tabela de últimas leituras do sensor, na tela de detalhamento do sensor."

**0.2.0 (18/06/2023)**: Implementada a lista de sensores conectados, tela de conexão a novos sensores, cadastro/atualização de sensores e também tela de informações detalhadas de sensores/atuadores.

**0.1.0 (18/03/2023)**: Primeira versão do aplicativo Planto IoT. Implementada a funcionada de login e cadastro via provedor de identidade do Google. Implementado o dashboard e placeholders para as funcionalidades de sensores, configurações. Implementada a funcionalidade de logout.

# Instruções para a instalação

- Acrecentar o arquivo app_config.dart, em lib/config/app_config.dart, de acordo com o modelo app_config_template.dart.
- Acrecentar o arquivo AndroidManifest.xml, em /android/app/src/main/AndroidManifest.xml, de acordo com o modelo AndroidManifest_template.xml. O arquivo AndroidManifest.xml deve conter a chave de API do Google Maps.
- Adicione o key.properties em /android/key.properties, de acordo com o modelo key_template.properties.
- Adicione o arquivo upload-keystore.jks em /android/app/upload-keystore.jks. Essa é a chave para assinatura da aplicação.