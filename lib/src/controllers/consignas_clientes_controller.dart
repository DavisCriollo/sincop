// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as _http;
import 'package:provider/provider.dart';
// import 'package:sincop_app/src/api/api_provider.dart';

import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/crea_foto_consigna_cliente.dart';
import 'package:sincop_app/src/models/crea_foto_realiza_consigna_guardia.dart';
import 'package:sincop_app/src/models/foto_url.dart';
import 'package:sincop_app/src/models/get_info_guardia_multa.dart';
import 'package:sincop_app/src/models/lista_allConsignas_clientes.dart';
import 'package:sincop_app/src/service/notifications_service.dart' as snaks;

import 'package:sincop_app/src/service/socket_service.dart';

import '../api/api_provider.dart';

class ConsignasClientesController extends ChangeNotifier {
  GlobalKey<FormState> consignasClienteFormKey = GlobalKey<FormState>();

  ConsignasClientesController() {
    getTodasLasConsignasClientes('');
    // getTodoPersonalDesignadoAlClientes();
    _listaFotos.clear;
    // _diaValueLunes = false;

    // print('se EJECUTO');
  }

  resetValues() async {
    // loadData
    // _listaDias = [];
    // setDiaLunes('');
    _diaValueLunes = false;
    _diaValueMartes = false;
    _diaValueMiercoles = false;
    _diaValueJueves = false;
    _diaValueViernes = false;
    _diaValueSabado = false;
    _diaValueDomingo = false;

    _diaSemanas!.clear();
    _listaFotosUrl.clear();
    _listaFotos.clear();
    // _listaGuardia.clear();
    _listaGuardiaInforme.clear();
    // notifyListeners();
  }

