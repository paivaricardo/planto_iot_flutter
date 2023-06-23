import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/cultura_managing_model.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

class GerenciarCulturasScreen extends StatefulWidget {
  const GerenciarCulturasScreen({super.key});

  @override
  State<GerenciarCulturasScreen> createState() =>
      _GerenciarCulturasScreenState();
}

class _GerenciarCulturasScreenState extends State<GerenciarCulturasScreen> {
  late User loggedInUser;

  @override
  initState() {
    super.initState();
    loggedInUser = Provider.of<User?>(context, listen: false)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  _buildBody() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: PlantoIoTBackgroundBuilder().buildPlantoIoTAppBackGround(
          firstRadialColor: 0xFF0D6D0B, secondRadialColor: 0xFF0B3904),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(),
      ),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showCreateUpdateCulturaDialog(context),
      child: const Icon(Icons.add),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                PlantoIOTTitleComponent(size: 18),
                Text("Gerenciar Culturas",
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

  _buildContent() {
    return FutureBuilder(
      future: BackendService.obterTodasCulturasGerenciar(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CulturaManagingModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScren(snapshot.error);
        } else if (snapshot.hasData) {
          // Carregar a lista de áreas a serem gerenciadas
          List<CulturaManagingModel> culturas = snapshot.data!;

          return _buildManagingCulturasList(culturas);
        } else {
          return _buildErrorScren(snapshot.error);
        }
      },
    );
  }

  _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildErrorScren(Object? error) {
    return Center(
      child: Text(
        "Erro ao carregar dados: $error",
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  _buildManagingCulturasList(List<CulturaManagingModel> culturas) {
    return ListView.builder(
      itemCount: culturas.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildManagingCulturaCard(culturas[index]);
      },
    );
  }

  _buildManagingCulturaCard(CulturaManagingModel cultura) {
    return Card(
      child: ListTile(
        title: Text(cultura.nomeCultura),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cultura.updatable)
              IconButton(
                  onPressed: () {
                    _showCreateUpdateCulturaDialog(context, cultura: cultura);
                  },
                  icon: const Icon(Icons.edit, color: Colors.green)),
            if (cultura.deletable)
              IconButton(
                  onPressed: () {
                    _showConfirmDeleteCulturaDialog(context, cultura);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red)),
          ],
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

  void _showCreateUpdateCulturaDialog(BuildContext context,
      {CulturaManagingModel? cultura}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return GerenciarCulturaCriarAtualizarWidget(cultura: cultura);
        });

    setState(() {});
  }

  void _showConfirmDeleteCulturaDialog(
      BuildContext context, CulturaManagingModel cultura) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return GerenciarCulturaDeletarWidget(cultura: cultura);
        });

    setState(() {});
  }
}

class GerenciarCulturaCriarAtualizarWidget extends StatefulWidget {
  final CulturaManagingModel? cultura;

  const GerenciarCulturaCriarAtualizarWidget({this.cultura, super.key});

  @override
  State<GerenciarCulturaCriarAtualizarWidget> createState() =>
      _GerenciarCulturaCriarAtualizarWidgetState();
}

class _GerenciarCulturaCriarAtualizarWidgetState
    extends State<GerenciarCulturaCriarAtualizarWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final CulturaManagingModel? cultura;

  final TextEditingController nomeCulturaController = TextEditingController();

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();

    cultura = widget.cultura;

    if (cultura != null) {
      nomeCulturaController.text = cultura!.nomeCultura;
    }
  }

  @override
  void dispose() {
    nomeCulturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(cultura != null ? 'Atualizar Cultura' : 'Criar Cultura'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                key: _formKey,
                child: TextFormField(
                  controller: nomeCulturaController,
                  maxLength: 255,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome para a cultura.';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nome da Cultura',
                  ),
                ))
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: isProcessing
                ? () {}
                : () async {
                    setState(() {
                      isProcessing = true;
                    });

                    try {
                      Map<String, dynamic> response = await (cultura != null
                          ? BackendService.atualizarCultura(
                              nomeCulturaController.text, cultura!.idCultura)
                          : BackendService.criarCultura(
                              nomeCulturaController.text));

                      if (response['status'] == 'success') {
                        Navigator.of(context).pop({'culturaUpdated': true});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(response['message']),
                        ));
                      }
                    } catch (e) {
                      setState(() {
                        isProcessing = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                      ));
                    }
                  },
            child: isProcessing
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                      Text('Processando...')
                    ],
                  )
                : Text(cultura == null ? 'Criar' : 'Atualizar')),
      ],
    );
  }
}

class GerenciarCulturaDeletarWidget extends StatefulWidget {
  final CulturaManagingModel cultura;

  const GerenciarCulturaDeletarWidget({required this.cultura, super.key});

  @override
  State<GerenciarCulturaDeletarWidget> createState() =>
      _GerenciarCulturaDeletarWidgetState();
}

class _GerenciarCulturaDeletarWidgetState
    extends State<GerenciarCulturaDeletarWidget> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmar exclusão'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Tem certeza que deseja excluir esta cultura? Esta ação não poderá ser desfeita.'),
            const SizedBox(height: 16.0),
            Text(
              widget.cultura.nomeCultura,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () async {
              setState(() {
                _isProcessing = true;
              });
              try {
                await BackendService.deletarCultura(widget.cultura.idCultura);
                Navigator.of(context).pop({'areaUpdated': true});
              } catch (e) {
                setState(() {
                  _isProcessing = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(e.toString()),
                ));
              }
            },
            child: _isProcessing
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                      Text('Processando...')
                    ],
                  )
                : const Text('Excluir')),
      ],
    );
  }
}
