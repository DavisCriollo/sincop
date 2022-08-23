import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/auth_response.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/splash_page.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:provider/provider.dart';

class HomeController extends ChangeNotifier {
  final _api = ApiProvider();
  GlobalKey<FormState> homeFormKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Session? _infoUser;
  Session? get infoUser => _infoUser;
  AuthResponse? usuarios;
  bool validateForm() {
    if (homeFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool _inciarTurnoCodigo = false;
  bool get getIniciarTurnoCodigo => _inciarTurnoCodigo;
  void setIniciarTurno(bool value) {
    _inciarTurnoCodigo = value;
    notifyListeners();
  }
  //===================BOTON SEARCH CLIENTE==========================//

  bool _btnSearch = false;
  bool get btnSearch => _btnSearch;

  void setBtnSearch(bool action) {
    _btnSearch = action;
    notifyListeners();
  }
  //===================BOTON SEARCH MORE CLIENTE==========================//

  bool _btnSearchMore = false;
  bool get btnSearchMore => _btnSearchMore;

  void setBtnSearchMore(bool action) {
    _btnSearchMore = action;
    notifyListeners();
  }
  //====== CAMPO BUSQUEDAS COMPRAS =========//
  //  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchCompras;

  SocketService? _serviceSocket;

  @override
  void dispose() {
    _deboucerSearchCompras?.cancel();
    super.dispose();
  }

  Future<void> connectSocket() async {
    if (_serviceSocket != null) {
      return;
    }

    final validaTurno = await Auth.instance.getTurnoSession();

    _validaBtnTurno = validaTurno == 'INICIATURNO';
    _btnIniciaTurno = _validaBtnTurno!;

    _serviceSocket = SocketService();

    _serviceSocket!.socket?.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'registro') {
        // print('====RESPUESTA INICIA TURNO $data');
        await Auth.instance.saveTurnoSession(true);
        _validaBtnTurno = true;
        _btnIniciaTurno = true;

        // NotificatiosnService.showSnackBarSuccsses(data['msg']);
        notifyListeners();
        // Navigator.of(context).pop();
      }
    });
    _serviceSocket!.socket?.on('server:error', (data) {
      NotificatiosnService.showSnackBarError(data['msg']);
    });
    _serviceSocket?.socket?.on('server:actualizadoExitoso', (data) async {
      final tabla = data['tabla'];

      if (tabla == 'notificacionleido') {
        buscaNotificacionesPush('');
      } else if (tabla == 'registro') {
        //========variable inicia turno======//
        await Auth.instance.deleteTurnoSesion();

        _btnIniciaTurno = false;
        setBtnIniciaTurno(false);
        notifyListeners();
      }
    });
    _serviceSocket?.socket?.on('server:nuevanotificacion', (data) async {
      buscaNotificacionesPush('');
    });
  }

  void disconnectSocket() {
    _serviceSocket?.disconnect();
  }

  String _nameSearch = "";
  String get nameSearch => _nameSearch;

  void onSearchText(String data) {
    _nameSearch = data;
    if (_nameSearch.length >= 3) {
      _deboucerSearchCompras?.cancel();
      _deboucerSearchCompras = Timer(const Duration(milliseconds: 700), () {
        // if (_indexTapCompras == 0) {
        //
        //
        //
        //   getTodasLasComprasPendientes('PENDIENTES', _nameSearch);
        // }
        // if (_indexTapCompras == 1) {
        //
        //
        //
        //   getTodasLasComprasProcesadas('PROCESADAS', _nameSearch);
        // }
        // if (_indexTapCompras == 2) {
        //
        //
        //
        //   // getTodasLasComprasAnuladas('ANULADAS', _nameSearch);
        // }
        // switch (_indexTapCompras) {
        //   case 0:
        //     getTodasLasComprasPendientes('PENDIENTES', _nameSearch);
        //     break;
        //   case 1:
        //     getTodasLasComprasPendientes('PROCESADAS', _nameSearch);
        //     break;
        //   case 2:
        //     getTodasLasComprasPendientes('ANULADAS', _nameSearch);
        //     break;
        //   default:
        //     getTodasLasComprasPendientes('PENDIENTES', _nameSearch);
        // }
      });
    } else {
      // getTodasLasComprasProcesadas('PROCESADAS', '');
      // getTodasLasComprasPendientes('PENDIENTES', '');
      // getTodasLasComprasAnuladas('ANULADAS', '');
    }
  }

  //===================LEE CODIGO QR==========================//

  Map<int, String>? _elementoQR = {};
  String? _infoQRTurno = '';
  String? get getInfoQRTurno => _infoQRTurno;

  void setInfoQRTurno(String? value) {
    _infoQRTurno = value;
    // print('info Turno: $_infoQRTurno');

    final split = _infoQRTurno!.split('-');
    _elementoQR = {for (int i = 0; i < split.length; i++) i: split[i]};
//
    notifyListeners();
  }

  //===================SELECCIONAMOS EL LA OBCION DE INICIAR ACTIVIDADES==========================//
  int? opcionActividad;

  int? get getOpcionActividad => opcionActividad;
  void setOpcionActividad(int? value) {
    opcionActividad = value;

    notifyListeners();
  }

  String _textoActividad = '';

  var _itemActividad;
  get getItemActividad => _itemActividad;
  get getTextoActividad => _textoActividad;
  void setItenActividad(value, text) {
    _itemActividad = value;
    _textoActividad = text;

    notifyListeners();
  }

  //===================CODIGO DE ACCESO A NOVEDADES==========================//
  String _textoCodigAccesoTurno = '';
  String? get getCodigoAccesoNovedades => _textoCodigAccesoTurno;
  void onChangeCodigoAccesoTurno(String text) {
    _textoCodigAccesoTurno = text;
    notifyListeners();
  }

  //===================CHECK TERMINOS Y CONDICIONES ==========================//
  bool _terminosCondiciones = false;
  bool get getTerminosCondiciones => _terminosCondiciones;

  void setTerminosCondiciones(bool value) {
    _terminosCondiciones = value;

    notifyListeners();
  }

  //===================VALIDA BOTON TURNO ==========================//
  bool? _finalizaTurno;
  bool? get getFinalizaTurno => _finalizaTurno;

  void setFinalizaTurno(bool? value) {
    _finalizaTurno = value;
    // print('_finalizaTurno:$value');
    notifyListeners();
  }

  bool? _validaBtnTurno;
  bool? get getValidaBtnTurno => _validaBtnTurno;

  void setValidaBtnTurno(bool? value) {
    _validaBtnTurno = value;
    // print('Boton TURNOddd:$value');
    notifyListeners();
  }

  //===================VALIDA BOTON TURNO OK ==========================//
  bool? _btnTurno;
  bool? get getBtnTurno => _btnTurno;

  void setBtnTurno(bool? value) {
    _btnTurno = value;
    // print('Boton TURNO:$value');
    notifyListeners();
  }

  //===================CHECK TERMINOS Y CONDICIONES ==========================//
  String? _codigoQRTurno;
  String? get getCodigoQRTurno => _codigoQRTurno;

  void setCodigoQRTurno(String? value) {
    _codigoQRTurno = value;

    notifyListeners();
  }

  //=================== IDENTIFICA EL DISPOSITIVO ==========================//
  String? _tipoDispositivo = '';
  String? get getTipoDispositivo => _tipoDispositivo;

  void setTipoDispositivo(String? value) {
    _tipoDispositivo = value;

    // print('_tipoDispositivo =====> : $_tipoDispositivo');

    // notifyListeners();
  }

