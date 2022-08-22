import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/lista_allClientes.dart';
import 'package:sincop_app/src/models/lista_allInforme_guardias.dart';
import 'package:sincop_app/src/service/socket_service.dart';

class TurnoExtraController extends ChangeNotifier {
  GlobalKey<FormState> turnoExtraFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();
  void resetValuesTurnoExtra() {
    _idGuardia;
    _cedulaGuardia = "";
    _nombreGuardia = "";
    // _puestoServicioGuardia = "";
    _idCliente;
    _cedulaCliente = "";
    _nombreNuevoCliente = "";
    _labelNuevoPuesto = null;
    _listaPuestosCliente = [];
    // _listaPuestoNuevoCliente = cliente.cliDatosOperativos!;
  }

  notifyListeners();

  bool validateForm() {
    if (turnoExtraFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  //==========================inputs================//
  int? _idGuardia;
  String? _cedulaGuardia;
  String? _nombreGuardia;
  String? get nombreGuardia => _nombreGuardia;
  List? _puestoServicioGuardia;
  List? get puestosServicioGuardia => _puestoServicioGuardia;
  String? _clienteNombre;
  String? get clienteNombre => _clienteNombre;

  String? _inputAutorizadoPor;
  String? get getInputAutorizadoPor => _inputAutorizadoPor;
  void onAutorizadoPorChange(String? text) {
    _inputAutorizadoPor = text;
    // print(_inputAutorizadoPor);
    notifyListeners();
  }

  String? _inputDetalle;
  String? get getInputDetalle => _inputDetalle;
  void onDetalleChange(String? text) {
    _inputDetalle = text;
    // print(_inputDetalle);
    notifyListeners();
  }
  // SELECCIONA EL PUESTO DEL GUARDIA//

//========================================//
  List _listaInfoGuardia = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaInfoGuardia => _listaInfoGuardia;

  void setInfoBusquedaInfoGuardia(List data) {
    _listaInfoGuardia = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de guardias SOCKET: ${_listaInfoGuardia}');
    notifyListeners();
  }

  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  late Informe _informeGuardia;
  Informe get getInforme => _informeGuardia;

  void setinformeGuardia(Informe data) {
    _listaInfoGuardia.add(data);

    notifyListeners();
  }

  bool? _errorInfoGuardia; // sera nulo la primera vez
  bool? get getErrorInfoGuardia => _errorInfoGuardia;
  set setErrorInfoGuardia(bool? value) {
    _errorInfoGuardia = value;
    notifyListeners();
  }

  Future buscaInfoGuardias(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllGuardias(
      search: _search,
      estado: 'GUARDIAS',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoGuardia = true;

      // print('${response.data[0].infAsunto} ${response.data[0].infLugar}');
      //  _listaInfoGuardia=response.data;
      setInfoBusquedaInfoGuardia(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoGuardia = false;
      notifyListeners();
      return null;
    }
  }

//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaGuardias;

  @override
  void dispose() {
    _deboucerSearchBuscaGuardias?.cancel();

    // _videoController.dispose();
    super.dispose();
  }

  String? _inputBuscaGuardia;
  get getInputBuscaGuardia => _inputBuscaGuardia;
  void onInputBuscaGuardiaChange(String? text) {
    _inputBuscaGuardia = text;
    // print('GUSCA GUARDIA MULTA :$_inputBuscaGuardia');
  }

  int? _idCliente;
  String? _cedulaCliente;
  String? _nombreNuevoCliente;
  String? get nombreCliente => _nombreNuevoCliente;
  String? _puestoNuevo;
  String? get getPuestosNuevoCliente => _puestoNuevo;
  void setPuestoNuevoCliente(String data) {
    _puestoNuevo = data;
    notifyListeners();
  }
  // SELECCIONA EL PUESTO DEL CLIENTE//

  List _listaPuestosCliente = [];
  List get getListaPuestosCliente => _listaPuestosCliente;
  void setListaPuestoCliente(List data) {
    _listaPuestosCliente = data;
    // print('PUESTOS : $_listaPuestosCliente');
    notifyListeners();
  }

  void resetDropDown() {
    _labelNuevoPuesto = null;
    _listaPuestosCliente = [];
  }

  Map<String, dynamic>? _nuevoPuesto;
  String? _labelNuevoPuesto;

  String? get labelNuevoPuesto => _labelNuevoPuesto;
  dynamic _itemSelect;
  void setLabelINuevoPuesto(String? value) {
    _labelNuevoPuesto = value;

    for (var e in _listaPuestosCliente) {
      if (e['puesto'] == labelNuevoPuesto) {
        _nuevoPuesto = {
          "ubicacion": e['ubicacion'],
          "puesto": e['puesto'],
          "supervisor": e['supervisor'],
          "guardias": e['guardias'],
          "horasservicio": e['horasservicio'],
          "tipoinstalacion": e['tipoinstalacion'],
          "vulnerabilidades": e['vulnerabilidades'],
          "consignas": e['consignas'],
        };
      }
    }

    // print(
    //     '-----ss:$_labelNuevoPuesto- $_nuevoPuesto ${_itemSelect.runtimeType}');
    notifyListeners();
  }
//========================================//

  void getInfoGuardia(dynamic guardia) {
    _idGuardia = guardia['perId'];
    _cedulaGuardia = guardia['perDocNumero'];
    _nombreGuardia = '${guardia['perNombres']} ${guardia['perApellidos']}';
    _puestoServicioGuardia = guardia['perPuestoServicio'];
    // print(
    //     '${_idGuardia}-${_cedulaGuardia}-${_nombreGuardia} - ${_puestoServicioGuardia!.length}');
    notifyListeners();
  }

  void getInfoCliente(dynamic cliente) {
    buscaClienteQR(cliente.cliId.toString());
  }

//========================== DROPDOWN MOTIVO AUSENCIA =======================//
  String? _labelMotivoTurnoExtra;

  String? get labelMotivoTurnoExtra => _labelMotivoTurnoExtra;

  void setLabelMotivoTurnoExtra(String value) {
    _labelMotivoTurnoExtra = value;

    notifyListeners();
  }

  //========================== VALIDA CAMPO  FECHA INICIO   =======================//
  String? _inputFechaInicio;
  get getInputfechaInicio => _inputFechaInicio;
  void onInputFechaInicioChange(String? date) {
    _inputFechaInicio = date;

    notifyListeners();
  }

  String? _inputHoraInicio;
  get getInputHoraInicio => _inputHoraInicio;
  void onInputHoraInicioChange(String? date) {
    _inputHoraInicio = date;

    notifyListeners();
  }

  //========================== VALIDA CAMPO  FECHA FIN   =======================//
  String? _inputFechaFin;
  get getInputfechaFin => _inputFechaFin;
  void onInputFechaFinChange(String? date) {
    _inputFechaFin = date;
    // print('FECHA FIN :$_inputFechaFin');

    notifyListeners();
  }

  String? _inputHoraFin;
  get getInputHoraFin => _inputHoraFin;
  void onInputHoraFinChange(String? date) {
    _inputHoraFin = date;

    notifyListeners();
  }

//==================== LISTO TODOS  LOS TURNOS====================//
  List _listaTurnoExtra = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaTurnoExtra => _listaTurnoExtra;

  void setInfoBusquedaTurnoExtra(List data) {
    _listaTurnoExtra = data;
    notifyListeners();
  }

  bool? _errorTurnoExtra; // sera nulo la primera vez
  bool? get getErrorTurnoExtra => _errorTurnoExtra;
  set setErrorTurnoExtra(bool? value) {
    _errorTurnoExtra = value;
    notifyListeners();
  }

  Future buscaTurnoExtra(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllTurnosExtras(
      search: _search,
      // estado: 'GUARDIAS',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorTurnoExtra = true;
      setInfoBusquedaTurnoExtra(response['data']);
      // print('object;$_listaTurnoExtra');
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorTurnoExtra = false;
      notifyListeners();
      return null;
    }
  }

  Future crearTurnoExtra(BuildContext context) async {
    // final serviceSocket = SocketService();
    final serviceSocket = SocketService();

    // print(
    //     '========================= NUEVO AVISO ================================');
    // print('--idCLIENTE -->:$_idCliente');

    final infoUserLogin = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();
    final turno = jsonDecode(infoUserTurno);

    // print(
    //     '==========================DATOS DEL TELEFONO ===============================');
    // print('rucEmpresa ${infoUserLogin!.rucempresa}');
    // print('rucempresa ${infoUserLogin.rucempresa}');
    // print('user ${turno['user']}');
    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');

    // print(
    //     ' $_idGuardia  $_cedulaGuardia  $_nombreGuardia  $_nombreGuardia  $_puestoServicioGuardia  $_clienteNombre  $_clienteNombre $_inputDetalle  $_inputDetalle ');

    final _pyloadNuevoTurnoExtra = {
      "tabla": "turnoextra", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      "rol": infoUserLogin.rol, //loginlogin
      "turIdPersona": _idGuardia,
      "turDocuPersona": _cedulaGuardia,
      "turNomPersona": _nombreGuardia,
      "turIdCliente": _idCliente,
      "turDocuCliente": _cedulaCliente,
      "turNomCliente": _nombreNuevoCliente,
      "turPuesto": _puestoServicioGuardia,

      "turMotivo":
          _labelNuevoPuesto, // select=> FALTA INJUSTIFICADA, PERMISO MEDICO, PATERNIDAD, EVENTO ESPECIAL
      "turAutorizado": _inputAutorizadoPor, // input
      "turFechaDesde":
          '${_inputFechaInicio}T$_inputHoraInicio', // fecha hora// fecha hora
      "turFechaHasta":
          '${_inputFechaFin}T$_inputHoraFin', // fecha hora fecha hora
      "turDetalle": _inputDetalle, // textarea
      "turUser": turno['user'], // iniciado turno // usuario iniciado turno
      "turEmpresa": infoUserLogin.rucempresa //login
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadNuevoTurnoExtra);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    // serviceSocket.socket!.emit('client:guardarData', _pyloadNuevoTurnoExtra);
  }

//================================== ELIMINAR  MULTA  ==============================//
  Future eliminaTurnoExtra(int? idTurno) async {
    final serviceSocket = SocketService();
    final infoUser = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();
    final turno = jsonDecode(infoUserTurno);

    print('==========================JSON  ===============================');
    final _pyloadEliminaTurnoExtra = {
      "tabla": 'turnoextra',
      "rucempresa": infoUser!.rucempresa,
      "turId": idTurno,
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    // print('$idTurno');
    // print('$_pyloadEliminaTurnoExtra');
    serviceSocket.socket!.emit('client:eliminarData', _pyloadEliminaTurnoExtra);
  }

  int? _idTurno;
  String? _nuevoMotivo;
  void getDataTurnoExtra(dynamic turno) {
    _idTurno = turno['turId'];
    _idGuardia = int.parse(turno['turIdPersona']);
    _cedulaGuardia = turno['turDocuPersona'];
    _nombreGuardia = turno['turNomPersona'];
    // _labelNuevoPuesto = turno['ausMotivo'];
    _nuevoMotivo = turno['turMotivo'];
    _inputAutorizadoPor = turno['turAutorizado'];
    _inputDetalle = turno['turDetalle'];

    List<String>? dataFechaInicio = turno['turFechaDesde']!.split('T');

    _inputFechaInicio = dataFechaInicio![0];
    _inputHoraInicio = dataFechaInicio[1];

    List<String>? dataFechaFin = turno['turFechaHasta']!.split('T');

    _inputFechaFin = dataFechaFin![0];
    _inputHoraFin = dataFechaFin[1];

    _puestoServicioGuardia = turno['turPuesto'];
  }

  Future editarTurnoExtra(BuildContext context) async {
    // final serviceSocket = SocketService();
    final serviceSocket = SocketService();

    final infoUserLogin = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();
    final turno = jsonDecode(infoUserTurno);

    // print(
    //     '==========================DATOS DEL TELEFONO ===============================');
    // print('rucEmpresa ${infoUserLogin!.rucempresa}');
    // print('rucempresa ${infoUserLogin.rucempresa}');
    // print('user ${turno['user']}');
    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');

    // print(
    //     ' $_idGuardia  $_cedulaGuardia  $_nombreGuardia  $_nombreGuardia  $_puestoServicioGuardia  $_clienteNombre  $_clienteNombre $_inputDetalle  $_inputDetalle ');

    final _pyloadEditaTurnoExtra = {
      "tabla": "turnoextra", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      "rol": infoUserLogin.rol, //loginlogin
      "turId": _idTurno,
      "turIdPersona": _idGuardia,
      "turDocuPersona": _cedulaGuardia,
      "turNomPersona": _nombreGuardia,
      "turIdCliente": _idCliente,
      "turDocuCliente": _cedulaCliente,
      "turNomCliente": _nombreNuevoCliente,
      "turPuesto": _puestoServicioGuardia,

      "turMotivo": (_labelMotivoTurnoExtra!.isNotEmpty)
          ? _labelMotivoTurnoExtra
          : _nuevoMotivo, // select=> FALTA INJUSTIFICADA, PERMISO MEDICO, PATERNIDAD, EVENTO ESPECIAL
      "turAutorizado": _inputAutorizadoPor, // input
      "turFechaDesde":
          '${_inputFechaInicio}T$_inputHoraInicio', // fecha hora// fecha hora
      "turFechaHasta":
          '${_inputFechaFin}T$_inputHoraFin', // fecha hora fecha hora
      "turDetalle": _inputDetalle, // textarea
      "turUser": turno['user'], // iniciado turno // usuario iniciado turno
      "turEmpresa": infoUserLogin.rucempresa //login
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadEditaTurnoExtra);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!.emit('client:actualizarData', _pyloadEditaTurnoExtra);
  }

  //===================LEE CODIGO QR GUARDIA==========================//
  String? _infoQRGuardia = '';
  String? get getInfoQRGuardia => _infoQRGuardia;

  void setInfoQRGuardia(String? value) {
    _infoQRGuardia = value;
    // print('info : $_infoQRGuardia');

    final split = _infoQRGuardia!.split('-');
    // _dataQR = {for (int i = 0; i < split.length; i++) i: split[i]};
    //  print('infoNecesaria : ${split[0]}');
    buscaGuardiaQR(split[0]);
    notifyListeners();
  }

//==================== LISTO INFORMACION DEL GUARDIA  QR====================//
  List _listaGuardiaQR = [];
  List get getListaGuardiaQR => _listaGuardiaQR;
  void setInfoBusquedaGuardiaQR(List data) {
    _listaGuardiaQR = data;
    notifyListeners();
  }

  bool? _errorGuardiaQR; // sera nulo la primera vez
  bool? get getErrorGuardiaQR => _errorGuardiaQR;
  set setErrorGuardiaQR(bool? value) {
    _errorGuardiaQR = value;
    notifyListeners();
  }

  Future buscaGuardiaQR(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getGuardiaQR(
      codigoQR: _search,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _idGuardia = response['data'][0]['perId']!;
      _cedulaGuardia = response['data'][0]['perDocNumero'];
      _nombreGuardia =
          '${response['data'][0]['perNombres']} ${response['data'][0]['perApellidos']}';
      _puestoServicioGuardia = response['data'][0]['perPuestoServicio'];

      _errorGuardiaQR = true;

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorGuardiaQR = false;
      notifyListeners();
      return null;
    }
  }

  //===================LEE CODIGO QR CLIENTE==========================//
  String? _infoQRCliente = '';
  String? get getInfoQRCliente => _infoQRCliente;

  void setInfoQRCliente(String? value) {
    _infoQRCliente = value;
    // print('info CLIENTE : $_infoQRCliente');

    final split = _infoQRCliente!.split('-');
    // _dataQR = {for (int i = 0; i < split.length; i++) i: split[i]};
    //  print('infoNecesaria : ${split[0]}');
    buscaClienteQR(split[0]);
    notifyListeners();
  }

//==================== LISTO INFORMACION DEL CLIENTE  QR====================//
  List _listaClienteQR = [];
  List get getListaClienteQR => _listaClienteQR;
  void setInfoBusquedaClienteQR(List data) {
    _listaClienteQR = data;
    notifyListeners();
  }

  bool? _errorClienteQR; // sera nulo la primera vez
  bool? get getErrorClienteQR => _errorClienteQR;
  set setErrorClienteQR(bool? value) {
    _errorClienteQR = value;
    notifyListeners();
  }

  Future buscaClienteQR(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getClienteQR(
      codigoQR: _search,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _idCliente = response['data'][0]['cliId']!;
      _cedulaCliente = response['data'][0]['cliDocNumero'];
      _nombreNuevoCliente = response['data'][0]['cliRazonSocial'];
      _listaPuestosCliente = response['data'][0]['cliDatosOperativos'];

      // print('object @@@@@@@ ${response['data']['cliDatosOperativos']['puesto']} ');
      // print('object @@@@@@@ ${response['data'][0]['cliDatosOperativos']} ');

      // print(
      //     '${_idCliente}-$_cedulaCliente-$_nombreNuevoCliente - ${_listaPuestosCliente.length}');

      _errorClienteQR = true;

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorClienteQR = false;
      notifyListeners();
      return null;
    }
  }
}
