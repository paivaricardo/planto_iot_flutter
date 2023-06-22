class AreaManagingModel {
  final int idArea;
  final String nomeArea;
  final bool updatable;
  final bool deletable;

  AreaManagingModel({
    required this.idArea,
    required this.nomeArea,
    required this.updatable,
    required this.deletable,
  });

  factory AreaManagingModel.fromJson(Map<String, dynamic> json) {
    return AreaManagingModel(
      idArea: json['id_area'],
      nomeArea: json['nome_area'],
      updatable: json['updatable'],
      deletable: json['deletable'],
    );
  }
}