//========================== GEOLOCATOR =======================//
  String? _coordenadas = "";
  Geolocator.Position? _position;
  Geolocator.Position? get position => _position;
  String? _selectCoords = "";
  String? get getCoords => _selectCoords;
  set setCoords(String? value) {
    _selectCoords = value;
    notifyListeners();
  }

  Future<bool?> checkGPSStatus() async {
    final isEnable = await Geolocator.Geolocator.isLocationServiceEnabled();
    Geolocator.Geolocator.getServiceStatusStream().listen((event) {
      final isEnable = (event.index == 1) ? true : false;
    });
    return isEnable;
  }

  Future<void> getCurrentPosition() async {
    // checkGPSStatus();
    late Geolocator.LocationSettings locationSettings;

    locationSettings = const Geolocator.LocationSettings(
      accuracy: Geolocator.LocationAccuracy.high,
      distanceFilter: 100,
    );
    _position =
        await Geolocator.GeolocatorPlatform.instance.getCurrentPosition();
    _position = position;
    _selectCoords = ('${position!.latitude},${position!.longitude}');
    _coordenadas = _selectCoords;

    // print('GPS ACTUAL: ${position!.latitude},${position!.longitude}');
    // print('GPS _selectCoords : ${_selectCoords}');
    notifyListeners();
  }

