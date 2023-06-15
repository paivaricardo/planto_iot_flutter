import 'package:flutter/foundation.dart';
import 'package:planto_iot_flutter/model/usuario_model.dart';

class UsuarioProvider extends ChangeNotifier {
  UsuarioModel? _usuario;

  UsuarioProvider(UsuarioModel? usuario) : _usuario = usuario;

  UsuarioModel? get usuario => _usuario;

  void updateUsuario(UsuarioModel updatedUsuario) {
    _usuario = updatedUsuario;
    notifyListeners();
  }
}
