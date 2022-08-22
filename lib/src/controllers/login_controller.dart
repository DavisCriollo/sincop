import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/auth_response.dart';
import 'package:sincop_app/src/models/session_response.dart';

class LoginController extends ChangeNotifier {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();
  AuthResponse? _dataLogin;

  Session? infoUser;

  // AuthResponse? get infoUser  => _dataLogin ;
  bool? _recuerdaCredenciales = false;

  String? _usuario = "", _clave = "", _empresa = "PAZVISEG";

  void onChangeUser(String text) {
    _usuario = text;
  }

  void onChangeClave(String text) {
    _clave = text;
  }

  void onChangeEmpresa(String text) {
    _empresa = text;
  }

  bool? get getRecuerdaCredenciales => _recuerdaCredenciales;
  String? get getUsuario => _usuario;
  String? get getClave => _clave;
  String? get getEmpresa => _empresa;

  bool validateForm() {
    if (loginFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  //====================================== RECORDAR CLAVE ======================================//
  void onRecuerdaCredenciales(bool value) {
    _recuerdaCredenciales = value;

    notifyListeners();
  }
//*******************************************************//

  //========================== MENU =======================//
  bool _isOpen = false;
  int _indexMenu = 0;

  void onChangeOpen(bool value) {
    _isOpen = value;

    notifyListeners();
  }

  void onChangeIndex(int index) {
    _indexMenu = index;

    notifyListeners();
  }

  bool get getIsOpen => _isOpen;
  int get getIndexMenu => _indexMenu;

  //========================== CREA TABLA ACTIVIDADES =======================//

  List<dynamic> tablaActividades = [];
  String _rondaSave = '';

  //========================== LOGIN =======================//
  Future<AuthResponse?> loginApp(BuildContext context) async {

    final response = await _api.login(
        empresa: _empresa, usuario: _usuario, password: _clave);

    if (response != null) {
      await Auth.instance.saveSession(response);
      infoUser = await Auth.instance.getSession();
      //  print('=========++ > ${infoUser!.usuario}');
      _dataLogin = response;
      // print(_dataLogin!.nomComercial);


 _rondaSave = jsonEncode(tablaActividades);
    await Auth.instance.saveRondasActividad(_rondaSave);




      return response;
    }
    if (response == null) {
      return null;
    }
  }
}