//================== VALIDA CODIGO QR INICIA TURNO ===========================//
  Future<void> validaCodigoQRTurno(BuildContext context) async {
    // print(
    //     '========================= INICIAR TURNO ================================');
    // print('SCANEO----->:$_infoQRTurno');
    // print('COORDENADAS----->:$_coordenadas');
    // print('========================PAILOAD=================================');
    _infoUser = await Auth.instance.getSession();
    // print('========================PAILOAD=================================');
    final _pyloadDataIniciaTurno = {
      "tabla": "registro", // info Quemada
      "rucempresa": _infoUser!.rucempresa, // dato del login
      "rol": _infoUser!.rol, // dato del login
      "regId": "", // va vacio
      "regCodigo": _elementoQR![0], // leer del qr
      "regRegistro": "QR",
      "regDocumento": "", // va vacio
      "regNombres": "", // va vacio
      "regPuesto": "", // va vacio
      'regTerminosCondiciones': _terminosCondiciones,
      "regCoordenadas": {
        // tomar coordenadas
        "latitud": position!.latitude,
        "longitud": position!.longitude,
      },
      "regDispositivo": _tipoDispositivo, // DISPOSITIVO
      "regEstadoIngreso": "INICIADA", // INICIADA O FINALIZADA
      "regEmpresa": _infoUser!.rucempresa, // dato del login
      "regUser": _infoUser!.usuario, // dato del login
      "regFecReg": "", // va vacio
      "Todos": "" // va vacio
    };

    // print('========================PAILOAD=================================');
    // print('$_pyloadDataIniciaTurno');
    _serviceSocket?.socket!.emit('client:guardarData', _pyloadDataIniciaTurno);
  }

//================== VALIDA CODIGO INICIA TURNO ===========================//
  Future<void> validaCodigoTurno(BuildContext context) async {
    // print(
    // '========================= INICIAR TURNO ================================');
    // print('SCANEO----->:$_infoQRTurno');
    // print('COORDENADAS----->:$_coordenadas');
    // print('========================PAILOAD=================================');
    final infoUser = await Auth.instance.getSession();
    // print('========================PAILOAD=================================');
    final _pyloadDataIniciaTurno = {
      "tabla": "registro", // info Quemada
      "rucempresa": infoUser!.rucempresa, // dato del login
      "rol": infoUser.rol, // dato del login
      "regId": "", // va vacio
      "regCodigo": _textoCodigAccesoTurno, // leer del qr
      "regDocumento": "", // va vacio
      "regNombres": "", // va vacio
      "regPuesto": "", // va vacio
      'regTerminosCondiciones': _terminosCondiciones,
      "regCoordenadas": {
        // tomar coordenadas
        "latitud": position!.latitude,
        "longitud": position!.longitude,
      },
      "regRegistro": "CÓDIGO",
      "regDispositivo": _tipoDispositivo, // tomar coordenadas
      "regEstadoIngreso": "INICIADA", // INICIADA O FINALIZADA
      "regEmpresa": infoUser.rucempresa, // dato del login
      "regUser": infoUser.usuario, // dato del login
      "regFecReg": "", // va vacio
      "Todos": "" // va vacio
    };

    // print('========================PAILOAD=================================');
    // print(' INICIA TURNO    $_pyloadDataIniciaTurno');
    _serviceSocket?.socket?.emit('client:guardarData', _pyloadDataIniciaTurno);
  }

//========================== GUARDA TOKEN DDE LA NOTIFICACION =======================//
  String? _tokennotificacion;

  String? get getTokennotificacion => _tokennotificacion;
  Future? setTokennotificacion(String? id) async {
    _tokennotificacion = id;
    sentToken();
    notifyListeners();
  }

  bool? _errorGuardatoken; // sera nulo la primera vez
  bool? get getErrorGuardatoken => _errorGuardatoken;
  set setErrorGuardatoken(bool? value) {
    _errorGuardatoken = value;
    notifyListeners();
  }

  Future sentToken() async {
    _infoUser = await Auth.instance.getSession();
    // print('object ++++++++++++++>>> :$_tokennotificacion');
    // print('======token===++ > ${infoUser!.token}');

    final response = await _api.sentIdToken(
      tokennotificacion: _tokennotificacion,
      token: infoUser!.token,
    );

    if (response != null) {
      _errorGuardatoken = true;
      // print('=========++ > ${response['msg']}');

      return response;
    }
    if (response == null) {
      _errorGuardatoken = false;
      notifyListeners();
      return null;
    }
  }

