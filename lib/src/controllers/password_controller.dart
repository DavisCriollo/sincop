import 'package:flutter/material.dart';
import 'package:sincop_app/src/api/api_provider.dart';

class PasswordController extends ChangeNotifier {
  GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();
  final _api = ApiProvider();
  String _usuario = "";
  String _empresa = "";

  void onChangeUser(String text) {
    _usuario = text;
    print(_usuario);
  }

  void onChangeEmpresa(String text) {
    _empresa = text;
    print(_empresa);
  }

  bool validateForm() {
    if (formKeyPassword.currentState!.validate()) {
      // print('formPass Oksss');
      return true;
    } else {
      // print('formPass ERROR');
      return false;
    }
  }

//========================== RECUPERA CLAVE =======================//
  Future passwordRecovery() async {
//  print('EMPRESA --> $_empresa');
//  print('USUARIO --> $_usuario');

    final response =
        await _api.recuperaClave(empresa: _empresa, usuario: _usuario);
    // //============//
    //  print('RESPUESTA CTRL: $response["msg"]');
    if (response != null) {
      return response;
    }
    if (response == null) {
      print('Es NULL');
      return null;
    }
  }
}