  final _api = ApiProvider();
  bool validateForm() {
    if (consignasClienteFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool _estadoConsigna = false;
  int? _itemConsigna = 0;
  get getItemConsigna => _itemConsigna;

  bool get getEstadoConsigna => _estadoConsigna;
  void setEstadoConsigna(bool value, int item) {
    _estadoConsigna = value;
    _itemConsigna = item;

    notifyListeners();
  }

  String? _asunto;
  void onChangeAsunto(String? text) {
    _asunto = text;
  }

  String? _detalle;
  void onChangeDetalle(String? text) {
    _detalle = text;
  }

  //========================== VALIDA CAMPO  FECHA INICIO CONSIGNA =======================//
  String? _inputFechaInicioConsigna;
  get getInputfechaInicioConsigna => _inputFechaInicioConsigna;
  void onInputFechaInicioConsignaChange(String? date) {
    _inputFechaInicioConsigna = date;

    notifyListeners();
  }

  String? _inputHoraInicioConsigna;
  get getInputHoraInicioConsigna => _inputHoraInicioConsigna;
  void onInputHoraInicioConsignaChange(String? date) {
    _inputHoraInicioConsigna = date;

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

  // Timer? _deboucerSearchCompras;

  // @override
  // void dispose() {
  //   _deboucerSearchCompras?.cancel();

  //   super.dispose();
  // }

  // String _nameSearch = "";
  // String get nameSearch => _nameSearch;

  // void onSearchText(String data) {
  //   _nameSearch = data;
  //   if (_nameSearch.length >= 3) {
  //     _deboucerSearchCompras?.cancel();
  //     _deboucerSearchCompras = Timer(const Duration(milliseconds: 700), () {});
  //   } else {}
  // }

  //========================== VALIDA CAMPO  FECHA FIN CONSIGNA =======================//
  String? _inputFechaFinConsigna;
  get getInputfechaFinConsigna => _inputFechaFinConsigna;
  void onInputFechaFinConsignaChange(String? date) {
    _inputFechaFinConsigna = date;
    // print('FECHA FIN :$_inputFechaFinConsigna');

    notifyListeners();
  }

  String? _inputHoraFinConsigna;
  get getInputHoraFinConsigna => _inputHoraFinConsigna;
  void onInputHoraFinConsignaChange(String? date) {
    _inputHoraFinConsigna = date;
    // print('Hora Fin:$_inputHoraFinConsigna');

    notifyListeners();
  }

//========================== DROPDOWN PERIODO CONSIGNA CLIENTE =======================//
  String? _labelConsignaCliente = '1';

  String? get labelConsignaCliente => _labelConsignaCliente;
  //String? get getTipoDocumento => this._tipoDocumento;

  set setLabelConsignaCliente(String value) {
    _labelConsignaCliente = value;

    notifyListeners();
  }

  //========================== VALIDA PRIORIDAD ALTA MEDIA BAJA CLIENTE =======================//
  var _prioridadCliente = 'BAJA';
  var _prioridadValueCliente = 3;
  get getprioridadValueCliente => _prioridadValueCliente;
  get getPrioridadCliente => _prioridadCliente;
  void onPrioridadClienteChange(text) {
    _prioridadValueCliente = text;
    _prioridadCliente = (text == 1)
        ? 'ALTA'
        : (text == 2)
            ? 'MEDIA'
            : 'BAJA';

    notifyListeners();
  }

  //========================== VALIDA REPETIR =======================//

  bool _diaValueLunes = false;
  bool _diaValueMartes = false;
  bool _diaValueMiercoles = false;
  bool _diaValueJueves = false;
  bool _diaValueViernes = false;
  bool _diaValueSabado = false;
  bool _diaValueDomingo = false;
  bool get getDiaLunes => _diaValueLunes;
  bool get getDiaMartes => _diaValueMartes;
  bool get getDiaMiercoles => _diaValueMiercoles;
  bool get getDiaJueves => _diaValueJueves;
  bool get getDiaViernes => _diaValueViernes;
  bool get getDiaSabado => _diaValueSabado;
  bool get getDiaDomingo => _diaValueDomingo;

//   String? _diaDeLaSemana;
//   String? get getDiaDeLaSemana => _diaDeLaSemana;

//   void setDiaDeLaSemana(bool? estado) {
//     // _diaValueLunes = estado!;
//     // if (estado == false) {
//     //   _listaDias.removeWhere((e) => (e == dia));
//     // } else {
//     //   _listaDias.add(dia);
//     // }

//     // for (var e in _listaDias) {
//     //   print('$e');
//     // }
// // _diaDeLaSemana=dia;
//     notifyListeners();
//   }

  // void deleteItemlDia(String? item) {
  //   print('==========================  LISTA ITEM BORRADO ==================');
  //   _listaDias.removeWhere((e) => (e == item));
  //   for (var e in _listaDias) {
  //     print('${e}');
  //   }
  //   notifyListeners();
  // }

  // List<String?> _listaDias = [];
  // List<String?> get getListaDias => _listaDias;

  // void setListaDias(List<String?> dia) {
  //   _listaDias = dia;
  //   notifyListeners();
  //   for (var e in _listaDias) {
  //     print('${e}');
  //   }
  // }

  // void setDiaLunes(bool value) {

  //   _diaValueLunes = value;

  //   setDiaDeLaSemana(value);
  //   notifyListeners();
  // }

//================================== OBTENEMOS TODAS LAS CONSIGNAS  ==============================//
  List<Result> _listaTodasLasConsignasCliente = [];
  List<Result> get getListaTodasLasConsignasCliente =>
      _listaTodasLasConsignasCliente;

  void setListaTodasLasConsignasCliente(List<Result> data) {
    _listaTodasLasConsignasCliente = data;
    notifyListeners();
  }

  bool? _errorAllConsignas; // sera nulo la primera vez
  bool? get getErrorAllConsignas => _errorAllConsignas;

  Future getTodasLasConsignasClientes(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllConsignasClientes(
      cantidad: 100,
      page: 0,
      search: search,
      input: 'conId',
      orden: false,
      datos: '',
      rucempresa: '${dataUser!.rucempresa}',
      token: '${dataUser.token}',
    );

    if (response != null) {
      _errorAllConsignas = true;
      setListaTodasLasConsignasCliente(response.data.results);
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorAllConsignas = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//========================================================= SELECCIONA CHECKBOX ==============================//

  // bool? _selectItemChecbox = false; // sera nulo la primera vez
  // bool? get getSelectItemChecbox => _selectItemChecbox;
  // List _listaGuardia = [];
  // List get getListaGuardia => _listaGuardia;
  // void setSelectItemChecbox(value, persona) {
  //   _selectItemChecbox = value;
  //   if (value == true) {
  //     _listaGuardia.removeWhere((e) => (e['id'] == persona.perId));

  //     _listaGuardia.addAll([
  //       {
  //         "docnumero":
  //             persona.perDocNumero, // al consumir el endpoint => perDocNumero
  //         "nombres": persona.perNombres + ' ' + persona.perApellidos,
  //         // al consumir el endpoint => perNombres perApellidos
  //         "asignado": persona.asignado, // si esta marcado el check
  //         "id": persona.perId, // al consumir el endpoint => perId
  //         "foto": persona.perFoto,
  //         "trabajos": []
  //       }
  //     ]);
  //   } else {
  //     _listaGuardia.removeWhere((e) => (e['id'] == persona.perId));

  //     print('==========================  LISTA DELETE ==================');

  //     for (var e in _listaGuardia) {
  //       // print('LIESTA TEMPORAL: ${e.perId} - ${e.perNombres}');
  //       print('LIESTA TEMPORAL: ${_listaGuardia}');
  //     }
  //   }

  //   notifyListeners();
  // }

//================================== OBTENEMOS TOTO EL PERSONAL DESIGNADO AL CLIENTE  ==============================//

  // List<InfoPersona> _listaPersonalDesignadoCliente = [];
  // List<InfoPersona> get getListaListaPersonalDesignadoCliente =>
  //     _listaPersonalDesignadoCliente;
  // // List<CheckItemPersonal?> _listaPersonalDesignadoClienteTemp = [];
  // List<InfoPersona> _listaPersonalDesignadoClienteTemp = [];
  // List _listaEstadoPersonalDesignadoCliente = [];
  // List get getlistaEstadoPersonalDesignadoCliente =>
  //     _listaEstadoPersonalDesignadoCliente;
  // List get getllistaPersonalDesignadoClienteTemp =>
  //     _listaPersonalDesignadoClienteTemp;
  // void setListaListaPersonalDesignadoCliente(List<InfoPersona> data) {
  //   _listaPersonalDesignadoCliente = data;
  //   // print('data : ${_listaPersonalDesignadoCliente.length}');
  //   notifyListeners();
  // }

  // void setListaPersonalDesignadoClienteTemp(List<InfoPersona> data) {
  //   _listaPersonalDesignadoClienteTemp = data;
  //   print('data Temp: ${_listaPersonalDesignadoClienteTemp}');
  //   notifyListeners();
  // }

  List<Guardia> _listaInfoGuardiaConsigna = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List<Guardia> get getListaInfoGuardiaConsigna => _listaInfoGuardiaConsigna;

  void setInfoBusquedaGuardiaConsigna(List<Guardia> data) {
    _listaInfoGuardiaConsigna = data;
    // print('Lista dde guardias : ${_listaInfoGuardiaConsigna}');
    notifyListeners();
  }

  bool? _errorLoadPersonal; // sera nulo la primera vez
  bool? get getErrorLoadPersonal => _errorLoadPersonal;

  // Future<AllPersonasDesignadas?> getTodoPersonalDesignadoAlClientes() async {
  //   final dataUser = await Auth.instance.getSession();

  //   final response = await _api.getAllPersonalDesignado(
  //     docnumero: '${dataUser!.usuario}',
  //     token: '${dataUser.token}',
  //   );
  //   //  print('-ALL CONSIGNAS->${response?.data}');

  //   if (response != null) {
  //     _errorLoadPersonal = true;
  //     setListaListaPersonalDesignadoCliente(response.data);

  //     _listaEstadoPersonalDesignadoCliente = List.generate(
  //         _listaPersonalDesignadoCliente.length, (index) => false);

  //     notifyListeners();
  //     return response;
  //   }
  //   if (response == null) {
  //     _errorLoadPersonal = false;
  //     notifyListeners();
  //     return null;
  //   }
  //   return null;
  // }

  // List<dynamic> _listaGuardiasInforme = [];
  // List<dynamic> get getListaGuardiasConsignas => _listaGuardiasInforme;

  // void setListaGuardiasConsigna(
  //     int? id, String? documento, String? nombres, List<String>? correo) {
  //   // _listaGuardiasInforme!.addAll([correo!.toString()]);
  //   // _listaGuardiasInforme!.addAll([correo!.toString()]);

  //   _listaGuardiasInforme.addAll([
  //     {
  //       "id": id!.toInt(),
  //       "docnumero": documento,
  //       "nombres": nombres,
  //       "compartido": true,
  //       "email": correo,
  //     }
  //   ]);
  //   // print('CORREO:$_listaGuardiasInforme ');

  //   notifyListeners();
  // }
  List<dynamic> _listaGuardiaInforme = [];
  List<dynamic> get getListaGuardiasConsigna => _listaGuardiaInforme;
  void setGuardiaConsigna(Guardia guardia) {
    // for (var e in _listaGuardiaInforme) {
    //   if (e.perId == guardia.perId) {
    _listaGuardiaInforme.removeWhere((e) => (e['id'] == guardia.perId));
    _listaGuardiaInforme.add({
      "docnumero":
          guardia.perDocNumero, // al consumir el endpoint => perDocNumero
      "nombres": '${guardia.perNombres} ${guardia.perApellidos}',
      // al consumir el endpoint => perNombres perApellidos
      "asignado": true, // si esta marcado el check
      "id": guardia.perId, // al consumir el endpoint => perId
      "foto": guardia.perFoto,
    });
    notifyListeners();
  }

  void eliminaGuardiaConsigna(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    print(id);
    // _listaGuardiasInforme.removeWhere((element) => element.id == id);
    _listaGuardiaInforme.removeWhere((e) => (e['id'] == id));
    // _listaGuardiasInforme.removeWhere((e) => e['id'] == id);
    _listaGuardiaInforme.forEach(((element) {
      // print('${element['nombres']}');
    }));

    notifyListeners();
    // print('------LISTA ---.${_listaGuardiasInforme.length}');
  }


//REVISAR 

String? _textDocNumDirigidoA='';

  Future<AllGuardias?> buscaGuardiasConsigna(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllInfoGuardias(
      search: _search,
      // estado: 'GUARDIAS',
      docnumero: _textDocNumDirigidoA,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorLoadPersonal = true;
      // setInfoBusquedaGuardiaInforme(response.data);
      // setIdPersonaMulta = response.data[0].perId;
      // setCedPersonaMulta = response.data[0].perDocNumero;
      // print('${response.data[0].perNombres} ${response.data[0].perApellidos}');
      //  _listaInfoGuardiaConsigna=response.data;
      setInfoBusquedaGuardiaConsigna(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorLoadPersonal = false;
      notifyListeners();
      return null;
    }
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  Future creaConsignaCliente(
    BuildContext context,
  ) async {
      final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadNuevaConsigna = {
      "tabla": "consigna", // defecto
      "rucempresa": infoUser!.rucempresa, //login
      "rol": infoUser.rol, //login
      "conIdCliente": infoUser.id, // login => id
      "conNombreCliente": infoUser.nombre, // login => nombre
      "conAsunto": _asunto,
      "conDetalle": _detalle,
      "conDesde": '$_inputFechaInicioConsigna $_inputHoraInicioConsigna',
      "conHasta": ' $_inputFechaFinConsigna $_inputHoraFinConsigna',
      "conFrecuencia": _labelConsignaCliente,
      "conPrioridad": _prioridadCliente,
      "conEstado": "ACTIVA", // con valor ACTIVA porque es un registro nuevo
      "conProgreso": "NO REALIZADO", // con valor 0 porque es un registro nuevo
      "conDiasRepetir": _diaSemanas,
      "conAsignacion": _listaGuardiaInforme,
      "conFotosCliente": _listaFotosUrl,
      "conLeidos": [],
      "conUser": infoUser.usuario, //login
      "conEmpresa": infoUser.rucempresa, //login
    };

    serviceSocket.socket!.emit('client:guardarData', _pyloadNuevaConsigna);
    serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'consigna') {
        getTodasLasConsignasClientes('');
        snaks.NotificatiosnService.showSnackBarSuccsses(data['msg']);
        serviceSocket.socket?.clearListeners();
        notifyListeners();
      }
    });
    serviceSocket.socket?.on('server:error', (data) {
      snaks.NotificatiosnService.showSnackBarError(data['msg']);
      notifyListeners();
    });
  }

  //================================== ELIMINAR  COMUNICADO  ==============================//
  Future consignaLeidaGuardia(int? _idConsigna,BuildContext context) async {
      final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadConsignaLeidaGuardia = {
      "tabla": "consignaleido", // defecto
      "rucempresa": infoUser!.rucempresa, // login
      "rol": infoUser.rol, // login
      "comId": _idConsigna, // id del registro
      "comIdPersona": infoUser.id, // login
      "comNombrePersona": infoUser.nombre, //login nombre
      "comUser": infoUser.rucempresa // login
    };
    // print(
    //     '================================== EJECUTA COMUNICADO LEIDO   ==============================');
    // print(_pyloadConsignaLeidaGuardia);

    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadConsignaLeidaGuardia);
    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'comunicadoleido') {
        // print('PAYLOAD RESPONSE: $data');
        getTodasLasConsignasClientes('');
        // NotificatiosnService.showSnackBarSuccsses(data['msg']);
        serviceSocket.socket?.clearListeners();
        notifyListeners();
      }
    });
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  int id = 0;
  File? _newPictureFile;
  File? get getNewPictureFile => _newPictureFile;
  final List _listaFotosUrl = [];

  List<CreaNuevaFotoConsignaCliente?> _listaFotos = [];
  List<CreaNuevaFotoConsignaCliente?> get getListaFotos => _listaFotos;
  void setNewPictureFile(String? path) {
    _newPictureFile = File?.fromUri(Uri(path: path));
    upLoadImagen(_newPictureFile);
    _listaFotos.add(CreaNuevaFotoConsignaCliente(id, _newPictureFile!.path));
    id = id + 1;
    notifyListeners();
  }

  void setEditarFoto(int id, String path) {
    _listaFotos.add(CreaNuevaFotoConsignaCliente(id, path));

    notifyListeners();
  }

  void eliminaFoto(int id) {
    _listaFotos.removeWhere((element) => element!.id == id);

    notifyListeners();
  }

//========================== EDITAR FORMULARIO CONSIGNA =======================//
  void datosConsigna(Result? infoConsignaCliente) {
    // print('------DATOS DE CONSIGNA EDICION--------');
    // print('${infoConsignaCliente!.conAsunto}');
    // print('${infoConsignaCliente.conDetalle}');
    // print('${infoConsignaCliente.conDesde}');
    // print('${infoConsignaCliente.conHasta}');
    // print('${infoConsignaCliente.conFrecuencia}');
    // print('${infoConsignaCliente.conPrioridad}');
    // print('${infoConsignaCliente.conDiasRepetir}');

    // for (var dia in infoConsignaCliente.conDiasRepetir!) {
    //   _listaDias.add(dia);
    // }

    notifyListeners();
  }

  void opcionesDecamara(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (pickedFile == null) {
      // print('NO SELECCIONO IMAGEN');
      return;
    }
  }

  Future<String?> upLoadImagen(File? _newPictureFile) async {
    final dataUser = await Auth.instance.getSession();

    //for multipartrequest
    var request = _http.MultipartRequest(
        'POST', Uri.parse('https://backsigeop.neitor.com/api/multimedias'));

    //for token
    request.headers.addAll({"x-auth-token": '${dataUser!.token}'});

    request.files
        .add(await _http.MultipartFile.fromPath('foto', _newPictureFile!.path));

    //for completeing the request
    var response = await request.send();

    //for getting and decoding the response into json format
    var responsed = await _http.Response.fromStream(response);
    // final responseData = json.decode(responsed.body);

    if (responsed.statusCode == 200) {
      print("SUCCESS");
      final responseFoto = FotoUrl.fromJson(responsed.body);
      final fotoUrl = responseFoto.urls[0];
      print(fotoUrl);

      // _listaFotosUrl.add(fotoUrl);
      _listaFotosUrl.addAll([
        {
          "nombre": responseFoto
              .urls[0].nombre, // al consumir el endpoint => perDocNumero
          "url": responseFoto.urls[0].url
        }
      ]);

      //  print('------LISTA FOTO---.${_listaFotosUrl.length}');

    }
    for (var item in _listaFotosUrl) {
      // print('imagen URL: $item');
    }

//========================================//
  }

  Future eliminaConsignaCliente(BuildContext context, Result? consigna) async {
      final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    final _pyloadEliminaConsignaCliente = {
      "tabla": "consigna", // defecto
      "conId": consigna!.conId,
      "rucempresa": infoUser!.rucempresa, //login
    };

    serviceSocket.socket!
        .emit('client:eliminarData', _pyloadEliminaConsignaCliente);
    serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
      if (data['tabla'] == 'consigna') {
        getTodasLasConsignasClientes('');
        snaks.NotificatiosnService.showSnackBarSuccsses(data['msg']);
        serviceSocket.socket?.clearListeners();
        notifyListeners();
      }
    });
  }