//==================== Notifiaciones 1====================//

  int numNotificaciones = 0;
  int get getNumNotificaciones => numNotificaciones;
  void setNumNotificaciones(int data) {
    numNotificaciones = data;
    notifyListeners();
  }

  List _listaNotificacionesPushNoLeidas = [];
  List get getListaNotificacionesPushNoLeidas =>
      _listaNotificacionesPushNoLeidas;
  void setInfoBusquedaNotificacionesPushNoLeidas(List data) {
    _listaNotificacionesPushNoLeidas = data;

    notifyListeners();
  }

  List _listaNotificacionesPush = [];
  List get getListaNotificacionesPush => _listaNotificacionesPush;
  void setInfoBusquedaNotificacionesPush(List data) {
    _listaNotificacionesPush = data;

    notifyListeners();
  }

//============ CONTADOR DE NOTIFICACIONES_2 NO LEIDAS =======//
//============ CONTADOR DE NOTIFICACIONES_2 NO LEIDAS =======//
  void cuentaNotificacionesNOLeidas() {
    // print('no hay nadaaaaaaaaa');
    numNotificaciones = 0;
    _listaNotificacionesPush.forEach(((e) {
      if (e['notVisto'] == 'NO') {
        // print(e['notVisto']);
        numNotificaciones = numNotificaciones + 1;
        notifyListeners();
      }
      notifyListeners();
    }));
    // print('CONTADOR 1: $numNotificaciones');
  }
//===========================================================//

  bool? _errorNotificacionesPush; // sera nulo la primera vez
  bool? get getErrorNotificacionesPush => _errorNotificacionesPush;
  set setErrorNotificacionesPush(bool? value) {
    _errorNotificacionesPush = value;

    notifyListeners();
  }

  Future buscaNotificacionesPush(String? _search) async {
    final dataUser = await Auth.instance.getSession();
    final response = await _api.getAllNotificacionesPush(
      token: '${dataUser!.token}',
    );
    if (response != null) {
      if (response['data'].length > 0) {
        _errorNotificacionesPush = true;
        //  print('RESPONSE NOTIFICACIONES en el controller  ${response['data']}');
        //   print('EL ARRAY ESTA VACIO000.....');
        setInfoBusquedaNotificacionesPush(response['data']['notificacion1']);
        setInfoBusquedaNotificaciones2Push(response['data']['notificacion2']);
        cuentaNotificacionesNOLeidas();
        cuentaNotificaciones2NOLeidas();
        notifyListeners();
        return response;
      }
    }
    if (response == null) {
      _errorNotificacionesPush = false;
      notifyListeners();
      return null;
    }
  }

// //============ CONTADOR DE NOTIFICACIONES_2 NO LEIDAS =======//
//============ CONTADOR DE NOTIFICACIONES_2 NO LEIDAS =======//
  void cuentaNotificaciones2NOLeidas() {
    numNotificaciones2 = 0;
    _listaNotificaciones2Push.forEach(((e) {
      if (e['notVisto'] == 'NO') {
        // print(e['notVisto']);
        numNotificaciones2 = numNotificaciones2 + 1;
      }
      notifyListeners();
    }));
    // print('CONTADOR 2: $numNotificaciones2');
  }

