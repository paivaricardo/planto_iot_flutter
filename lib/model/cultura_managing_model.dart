class CulturaManagingModel {
  final String nomeCultura;
  final int idCultura;
  final bool updatable;
  final bool deletable;

  CulturaManagingModel({
    required this.nomeCultura,
    required this.idCultura,
    required this.updatable,
    required this.deletable,
  });

  factory CulturaManagingModel.fromJson(Map<String, dynamic> json) {
    return CulturaManagingModel(
      idCultura: json['id_cultura'],
      nomeCultura: json['nome_cultura'],
      updatable: json['updatable'],
      deletable: json['deletable'],
    );
  }
}
