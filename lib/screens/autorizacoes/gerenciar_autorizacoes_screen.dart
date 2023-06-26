import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/autorizacao_model.dart';
import 'package:planto_iot_flutter/model/sensor_atuador_info_model.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

class GerenciarAutorizacoesScreen extends StatefulWidget {
  final String uuidSensorAtuador;

  const GerenciarAutorizacoesScreen(
      {required this.uuidSensorAtuador, super.key});

  @override
  State<GerenciarAutorizacoesScreen> createState() =>
      _GerenciarAutorizacoesScreenState();
}

class _GerenciarAutorizacoesScreenState
    extends State<GerenciarAutorizacoesScreen> {
  // Informações do sensor que está sendo monitorado
  SensorAtuadorInfoModel? sensorAtuadorInfoModel;

  // Informações das autorizações do sensor que está sendo monitorado
  List<AutorizacaoSensorModel>? autorizacoes;

  late User loggedInUser;

  late Future<Map<String, dynamic>> _verificarSensorAtuadorFuture;

  @override
  void didChangeDependencies() {
    loggedInUser = Provider.of<User?>(context)!;
    _verificarSensorAtuadorFuture = _loadVerificarSensorAtuadorFuture();
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>> _loadVerificarSensorAtuadorFuture() {
    return BackendService.verificarSensorAtuador(
        uuid: widget.uuidSensorAtuador, email: loggedInUser.email!);
  }

  void _reloadAutorizacoesFuture() {
    setState(() {
      _verificarSensorAtuadorFuture = _loadVerificarSensorAtuadorFuture();
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlantoIOTTitleComponent(size: 18),
                Text("Gerenciar autorizações",
                    style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaOne')),
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
    loggedInUser = Provider.of<User?>(context)!;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
          firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            SingleChildScrollView(child: _buildGerenciarAutorizacoesMainBody()),
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

  Widget _buildLoadingScreen() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Colors.white,
        ),
        Text(
          "Carregando dados...",
          style: TextStyle(color: Colors.white, fontFamily: "Josefin Sans"),
        )
      ],
    );
  }

  Widget _buildErrorScren(Object? error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Erro ao carregar dados do sensor: ${error.toString()}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  _buildGerenciarAutorizacoesMainBody() {
    return FutureBuilder(
      future: _verificarSensorAtuadorFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScren(snapshot.error);
        } else if (snapshot.hasData) {
          // Carregar os dados do sensor cadastrado
          final sensorAtuadorBackendInfo = snapshot.data!;

          if (sensorAtuadorBackendInfo['status'] != 1 &&
              sensorAtuadorBackendInfo['status'] != 2) {
            // Carregar as informações do sensor no modelo de dados
            sensorAtuadorInfoModel = SensorAtuadorInfoModel.fromJson(
                sensorAtuadorBackendInfo['content']['sensor_atuador_info']);

            // Definir a lista de autorizações
            List<AutorizacaoSensorModel> autorizacoes =
                sensorAtuadorBackendInfo['content']['autorizacoes']
                    .map<AutorizacaoSensorModel>((autorizacao) =>
                        AutorizacaoSensorModel.fromJson(autorizacao))
                    .toList();

            this.autorizacoes = autorizacoes;

            return GerenciarAutorizacoesSensorCarregado(
                sensorAtuadorInfoModel: sensorAtuadorInfoModel!,
                autorizacoes: autorizacoes,
                loggedInUser: loggedInUser,
                reloadAutorizacoesParent: _reloadAutorizacoesFuture);
          } else {
            return _buildNotAuthorizedScreen();
          }
        } else {
          return _buildErrorScren(snapshot.error);
        }
      },
    );
  }

  Widget _buildNotAuthorizedScreen() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'O usuário não possui permissão para acessar os dados do sensor.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showCreateAutorizacaoDialog(context);
      },
      backgroundColor: Colors.green,
      child: const Icon(Icons.add),
    );
  }

  void _showCreateAutorizacaoDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool processingCreateAutorizacao = false;

    void setProcessingCreateAutorizacao(bool value) {
      setState(() {
        processingCreateAutorizacao = value;
      });
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return autorizacoes == null
              ? AlertDialog(
                  title: const Text(
                    'Carregando dados...',
                    style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),
                  ),
                  content: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'))
                  ],
                )
              : AlertDialog(
                  title: const Text(
                    'Criar autorização',
                    style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),
                  ),
                  content: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Digite o e-mail do usuário que deseja autorizar a acessar os dados do sensor.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontFamily: "Josefin Sans", fontSize: 16.0),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite o e-mail do usuário';
                              }

                              if (!EmailValidator.validate(value)) {
                                return 'Digite um e-mail válido';
                              }

                              if (autorizacoes!.any((autorizacao) =>
                                  autorizacao.usuario.emailUsuario == value)) {
                                return 'Já existe uma autorização para este usuário.';
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'E-mail do usuário',
                                hintText: 'Digite o e-mail do usuário'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar')),
                    processingCreateAutorizacao
                        ? TextButton(
                            onPressed: () {},
                            child: const Row(
                              children: [
                                CircularProgressIndicator(),
                                Text('Processando...')
                              ],
                            ))
                        : TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                _createAutorizacao(
                                    context,
                                    emailController.text,
                                    setProcessingCreateAutorizacao);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Preencha os campos corretamente.')));
                              }
                            },
                            child: const Text('Criar'))
                  ],
                );
        });
  }

  void _createAutorizacao(BuildContext context, String emailUsuario,
      void Function(bool) setProcessingCreateAutorizacao) async {
    try {
      setProcessingCreateAutorizacao(true);

      final Map<String, dynamic> criarAutorizacaoResponse =
          await BackendService.criarAutorizacao(
              idSensorAtuador: sensorAtuadorInfoModel!.idSensorAtuador,
              emailUsuario: emailUsuario,
              idPerfilAutorizacao: 1);

      if (criarAutorizacaoResponse['status'] == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Autorização criada com sucesso.')));

        _reloadAutorizacoesFuture();

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao criar autorização.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar autorização.')));
    } finally {
      setProcessingCreateAutorizacao(false);
    }
  }
}