//===========================================================//
// //=========================NOTIFICACION 2==================================//
  int numNotificaciones2 = 0;
  int get getNumNotificaciones2 => numNotificaciones2;
  void setNumNotificaciones2(int data) {
    numNotificaciones2 = data;
    notifyListeners();
  }

  List _listaNotificaciones2PushNoLeidas = [];
  List get getListaNotificaciones2PushNoLeidas =>
      _listaNotificaciones2PushNoLeidas;
  void setInfoBusquedaNotificaciones2PushNoLeidas(List data) {
    _listaNotificaciones2PushNoLeidas = data;
    //  print('NOTIFICACIONES 2:${_listaNotificaciones2PushNoLeidas.length}');
    notifyListeners();
  }

  List _listaNotificaciones2Push = [];
  List get getListaNotificaciones2Push => _listaNotificaciones2Push;
  void setInfoBusquedaNotificaciones2Push(List data) {
    _listaNotificaciones2Push = data;
    // print('NOTIFICACIONES 2:${_listaNotificaciones2Push.length}');
    notifyListeners();
  }

  bool? _errorNotificaciones2Push; // sera nulo la primera vez
  bool? get getErrorNotificaciones2Push => _errorNotificaciones2Push;
  set setErrorNotificaciones2Push(bool? value) {
    _errorNotificaciones2Push = value;

    notifyListeners();
  }

  Future buscaNotificaciones2Push(String? _search) async {
    final dataUser = await Auth.instance.getSession();
    final response = await _api.getAllNotificaciones2Push(
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorNotificaciones2Push = true;

      // setInfoBusquedaNotificaciones2Push(response);
      // cuentaNotificaciones2NOLeidas();

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorNotificaciones2Push = false;
      notifyListeners();
      return null;
    }
  }

  //====================== LEER LA NOTIFICACION_1
  Future leerNotificacionPush(dynamic notificacion) async {
    final infoUserLogin = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();

    final _pyloadNotificacionPushLeida = {
      "tabla": "notificacionleido", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      "rol": infoUserLogin.rol, //login
      "notId": notificacion['notId'],
      "notTipo": notificacion['notTipo'],
      "notVisto": notificacion['notVisto'],
      "notIdPersona": notificacion['notIdPersona'],
      "notDocuPersona": notificacion['notDocuPersona'],
      "notNombrePersona": notificacion['notNombrePersona'],
      "notFoto": notificacion['notFoto'],
      "notRol": notificacion['notRol'],
      "notTitulo": notificacion['notTitulo'],
      "notContenido": notificacion['notContenido'],
      "notUser": notificacion['notUser'],
      "notNotificacionPertenece": notificacion['notNotificacionPertenece'],
      "notEmpresa": notificacion['notEmpresa'],

      "notInformacion": notificacion['notTipo'] == 'ACTIVIDAD'
          ? {
              "conAsunto": notificacion['notInformacion']['conAsunto'],
              "actDesde": notificacion['notInformacion']['actDesde'],
              "actHasta": notificacion['notInformacion']['actHasta'],
              "actFrecuencia": notificacion['notInformacion']['actFrecuencia'],
              "actPrioridad": notificacion['notInformacion']['actPrioridad'],
              "actDiasRepetir": notificacion['notInformacion']['actDiasRepetir']
            }
          : {
              "conAsunto": notificacion['notInformacion']['conAsunto'],
              "conDesde": notificacion['notInformacion']['conDesde'],
              "conHasta": notificacion['notInformacion']['conHasta'],
              "conFrecuencia": notificacion['notInformacion']['conFrecuencia'],
              "conPrioridad": notificacion['notInformacion']['conPrioridad'],
              "conDiasRepetir": notificacion['notInformacion']['conDiasRepetir']
            },
      "notFecReg": notificacion['notFecReg']
    };
    // print(
    // '==========================JSON PARA LEER LA NOTIFICACION ===============================');
    // print(_pyloadNotificacionPushLeida);
    // print(
    // '==========================JSON DE PERSONAL DEIGNADO ===============================');
    _serviceSocket?.socket?.emit(
      'client:actualizarData',
      _pyloadNotificacionPushLeida,
    );
  }

  //====================== LEER LA NOTIFICACION_2
  Future leerNotificacion2Push(dynamic notificacion) async {
    // final serviceSocket = SocketService();
    List documentosexpirados = [];
    final serviceSocket = SocketService();
    final infoUserLogin = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();

    final _pyloadNotificacion2PushLeida = {
      "tabla": "notificacionleido", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      "rol": infoUserLogin.rol, //login
      "notId": notificacion['notId'],
      "notTipo": notificacion['notTipo'],
      "notVisto": notificacion['notVisto'],
      "notIdPersona": notificacion['notIdPersona'],
      "notDocuPersona": notificacion['notDocuPersona'],
      "notNombrePersona": notificacion['notNombrePersona'],
      "notFoto": notificacion['notFoto'],
      "notRol": notificacion['notRol'],
      "notTitulo": notificacion['notTitulo'],
      "notContenido": notificacion['notContenido'],
      "notUser": notificacion['notUser'],
      "notNotificacionPertenece": notificacion['notNotificacionPertenece'],
      "notEmpresa": notificacion['notEmpresa'],
      "notInformacion": {
        "documentosexpirados": [
          {
            "namearchivo": "certificadoafisexpira",
            "fecha": "2022-03-23",
            "url":
                "https://backsigeop.neitor.com/PAZVISEG/documentos/17d72c93-586d-4986-b317-0140560dc3df.pdf"
          },
          {
            "namearchivo": "antecedentepenalesexpira",
            "fecha": "2022-03-23",
            "url":
                "https://backsigeop.neitor.com/PAZVISEG/documentos/2a80ac7e-00fc-48d4-ad92-14b5c12b1180.pdf"
          },
          {
            "namearchivo": "certificadomedicoexpira",
            "fecha": "2022-03-23",
            "url":
                "https://backsigeop.neitor.com/PAZVISEG/documentos/c9adeb69-41db-4023-bebf-bb8f83f9b56e.pdf"
          }
        ]
      },

      "notFecReg": notificacion['notFecReg']
    };
    // print(
    // '==========================JSON PARA LEER LA NOTIFICACION ===============================');
    // print(_pyloadNotificacion2PushLeida);
    // print(
    // '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadNotificacion2PushLeida);
  }

  // '========================== LEER LA NOTIFICACION GENERICA ===============================');

  //====================== LEER LA NOTIFICACION_2
  Future leerNotificacionPushGeneric(dynamic notificacion) async {
    final infoUserLogin = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();

// print('GENERIC NOTIFICACION: $notificacion');

    if (notificacion['notTipo'] == 'MULTA') {
      print('LA NOTIFICACION ES DE: ${notificacion['notTipo']}');
    }

    final _payloadNotificacionGeneric = {
      {
        "tabla": "notificacionleido",
        "notId": notificacion['notId'],
        "notTipo": notificacion['notTipo'],
        "rucempresa": infoUserLogin!.rucempresa,
        "rol": infoUserLogin.rol,
        "notVisto": notificacion['notVisto'],
        "notIdPersona": notificacion['notIdPersona'],
        "notDocuPersona": notificacion['notDocuPersona'],
        "notNombrePersona": notificacion['notNombrePersona'],
        "notFoto": notificacion['notFoto'],
        "notRol": notificacion['notRol'],
        "notTitulo": notificacion['notTitulo'],
        "notContenido": notificacion['notContenido'],
        "notUser": notificacion['notUser'],
        "notNotificacionPertenece": notificacion['notNotificacionPertenece'],
        "notEmpresa": notificacion['notEmpresa'],
        "notInformacion": notificacion['notInformacion'],
        //  {
        // 	"idregistro": "44",
        // 	"urlweb": "/Seguridad/RRHH/Nomina/Multas?idRegistro=44&notificacion=true",
        // 	"datos": {
        // 		"nomNombrePer": "CRIOLLO PARRALES EDWIN DAVID",
        // 		"nomDocuPer": "1719972687",
        // 		"nomDetalle": "ATRASOS",
        // 		"nomObservacion": "Multa asignado por atraso",
        // 		"nomSueldo": "1200.00",
        // 		"nomPorcentaje": 10,
        // 		"nomDescuento": "120.00",
        // 		"nomUser": "talentohumano"
        // 	}
        // },
        "notFecReg": notificacion['notFecReg']
      }
    };
    // print(
    //   '==========================JSON PARA LEER LA NOTIFICACION ===============================');
    //   print(_payloadNotificacionGeneric);

    // "rucempresa": infoUserLogin!.rucempresa, //login
    //   "rol": infoUserLogin.rol, //login
    //   "notId": notificacion['notId'],
    //   "notTipo": notificacion['notTipo'],
    //   "notVisto": notificacion['notVisto'],
    //   "notIdPersona": notificacion['notIdPersona'],
    //   "notDocuPersona": notificacion['notDocuPersona'],
    //   "notNombrePersona": notificacion['notNombrePersona'],
    //   "notFoto": notificacion['notFoto'],
    //   "notRol": notificacion['notRol'],
    //   "notTitulo": notificacion['notTitulo'],
    //   "notContenido": notificacion['notContenido'],
    //   "notUser": notificacion['notUser'],
    //   "notNotificacionPertenece": notificacion['notNotificacionPertenece'],
    //   "notEmpresa": notificacion['notEmpresa'],

    _serviceSocket?.socket?.emit(
      'client:actualizarData',
      _payloadNotificacionGeneric,
    );
  }

  void enviaAlerta(
    String? usuario,
    List<String?>? rol,
    String? rucempresa,
    String? coordenadas,
  ) {
    //  print('usuario: $usuario');
    //  print('rol: $rol');
    //  print('rucempresa: $rucempresa');
    //  print('coordenadas: $coordenadas');

    final List<String> latlong = coordenadas!.split(",");
// print(coordenadas);
//     print(latlong[0]);
//     print(latlong[1]);

//     print('latlong: ${latlong[0]}');
//     print('latlong: ${latlong[1]}');

    final _pyloadEnviaAlerta = {
      "usuario": usuario,
      "rol": rol,
      "rucempresa": rucempresa,
      "coordenadas": {"longitud": latlong[0], "latitud": latlong[1]}
    };

    // print(
    //     '==========================JSON PARA GENERAR ALARMA ===============================');
    // print(_pyloadEnviaAlerta);
    _serviceSocket?.socket?.emit(
      'client:alerta',
      _pyloadEnviaAlerta,
    );

// socket.emit('client:alerta', {
//       usuario: '1311060378',
//       rol: ['SUPERVISOR'],
//       rucempresa: 'PAZVISEG',
//       coordenadas: { longitud: -79.1805952, latitud: -0.2555904 }
//    });
  }

  RemoteMessage? payloadAlerta;

  RemoteMessage? get getPayloadAlerta => payloadAlerta;
  void setPayloadAlerta(RemoteMessage? paylad) {
    payloadAlerta = paylad;
    // print('RECIBO EL PAYLOADSDSDSD: ${payloadAlerta!.notification!.title}');
    notifyListeners();
  }

