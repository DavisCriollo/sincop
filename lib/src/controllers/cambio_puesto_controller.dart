import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/lista_allClientes.dart';
import 'package:sincop_app/src/service/socket_service.dart';

class CambioDePuestoController extends ChangeNotifier {
  GlobalKey<FormState> cambioPuestoFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();
  void resetValuesCambioPuesto() {
    _idGuardia;
    _cedulaGuardia = '';
    _nombreGuardia = '';
    _nombreNuevoCliente = '';
    _inputDetalle = '';
    _idCliente;
    _cedulaCliente = '';
    _clienteNombre = '';
    _labelIntervaloTurno = null;
    _puestoServicioGuardia = [];

    notifyListeners();
    // _puestoServicioGuardia!.clear();
  }

  bool validateForm() {
    if (cambioPuestoFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

//==================== LISTO TODOS  LOS CAMBIOS DE PUESTO====================//
  List _listaCambioPuesto = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaCambioPuesto => _listaCambioPuesto;

  void setInfoBusquedaCambioPuesto(List data) {
    _listaCambioPuesto = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de guardias SOCKET: ${_listaCambioPuesto}');
    notifyListeners();
  }

  bool? _errorCambioPuesto; // sera nulo la primera vez
  bool? get getErrorCambioPuesto => _errorCambioPuesto;
  set setErrorCambioPuesto(bool? value) {
    _errorCambioPuesto = value;
    notifyListeners();
  }

  Future buscaCambioPuesto(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllCambioPuesto(
      search: _search,
      // estado: 'GUARDIAS',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorCambioPuesto = true;
      setInfoBusquedaCambioPuesto(response['data']);
      // print('object;$_listaCambioPuesto');
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorCambioPuesto = false;
      notifyListeners();
      return null;
    }
  }

//================================== FECHA Y HORA DEL COMUNICADO  ==============================//
  String? _inputFecha;
  get getInputfecha => _inputFecha;
  void onInputFechaChange(String? date) {
    _inputFecha = date;

    notifyListeners();
  }

  String? _inputHora;
  get getInputHora => _inputHora;
  void onInputHoraChange(String? date) {
    _inputHora = date;

    notifyListeners();
  }

  String? _inputDetalle;
  String? get getInputDetalle => _inputDetalle;
  void onDetalleChange(String? text) {
    _inputDetalle = text;
    // print(_inputDetalle);
    notifyListeners();
  }

  Map<String, dynamic>? _nuevoPuesto;
//========================== DROPDOWN PERIODO CONSIGNA CLIENTE =======================//
  String? _labelIntervaloTurno;

  String? get labelIntervaloTurno => _labelIntervaloTurno;

  void setLabelIntervaloTurno(String value) {
    _labelIntervaloTurno = value;
    // print('-----ss:$_labelIntervaloTurno');
    notifyListeners();
  }

//========================== DROPDOWN NUEVO PUESTO=======================//
  String? _labelPuestoNuevo;

  String? get getlabelPuestoNuevo => _labelPuestoNuevo;
  //String? get getTipoDocumento => this._tipoDocumento;

  set setLabelNuevoPuesto(String value) {
    _labelPuestoNuevo = value;
// print('NNUEVO PUESTO: $_labelPuestoNuevo');
    notifyListeners();
  }

//========================== DROPDOWN SELECCIONA PUESTO =======================//
// TOMO TODOS LOS DATOS DEL PUESTO
  String? _ubicacion;
  String? _puesto;
  String? _supervisor;
  String? _guardias;
  String? _horasservicio;
  String? _tipoinstalacion;
  String? _vulnerabilidades;
  List? _consignas;
//=======================//

  void resetDropDown() {
    _labelNuevoPuesto = null;
    _listaPuestoNuevoCliente = [];
  }

  String? _labelNuevoPuesto;

  String? get labelNuevoPuesto => _labelNuevoPuesto;
  dynamic _itemSelect;
  void setLabelINuevoPuesto(String? value) {
    _labelNuevoPuesto = value;

    for (var e in _listaPuestoNuevoCliente) {
      if (e.puesto == labelNuevoPuesto) {
        // print('wwwwww ${e.puesto}');
        _nuevoPuesto = {
          "ubicacion": e.ubicacion,
          "puesto": e.puesto,
          "supervisor": e.supervisor,
          "guardias": e.guardias,
          "horasservicio": e.horasservicio,
          "tipoinstalacion": e.tipoinstalacion,
          "vulnerabilidades": e.vulnerabilidades,
          "consignas": e.consignas,
        };
      }
    }

    // print('-----ss:$_labelNuevoPuesto- $_nuevoPuesto ${_itemSelect.runtimeType}');
    notifyListeners();
  }

//========================== DROPDOWN SELECCIONA PUESTO =======================//
  var _dataItems;

  String? get getDataItems => _dataItems;

  void setDataItem(dynamic value) {
    _dataItems = value;
    // print('-----ss:$_dataItems');
    notifyListeners();
  }

  int? _idGuardia;
  String? _cedulaGuardia;
  String? _nombreGuardia;
  String? get nombreGuardia => _nombreGuardia;
  List? _puestoServicioGuardia;
  List? get puestosServicioGuardia => _puestoServicioGuardia;
  String? _clienteNombre;
  String? get clienteNombre => _clienteNombre;
//==============================================================//

  void getInfoGuardia(dynamic guardia) {
    _idGuardia = guardia['perId'];
    _cedulaGuardia = guardia['perDocNumero'];
    _nombreGuardia = '${guardia['perNombres']} ${guardia['perApellidos']}';
    _puestoServicioGuardia = guardia['perPuestoServicio'];
    // print(
    //     '${_idGuardia}-${_cedulaGuardia}-${_nombreGuardia} - ${_puestoServicioGuardia!.length}');
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

  List _listaPuestoNuevoCliente = [];
  List get getListaPuestosNuevoCliente => _listaPuestoNuevoCliente;
  void setListaPuestoNuevoCliente(List data) {
    _listaPuestoNuevoCliente = data;
    notifyListeners();
  }

  void getInfoCliente(dynamic cliente) {
    // print('CLIENTE SELECCIONADO++++>  $cliente}');
    // print('CLIENTE SELECCIONADO++++>  ${cliente.cliId}');
    // print('CLIENTE SELECCIONADO++++>  ${cliente.cliDocNumero}');
    // print('CLIENTE SELECCIONADO++++>  ${cliente.cliRazonSocial}');
    // print('CLIENTE SELECCIONADO++++>  ${cliente.cliDatosOperativos}');

    _idCliente = cliente.cliId;
    _cedulaCliente = cliente.cliDocNumero;
    _nombreNuevoCliente = cliente.cliRazonSocial;
    _listaPuestoNuevoCliente = cliente.cliDatosOperativos!;

    // print(
    //     '${_idCliente}-${_cedulaCliente}-${_nombreNuevoCliente} - ${_listaPuestoNuevoCliente.length}');
  }

//================================== OBTENEMOS TODOS LOS CLIENTES ==============================//
  List<InfoCliente> _listaTodosLosClientes = [];
  List<InfoCliente> get getListaTodosLosClientes => _listaTodosLosClientes;

  void setListaTodosLosClientes(List<InfoCliente> data) {
    _listaTodosLosClientes = data;
    // print('data clientes : ${_listaTodosLosClientes}');
    notifyListeners();
  }

  bool? _errorClientes; // sera nulo la primera vez
  bool? get getErrorClientes => _errorClientes;

  Future<AllClientes?> getTodosLosClientes(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllClientesMultas(
      // cantidad: 100,
      // page: 0,
      search: search,
      // input: 'cliId',
      // orden: false,
      // datos: '',
      // rucempresa: '${dataUser!.rucempresa}',
      estado: 'CLIENTES',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorClientes = true;
      setListaTodosLosClientes(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorClientes = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaClientes;

  @override
  void dispose() {
    _deboucerSearchBuscaClientes?.cancel();

    // _videoController.dispose();
    super.dispose();
  }

  String? _inputBuscaCliente;
  get getInputBuscaCliente => _inputBuscaCliente;
  void onInputBuscaClienteChange(String? text) {
    _inputBuscaCliente = text;
    // print('GUSCA Cliente MULTA :$_inputBuscaCliente');

//================================================================================//
    if (_inputBuscaCliente!.length >= 3) {
      _deboucerSearchBuscaClientes?.cancel();
      _deboucerSearchBuscaClientes =
          Timer(const Duration(milliseconds: 500), () {
        getTodosLosClientes(_inputBuscaCliente);
        // print('GUSCA Cliente MULTA :ya');
      });
    } else if (_inputBuscaCliente!.isEmpty) {
      getTodosLosClientes('');
    } else {
      getTodosLosClientes('');
    }

    notifyListeners();
//================================================================================//
  }

  Future crearCambioPuesto(BuildContext context) async {
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
    final _pyloadNuevoCambioPuesto = {
      {
        "tabla": "cambiopuesto", // defecto
        "rucempresa": infoUserLogin!.rucempresa, //login
        "rol": infoUserLogin.rol, //login
        "camTipo": "CAMBIO PUESTO",
        "camIdPersona": _idGuardia,
        "camDocuPersona": _cedulaGuardia,
        "camNomPersona": _nombreGuardia,
        "camFecha":_inputFecha, //'${_inputFecha}T$_inputHora',
        "camMotivo": _inputDetalle,
        "camEstado": 'PENDIENTE',
        "camIdCliente": _idCliente,
        "camDocuCliente": _cedulaCliente,
        "camNomCliente": _nombreNuevoCliente,
        "camActualPuesto": _puestoServicioGuardia,
        'camNuevoPuesto': [_nuevoPuesto],
        "camNuevoTurno": _labelIntervaloTurno,
        "camUser": turno['user'], // iniciado turno
        "camEmpresa": infoUserLogin.rucempresa //login
      }
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadNuevoCambioPuesto);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!.emit('client:guardarData', _pyloadNuevoCambioPuesto);
  }

  //================================== ELIMINAR   ==============================//
  Future eliminaCambioPuesto(int? idCambioPuesto) async {
    final serviceSocket = SocketService();
    final infoUser = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();
    final turno = jsonDecode(infoUserTurno);

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadEliminaCambiouesto = {
      {
        "tabla": 'cambiopuesto',
        "rucempresa": infoUser!.rucempresa,
        "camId": idCambioPuesto,
      }
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');

    serviceSocket.socket!
        .emit('client:eliminarData', _pyloadEliminaCambiouesto);
  }

  int? _idCambioPuesto;
  void getDataCambioPuesto(dynamic puesto) {
    _idCambioPuesto = puesto['camId'];
    _idGuardia = int.parse(puesto['camIdPersona']);
    _cedulaGuardia = puesto['camDocuPersona'];
    _nombreGuardia = puesto['camNomPersona'];
    _inputFecha = puesto['camFecha'];
    _labelNuevoPuesto = puesto['camMotivo'];
    _inputDetalle = puesto['camMotivo'];
    _idCliente = int.parse(puesto['camIdCliente']);
    _cedulaCliente = puesto['camDocuCliente'];
    _clienteNombre = puesto['camNomCliente'];
    _labelIntervaloTurno = puesto['camNuevoTurno'];
    _puestoServicioGuardia = puesto['camActualPuesto'];

    for (var e in puesto['camNuevoPuesto']) {
      _nuevoPuesto = {
        "ubicacion": e['ubicacion'],
        "puesto": e['puesto'],
        "supervisor": e['supervisor'],
        "guardias": e['guardias'],
        "horasservicio": e['horasservicio'],
        "tipoinstalacion": e['tipoinstalacion'],
        "vulnerabilidades": e['vulnerabilidades'],
        "consignas": e['consignas']
      };
    }

    // print(
    //   '8888888$_idCambioPuesto $_idGuardia $_cedulaGuardia $_nombreGuardia $_inputFecha $_labelNuevoPuesto $_inputDetalle $_idCliente $_cedulaCliente $_clienteNombre $_labelIntervaloTurno  $_puestoServicioGuardia $_nuevoPuesto');
  }

  Future editarCambioTurno(BuildContext context) async {
    // final serviceSocket = SocketService();
    final serviceSocket = SocketService();

    print(
        '========================= NUEVO AVISO ================================');
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
    final _pyloadEditaCambioPuesto = {
      {
        "tabla": "cambiopuesto", // defecto
        "camId": _idCambioPuesto,
        "rucempresa": infoUserLogin!.rucempresa, //login
        "rol": infoUserLogin.rol, //login
        "camTipo": "CAMBIO PUESTO",
        "camEstado": 'PENDIENTE',
        "camIdPersona": _idGuardia,
        "camDocuPersona": _cedulaGuardia,
        "camNomPersona": _nombreGuardia,
        "camFecha":_inputFecha,// '${_inputFecha}T$_inputHora',
        "camMotivo": _inputDetalle,
        "camIdCliente": _idCliente,
        "camDocuCliente": _cedulaCliente,
        "camNomCliente": _clienteNombre,
        "camActualPuesto": _puestoServicioGuardia,
        'camNuevoPuesto': [_nuevoPuesto],
        "camNuevoTurno": _labelIntervaloTurno,
        "camUser": turno['user'], // iniciado turno
        "camEmpresa": infoUserLogin.rucempresa //login
      }
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadEditaCambioPuesto);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadEditaCambioPuesto);
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
      _listaPuestoNuevoCliente = response['data'][0]['cliDatosOperativos'];

      // print('object @@@@@@@ ${response['data']['cliDatosOperativos']['puesto']} ');
      // print('object @@@@@@@ ${response['data'][0]['cliDatosOperativos']} ');

      // print(
      //     '${_idCliente}-$_cedulaCliente-$_nombreNuevoCliente - ${_listaPuestoNuevoCliente.length}');

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


//========================== DROPDOWN PERIODO  CLIENTE =======================//
  String? _labelNombreEstadoCambioPuesto;

  String? get labelNombreEstadoCambioPuesto => _labelNombreEstadoCambioPuesto;

  void setLabelNombreEstadoCambioPuesto(String value) async{
    _labelNombreEstadoCambioPuesto = value;
    // print('--estado:$_labelNombreEstadoCambioPuesto');
//   if(_labelNombreEstadoCambioPuesto=='RECIBIDO'){
    
//   //    _fechaActual= DateTime.now();
//   //    final DateFormat formatter = DateFormat('yyyy-MM-ddThh:mm');
//   // _fechaActualParse = formatter.format(_fechaActual!);



// // _fechaActualParse='${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm').format(DateTime.now())}';
// // print('_fechaActualParse: $_fechaActualParse');




//   }
    notifyListeners();
  }





}
