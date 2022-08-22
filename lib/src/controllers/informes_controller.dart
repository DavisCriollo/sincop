import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:http/http.dart' as _http;
import 'package:sincop_app/src/models/agrega_guardias.dart';
import 'package:sincop_app/src/models/crea_fotos.dart';
import 'package:sincop_app/src/models/foto_url.dart';
import 'package:sincop_app/src/models/get_info_guardia_multa.dart';
import 'package:sincop_app/src/models/lista_allClientes.dart';
import 'package:sincop_app/src/models/lista_allInforme_guardias.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:provider/provider.dart';

class InformeController extends ChangeNotifier {
  GlobalKey<FormState> informesGuardiasFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();

  bool validateForm() {
    if (informesGuardiasFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

// late VideoPlayerController _videoController;
  InformeController() {
    // buscaInformeGuardias('');
    // _videoController.initialize();
  }

  void resetValuesInformes() {
    _labelInformePara = null;
    _inputFechaInformeGuardia;
    _inputHoraInformeGuardia;
    infDocNumDirigido = '';
    _textDirigidoA = '';
    _inputAsunto = '';
    _inputTipoNovedad = '';
    _inputLugar = '';
    _inputPejudicado = '';
    _inputMotivo = '';
    _inputDetalle = '';
    _listaGuardiasInforme.clear();
    _listaFotosUrl!.clear();
    _listaVideosUrl.clear();
    _listaFotosCrearInforme.clear();
    _listaGuardiaInforme.clear();
    _pathVideo = '';
    _urlVideo = '';

    notifyListeners();
  }

  void resetListaGuardiasInformes() {
    _textDirigidoA = '';
    _listaGuardiaInforme.clear();
    notifyListeners();
  }

  //================================== FECHA Y HORA DEL COMUNICADO  ==============================//
  String? _inputFechaInformeGuardia;
  get getInputfechaInformeGuardia => _inputFechaInformeGuardia;
  void onInputFechaInformeGuardiaChange(String? date) {
    _inputFechaInformeGuardia = date;

    notifyListeners();
  }

  String? _inputHoraInformeGuardia;
  get getInputHoraInformeGuardia => _inputHoraInformeGuardia;
  void onInputHoraInformeGuardiaChange(String? date) {
    _inputHoraInformeGuardia = date;

    notifyListeners();
  }

  String? _textoPrueba;
  get getTextoPrueba => _textoPrueba;
  void setTextoPrueba(String? date) {
    _textoPrueba = date;
    // print('object; $date');
    notifyListeners();
  }

//  =================  AGREGA CORREOS CLIENTE MULTAS ==================//

  List<dynamic> _listaGuardiasInforme = [];
  List<dynamic> get getListaGuardiasInforme => _listaGuardiasInforme;

  void setListaGuardiasInforme(
      int? id, String? documento, String? nombres, List<String>? correo) {
    // _listaGuardiasInforme!.addAll([correo!.toString()]);
    // _listaGuardiasInforme!.addAll([correo!.toString()]);

    _listaGuardiasInforme.addAll([
      {
        "id": id!.toInt(),
        "docnumero": documento,
        "nombres": nombres,
        "compartido": true,
        "email": correo,
      }
    ]);
    // print('CORREO:$_listaGuardiasInforme ');

    notifyListeners();
  }

  void eliminaGuardiaInforme(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    // print(id);
    // _listaGuardiasInforme.removeWhere((element) => element.id == id);
    _listaGuardiaInforme.removeWhere((e) => (e['id'] == id));
    // _listaGuardiasInforme.removeWhere((e) => e['id'] == id);
    _listaGuardiasInforme.forEach(((element) {
      // print('${element['nombres']}');
    }));

    notifyListeners();
    // print('------LISTA ---.${_listaGuardiasInforme.length}');
  }

//============================= SELECCIONA DATOS PARA A ==================================//

  String? _textDirigidoA;
  String? infDocNumDirigido;
  String? _textDocNumDirigidoA;
  // String? _textDocNumNeevoDirigidoA;
  int? _idCliente;

  List<dynamic>? _infCorreosCliente;
  String? get getTextDirigido => _textDirigidoA;
  // String? get getTextDirigido => _textDocNumNeevoDirigidoA;
  set setTextDirigido(String? value) {
    _textDirigidoA = value;
    notifyListeners();
  }
  // void setDirigidoAChange(InfoCliente cliente) {
  //   _textDirigidoA = cliente.cliRazonSocial;
  //   _idCliente = cliente.cliId;
  //   infDocNumDirigido = cliente.cliDocNumero;
  //   _textDocNumDirigidoA = cliente.cliDocNumero;
  //   // _infCorreosCliente = cliente.perEmail;
  //   _infCorreosCliente = cliente.perEmail;

  //   print('ID A : $_idCliente');
  //   print('DIRIGIDO A : $_textDirigidoA');
  //   print('DIRIGIDO cedula  : $_textDocNumDirigidoA');
  //   print('DIRIGIDO CORREO  : $_infCorreosCliente');
  //   notifyListeners();
  // }
  // void setDirigidoAChange(InfoCliente cliente) {
  //   _textDirigidoA = cliente.cliRazonSocial;
  //   _idCliente = cliente.cliId;
  //   infDocNumDirigido = cliente.cliDocNumero;
  //   _textDocNumDirigidoA = cliente.cliDocNumero;
  //   // _infCorreosCliente = cliente.perEmail;
  //   _infCorreosCliente = cliente.perEmail;

  //   print('ID A : $_idCliente');
  //   print('DIRIGIDO A : $_textDirigidoA');
  //   print('DIRIGIDO cedula  : $_textDocNumDirigidoA');
  //   print('DIRIGIDO CORREO  : $_infCorreosCliente');
  //   notifyListeners();
  // }

  String? _inputAsunto = '';
  String? get getInputAsunto => _inputAsunto;
  void setInputAsuntoChange(String? text) {
    _inputAsunto = text;
    // print('ASUNTO : $_inputAsunto');
    notifyListeners();
  }

  String? _inputTipoNovedad = '';
  String? get getInputTipoNovedad => _inputTipoNovedad;
  void setInputTipoNovedadChange(String? text) {
    _inputTipoNovedad = text;
    // print('TipoNovedad : $_inputTipoNovedad');
    notifyListeners();
  }

  String? _inputLugar = '';
  String? get getInputLugar => _inputLugar;
  void setInputLugarChange(String? text) {
    _inputLugar = text;
    // print('Lugar : $_inputLugar');
    notifyListeners();
  }

  String? _inputPejudicado = '';
  String? get getInputPejudicado => _inputPejudicado;
  void setInputPejudicadoChange(String? text) {
    _inputPejudicado = text;
    // print('Pejudicado : $_inputPejudicado');
    notifyListeners();
  }

  String? _inputMotivo = '';
  String? get getInputMotivo => _inputMotivo;
  void setInputMotivoChange(String? text) {
    _inputMotivo = text;
    // print('Motivo : $_inputMotivo');
    notifyListeners();
  }

  String? _inputDetalle = '';
  String? get getInputDetalle => _inputDetalle;
  void setInputDetalleChange(String? text) {
    _inputDetalle = text;
    // print('Detalle : $_inputDetalle');
    notifyListeners();
  }

  String? _inputConclusiones = '';
  String? get getInputConclusiones => _inputConclusiones;
  void setInputConclusionesChange(String? text) {
    _inputConclusiones = text;
    // print('Detalle : $_inputConclusiones');
    notifyListeners();
  }

  String? _inputRecomendaciones = '';
  String? get getInputRecomendaciones => _inputRecomendaciones;
  void setInputRecomendacionesChange(String? text) {
    _inputRecomendaciones = text;
    // print('Detalle : $_inputRecomendaciones');
    notifyListeners();
  }

//========================== DROPDOWN MOTIVO AUSENCIA =======================//
  String? _labelInformePara;

  String? get labelInformePara => _labelInformePara;

  void setLabelInformePara(String value) {
    _labelInformePara = value;
    _textDirigidoA = '';
    _listaGuardiaInforme = [];
    // resetListaGuardiasInformes();
    // print('-----ss:$_labelInformePara');
    notifyListeners();
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  int id = 0;
  File? _newPictureFile;
  File? get getNewPictureFile => _newPictureFile;
  List? _listaFotosUrl = [];
  List? get getListaFotosUrl => _listaFotosUrl;

  List<dynamic> _listaFotosCrearInforme = [];
  List<dynamic> get getListaFotosInforme => _listaFotosCrearInforme;
  void setNewPictureFile(String? path) {
    _newPictureFile = File?.fromUri(Uri(path: path));
    upLoadImagen(_newPictureFile);
    _listaFotosCrearInforme
        .add(CreaNuevaFotoInformeGuardias(id, _newPictureFile!.path));
    // _listaFotosCrearInforme.add({"id": id, "path": _newPictureFile});

    id = id + 1;
    notifyListeners();
  }

  void setEditarFoto(int id, String path) {
    _listaFotosCrearInforme.add(CreaNuevaFotoInformeGuardias(id, path));

    notifyListeners();
  }

  void eliminaFoto(int id) {
    _listaFotosCrearInforme.removeWhere((element) => element!.id == id);

    notifyListeners();
  }

  void opcionesDecamara(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (pickedFile == null) {
      print('NO SELECCIONO IMAGEN');
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
      // print("SUCCESS");
      final responseFoto = FotoUrl.fromJson(responsed.body);
      final fotoUrl = responseFoto.urls[0];
      // print(fotoUrl);

      // _listaFotosUrl.add(fotoUrl);
      _listaFotosUrl!.addAll([
        {
          "nombre": responseFoto
              .urls[0].nombre, // al consumir el endpoint => perDocNumero
          "url": responseFoto.urls[0].url
        }
      ]);

      //  print('------LISTA FOTO---.${_listaFotosUrl.length}');
      notifyListeners();
    }
    for (var item in _listaFotosUrl!) {
      // print('imagen URL: $item');
    }
  }

//======================================================OBTIENE DATOS DEL GUARDIAMULTA============================================//
  int? _idPersonaInforme;
  String? _cedPersonaInforme;
  String? _nombrePersonaInforme;

  int? get getIdPersonaInforme => _idPersonaInforme;
  String? get getCedPersonaInforme => _cedPersonaInforme;
  String? get getNomPersonaInforme => _nombrePersonaInforme;

  set setIdPersonaInforme(int? id) {
    _idPersonaInforme = id;
    // print('ID GUARDIA Informe: $_idPersonaInforme');
    notifyListeners();
  }

  set setCedPersonaInforme(String? cedula) {
    _cedPersonaInforme = cedula;
    // print('CEDULA GUARDIA Informe: $_cedPersonaInforme');
    notifyListeners();
  }

  set setNomPersonaInforme(String? nombre) {
    _nombrePersonaInforme = nombre;
    // print('NOMBRE GUARDIA Informe: $_nombrePersonaInforme');
    notifyListeners();
  }

  //===================LEE CODIGO QR==========================//
  // Map<int, String>? _elementoQRMulta = {};
  String? _infoQRGuardiaInforme;
  String? get getInfoQRMultaGuardia => _infoQRGuardiaInforme;

  Future setInfoQRMultaGuardia(String? value) async {
    _infoQRGuardiaInforme = value;
    // print('info GUARDIA MULTA: $_infoQRGuardiaInforme');
    if (_infoQRGuardiaInforme != null) {
      _errorInfoGuardiaInforme = true;
      final split = _infoQRGuardiaInforme!.split('-');
      setIdPersonaInforme = int.parse(split[0]);
      setCedPersonaInforme = split[1];
      setNomPersonaInforme = split[2];

      notifyListeners();
    } else {
      _errorInfoGuardiaInforme = false;
    }
  }

//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaGuardiasInforme;

  @override
  void dispose() {
    _deboucerSearchBuscaGuardiasInforme?.cancel();
    _deboucerSearchBuscaClienteInformes?.cancel();
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
      _deboucerSearchBuscaGuardiasInforme?.cancel();
      _deboucerSearchBuscaGuardiasInforme =
          Timer(const Duration(milliseconds: 500), () {
        buscaGuardiaInforme(_inputBuscaGuardia);
        // print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaGuardia!.isEmpty) {
      buscaGuardiaInforme('');
    } else {
      buscaGuardiaInforme('');
    }

    notifyListeners();
//================================================================================//
  }

  List<Guardia> _listaInfoGuardiaInforme = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List<Guardia> get getListaInfoGuardiaInforme => _listaInfoGuardiaInforme;

  void setInfoBusquedaGuardiaInforme(List<Guardia> data) {
    _listaInfoGuardiaInforme = data;
    // print('Lista dde guardias : ${_listaInfoGuardiaInforme}');
    notifyListeners();
  }

  bool? _errorInfoGuardiaInforme; // sera nulo la primera vez
  bool? get getErrorInfoGuardiaInforme => _errorInfoGuardiaInforme;
  set setErrorInfoGuardiaInforme(bool? value) {
    _errorInfoGuardiaInforme = value;
    notifyListeners();
  }

  Future<AllGuardias?> buscaGuardiaInforme(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllInfoGuardias(
      search: _search,
      docnumero: _textDocNumDirigidoA,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoGuardiaInforme = true;
      // setInfoBusquedaGuardiaInforme(response.data);
      // setIdPersonaMulta = response.data[0].perId;
      // setCedPersonaMulta = response.data[0].perDocNumero;
      // print('${response.data[0].perNombres} ${response.data[0].perApellidos}');
      //  _listaInfoGuardiaInforme=response.data;
      setInfoBusquedaGuardiaInforme(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoGuardiaInforme = false;
      notifyListeners();
      return null;
    }
  }

//========================================//
  // List<Informe> _listaInformesGuardia = [];
  // // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  // List<Informe> get getListaInformesInforme => _listaInformesGuardia;

  // void setInfoBusquedaInformesGuardia(List<Informe> data) {
  //   _listaInformesGuardia = data;
  //   print('dataRefresca $_listaInformesGuardia');
  //   // print('Lista de guardias SOCKET: ${_listaInformesGuardia}');
  //   notifyListeners();
  // }

  // // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  // late Informe _informeGuardia;
  // Informe get getInforme => _informeGuardia;

  // void setinformeGuardia(Informe data) {
  //   _listaInformesGuardia.add(data);

  //   notifyListeners();
  // }
  List _listaInformesGuardia = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaInformesInforme => _listaInformesGuardia;

  void setInfoBusquedaInformesGuardia(List data) {
    _listaInformesGuardia = data;
    // print('informes Guardias  $_listaInformesGuardia');
    // print('Lista de guardias SOCKET: ${_listaInformesGuardia}');
    notifyListeners();
  }

  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  late Informe _informeGuardia;
  Informe get getInforme => _informeGuardia;

  void setinformeGuardia(Informe data) {
    _listaInformesGuardia.add(data);

    notifyListeners();
  }

  bool? _errorInformesGuardia; // sera nulo la primera vez
  bool? get getErrorInformesGuardia => _errorInformesGuardia;
  set setErrorInformesGuardia(bool? value) {
    _errorInformesGuardia = value;
    notifyListeners();
  }

//   Future<AllInformesGuardias?> buscaInformeGuardias(String? _search) async {
//     final dataUser = await Auth.instance.getSession();
// // print('usuario : ${dataUser!.rucempresa}');
//     final response = await _api.getAllInformesGuardia(
//       search: _search,
//       // estado: 'GUARDIAS',
//       token: '${dataUser!.token}',
//     );
//     if (response != null) {
//       _errorInformesGuardia = true;
//       // setInfoBusquedaGuardiaInforme(response.data);
//       // setIdPersonaMulta = response.data[0].perId;
//       // setCedPersonaMulta = response.data[0].perDocNumero;
//       print('${response.data[0].infAsunto} ${response.data[0].infLugar}');
//       //  _listaInformesGuardia=response.data;
//       setInfoBusquedaInformesGuardia(response.data);

//       notifyListeners();
//       return response;
//     }
//     if (response == null) {
//       _errorInfoGuardiaInforme = false;
//       notifyListeners();
//       return null;
//     }
//   }
  Future buscaInformeGuardias(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllInformesGuardia(
      search: _search,
      // estado: 'GUARDIAS',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInformesGuardia = true;
      // setInfoBusquedaGuardiaInforme(response.data);
      // setIdPersonaMulta = response.data[0].perId;
      // setCedPersonaMulta = response.data[0].perDocNumero;
      // print('${response.data[0].infAsunto} ${response.data[0].infLugar}');
      //  _listaInformesGuardia=response.data;
      setInfoBusquedaInformesGuardia(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoGuardiaInforme = false;
      notifyListeners();
      return null;
    }
  }

//========================================//
//================================== OBTENEMOS TODOS LOS CLIENTES ==============================//
  List<InfoCliente> _listaTodosLosClientesInformes = [];
  List<InfoCliente> get getListaTodosLosClientesInfomes =>
      _listaTodosLosClientesInformes;

  void setListaTodosLosClientesInformes(List<InfoCliente> data) {
    _listaTodosLosClientesInformes = data;
    // print('data clientes : ${_listaTodosLosClientesInformes}');
    notifyListeners();
  }

  bool? _errorClientesInformes; // sera nulo la primera vez
  bool? get getErrorClientesInformes => _errorClientesInformes;

  Future<AllClientes?> getTodosLosClientesInformes(String? search) async {
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
      _errorClientesInformes = true;
      setListaTodosLosClientesInformes(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorClientesInformes = false;
      notifyListeners();
      return null;
    }
    return null;
  }
//  =================  CREO UN DEBOUNCE BUSCAR CLIENTES ==================//

  Timer? _deboucerSearchBuscaClienteInformes;

  String? _inputBuscaClienteInformes;
  get getInputBuscaClienteInformes => _inputBuscaClienteInformes;
  void onInputBuscaClienteInformesChange(String? text) {
    _inputBuscaClienteInformes = text;
    // print(' CLIENTES INFORMES :$_inputBuscaClienteInformes');

//================================================================================//
    // @override
    // void dispose() {
    //   _deboucerSearchBuscaClienteInformes?.cancel();
    //   super.dispose();
    // }

    if (_inputBuscaClienteInformes!.length >= 3) {
      _deboucerSearchBuscaClienteInformes?.cancel();
      _deboucerSearchBuscaClienteInformes =
          Timer(const Duration(milliseconds: 500), () {
        getTodosLosClientesInformes(_inputBuscaClienteInformes);
        //  print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaClienteInformes!.isEmpty) {
      getTodosLosClientesInformes('');
    } else {
      getTodosLosClientesInformes('');
    }

    notifyListeners();
  }
//================================================================================//
//========================================================= SELECCIONA  ==============================//

  // List _listaGuardiaInforme = [];
  // List get getListaGuardiaInforme => _listaGuardiaInforme;
  // void setGuardiaInforme(Guardia guardia) {
  //   // for (var e in _listaGuardiaInforme) {
  //   //   if (e.perId == guardia.perId) {
  //   _listaGuardiaInforme.removeWhere((e) => (e['id'] == guardia.perId));

  //   _listaGuardiaInforme.add({
  //     "perPuestoServicio": guardia.perPuestoServicio,
  //     "docnumero": guardia.perDocNumero,
  //     "nombres": '${guardia.perNombres} ${guardia.perApellidos}',
  //     "asignado": true,
  //     "id": guardia.perId,
  //     "foto": guardia.perFoto,
  //     "correo": guardia.perEmail
  //   });
  //   notifyListeners();
  // }
//========================================================= SELECCIONA  ==============================//

  List _listaGuardiaInforme = [];
  List get getListaGuardiaInforme => _listaGuardiaInforme;
  void setGuardiaInforme(dynamic guardia) {
    // for (var e in _listaGuardiaInforme) {
    //   if (e.perId == guardia.perId) {

    _listaGuardiaInforme.removeWhere((e) => (e['id'] == guardia['perId']));

    _listaGuardiaInforme.add({
      "perPuestoServicio": guardia['perPuestoServicio'],
      "docnumero": guardia['perDocNumero'],
      "nombres": '${guardia['perNombres']} ${guardia['perApellidos']}',
      "asignado": true,
      "id": guardia['perId'],
      "foto": guardia['perFoto'],
      "correo": guardia['perEmail']
    });
    notifyListeners();
  }
//========================================================= SELECCIONA guardia por cliente ==============================//

  // List _listaGuardiaInformePorCliente = [];
  // List get getListaGuardiaInformePorCliente => _listaGuardiaInformePorCliente;
  // void setGuardiaInformePorCliente(dynamic guardia) {
  //   // for (var e in _listaGuardiaInformePorCliente) {
  //   //   if (e.perId == guardia.perId) {
  //   _listaGuardiaInformePorCliente.removeWhere((e) => (e['id'] == guardia['perId']));

  //   _listaGuardiaInformePorCliente.add({
  //     "perPuestoServicio": guardia['perPuestoServicio'],
  //     "docnumero": guardia['perDocNumero'],
  //     "nombres": '${guardia['perNombres']} ${guardia['perApellidos']}',
  //     "asignado": true,
  //     "id": guardia['perId'],
  //     "foto": guardia['perFoto'],
  //     "correo": guardia['perEmail']
  //   });
  //   notifyListeners();
  // }

  void setDirigidoAChange(dynamic persona) {
    _idCliente = persona['perId'];
    infDocNumDirigido = persona['perDocNumero'];
    _textDirigidoA = '${persona['perApellidos']} ${persona['perNombres']}';
    // _textDocNumDirigidoA = persona.cliDocNumero;
    // _infCorreosCliente = cliente.perEmail;
    // for (var e in persona['perEmail']) {
    //    _infCorreosCliente?.addAll(e['perEmail']);

    // }
    _infCorreosCliente = persona?['perEmail'];

    // print('ID A : $_idCliente');
    // print('DIRIGIDO A : $_textDirigidoA');
    // print('DIRIGIDO cedula  : $infDocNumDirigido');
    // print('DIRIGIDO CORREO  : $_infCorreosCliente');
    notifyListeners();
  }

  void setDirigidoAClienteChange(dynamic persona) {
    _idCliente = persona.cliId;
    infDocNumDirigido = persona.cliDocNumero;
    _textDirigidoA = persona.cliRazonSocial;
    _infCorreosCliente = persona?.perEmail;
    // print('ID A : $_idCliente');
    // print('DIRIGIDO A : $_textDirigidoA');
    // print('DIRIGIDO cedula  : $infDocNumDirigido');
    // print('DIRIGIDO CORREO  : $_infCorreosCliente');
    notifyListeners();
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  Future crearInforme(
    BuildContext context,
  ) async {
    // final serviceSocket = SocketService();
    final serviceSocket = SocketService();

    // print(
    //     '========================= GUARDA NUEVO INFORME ================================');
    // print('--idCLIENTE -->:$_idCliente');
    // print('--DIRIGIDO A -->:$_textDirigidoA');
    // print('--ASUNTOA-->:$_inputAsunto');
    // print('--Tipo NOVEDAD-->:$_inputTipoNovedad');
    // print('--FEHCA SUCESO-->:$_inputFechaInformeGuardia');
    // print('--HORA SUCESO-->:$_inputHoraInformeGuardia');
    // print('--LUGAR-->:$_inputLugar');
    // print('--PERJUDICADO-->:$_inputPejudicado');
    // print('--GUARDIAS-->:$_listaGuardiaInforme');
    // print('--MOTIVO-->:$_inputMotivo');
    // print('--DETALLE-->:$_inputDetalle');
    final infoUser = await Auth.instance.getSession();
    // print(
    //     '==========================DATOS DEL TELEFONO ===============================');
    // print('rucEmpresa ${infoUser!.rucempresa}');
    // print('rucempresa ${infoUser.rucempresa}');
    // print('user ${infoUser.usuario}');
    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadNuevoInforme = {
      "tabla": "informe", //DEFECTO
      "rucempresa": infoUser!.rucempresa, // LOGIN
      "rol": infoUser.rol, //LOGIN

      "infIdDirigido": _idCliente, // perId
      "infRol": infoUser.rol, // del login
      "infPara":
          _labelInformePara, // de select ################################
      "infDocNumDirigido": infDocNumDirigido, // perDocNumero
      "infNomDirigido": _textDirigidoA, // perApellidos- perNombres

      "infGenerado": "",
      "infDocumento": "",

      "infAsunto": _inputAsunto, // input
      "infTipoNovedad": _inputTipoNovedad, // input

      "infCorreo": _infCorreosCliente,
      "infFechaSuceso":
          '${_inputFechaInformeGuardia}T$_inputHoraInformeGuardia', // input y hora
      "infLugar": _inputLugar, // input
      "infPerjudicado": _inputPejudicado, // input
      "infPorque": _inputMotivo, // input
      "infSucedido": _inputDetalle, // textarea
      "infConclusiones": _inputConclusiones, // textarea
      "infRecomendaciones": _inputRecomendaciones, // textarea
      "infGuardias":
          _listaGuardiaInforme, // array para los guardias asignados (LLenar con los mismos parametros que se utilizo en consigna)
      "infFotos": _listaFotosUrl,
      "infVideo": _listaVideosUrl,
      "infUser": infoUser.usuario, //LOGIN
      "infEmpresa": infoUser.rucempresa //LOGIN
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadNuevoInforme);
    // // print(
    //     '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!.emit('client:guardarData', _pyloadNuevoInforme);
  }

  //================================== ELIMINAR  MULTA  ==============================//
  Future eliminaInformeGuardia(BuildContext context, int? idInforme) async {
    // final serviceSocket = SocketService();

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    final infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadEliminaInformeGuardia = {
      {
        "tabla": 'informe',
        "rucempresa": infoUser!.rucempresa,
        "infId": idInforme,
      }
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');

    serviceSocket.socket!
        .emit('client:eliminarData', _pyloadEliminaInformeGuardia);
    // serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
    //   if (data['tabla'] == 'informe') {

    buscaInformeGuardias('');
    //     NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //     serviceSocket.socket?.clearListeners();
    //     notifyListeners();
    //   }
    // });
    // serviceSocket.socket?.on('server:error', (data) {
    //   NotificatiosnService.showSnackBarError(data['msg']);
    //   notifyListeners();
    // });
  }

  //==========================TRABAJAMOS CON VIDEO  ===============================//

  String? _pathVideo =
      'https://movietrailers.apple.com/movies/independent/unhinged/unhinged-trailer-1_h720p.mov';
  String? get getPathVideo => _pathVideo;

  void setPathVideo(String? path) {
    _pathVideo = path;
    upLoadVideo(_pathVideo);
    // print('Video PATH ===================> : $path');
    notifyListeners();
  }

  String? _urlVideo = '';
  String? get getUrlVideo => _urlVideo;

  void setUrlVideo(String? url) {
    _urlVideo = url;
    // print(
    //     'url del video es =======*******************************========> : $_urlVideo');
    notifyListeners();
  }
//============================LOAD VIDEO===========================================//

  List<dynamic> _listaVideosUrl = [];
  List<dynamic> get getVideoUrl => _listaVideosUrl;

  Future<String?> upLoadVideo(String? path) async {
    final dataUser = await Auth.instance.getSession();

    //for multipartrequest
    var request = _http.MultipartRequest(
        'POST', Uri.parse('https://backsigeop.neitor.com/api/multimedias'));

    //for token
    request.headers.addAll({"x-auth-token": '${dataUser!.token}'});

    request.files.add(await _http.MultipartFile.fromPath('video', path!));

    //for completeing the request
    var response = await request.send();

    //for getting and decoding the response into json format
    var responsed = await _http.Response.fromStream(response);
    // final responseData = json.decode(responsed.body);

    if (responsed.statusCode == 200) {
      // print("SUCCESS");
      final responseVideo = FotoUrl.fromJson(responsed.body);
      final _urlVideo = responseVideo.urls[0];
      setUrlVideo(responseVideo.urls[0].url);
      //  print('url del video es =======*******************************========> : ${_urlVideo.url}');

      _listaVideosUrl.addAll([
        {
          "nombre": responseVideo
              .urls[0].nombre, // al consumir el endpoint => perDocNumero
          "url": responseVideo.urls[0].url
        }
      ]);

      //  print('------LISTA FOTO---.${_listaVideosUrl.length}');

    }
    for (var item in _listaVideosUrl) {
      // print('VIDEO URL: $item');
    }
  }

  void eliminaVideo() {
    _listaVideosUrl.clear();
    _urlVideo = '';
    _pathVideo = '';
    notifyListeners();
  }

//====================================TOMAMO LOS DATOS PARA EDITAR INFORME  ============================================//
  int? _idInforme;
  String? _infIdDirigido = '';
  String? get getInfIdDirigido => infDocNumDirigido;
  String? _infGenerado = '';
  String? _infFechaSuceso = '';
  void getDataInformeGuardia(Informe informe) {
    //============================= INPUTS ==================================//
    _idInforme = informe.infId;
    _infIdDirigido = informe.infIdDirigido;
    _textDocNumDirigidoA = informe.infDocNumDirigido;
    _textDirigidoA = informe.infNomDirigido;
    _infCorreosCliente = informe.infCorreo;
    _infFechaSuceso = informe.infFechaSuceso;
    _inputAsunto = informe.infAsunto;
    _inputTipoNovedad = informe.infTipoNovedad;
    _inputLugar = informe.infLugar;
    _inputPejudicado = informe.infPerjudicado;
    _inputMotivo = informe.infPorque;
    _inputDetalle = informe.infSucedido;
    _inputHoraInformeGuardia = informe.infFechaSuceso;

    informe.infFotos!.map((e) {
      return _listaFotosUrl!.addAll([
        {
          "nombre": e.nombre,
          // al consumir el endpoint => perDocNumero
          "url": e.url
        }
      ]);
    });
    notifyListeners();
    // print('INFORMES F S====> ${informe.infFotos!.length}');
    // print('fotos S====> ${_listaFotosUrl!.length}');

    // print(
    //     'dddddddd====> ${informe.infGuardias![0].perPuestoServicio.runtimeType}');

    for (var e in informe.infGuardias!) {
      _listaGuardiaInforme.add({
        "perPuestoServicio": e.perPuestoServicio!.map((x) {
          return {
            "ruccliente": x.ruccliente,
            "razonsocial": x.razonsocial,
            "ubicacion": x.ubicacion,
            "puesto": x.puesto,
          };
        }).toList(),
        "docnumero": e.docnumero,
        "nombres": e.nombres,
        "asignado": true,
        "id": e.id,
        "foto": e.foto,
        "correo": e.correo
      });
    }
    // print('ID A : $_infIdDirigido');
    // print('DIRIGIDO A : $_textDirigidoA');
    // print('DIRIGIDO cedula  : $_textDocNumDirigidoA');
    // print('DIRIGIDO CORREO  : $_infCorreosCliente');
    // print('_inputAsunto  : $_inputAsunto');
    // print('_inputTipoNovedad  : $_inputTipoNovedad');
    // print('_inputLugar  : $_inputLugar');
    // print('_inputPejudicado  : $_inputPejudicado');
    // print('_inputMotivo  : $_inputMotivo');
    // print('_inputDetalle  : $_inputDetalle');
    // print('_inputHoraInformeGuardia  : $_inputHoraInformeGuardia');
    // print('LISTA GUARDIAS  : $_listaGuardiaInforme');
    // print('LISTA FOTOS  : $_listaFotosUrl');
    // print('LISTA VIDEOS  : $_listaVideosUrl');
  }

  void getDataInformes(dynamic informe) {
    //============================= INPUTS ==================================//
    _idInforme = informe['infId'];
    _infIdDirigido = informe['infIdDirigido'];
    _textDocNumDirigidoA = informe['infDocNumDirigido'];
    _textDirigidoA = informe['infNomDirigido'];
    _infCorreosCliente = informe['infCorreo'];
    _infGenerado = informe['infGenerado'];
    _infFechaSuceso = informe['infFechaSuceso'];
    _inputAsunto = informe['infAsunto'];
    _inputTipoNovedad = informe['infTipoNovedad'];
    _inputLugar = informe['infLugar'];
    _inputPejudicado = informe['infPerjudicado'];
    _inputMotivo = informe['infPorque'];
    _inputDetalle = informe['infSucedido'];
    _inputHoraInformeGuardia = informe['infFechaSuceso'];
    _labelInformePara = informe['infPara'];
    _listaFotosUrl = informe['infFotos'];
    _listaVideosUrl = informe['infVideo'];
    _inputConclusiones = informe["infConclusiones"]; // textarea
    _inputRecomendaciones = informe["infRecomendaciones"]; // textarea

    // informe['infFotos']!.map((e) {
    //   return _listaFotosUrl!.addAll([
    //     {
    //       "nombre": e['nombre'],
    //       // al consumir el endpoint => perDocNumero
    //       "url": e['url']
    //     }
    //   ]);
    // }
    // );

    notifyListeners();
    // print('INFORMES F S====> ${informe['infFotos']!.length}');
    // print('fotos S====> ${_listaFotosUrl!.length}');
    // print('fotos S====> ${_listaVideosUrl.length}');

    // print(
    //     'dddddddd====> ${informe['infGuardias']![0]['perPuestoServicio'].runtimeType}');

    for (var e in informe['infGuardias']!) {
      _listaGuardiaInforme.add({
        "perPuestoServicio": e['perPuestoServicio']!.map((x) {
          return {
            "ruccliente": x['ruccliente'],
            "razonsocial": x['razonsocial'],
            "ubicacion": x['ubicacion'],
            "puesto": x['puesto'],
          };
        }).toList(),
        "docnumero": e['docnumero'],
        "nombres": e['nombres'],
        "asignado": true,
        "id": e['id'],
        "foto": e['foto'],
        "correo": e['correo']
      });
    }
    // print('ID A : $_infIdDirigido');
    // print('DIRIGIDO A : $_textDirigidoA');
    // print('DIRIGIDO cedula  : $_textDocNumDirigidoA');
    // print('DIRIGIDO CORREO  : $_infCorreosCliente');
    // print('_inputAsunto  : $_inputAsunto');
    // print('_inputTipoNovedad  : $_inputTipoNovedad');
    // print('_inputLugar  : $_inputLugar');
    // print('_inputPejudicado  : $_inputPejudicado');
    // print('_inputMotivo  : $_inputMotivo');
    // print('_inputDetalle  : $_inputDetalle');
    // print('_inputHoraInformeGuardia  : $_inputHoraInformeGuardia');
    // print('LISTA GUARDIAS  : $_listaGuardiaInforme');
    // print('LISTA FOTOS  : $_listaFotosUrl');
    // print('LISTA VIDEOS  : $_listaVideosUrl');
    // print('INFO PARA   : $_labelInformePara');
    // print('INFO Conclusiones   : $_inputConclusiones');
    // print('INFO Recomendaciones   : $_inputRecomendaciones');
  }

  void eliminaFotoUrl(String url) {
    _listaFotosUrl!.removeWhere((e) => e['url'] == url);
  }

// _listaFotosUrl!.forEach((e)=>print(e));
  //================================== CREA NUEVA CONSIGNA  ==============================//
  Future editarInforme(
    BuildContext context,
  ) async {
    // final serviceSocket = SocketService();
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    // print(
    //     '========================= GUARDA NUEVO INFORME ================================');
    // print('--idCLIENTE -->:$_idCliente');
    // print('--DIRIGIDO A -->:$_textDirigidoA');
    // print('--ASUNTOA-->:$_inputAsunto');
    // print('--Tipo NOVEDAD-->:$_inputTipoNovedad');
    // print('--FEHCA SUCESO-->:$_inputFechaInformeGuardia');
    // print('--HORA SUCESO-->:$_inputHoraInformeGuardia');
    // print('--LUGAR-->:$_inputLugar');
    // print('--PERJUDICADO-->:$_inputPejudicado');
    // print('--GUARDIAS-->:$_listaGuardiaInforme');
    // print('--MOTIVO-->:$_inputMotivo');
    // print('--DETALLE-->:$_inputDetalle');
    final infoUser = await Auth.instance.getSession();
    // print(
    //     '==========================DATOS DEL TELEFONO ===============================');
    // print('rucEmpresa ${infoUser!.rucempresa}');
    // print('rucempresa ${infoUser.rucempresa}');
    // print('user ${infoUser.usuario}');
    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadEditaInforme = {
      "tabla": "informe", //DEFECTO
      "infId": _idInforme,
      "rucempresa": infoUser!.rucempresa, // LOGIN
      "rol": infoUser.rol, //LOGIN

      "infRol": infoUser.rol, // del login
      "infIdDirigido": _idCliente, // perId
      "infPara":
          _labelInformePara, // de select ################################
      "infDocNumDirigido": infDocNumDirigido, // perDocNumero
      "infNomDirigido": _textDirigidoA, // perApellidos- perNombres
      "infDocumento": "",
      "infGenerado": _infGenerado,

      "infConclusiones": _inputConclusiones, // textarea
      "infRecomendaciones": _inputRecomendaciones, // textarea

      // "infDocNumDirigido": _textDocNumDirigidoA,
      // "infNomDirigido":
      //     _textDirigidoA, // utilizar el enpoint para buscar cliente tomar la propiedad => cliRazonSocial
      // "infIdDirigido":
      //     _infIdDirigido, // mantenerlo internamente, llenarlo con la propiedad => cliId, al consumir el endpoint de buscar cliente
      "infAsunto": _inputAsunto, // input
      "infTipoNovedad": _inputTipoNovedad, // input
      "infCorreo": _infCorreosCliente,
      "infFechaSuceso": _infFechaSuceso, // input y hora
      "infLugar": _inputLugar, // input
      "infPerjudicado": _inputPejudicado, // input
      "infPorque": _inputMotivo, // input
      "infSucedido": _inputDetalle, // textarea
      "infGuardias":
          _listaGuardiaInforme, // array para los guardias asignados (LLenar con los mismos parametros que se utilizo en consigna)
      "infFotos": _listaFotosUrl,
      "infVideo": _listaVideosUrl,
      "infUser": infoUser.usuario, //LOGIN
      "infEmpresa": infoUser.rucempresa //LOGIN
    };
    // print(
    //     '==========================JSON PARA EDITAR INFORME ===============================');
    // print('_listaGuardiaInforme====>>    ${_listaGuardiaInforme.length}');
    // print(_pyloadEditaInforme);

    serviceSocket.socket!.emit('client:actualizarData', _pyloadEditaInforme);
  }
//=======================================================================//

//===============LISTAMOS TODOS LOS GUARDIAS =========================//
  List _listaInfoGuardia = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaInfoGuardia => _listaInfoGuardia;

  void setInfoBusquedaInfoGuardia(List data) {
    _listaInfoGuardia = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de guardias SOCKET: ${_listaInfoGuardia}');
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

//==================OBTENEMOS A LOS GUARDIAS POR CLIENTES======================//
  List _listaInfoGuardiaPorCliente = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaInfoGuardiaPorCliente => _listaInfoGuardiaPorCliente;

  void setInfoBusquedaInfoGuardiaPorCliente(List data) {
    _listaInfoGuardiaPorCliente = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de guardias POR CLIENTE: ${_listaInfoGuardiaPorCliente}');
    notifyListeners();
  }

  bool? _errorInfoGuardiaPorCliente; // sera nulo la primera vez
  bool? get getErrorInfoGuardiaPorCliente => _errorInfoGuardiaPorCliente;
  set setErrorInfoGuardiaPorCliente(bool? value) {
    _errorInfoGuardiaPorCliente = value;
    notifyListeners();
  }

  Future buscaInfoGuardiasPorCliente(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllGuardiasPorCliente(
      search: _search,
      // estado: 'GUARDIAS',
      docnumero: infDocNumDirigido,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoGuardiaPorCliente = true;

      // print('${response.data[0].infAsunto} ${response.data[0].infLugar}');
      //  _listaInfoGuardiaPorCliente=response['data'];

      setInfoBusquedaInfoGuardiaPorCliente(response['data']);
      // print('DATOS DESDE LA BASE: ${response['data']}');

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoGuardiaPorCliente = false;
      notifyListeners();
      return null;
    }
  }

//===================BUSCAR PERSONA DIRIGIDO A=====================//
  List _listaPersonaDirigidoA = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaPersonaDirigidoA => _listaPersonaDirigidoA;

  void setInfoBusquedaPersonaDirigidoA(List data) {
    _listaPersonaDirigidoA = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de PERSONA DIRIGIDO A: ${_listaPersonaDirigidoA}');
    notifyListeners();
  }

  bool? _errorPersonaDirigidoA; // sera nulo la primera vez
  bool? get getErrorPersonaDirigidoA => _errorPersonaDirigidoA;
  set setErrorPersonaDirigidoA(bool? value) {
    _errorPersonaDirigidoA = value;
    notifyListeners();
  }

  Future buscaPersonaDirigidoAs(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllPersonasDirigidoA(
      search: _search,
      estado: _labelInformePara,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorPersonaDirigidoA = true;

      // print('${response.data[0]}');
      //  _listaPersonaDirigidoA=response.data;
      setInfoBusquedaPersonaDirigidoA(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorPersonaDirigidoA = false;
      notifyListeners();
      return null;
    }
  }
}
