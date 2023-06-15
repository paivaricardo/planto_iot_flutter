class AreaModel {
  final int idArea;
  final String nomeArea;

  AreaModel({
    required this.idArea,
    required this.nomeArea,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      idArea: json['id_area'],
      nomeArea: json['nome_area'],
    );
  }
}