class EmailValidator {
  static bool validate(String value) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
  }
}

class GerenciarAutorizacoesSensorCarregado extends StatefulWidget {
  final User loggedInUser;
  final SensorAtuadorInfoModel sensorAtuadorInfoModel;
  final List<AutorizacaoSensorModel> autorizacoes;
  final void Function() reloadAutorizacoesParent;

  const GerenciarAutorizacoesSensorCarregado(
      {required this.sensorAtuadorInfoModel,
      required this.autorizacoes,
      required this.loggedInUser,
      required this.reloadAutorizacoesParent,
      super.key});

  @override
  State<GerenciarAutorizacoesSensorCarregado> createState() =>
      _GerenciarAutorizacoesSensorCarregadoState();
}

class _GerenciarAutorizacoesSensorCarregadoState
    extends State<GerenciarAutorizacoesSensorCarregado> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSensorInfo(),
        _buildAutorizacoesList(),
      ],
    );
  }

  _buildSensorInfo() {
    return Column(
      children: [
        Visibility(
          visible: widget.sensorAtuadorInfoModel.nomeSensor != null,
          child: Column(
            children: [
              const Text('Nome',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Josefin Sans",
                      fontSize: 24.0)),
              SelectableText(
                widget.sensorAtuadorInfoModel.nomeSensor ?? "Sem nome",
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Josefin Sans",
                    fontSize: 24.0),
              ),
            ],
          ),
        ),
        const Text(
          "UUID",
          style: TextStyle(
              color: Colors.white, fontFamily: "Josefin Sans", fontSize: 24.0),
        ),
        SelectableText(
          widget.sensorAtuadorInfoModel.uuidSensorAtuador,
          style: const TextStyle(
              color: Colors.white, fontFamily: "Josefin Sans", fontSize: 16.0),
        ),
      ],
    );
  }

  _buildAutorizacoesList() {
    return Column(
      children: [
        const Text(
          "Autorizações",
          style: TextStyle(
              color: Colors.white, fontFamily: "Josefin Sans", fontSize: 24.0),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.autorizacoes.length,
          itemBuilder: (context, index) {
            return _buildAutorizacaoItem(widget.autorizacoes[index]);
          },
        ),
      ],
    );
  }

  _buildAutorizacaoItem(AutorizacaoSensorModel autorizacao) {
    return Card(
      child: ListTile(
        title: Text(
          autorizacao.usuario.nomeUsuario,
          style: const TextStyle(
              color: Colors.black, fontFamily: "Josefin Sans", fontSize: 16.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              autorizacao.usuario.emailUsuario,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Josefin Sans",
                  fontSize: 12.0),
            ),
            Text(
              autorizacao.perfilAutorizacao.nmePerfilAutorizacao,
              style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Josefin Sans",
                  fontSize: 12.0),
            ),
            Text(
              autorizacao.visualizacaoAtiva ? "Conectado" : "Não conectado",
              style: TextStyle(
                  color:
                      autorizacao.visualizacaoAtiva ? Colors.green : Colors.red,
                  fontFamily: "Josefin Sans",
                  fontSize: 12.0),
            ),
          ],
        ),
        trailing: Visibility(
          visible:
              widget.loggedInUser.email! != autorizacao.usuario.emailUsuario,
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteAutorizacaoDialog(autorizacao);
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteAutorizacaoDialog(AutorizacaoSensorModel autorizacao) {
    bool deleteButtonProcessing = false;

    void setDeleteButtonProcessing(bool value) {
      setState(() {
        deleteButtonProcessing = value;
      });
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Text(
              'Remover autorização',
              style: TextStyle(fontFamily: "FredokaOne", fontSize: 24.0),
            ),
            content: const SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tem certeza que deseja remover a autorização do usuário?',
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
                  child: const Text('Cancelar')),
              deleteButtonProcessing
                  ? TextButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          CircularProgressIndicator(),
                          Text('Processando...')
                        ],
                      ))
                  : TextButton(
                      onPressed: () {
                        _deleteAutorizacao(
                            autorizacao: autorizacao,
                            setDeleteButtonProcessing:
                                setDeleteButtonProcessing);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Remover'))
            ],
          );
        });
  }

  _deleteAutorizacao({
    required AutorizacaoSensorModel autorizacao,
    required void Function(bool) setDeleteButtonProcessing,
  }) async {
    setDeleteButtonProcessing(true);

    Map<String, dynamic> autorizacaoSensorResponse =
        await BackendService.deletarAutorizacao(
            autorizacao.idAutorizacaoSensor);

    if (autorizacaoSensorResponse['status'] == 'success') {
      setDeleteButtonProcessing(false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Autorização removida.',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Josefin Sans",
                fontSize: 16.0),
          ),
          backgroundColor: Colors.red,
        ),
      );

      widget.reloadAutorizacoesParent();
    } else {
      setDeleteButtonProcessing(false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            autorizacaoSensorResponse['message'],
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "Josefin Sans",
                fontSize: 16.0),
          ),
          backgroundColor: Colors.red,
        ),
      );
      widget.reloadAutorizacoesParent();
    }
  }
}
