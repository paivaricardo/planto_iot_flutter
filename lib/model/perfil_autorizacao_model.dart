class PerfilAutorizacaoModel {
  int idPerfilAutorizacao;
  String nmePerfilAutorizacao;

  PerfilAutorizacaoModel({
    required this.idPerfilAutorizacao,
    required this.nmePerfilAutorizacao,
  });

  factory PerfilAutorizacaoModel.fromJson(Map<String, dynamic> json) {
    return PerfilAutorizacaoModel(
      idPerfilAutorizacao: json['id_perfil_autorizacao'],
      nmePerfilAutorizacao: json['nme_perfil_autorizacao'],
    );
  }
}
