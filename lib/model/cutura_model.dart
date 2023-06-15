class CulturaModel {
  final String nomeCultura;
  final int idCultura;

  CulturaModel({
    required this.nomeCultura,
    required this.idCultura,
  });

  factory CulturaModel.fromJson(Map<String, dynamic> json) {
    return CulturaModel(
      nomeCultura: json['nome_cultura'],
      idCultura: json['id_cultura'],
    );
  }
}