//========================== ELIMINA TOKEN DE LA NOTIFICACION =======================//
  String? _tokennotificacionDelete;

  String? get getTokennotificacionDelete => _tokennotificacionDelete;
  Future? setTokennotificacionDelete(String? id) {
    _tokennotificacionDelete = id;
    // print('======TOKENS ===++ > ${_tokennotificacionDelete}');
    sentToken();
    notifyListeners();
  }

  bool? _errorGuardatokenDelete; // sera nulo la primera vez
  bool? get getErrorGuardatokenDelete => _errorGuardatokenDelete;
  set setErrorGuardatokenDelete(bool? value) {
    _errorGuardatokenDelete = value;
    notifyListeners();
  }

  Future sentTokenDelete() async {
    final dataUser = await Auth.instance.getSession();
    //  print( 'token Usuario${dataUser!.token}');
    final String? firebase = await Auth.instance.getTokenFireBase();
    //  print('TOKIKTO delete=======> $firebase');
    final response = await _api.deleteTokenFirebase(
      tokennotificacion: firebase,
      token: dataUser!.token,
    );

    if (response != null) {
      _errorGuardatokenDelete = true;
      // print('=========++ > ${response['msg']}');

      return response;
    }
    if (response == null) {
      _errorGuardatokenDelete = false;
      notifyListeners();
      return null;
    }
  }

// ============== ACTIVAMOS EL BOTON DE INICIAR TURNO ================//

  bool _btnIniciaTurno = false;
  bool get getBtnIniciaTurno => _btnIniciaTurno;

  void setBtnIniciaTurno(bool value) async {
    if (!value) {
      await Auth.instance.deleteTurnoSesion();
    }
    _btnIniciaTurno = value;
    notifyListeners();
  }

//==================FINALIZA TURNO ===========================//
  Future<void> finalizarTurno(BuildContext context) async {
    // final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();
    final idRegistro = await Auth.instance.getIdRegistro();

    final _pyloadDataFinaizaTurno = {
      "tabla": "registro", // info Quemada
      "rucempresa": infoUser!.rucempresa, // dato del login

      "regId": idRegistro, // va vacio
    };

    _serviceSocket?.socket?.emit(
      'client:actualizarData',
      _pyloadDataFinaizaTurno,
    );
  }
}
