import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/crea_foto_multas.dart';
import 'package:sincop_app/src/models/foto_url.dart';
import 'package:sincop_app/src/models/get_info_guardia_multa.dart';
import 'package:sincop_app/src/models/lista_allClientes.dart';
import 'package:sincop_app/src/models/lista_allNovedades_guardia.dart';
import 'package:sincop_app/src/models/lista_allTipos_multas.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:http/http.dart' as _http;
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/service/notifications_service.dart' as snaks;
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:provider/provider.dart';

class MultasGuardiasContrtoller extends ChangeNotifier {
  GlobalKey<FormState> multasGuardiaFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> validaMultasGuardiaFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> validaMultasApelacionFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();
  Session? infoUser;

  MultasGuardiasContrtoller() {
    getTodasLasMultasGuardia('');
    getTodoosLosTiposDeMultasGuardia();
    // buscaGuardiaMultas();
    formatofecha();
  }
  bool validateForm() {
    if (multasGuardiaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormValidaMulta() {
    if (validaMultasGuardiaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormApelacionMulta() {
    if (validaMultasApelacionFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

//================================== OBTENEMOS TODAS LAS NOVEDADES  ==============================//
  List<Result> _listaTodasLasMultas = [];
  List<Result> get getListaTodasLasMultasGuardias => _listaTodasLasMultas;

  void setListaTodasLasMultas(List<Result> data) {
    _listaTodasLasMultas = data;
    // print('data : ${_listaTodasLasMultas}');
    notifyListeners();
  }

  bool? _errorMultas; // sera nulo la primera vez
  bool? get getErrorMultas => _errorMultas;

  Future<AllNovedadesGuardia?> getTodasLasMultasGuardia(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllMultasGuardias(
      // cantidad: 100,
      // page: 0,
      search: search,
      // input: 'nomId',
      // orden: false,
      // datos: '',
      // rucempresa: '${dataUser!.rucempresa}',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorMultas = true;
List<Result> daraSort=[];
       daraSort = response.data;
      // print('DARA NORMAL:$daraSort');
      daraSort.sort((a, b) => b.nomFecReg!.compareTo(a.nomFecReg!));
      // print('DARA SORT:${daraSort.nomFecReg}');

      setListaTodasLasMultas(daraSort);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorMultas = false;
      notifyListeners();
      return null;
    }
    return null;
  }
//   Future<AllNovedadesGuardia?> getTodasLasMultasGuardia(String? search) async {
//     final dataUser = await Auth.instance.getSession();
// // print('usuario : ${dataUser!.rucempresa}');
//     final response = await _api.getAllMultasGuardias(
//       cantidad: 100,
//       page: 0,
//       search: search,
//       input: 'nomId',
//       orden: false,
//       datos: '',
//       rucempresa: '${dataUser!.rucempresa}',
//       token: '${dataUser.token}',
//     );
//     if (response != null) {
//       _errorMultas = true;
//       setListaTodasLasMultas(response.data.results);

//       notifyListeners();
//       return response;
//     }
//     if (response == null) {
//       _errorMultas = false;
//       notifyListeners();
//       return null;
//     }
//     return null;
//   }

  //===================SELECCIONAMOS EL LA OBCION DE LA MULTA==========================//
  var _idMulta;
  String _origen = '';
  String _textoTipoMulta = '';
  String _tipoMulta = '';

  var _itemTipoMulta;
  var _porcentajeTipoMulta;
  get getIdMulta => _idMulta;
  get getOrigenMulta => _origen;
  get getTipoMulta => _tipoMulta;
  get getItemTipoMulta => _itemTipoMulta;
  String get getTextoTipoMulta => _textoTipoMulta;
  get getPorcentajeTipoMulta => _porcentajeTipoMulta;
  final Map<String, dynamic> _datosMulta = {};
  Map<String, dynamic> get getdatosMulta => _datosMulta;

  void setItenTipoMulta(value, idMulta, origen, tipo, porcentaje, text) {
    _idMulta = idMulta;
    _origen = origen;
    _tipoMulta = tipo;
    _itemTipoMulta = value;
    _porcentajeTipoMulta = porcentaje;
    _textoTipoMulta = text;

    // print('--idMULTA-->:$_idMulta');
    // print('--origen MULTA-->:$_origen');
    // print('--Tipo Multa-->:$_tipoMulta');
    // print('--PORCENTAJE MULTA-->:$_porcentajeTipoMulta');
    // print('--TEXTO MULTA-->:$_textoTipoMulta');

    notifyListeners();
  }

// //===================SELECCIONAMOS EL LA OBCION DE LA MULTA==========================//

//   String _textoTipoMulta = '';

//   var _itemTipoMulta;
//   get getItemTipoMulta => _itemTipoMulta;
//   get getTextoTipoMulta => _textoTipoMulta;
//   void setItenTipoMulta(value, text) {
//     _itemTipoMulta = value;
//     _textoTipoMulta = text;
//     // _inputValorfactura = 0.0;
//     // _inventarioSINOF = (text == 3) ? 'SI' : 'NO';
//     print('--ITEM MULTA-->:$_itemTipoMulta');
//     print('--ITEM TEXTO-->:$_textoTipoMulta');

//     notifyListeners();
//   }
//========================== GEOLOCATOR =======================//
  String? _coordenadas = "";
  Geolocator.Position? _position;
  Geolocator.Position? get position => _position;
  String? _selectCoords = "";
  String? get getCoords => _selectCoords;
  set setCoords(String? value) {
    _selectCoords = value;
  }

  Future<bool?> checkGPSStatus() async {
    final isEnable = await Geolocator.Geolocator.isLocationServiceEnabled();
    Geolocator.Geolocator.getServiceStatusStream().listen((event) {
      final isEnable = (event.index == 1) ? true : false;
      // print('--GPS->:$event');
    });
    return isEnable;
  }

  Future<void> getCurrentPosition() async {
    // checkGPSStatus();
    late LocationSettings locationSettings;

    locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    _position =
        await Geolocator.GeolocatorPlatform.instance.getCurrentPosition();
    _position = position;
    _selectCoords = ('${position!.latitude},${position!.longitude}');
    _coordenadas = _selectCoords;
    // print(_selectCoords);
    notifyListeners();
  }

//================================== OBTENEMOS TODOS LOS TIPOS DE MULTAS  ==============================//
  List<TipoMulta> _listaTodosLosTiposDeMultas = [];
  List<TipoMulta> get getListaTodosLosTiposDeMultas =>
      _listaTodosLosTiposDeMultas;

  void setListaTodosLosTiposDeMultas(List<TipoMulta> data) {
    _listaTodosLosTiposDeMultas = data;
    // print('data TIPO: ${_listaTodosLosTiposDeMultas}');
    notifyListeners();
  }

  bool? _errorTiposMultas; // sera nulo la primera vez
  bool? get getErrorTiposMultas => _errorTiposMultas;

  Future<AllTiposMultasGuardias?> getTodoosLosTiposDeMultasGuardia() async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllTiposMultasGuardias(
      search: 'MULTAS',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      // print('data dddd: ${response.data.results[0].nomDetalle}');
      _errorTiposMultas = true;
      setListaTodosLosTiposDeMultas(response.data);
      // _listaTodasLasNovedades=response.data.results;
      // print('COBECERA INFO: ${response.data.runtimeType}');
      // print('data LISTA INFO: ${response.data[0].novlista![0].runtimeType}');
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorTiposMultas = false;
      notifyListeners();
      return null;
    }
    // return null;
  }

//==========================================================//
  //========================== VALIDA CAMPO  FECHA FIN CONSIGNA =======================//
  String? _inputFechaMulta;
  get getInputFechamulta => _inputFechaMulta;
  void onInputFechaMultaChange(String? date) {
    _inputFechaMulta = date;
    // print('FECHA MULTA :$_inputFechaMulta');

    notifyListeners();
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  int id = 0;
  File? _newPictureFile;
  File? get getNewPictureFile => _newPictureFile;
  final List _listaFotosUrlMultas = [];

  List<CreaNuevaFotoMultas?> _listaFotoMulta = [];
  List<CreaNuevaFotoMultas?> get getListaFotosMultas => _listaFotoMulta;
  void setNewPictureFile(String? path) {
    _newPictureFile = File?.fromUri(Uri(path: path));
    upLoadImagen();
    _listaFotoMulta.add(CreaNuevaFotoMultas(id, _newPictureFile!.path));
    id = id + 1;
    notifyListeners();
  }

  void eliminaFoto(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    _listaFotoMulta.removeWhere((element) => element!.id == id);

    notifyListeners();
    // print('------LISTA ---.${_listaFotoMulta.length}');
  }

  int idFotoApelacion = 0;
  File? _newPictureFileApelacion;
  File? get getNewPictureFileApelacion => _newPictureFileApelacion;
  final List _listaFotosUrlMultasApelacion = [];

  List<CreaNuevaFotoMultas?> _listaFotoMultaApelacion = [];
  List<CreaNuevaFotoMultas?> get getListaFotosMultasApelacion =>
      _listaFotoMulta;
  void setNewPictureFileApelacion(String? path) {
    _newPictureFileApelacion = File?.fromUri(Uri(path: path));
    upLoadImagen();
    _listaFotosUrlMultasApelacion
        .add(CreaNuevaFotoMultas(id, _newPictureFileApelacion!.path));
    id = id + 1;
    notifyListeners();
  }

  void eliminaFotoApelacion(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    _listaFotoMulta.removeWhere((element) => element!.id == id);

    notifyListeners();
    // print('------LISTA ---.${_listaFotoMulta.length}');
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
    setNewPictureFile(pickedFile.path);
    // print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');
  }

  String? _inputDetalleNovedad;
  get getInputDetalleNovedad => _inputDetalleNovedad;
  void onInputDetalleNovedadChange(String? text) {
    _inputDetalleNovedad = text;
    // print('DETALLE MULTA :$_inputDetalleNovedad');

    notifyListeners();
  }

  String? _inputAnulacionDeMulta;
  get getInputAnulacionDeMulta => _inputAnulacionDeMulta;
  void onInputAnulacionDeMultaChange(String? text) {
    _inputAnulacionDeMulta = text;
    // print('DETALLE MULTA :$_inputAnulacionDeMulta');

    notifyListeners();
  }

  String? _inputCiudad;
  get getInputCiudad => _inputCiudad;
  void onInputCiudadChange(String? text) {
    _inputCiudad = text;
    // print('DETALLE MULTA :$_inputDetalleNovedad');

    notifyListeners();
  }

  // String? _inputBuscaGuardia;
  // get getInputBuscaGuardia => _inputBuscaGuardia;
  // void onInputBuscaGuardiaChange(String? text) {
  //   _inputBuscaGuardia = text;
  //   // print('DETALLE MULTA :$_inputBuscaGuardia');

  //   notifyListeners();
  // }

  String? _inputBuscaPersona;
  get getInputBuscaPersona => _inputBuscaPersona;
  void onInputBuscaPersonaChange(String? text) {
    _inputBuscaPersona = text;
    // print('INPUTBUSCA PERSONA :$_inputBuscaPersona');

    notifyListeners();
  }

  Future<String?> upLoadImagen() async {
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
      print(fotoUrl);

      // _listaFotosUrlMultas.add(fotoUrl);
      _listaFotosUrlMultas.addAll([
        {
          "nombre": responseFoto
              .urls[0].nombre, // al consumir el endpoint => perDocNumero
          "url": responseFoto.urls[0].url
        }
      ]);

      //  print('------LISTA FOTO---.${_listaFotosUrlMultas.length}');
      // print('------LISTA FOTO url mults ---.${_listaFotosUrlMultas}');
    }
    for (var item in _listaFotosUrlMultas) {
      // print('imagen URL: $item');
    }
  }

  Future<String?> upLoadImagenApelacion() async {
    final dataUser = await Auth.instance.getSession();

    //for multipartrequest
    var request = _http.MultipartRequest(
        'POST', Uri.parse('https://backsigeop.neitor.com/api/multimedias'));

    //for token
    request.headers.addAll({"x-auth-token": '${dataUser!.token}'});

    request.files.add(await _http.MultipartFile.fromPath(
        'foto', _newPictureFileApelacion!.path));

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

      // _listaFotosUrlMultas.add(fotoUrl);
      _listaFotosUrlMultasApelacion.addAll([
        {
          "nombre": responseFoto
              .urls[0].nombre, // al consumir el endpoint => perDocNumero
          "url": responseFoto.urls[0].url
        }
      ]);

      //  print('------LISTA FOTO---.${_listaFotosUrlMultas.length}');
      // print('------LISTA FOTO url mults ---.${_listaFotosUrlMultas}');
    }
    for (var item in _listaFotosUrlMultasApelacion) {
      // print('imagen URL: $item');
    }
  }

  void resetValuesMulta() {
    _listaInfoGuardia.clear();
    _listaFotosUrlMultas.clear();
    _listaFotosUrlMultasApelacion.clear();
    _listaFotoMulta.clear();
    _listaComparteClienteMultas.clear();
    _errorInfoGuardia = false;

    _pathVideo = '';
    _urlVideo = '';
    notifyListeners();
    notifyListeners();
  }

//================================== BUSCA GUARDIA PARA ASIGNAR MULTA  ==============================//
  List<Guardia> _listaInfoGuardia = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List<Guardia> get getInfoGuardia => _listaInfoGuardia;

  void setInfoGuardia(List<Guardia> data) {
    _listaInfoGuardia = data;
    // print('data TIPO: ${_listaInfoGuardia}');
    notifyListeners();
  }

  bool? _errorInfoGuardia; // sera nulo la primera vez
  bool? get getErrorInfoGuardia => _errorInfoGuardia;
  set setErrorInfoGuardia(bool? value) {
    _errorInfoGuardia = value;
  }

  int? _idPersona;
  String? _cedPersona;
  String? _nombrePersona;
  String? get getIdPersona => _cedPersona;
  String? get getCedPersona => _cedPersona;
  String? get getNomPersona => _cedPersona;

  Future<AllGuardias?> s() async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllInfoGuardias(
      search: _inputBuscaGuardia,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoGuardia = true;
      setInfoGuardia(response.data);
      _idPersona = response.data[0].perId;
      _cedPersona = response.data[0].perDocNumero;
      _nombrePersona =
          '${response.data[0].perNombres}' ' ${response.data[0].perApellidos}';

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoGuardia = false;
      notifyListeners();
      return null;
    }
  }

  bool? _errorInfoCompartirGuardia; // sera nulo la primera vez
  bool? get getErrorInfoCompartirGuardia => _errorInfoCompartirGuardia;
  set setErrorInfoCompartirGuardia(bool? value) {
    _errorInfoCompartirGuardia = value;
  }

  List<Guardia> _listaInfoCompartir = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List<Guardia> get getInfoCompartir => _listaInfoGuardia;

  void setInfoBusquedaCompartirGuardia(List<Guardia> data) {
    _listaInfoCompartir = data;
    // print('data TIPO: ${_listaInfoGuardia}');
    notifyListeners();
  }

  int? _idPersonaCompartir;
  String? _cedPersonaCompartir;
  String? _nombrePersonaCompartir;
  String? get getIdPersonaCompartir => _cedPersonaCompartir;
  String? get getCedPersonaCompartir => _cedPersonaCompartir;
  String? get getNombrePersonaCompartir => _cedPersonaCompartir;

  Future<AllGuardias?> buscaCompartirMulta() async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllInfoGuardias(
      search: _inputBuscaGuardia,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoCompartirGuardia = true;
      setInfoBusquedaCompartirGuardia(response.data);
      _idPersonaCompartir = response.data[0].perId;
      _cedPersonaCompartir = response.data[0].perDocNumero;
      _nombrePersonaCompartir = response.data[0].perNombres;

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoCompartirGuardia = false;
      notifyListeners();
      return null;
    }
  }

  String? _fechaActual;
  get getFechaActul => _fechaActual;

  formatofecha() {
    DateTime? data = DateTime.now();
    String? anio, mes, dia;
    anio = '${data.year}';
    mes = (data.month < 10) ? '0${data.month}' : '${data.month}';
    dia = (data.day < 10) ? '0${data.day}' : '${data.day}';

    // setState(() {
    _fechaActual = '${anio.toString()}-${mes.toString()}-${dia.toString()}';

    // print('Fecha actual $_fechaActual');
    _inputFechaMulta = _fechaActual;

    return _fechaActual;
  }

  void getInfomacionGuardia(int id, String cedula, String nombre,
      String apellido, String lugarTrabajo, List puestoServicio) {
    _idPersonaMulta = id;
    _cedPersonaMulta = cedula;
    _nombrePersonaMulta = '$nombre $apellido';
    _lugarTrabajoPersonaMulta = lugarTrabajo;
    _puestoServicio = puestoServicio;
// print('${_idPersonaMulta}-${_cedPersonaMulta}-${_nombrePersonaMulta}');
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  Future creaMultaGuardia(
    BuildContext context,
  ) async {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    print(
        '========================= GUARDA NUEVA CONSIGNA ================================');

    infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadNuevaMulta = {
      "tabla": "nominanovedad", // defecto
      "rucempresa": infoUser!.rucempresa, // LOGIN
      "rol": infoUser!.rol, // LOGIN
      "nomCodigo": _idMulta, // datos de la multa, propiedad => novId
      "nomOrigen": _origen, // datos de la multa, propiedad => novOrigen
      "nomTipo": _tipoMulta, // datos de la multa, propiedad => novTipo
      "nomPorcentaje":
          _porcentajeTipoMulta, // datos de la multa, propiedad => novPorcentaje
      "nomSueldo": "",
      "nomDescuento": "",
      "nomDetalle": _textoTipoMulta, //input
      "nomObservacion": _inputDetalleNovedad, //input
      "nomFotos": _listaFotosUrlMultas, //input
      "nomVideo": _listaVideosUrl,
      "nomCompartido": _listaComparteClienteMultas, //input
      "nomEstado": "ACTIVA", // POR DEFECTO
      "nomCiudad": _lugarTrabajoPersonaMulta, // input
      "nomAnulacion": "", // esto input aparecera si actualiza el estado
      "nomFecha": _inputFechaMulta, // input
      "nomIdPer":
          _idPersonaMulta, // Esto datos tomar de un endpoint(luego que paso el endpoint)
      "nomDocuPer":
          _cedPersonaMulta, // Esto datos tomar de un endpoint(luego que paso el endpoint)
      "nomNombrePer":
          _nombrePersonaMulta, // Esto datos tomar de un endpoint(luego que paso el endpoint)
      "nomPuesto": _puestoServicio,
      "nomUser": infoUser!.usuario, // LOGIN
      "nomEmpresa": infoUser!.rucempresa, // LOGIN
      "nomApelacionTexto": "",
      "nomApelacionFotos": [],
      "nomApelacionFecha": "",
      "nomApelacionTextoAceptada": "",
      "nomApelacionFechaAceptada": "",
      "nomApelacionUserAceptada": "",

      "nomFecReg": _nomFecReg,
      "Todos": _todos,
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVA MULTA ===============================');

    // print(
    //     '==========================JSON DE PERSONAL DEIGNADO ===============================');

    serviceSocket.socket!.emit('client:guardarData', _pyloadNuevaMulta);
    serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'nominanovedad') {
        // print(
        //     '==========================JSON PARA CREAR NUEVA MULTA ===============================');
        // print('RESPUESTA DEL SOCKET===> $data');

        //  setListaTodasLasMultas(data);
        getTodasLasMultasGuardia('');

        // getTodoosLosTiposDeMultasGuardia();
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

//================================== CREA NUEVA CONSIGNA  ==============================//
  Future actualizaEstadoMulta(BuildContext context, Result multas) async {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    // print(
    //     '========================= GUARDA NUEVA CONSIGNA ================================');

    final infoUser = await Auth.instance.getSession();
    // print(
    //     '==========================DATOS DEL TELEFONO ===============================');

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadActualizaEstadoMulta = {
      "tabla": "nominanovedad", // defecto
      "rucempresa": infoUser!.rucempresa, // LOGIN
      "rol": infoUser.rol, // LOGIN
      "nomId": multas.nomId, // ID de registro
      "nomCodigo": multas.nomCodigo, // datos de la multa, propiedad => novId
      "nomOrigen":
          multas.nomOrigen, // datos de la multa, propiedad => novOrigen
      "nomTipo": multas.nomTipo, // datos de la multa, propiedad => novTipo
      "nomPorcentaje":
          multas.nomPorcentaje, // datos de la multa, propiedad => novPorcentaje
      "nomDetalle": multas.nomDetalle, //input
      "nomObservacion": multas.nomObservacion, //input
      "nomFotos": multas.nomFotos, //input
      "nomVideo": "", //input
      "nomEstado": "INACTIVA", // POR DEFECTO
      "nomAnulacion":
          _inputAnulacionDeMulta, // esto input aparecera si actualiza el estado
      "nomCiudad": "SANTO DOMINGO", // input
      "nomFecha": multas.nomFecha, // input
      "nomIdPer": multas
          .nomIdPer, // Esto datos tomar de un endpoint(luego que paso el endpoint)
      "nomDocuPer": multas
          .nomDocuPer, // Esto datos tomar de un endpoint(luego que paso el endpoint)
      "nomNombrePer": multas
          .nomNombrePer, // Esto datos tomar de un endpoint(luego que paso el endpoint)
      "nomUser": infoUser.usuario, // LOGIN
      "nomEmpresa": infoUser.rucempresa // LOGIN
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVA MULTA ===============================');
    // // print(_pyloadActualizaEstadoMulta);
    // print(
    //     '==========================JSON DE PERSONAL DEIGNADO ===============================');

    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadActualizaEstadoMulta);
    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'nominanovedad') {
        // print(
        //     '==========================JSON PARA CREAR NUEVA MULTA ===============================');
        // print('RESPUESTA DEL SOCKET===> $data');

        getTodasLasMultasGuardia('');
        // getTodoosLosTiposDeMultasGuardia();
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

  //================================== ELIMINAR  MULTA  ==============================//
  Future eliminaMultaGuardia(BuildContext context, Result? multaGuardia) async {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadEliminaMultaGuardia = {
      "tabla": "nominanovedad", // defecto
      "nomId": multaGuardia!.nomId,
      "rucempresa": infoUser!.rucempresa, //login
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');

    serviceSocket.socket!
        .emit('client:eliminarData', _pyloadEliminaMultaGuardia);
    serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
      if (data['tabla'] == 'nominanovedad') {
        getTodasLasMultasGuardia('');
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

//======================================================OBTIENE DATOS DEL GUARDIAMULTA============================================//
  int? _idPersonaMulta;
  String? _cedPersonaMulta;
  String? _nombrePersonaMulta;
  String? _lugarTrabajoPersonaMulta;
  List? _puestoServicio = [];

  int? get getIdPersonaMulta => _idPersonaMulta;
  String? get getCedPersonaMulta => _cedPersonaMulta;
  String? get getNomPersonaMulta => _nombrePersonaMulta;
  String? get getlugarTrabajoPersonaMulta => _lugarTrabajoPersonaMulta;
  List? get getPuestoServicio => _puestoServicio;

  set setIdPersonaMulta(int? id) {
    _idPersonaMulta = id;

    notifyListeners();
  }

  set setCedPersonaMulta(String? cedula) {
    _cedPersonaMulta = cedula;

    notifyListeners();
  }

  set setNomPersonaMulta(String? nombre) {
    _nombrePersonaMulta = nombre;

    notifyListeners();
  }

  set setlugarTrabajoPersonaMulta(String? lugarTrabajo) {
    _lugarTrabajoPersonaMulta = lugarTrabajo;

    notifyListeners();
  }

  set setPuestoServicio(List? puestoTrabajo) {
    _puestoServicio = puestoTrabajo;

    notifyListeners();
  }

  //===================LEE CODIGO QR==========================//
  // Map<int, String>? _elementoQRMulta = {};
  String? _infoQRTurnoMulta;
  String? get getInfoQRMultaGuardia => _infoQRTurnoMulta;

  Future setInfoQRMultaGuardia(String? value) async {
    _infoQRTurnoMulta = value;
    // print('info GUARDIA MULTA: $_infoQRTurnoMulta');
    if (_infoQRTurnoMulta != null) {
      _errorInfoMultaGuardia = true;
      final split = _infoQRTurnoMulta!.split('-');
      setIdPersonaMulta = int.parse(split[0]);
      setCedPersonaMulta = split[1];
      setNomPersonaMulta = split[2];
      setlugarTrabajoPersonaMulta = split[2];

      notifyListeners();
    } else {
      _errorInfoMultaGuardia = false;
    }
  }
  //===================INGRESA CODIGO O NOMBRE GUARDIA MULTA==========================//

//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaGuardiasMultas;

  @override
  void dispose() {
    _deboucerSearchBuscaGuardiasMultas?.cancel();
    _deboucerSearchBuscaClienteMultas?.cancel();
    super.dispose();
  }

  String? _inputBuscaGuardia;
  get getInputBuscaGuardia => _inputBuscaGuardia;
  void onInputBuscaGuardiaChange(String? text) {
    _inputBuscaGuardia = text;
    // print('GUSCA GUARDIA MULTA :$_inputBuscaGuardia');

//================================================================================//
    if (_inputBuscaGuardia!.length >= 3) {
      _deboucerSearchBuscaGuardiasMultas?.cancel();
      _deboucerSearchBuscaGuardiasMultas =
          Timer(const Duration(milliseconds: 500), () {
        buscaGuardiaMultas(_inputBuscaGuardia);
        //  print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaGuardia!.isEmpty) {
      buscaGuardiaMultas('');
    } else {
      buscaGuardiaMultas('');
    }
//================================================================================//

    notifyListeners();
  }

  List<Guardia> _listaInfoMultaGuardia = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List<Guardia> get getListaInfoMultaGuardia => _listaInfoMultaGuardia;

  void setInfoBusquedaMultaGuardia(List<Guardia> data) {
    _listaInfoMultaGuardia = data;
    // print('Lista dde guardias : ${_listaInfoMultaGuardia}');
    notifyListeners();
  }

  bool? _errorInfoMultaGuardia; // sera nulo la primera vez
  bool? get getErrorInfoMultaGuardia => _errorInfoMultaGuardia;
  set setErrorInfoMultaGuardia(bool? value) {
    _errorInfoMultaGuardia = value;
    notifyListeners();
  }
//REVISAR

  String? _textDocNumDirigidoA = '';
  Future<AllGuardias?> buscaGuardiaMultas(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllInfoGuardias(
      search: _search,
      docnumero: _textDocNumDirigidoA,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoMultaGuardia = true;
      // setInfoBusquedaMultaGuardia(response.data);
      // setIdPersonaMulta = response.data[0].perId;
      // setCedPersonaMulta = response.data[0].perDocNumero;
      // setNomPersonaMulta = '${response.data[0].perNombres} ${response.data[0].perApellidos}';
      //  _listaInfoMultaGuardia=response.data;
      setInfoBusquedaMultaGuardia(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoMultaGuardia = false;
      notifyListeners();
      return null;
    }
  }

// //================================== OBTENEMOS TODOS LOS CLIENTES ==============================//
//   List<InfoCliente> _listaTodosLosClientesMultas = [];
//   List<InfoCliente> get getListaTodosLosClientes =>
//       _listaTodosLosClientesMultas;

//   void setListaTodosLosClientesMultas(List<InfoCliente> data) {
//     _listaTodosLosClientesMultas = data;
//     // print('data clientes : ${_listaTodosLosClientesMultas}');
//     notifyListeners();
//   }

//   bool? _errorClientesMultas; // sera nulo la primera vez
//   bool? get getErrorClientesMultas => _errorClientesMultas;

//   Future<AllClientes?> getTodosLosClientesMultas(String? search) async {
//     final dataUser = await Auth.instance.getSession();
// // print('usuario : ${dataUser!.rucempresa}');
//     final response = await _api.getAllClientesMultas(
//       // cantidad: 100,
//       // page: 0,
//       search: search,
//       // input: 'cliId',
//       // orden: false,
//       // datos: '',
//       // rucempresa: '${dataUser!.rucempresa}',
//       estado: 'CLIENTES',
//       token: '${dataUser!.token}',
//     );
//     if (response != null) {
//       _errorClientesMultas = true;
//       setListaTodosLosClientesMultas(response.data);

//       notifyListeners();
//       return response;
//     }
//     if (response == null) {
//       _errorClientesMultas = false;
//       notifyListeners();
//       return null;
//     }
//     return null;
//   }
//================================== OBTENEMOS TODOS LOS CLIENTES ==============================//
  List<InfoCliente> _listaTodosLosClientesMultas = [];
  List<InfoCliente> get getListaTodosLosClientes =>
      _listaTodosLosClientesMultas;

  void setListaTodosLosClientesMultas(List<InfoCliente> data) {
    _listaTodosLosClientesMultas = data;
    // print('data clientes : ${_listaTodosLosClientesMultas}');
    notifyListeners();
  }

  bool? _errorClientesMultas; // sera nulo la primera vez
  bool? get getErrorClientesMultas => _errorClientesMultas;

  Future<AllClientes?> getTodosLosClientesMultas(String? search) async {
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
      _errorClientesMultas = true;
      setListaTodosLosClientesMultas(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorClientesMultas = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//  =================  AGREGA CORREOS CLIENTE MULTAS ==================//

  List<dynamic> _listaComparteClienteMultas = [];
  List<dynamic> get getListaCorreosClienteMultas => _listaComparteClienteMultas;

  void setListaCorreosClienteMultas(
      int? id, String? documento, String? nombres, List<dynamic>? correo) {
    // _listaComparteClienteMultas!.addAll([correo!.toString()]);
    // _listaComparteClienteMultas!.addAll([correo!.toString()]);
    _listaComparteClienteMultas.removeWhere((e) => (e['id'] == id));

    _listaComparteClienteMultas.addAll([
      {
        "id": id!.toInt(),
        "docnumero": documento,
        "nombres": nombres,
        "compartido": true,
        "email": correo,
      }
    ]);
    // print('CORREO:$_listaComparteClienteMultas ');

    notifyListeners();
  }

  void eliminaClienteMulta(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    // print(id);
    // _listaComparteClienteMultas.removeWhere((element) => element.id == id);

    _listaComparteClienteMultas.removeWhere((e) => e['id'] == id);
    _listaComparteClienteMultas.forEach(((element) {
      // print('${element['nombres']}');
    }));

    notifyListeners();
    // print('------LISTA ---.${_listaComparteClienteMultas.length}');
  }
//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaClienteMultas;

  String? _inputBuscaClienteMultas;
  get getInputBuscaClienteMulta => _inputBuscaClienteMultas;
  void onInputBuscaClienteMultaChange(String? text) {
    _inputBuscaClienteMultas = text;
    // print(' GUARDIA MULTA :$_inputBuscaClienteMultas');

//================================================================================//
    if (_inputBuscaClienteMultas!.length >= 3) {
      _deboucerSearchBuscaClienteMultas?.cancel();
      _deboucerSearchBuscaClienteMultas =
          Timer(const Duration(milliseconds: 500), () {
        getTodosLosClientesMultas(_inputBuscaClienteMultas);
        //  print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaClienteMultas!.isEmpty) {
      getTodosLosClientesMultas('');
    } else {
      getTodosLosClientesMultas('');
    }
//================================================================================//

    notifyListeners();
  }

  //==========================TRABAJAMOS CON VIDEO  ===============================//

  String? _pathVideo =
      'https://movietrailers.apple.com/movies/independent/unhinged/unhinged-trailer-1_h720p.mov';
  String? get getPathVideo => _pathVideo;

  void setPathVideoMultas(String? path) {
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
      print("SUCCESS");
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
    // for (var item in _listaVideosUrl) {
    //   // print('VIDEO URL: $item');
    // }
  }

  void eliminaVideo() {
    _listaVideosUrl.clear();
    _urlVideo = '';
    _pathVideo = '';
    notifyListeners();
  }

//========================================//
  List _listaInfoCliente = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaInfoCliente => _listaInfoCliente;

  void setInfoBusquedaInfoCliente(List data) {
    _listaInfoCliente = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de Clientes SOCKET: ${_listaInfoCliente}');
    notifyListeners();
  }

  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  // late Informe _informeCliente;
  // Informe get getInforme => _informeCliente;

  // void setinformeCliente(Informe data) {
  //   _listaInfoCliente.add(data);

  //   notifyListeners();
  // }

  bool? _errorInfoCliente; // sera nulo la primera vez
  bool? get getErrorInfoCliente => _errorInfoCliente;
  set setErrorInfoCliente(bool? value) {
    _errorInfoCliente = value;
    notifyListeners();
  }

  Future buscaInfoClientes(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllClientesVarios(
      search: _search,
      estado: 'CLIENTES',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoCliente = true;

      // print('${response.data[0].infAsunto} ${response.data[0].infLugar}');
      //  _listaInfoCliente=response.data;
      setInfoBusquedaInfoCliente(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoCliente = false;
      notifyListeners();
      return null;
    }
  }

  String? _inputDetalleApelacion;
  get getInputDetalleApelacion => _inputDetalleApelacion;
  void onInputDetalleApelacionChange(String? text) {
    _inputDetalleApelacion = text;
    // print('DETALLE MULTA :$_inputDetalleApelacion');

    notifyListeners();
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  int? _nomId;
  String? _nomCodigo = "";
  String? _nomOrigen = "";
  String? _nomTipo = "";
  String? _nomPorcentaje = "";
  String? _nomSueldo = "";
  String? _nomDescuento = "";
  String? _nomDetalle = "";
  String? _nomObservacion = "";
  List? _nomFotosMultas = [];
  List? _nomVideoMultas = [];
  List? _nomCompartido = [];
  List? _nomPuesto = [];
  String? _nomEstado = "";
  String? _nomAnulacion = "";
  String? _nomCiudad = "";
  String? _nomFecha = "";
  String? _nomIdPer = "";
  String? _nomDocuPer = "";
  String? _nomNombrePer = "";
//  String? _nomApelacionTexto="";
  List? _nomApelacionFotos = [];
//  String? _nomApelacionFecha="";

  String? _nomApelacionTextoAceptada = "";
  String? _nomApelacionFechaAceptada = "";
  String? _nomApelacionUserAceptada = "";
  String? _nomFecReg = "";
  String? _todos = "";
  void getInfomacionMulta(multa) {
    // print('INFORMACION DE LA MULTA: ${multa}');
    //  print(multa.nomId);
    //  print(multa.nomCodigo);
    //  print(multa.nomOrigen);
    //  print(multa.nomTipo);
    //  print(multa.nomPorcentaje);
    //  print(multa.nomSueldo);
    //  print(multa.nomDescuento);
    //  print(multa.nomDetalle);
    //  print(multa.nomObservacion);
    //  print('FOTOS: ${multa.nomFotos}');
    //  print(multa.nomVideo);
    //  print(multa.nomCompartido);
    //  print(multa.nomPuesto);
    //  print(multa.nomEstado);
    //  print(multa.nomAnulacion);
    //  print(multa.nomCiudad);

    //  print(multa.nomFecha);
    //  print(multa.nomIdPer);
    //  print(multa.nomDocuPer);
    //  print(multa.nomNombrePer);
    //  print(multa.nomApelacionTexto);
    //  print(multa.nomApelacionFotos);
    //  print(multa.nomApelacionFecha);
    //  print(multa.nomApelacionFechaAceptada);
    //  print(multa.nomApelacionUserAceptada);

    //  print(multa.nomFecReg);
    //  print(multa.todos);
    _nomId = multa.nomId;
    _nomCodigo = multa.nomCodigo;
    _nomOrigen = multa.nomOrigen;
    _nomTipo = multa.nomTipo;
    _nomPorcentaje = multa.nomPorcentaje;
    _nomSueldo = multa.nomSueldo;
    _nomDescuento = multa.nomDescuento;
    _nomDetalle = multa.nomDetalle;
    _nomObservacion = multa.nomObservacion;

    for (var e in multa.nomFotos) {
      _nomFotosMultas!.add({"nombre": e.nombre, "url": e.url});
    }
    for (var e in multa.nomVideo) {
      _nomVideoMultas!.add({"nombre": e['nombre'], "url": e['url']});
    }
    for (var e in multa.nomApelacionFotos) {
      _listaFotosUrlMultasApelacion
          .add({"nombre": e['nombre'], "url": e['url']});
    }

    _nomCompartido = multa.nomCompartido;
    _nomPuesto = multa.nomPuesto;
    _nomEstado = multa.nomEstado;
    _nomAnulacion = multa.nomAnulacion;
    _nomCiudad = multa.nomCiudad;

    _nomFecha = multa.nomFecha.toString();
    _nomIdPer = multa.nomIdPer;
    _nomDocuPer = multa.nomDocuPer;
    _nomNombrePer = multa.nomNombrePer;
    //  _nomApelacionTexto= multa.nomApelacionTexto;
    //  _nomApelacionFotos= multa.nomApelacionFotos;
    //  _nomApelacionFecha= multa.nomApelacionFecha;

    _nomApelacionTextoAceptada = multa.nomApelacionTextoAceptada;
    _nomApelacionFechaAceptada = multa.nomApelacionFechaAceptada;
    _nomApelacionUserAceptada = multa.nomApelacionUserAceptada;

    _nomFecReg = multa.nomFecReg.toString();
    _todos = multa.todos;
  }

  Future creaApelacionMulta(BuildContext context) async {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    print(
        '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadCreaApelacionMulta = {
      "tabla": "nominanovedad", // defecto
      "rucempresa": infoUser!.rucempresa, // LOGIN
      "rol": infoUser.rol, // LOGIN
      "nomId": _nomId,
      "nomCodigo": _nomCodigo,
      "nomOrigen": _nomOrigen,
      "nomTipo": _nomTipo,
      "nomPorcentaje": _nomPorcentaje,
      "nomSueldo": _nomSueldo,
      "nomDescuento": _nomDescuento,
      "nomDetalle": _nomDetalle,
      "nomObservacion": _nomObservacion,
      "nomFotos": _nomFotosMultas,
      "nomVideo": _nomVideoMultas,
      "nomCompartido": _nomCompartido,
      "nomPuesto": _nomPuesto,
      "nomEstado": 'APELADA',
      "nomAnulacion": _nomAnulacion,
      "nomCiudad": _nomCiudad,
      "nomFecha": _nomFecha,
      "nomIdPer": _nomIdPer,
      "nomDocuPer": _nomDocuPer,
      "nomNombrePer": _nomNombrePer,
      "nomApelacionTexto": _inputDetalleApelacion,
      "nomApelacionFotos": _listaFotosUrlMultasApelacion,
      "nomApelacionFecha": DateTime.now().toString(),
      "nomApelacionTextoAceptada": _nomApelacionTextoAceptada,
      "nomApelacionFechaAceptada": _nomApelacionFechaAceptada,
      "nomApelacionUserAceptada": _nomApelacionUserAceptada,
      "nomUser": infoUser.usuario,
      "nomEmpresa": infoUser.nomEmpresa,
      "nomFecReg": _nomFecReg,
      "Todos": _todos,
    };
    // print(
    //     '==========================JSON PARA CREAR APELACION MULTA ===============================');
    // print(_pyloadCreaApelacionMulta);
    // print(
    //     '==========================JSON DE PERSONAL DEIGNADO ===============================');

    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadCreaApelacionMulta);
    // serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
    //   if (data['tabla'] == 'nominanovedad') {
    //     print(
    //         '==========================JSON PARA CREAR NUEVA MULTA ===============================');
    //     // print('RESPUESTA DEL SOCKET===> $data');

    //     getTodasLasMultasGuardia('');
    //     // getTodoosLosTiposDeMultasGuardia();
    //     snaks.NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //     // serviceSocket.socket?.clearListeners();
    //     notifyListeners();
    //   }
    // });
    // serviceSocket.socket?.on('server:error', (data) {
    //   snaks.NotificatiosnService.showSnackBarError(data['msg']);
    //   notifyListeners();
    // });
  }
}
