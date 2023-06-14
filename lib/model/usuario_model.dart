class UsuarioModel {
  final int idUsuario;
  final String emailUsuario;
  final String nomeUsuario;
  final DateTime dataCadastro;
  final int idPerfil;

  UsuarioModel({
    required this.idUsuario,
    required this.emailUsuario,
    required this.nomeUsuario,
    required this.dataCadastro,
    required this.idPerfil,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      idUsuario: json['id_usuario'],
      emailUsuario: json['email_usuario'],
      nomeUsuario: json['nome_usuario'],
      dataCadastro: DateTime.parse(json['data_cadastro']),
      idPerfil: json['id_perfil'],
    );
  }
}