//========================== VALIDA CAMPO  FECHA INICIO CONSIGNA =======================//
  String? _inputObservacionesRealizaConsigna;
  get getInputObservacionesRealizaConsigna =>
      _inputObservacionesRealizaConsigna;
  void onInputObservacionesRealizaConsignaChange(String? date) {
    _inputObservacionesRealizaConsigna = date;

    notifyListeners();
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA REALIZAR CONSIGNA=======================//
  int idFotoRealizaConsigna = 0;
  File? _newPictureFileRealizaConsigna;
  File? get getNewPictureFileRealizaConsigna => _newPictureFileRealizaConsigna;

  List<CreaNuevaFotoRealizaConsignaGuardia?> _listaFotosRealizaConsigna = [];
  List<CreaNuevaFotoRealizaConsignaGuardia?>
      get getListaFotosListaFotosRealizaConsigna => _listaFotosRealizaConsigna;
  void setNewPictureFileRealizaConsigna(String? path) {
    _newPictureFileRealizaConsigna = File?.fromUri(Uri(path: path));
    upLoadImagen(_newPictureFileRealizaConsigna);
    _listaFotosRealizaConsigna.add(CreaNuevaFotoRealizaConsignaGuardia(
        idFotoRealizaConsigna, _newPictureFileRealizaConsigna!.path));

    idFotoRealizaConsigna = idFotoRealizaConsigna + 1;
    notifyListeners();
  }

  void eliminaFotoRealizaConsigna(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    _listaFotosRealizaConsigna.removeWhere((element) => element!.id == id);

    notifyListeners();
  }

  void opcionesDecamaraRealizaConsigna(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFileRealizaConsigna = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFileRealizaConsigna == null) {
      // print('NO SELECCIONO IMAGEN');
      return;
    }
    setNewPictureFile(pickedFileRealizaConsigna.path);
  }

