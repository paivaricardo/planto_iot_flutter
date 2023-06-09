import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:planto_iot_flutter/components/planto_iot_appbar_background.dart';
import 'package:planto_iot_flutter/components/planto_iot_background_builder.dart';
import 'package:planto_iot_flutter/components/planto_iot_title_component.dart';
import 'package:planto_iot_flutter/model/area_managing_model.dart';
import 'package:planto_iot_flutter/services/planto_iot_backend_service.dart';
import 'package:provider/provider.dart';

class GerenciarAreasScreen extends StatefulWidget {
  const GerenciarAreasScreen({super.key});

  @override
  State<GerenciarAreasScreen> createState() => _GerenciarAreasScreenState();
}

class _GerenciarAreasScreenState extends State<GerenciarAreasScreen> {
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
      onPressed: () => _showCreateUpdateAreaDialog(context),
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
                Text("Gerenciar Áreas",
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
      future: BackendService.obterTodasAreasGerenciar(),
      builder: (BuildContext context,
          AsyncSnapshot<List<AreaManagingModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScren(snapshot.error);
        } else if (snapshot.hasData) {
          // Carregar a lista de áreas a serem gerenciadas
          List<AreaManagingModel> areas = snapshot.data!;

          return _buildManagingAreasList(areas);
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

  _buildManagingAreasList(List<AreaManagingModel> areas) {
    return ListView.builder(
      itemCount: areas.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildManagingAreaCard(areas[index]);
      },
    );
  }

  _buildManagingAreaCard(AreaManagingModel area) {
    return Card(
      child: ListTile(
        title: Text(area.nomeArea),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (area.updatable)
              IconButton(
                  onPressed: () {
                    _showCreateUpdateAreaDialog(context, area: area);
                  },
                  icon: const Icon(Icons.edit, color: Colors.green)),
            if (area.deletable)
              IconButton(
                  onPressed: () {
                    _showConfirmDeleteAreaDialog(context, area);
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


  void _showCreateUpdateAreaDialog(BuildContext context,
      {AreaManagingModel? area}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return GerenciarAreaCriarAtualizarWidget(area: area);
        });

    setState(() {});
  }

  void _showConfirmDeleteAreaDialog(
      BuildContext context, AreaManagingModel area) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return GerenciarAreaDeletarWidget(area: area);
        });

    setState(() {});
  }
}

class GerenciarAreaCriarAtualizarWidget extends StatefulWidget {
  final AreaManagingModel? area;

  const GerenciarAreaCriarAtualizarWidget({this.area, super.key});

  @override
  State<GerenciarAreaCriarAtualizarWidget> createState() =>
      _GerenciarAreaCriarAtualizarWidgetState();
}

class _GerenciarAreaCriarAtualizarWidgetState
    extends State<GerenciarAreaCriarAtualizarWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final AreaManagingModel? area;

  final TextEditingController nomeAreaController = TextEditingController();

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();

    area = widget.area;

    if (area != null) {
      nomeAreaController.text = area!.nomeArea;
    }
  }

  @override
  void dispose() {
    nomeAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(area != null ? 'Atualizar Área' : 'Criar Área'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                key: _formKey,
                child: TextFormField(
                  controller: nomeAreaController,
                  maxLength: 255,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome para a área';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nome da Área',
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
                      Map<String, dynamic> response = await (area != null
                          ? BackendService.atualizarArea(
                              nomeAreaController.text, area!.idArea)
                          : BackendService.criarArea(nomeAreaController.text));

                      if (response['status'] == 'success') {
                        Navigator.of(context).pop({'areaUpdated': true});
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
                : Text(area == null ? 'Criar' : 'Atualizar')),
      ],
    );
  }
}

class GerenciarAreaDeletarWidget extends StatefulWidget {
  final AreaManagingModel area;

  const GerenciarAreaDeletarWidget({required this.area, super.key});

  @override
  State<GerenciarAreaDeletarWidget> createState() =>
      _GerenciarAreaDeletarWidgetState();
}

class _GerenciarAreaDeletarWidgetState
    extends State<GerenciarAreaDeletarWidget> {
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
                'Tem certeza que deseja excluir esta área? Esta ação não poderá ser desfeita.'),
            const SizedBox(height: 16.0),
            Text(
              widget.area.nomeArea,
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
                await BackendService.deletarArea(widget.area.idArea);
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