//=============================SELECCIONA DIA DE LA SEMANA===============================//

  List<String>? _diaSemanasTepmporal = [];
  List<String>? get getDiaSemanasTepmporal => _diaSemanasTepmporal;
  void setDiaSemanasTepmporal(List<String>? diasTemporal) {
    _diaSemanasTepmporal = diasTemporal;
    // print('44444----> $_diaSemanasTepmporal');
    notifyListeners();
  }

  void persisteSemanaOriginal() {
    _diaSemanas = _diaSemanasTepmporal;
    notifyListeners();
  }

  List<String>? _diaSemanas = [];

  List<String>? get getDiaSemana => _diaSemanas;
  void setDiaSemanas(List<String>? dias) {
    _diaSemanas = dias;
    //  notifyListeners();
    for (var e in _diaSemanas!) {
      // print('object NAAAAA $e');
    }

    for (var e in _diaSemanas!) {
      if (e == 'LUNES' && _diaValueLunes == true) {
        _diaValueLunes = false;
      } else if (e == 'LUNES' && _diaValueLunes == false) {
        _diaValueLunes = true;
        // notifyListeners();
      }
    }
    for (var e in _diaSemanas!) {
      if (e == 'MARTES' && _diaValueMartes == true) {
        _diaValueMartes = false;
      } else if (e == 'MARTES' && _diaValueMartes == false) {
        _diaValueMartes = true;
      }
    }
    for (var e in _diaSemanas!) {
      if (e == 'MIERCOLES' && _diaValueMiercoles == true) {
        _diaValueMiercoles = false;
      } else if (e == 'MIERCOLES' && _diaValueMiercoles == false) {
        _diaValueMiercoles = true;
      }
    }
    for (var e in _diaSemanas!) {
      if (e == 'JUEVES' && _diaValueJueves == true) {
        _diaValueJueves = false;
      } else if (e == 'JUEVES' && _diaValueJueves == false) {
        _diaValueJueves = true;
      }
    }
    for (var e in _diaSemanas!) {
      if (e == 'VIERNES' && _diaValueViernes == true) {
        _diaValueViernes = false;
      } else if (e == 'VIERNES' && _diaValueViernes == false) {
        _diaValueViernes = true;
      }
    }
    for (var e in _diaSemanas!) {
      if (e == 'SABADO' && _diaValueSabado == true) {
        _diaValueSabado = false;
      } else if (e == 'SABADO' && _diaValueSabado == false) {
        _diaValueSabado = true;
      }
    }

    for (var e in _diaSemanas!) {
      if (e == 'DOMINGO' && _diaValueDomingo == true) {
        _diaValueDomingo = false;
      } else if (e == 'DOMINGO' && _diaValueDomingo == false) {
        _diaValueDomingo = true;
      }
    }
  }

  void setDiaLunes(String dia) {
    _diaSemanas!.add(dia);
    _diaValueLunes = true;
    notifyListeners();
  }

  void setDiaMartes(String dia) {
    _diaSemanas!.add(dia);
    _diaValueMartes = true;

    notifyListeners();
  }

  void setDiaMiercoles(String dia) {
    _diaSemanas!.add(dia);
    _diaValueMiercoles = true;

    notifyListeners();
  }

  void setDiaJueves(String dia) {
    _diaSemanas!.add(dia);
    _diaValueJueves = true;

    notifyListeners();
  }

  void setDiaViernes(String dia) {
    _diaSemanas!.add(dia);
    _diaValueViernes = true;

    notifyListeners();
  }

  void setDiaSabado(String dia) {
    _diaSemanas!.add(dia);
    _diaValueSabado = true;

    notifyListeners();
  }

  void setDiaDomingo(String dia) {
    _diaSemanas!.add(dia);
    _diaValueDomingo = true;

    notifyListeners();
  }

  void semanaDiaOnChange(String dia) {
    // for (var e in _diaSemanas) {
    //   if (e == 'MARTES' && _diaValueMartes == true) {
    //     _diaValueMartes = false;
    //     notifyListeners();
    //   } else if (e == 'MARTES' && _diaValueMartes == false) {
    //     _diaValueMartes = true;
    //     notifyListeners();
    //   }
    // }
    // for (var e in _diaSemanas) {
    //   if (e == 'MIERCOLES' && _diaValueMiercoles == true) {
    //     _diaValueMiercoles = false;
    //     notifyListeners();
    //   } else if (e == 'MIERCOLES' && _diaValueMiercoles == false) {
    //     _diaValueMiercoles = true;
    //     notifyListeners();
    //   }
    // }
    // for (var e in _diaSemanas) {
    //   if (e == 'JUEVES' && _diaValueJueves == true) {
    //     _diaValueJueves = false;
    //     notifyListeners();
    //   } else if (e == 'JUEVES' && _diaValueJueves == false) {
    //     _diaValueJueves = true;
    //     notifyListeners();
    //   }
    // }
    // for (var e in _diaSemanas) {
    //   if (e == 'VIERNES' && _diaValueViernes == true) {
    //     _diaValueViernes = false;
    //     notifyListeners();
    //   } else if (e == 'VIERNES' && _diaValueViernes == false) {
    //     _diaValueViernes = true;
    //     notifyListeners();
    //   }
    // }
    // for (var e in _diaSemanas) {
    //   if (e == 'SABADO' && _diaValueSabado == true) {
    //     _diaValueSabado = false;
    //     notifyListeners();
    //   } else if (e == 'SABADO' && _diaValueSabado == false) {
    //     _diaValueSabado = true;
    //     notifyListeners();
    //   }
    // }

    // for (var e in _diaSemanas) {
    //   if (e == 'DOMINGO' && _diaValueDomingo == true) {
    //     _diaValueDomingo = false;
    //     notifyListeners();
    //   } else if (e == 'DOMINGO' && _diaValueDomingo == false) {
    //     _diaValueDomingo = true;
    //     notifyListeners();
    //   }
    // }
    // print('=============${diaSemana.length}===================');
    notifyListeners(); // for (var i = 0; i < diaSemana.length; i++) {
  }

  void eliminaDia(String dia) {
    _diaSemanas!.remove(dia);
    if (dia == 'LUNES') {
      _diaValueLunes = false;
      notifyListeners();
    }
    if (dia == 'MARTES') {
      _diaValueMartes = false;
      notifyListeners();
    }
    if (dia == 'MIERCOLES') {
      _diaValueMiercoles = false;
      notifyListeners();
    }
    if (dia == 'JUEVES') {
      _diaValueJueves = false;
      notifyListeners();
    }
    if (dia == 'VIERNES') {
      _diaValueViernes = false;
      notifyListeners();
    }
    if (dia == 'SABADO') {
      _diaValueSabado = false;
      notifyListeners();
    }
    if (dia == 'DOMINGO') {
      _diaValueDomingo = false;
      notifyListeners();
    }
  }

  void loadDias() {
    for (var e in _diaSemanas!) {
      // print('object: $_diaSemanas');
    }
    for (var e in _diaSemanas!) {
      if (e == 'MARTES' && _diaValueMartes == true) {
        _diaValueMartes = false;
      } else if (e == 'MARTES' && _diaValueMartes == false) {
        _diaValueMartes = true;
      }
      notifyListeners();
    }
    for (var e in _diaSemanas!) {
      if (e == 'MIERCOLES' && _diaValueMiercoles == true) {
        _diaValueMiercoles = false;
      } else if (e == 'MIERCOLES' && _diaValueMiercoles == false) {
        _diaValueMiercoles = true;
      }
      notifyListeners();
    }
    for (var e in _diaSemanas!) {
      if (e == 'JUEVES' && _diaValueJueves == true) {
        _diaValueJueves = false;
      } else if (e == 'JUEVES' && _diaValueJueves == false) {
        _diaValueJueves = true;
      }
      notifyListeners();
    }
    for (var e in _diaSemanas!) {
      if (e == 'VIERNES' && _diaValueViernes == true) {
        _diaValueViernes = false;
      } else if (e == 'VIERNES' && _diaValueViernes == false) {
        _diaValueViernes = true;
      }
      notifyListeners();
    }
    for (var e in _diaSemanas!) {
      if (e == 'SABADO' && _diaValueSabado == true) {
        _diaValueSabado = false;
      } else if (e == 'SABADO' && _diaValueSabado == false) {
        _diaValueSabado = true;
      }
      notifyListeners();
    }

    for (var e in _diaSemanas!) {
      if (e == 'DOMINGO' && _diaValueDomingo == true) {
        _diaValueDomingo = false;
      } else if (e == 'DOMINGO' && _diaValueDomingo == false) {
        _diaValueDomingo = true;
      }
      notifyListeners();
    }
  }

//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaGuardiasConsigna;

  @override
  void dispose() {
    _deboucerSearchBuscaGuardiasConsigna?.cancel();
    // _deboucerSearchBuscaClienteInformes?.cancel();
    // _videoController.dispose();
    super.dispose();
  }

  String? _inputBuscaGuardia;
  get getInputBuscaGuardia => _inputBuscaGuardia;
  void onInputBuscaGuardiaChange(String? text) {
    _inputBuscaGuardia = text;
    // print('GUSCA GUARDIA MULTA :$_inputBuscaGuardia');

//================================================================================//
    if (_inputBuscaGuardia!.length >= 3) {
      _deboucerSearchBuscaGuardiasConsigna?.cancel();
      _deboucerSearchBuscaGuardiasConsigna =
          Timer(const Duration(milliseconds: 500), () {
        buscaGuardiasConsigna(_inputBuscaGuardia);
        // print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaGuardia!.isEmpty) {
      buscaGuardiasConsigna('');
    } else {
      buscaGuardiasConsigna('');
    }

    notifyListeners();
  }

//====================================EDITAR CONSIGNA============================================//
  void getInfoEdit(Result consigna) {
    _labelConsignaCliente = consigna.conFrecuencia;
    _prioridadCliente = consigna.conPrioridad!;
    _prioridadValueCliente = (consigna.conPrioridad == 'ALTA')
        ? 1
        : (consigna.conPrioridad == 'MEDIA')
            ? 2
            : 3;
    for (var e in consigna.conAsignacion!) {
      _listaGuardiaInforme.add({
        "docnumero": e.docnumero, // al consumir el endpoint => perDocNumero
        "nombres": e.nombres,
        // al consumir el endpoint => perNombres perApellidos
        "asignado": e.asignado, // si esta marcado el check
        "id": e.id, // al consumir el endpoint => perId
        "foto": e.foto,
      });
    }

    for (var e in consigna.conFotosCliente!) {
      _listaFotosUrl.addAll([
        {"nombre": e.nombre, "url": e.url}
      ]);
    }
  }



  //================================== ELIMINAR  COMUNICADO  ==============================//
  Future relizaGuardiaConsigna(int? _idConsigna,BuildContext context) async {
      final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadRealizaGuardiaConsigna = 
    {
   "tabla": "consignatrabajo", // defecto
   "rucempresa": infoUser!.rucempresa, // login
   "rol": infoUser.rol, // login
   "conId":_idConsigna, // id de registro
   "conIdPersona": infoUser.id,  //  login
   "detalle": _inputObservacionesRealizaConsigna, 
   "fotos": _listaFotosUrl
};
  
    // print(
    //     '================================== PAYLOAD EJECUTA CONSIGNA   ==============================');
    // print(_pyloadRealizaGuardiaConsigna);

    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadRealizaGuardiaConsigna);
    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'consignatrabajo') {
        // print('PAYLOAD RESPONSE consigna : $data');
        getTodasLasConsignasClientes('');
        snaks.NotificatiosnService.showSnackBarSuccsses(data['msg']);
        // serviceSocket.socket?.clearListeners();
        notifyListeners();
      }
    });
  }












//========================================================================================//

}
