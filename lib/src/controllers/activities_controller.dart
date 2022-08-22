import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as _http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';

import 'package:sincop_app/src/models/crea_fotos.dart';
import 'package:sincop_app/src/models/foto_url.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';

class ActivitiesController extends ChangeNotifier {
  GlobalKey<FormState> actividadesFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> actividadesRondaFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();

  bool validateForm() {
    if (actividadesFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormRonda() {
    if (actividadesRondaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void resetValuesActividades() {
    _listaFotos.clear();
    _listaFotosRealizaActividades.clear();
    _listaFotosUrl.clear();
    _listaVideosUrl.clear();
    _urlVideo = '';
    _pathVideo = '';
    _infoQR = '';
    _detallePuntoPuesto = '';
    _nombrePuntoPuesto = '';
    dataRondas.clear();
    _rondaSave = '';
    _rondaGet = '';
    _listaPuestos.clear();
    _listaRespMovil.clear();
    _rondaCompleta = false;
    _elementoQR = {};
    notifyListeners();
  }

//================================== OBTENEMOS TODAS LAS NOVEDADES  ==============================//
  List _listaTodasLasActividades = [];
  List get getListaTodasLasActividades => _listaTodasLasActividades;

  void setListaTodasLasActividades(List data) {
    _listaTodasLasActividades = data;
    // print('data : ${_listaTodasLasActividades}');
    notifyListeners();
  }

  bool? _errorActividades; // sera nulo la primera vez
  bool? get getErrorActividades => _errorActividades;

  Future getTodasLasActividades(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllActividades(
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
      _errorActividades = true;
      setListaTodasLasActividades(response['data']);
      // print('TOTAL DE ACTIVIDADES: ${_listaTodasLasActividades.length}');

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorActividades = false;
      notifyListeners();
      return null;
    }

    return null;
  }

//========================== VALIDA CAMPO  FECHA INICIO CONSIGNA =======================//
  String? _inputObservacionesRealizaActivities;
  get getInputObservacionesRealizaActivities =>
      _inputObservacionesRealizaActivities;
  void onInputObservacionesRealizaActivitiesChange(String? date) {
    _inputObservacionesRealizaActivities = date;
    // print('object: $_inputObservacionesRealizaActivities');

    notifyListeners();
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA REALIZAR CONSIGNA=======================//
  int idFotoRealizaActividades = 0;
  File? _newPictureFileRealizaActividades;
  File? get getNewPictureFileRealizaActividades =>
      _newPictureFileRealizaActividades;

  final List<CreaNuevaFotoRealizaActividadGuardia?> _listaFotosRealizaActividades =
      [];
  List<CreaNuevaFotoRealizaActividadGuardia?>
      get getListaFotosListaFotosRealizaActividades =>
          _listaFotosRealizaActividades;
  void setNewPictureFileRealizaActividades(String? path) {
    _newPictureFileRealizaActividades = File?.fromUri(Uri(path: path));
    upLoadImagen(_newPictureFileRealizaActividades);
    _listaFotosRealizaActividades.add(CreaNuevaFotoRealizaActividadGuardia(
        idFotoRealizaActividades, _newPictureFileRealizaActividades!.path));

    idFotoRealizaActividades = idFotoRealizaActividades + 1;
    notifyListeners();
  }

  void eliminaFotoRealizaActividades(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    _listaFotosRealizaActividades.removeWhere((element) => element!.id == id);

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

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  int id = 0;
  File? _newPictureFile;
  File? get getNewPictureFile => _newPictureFile;
  final List _listaFotosUrl = [];

  final List<CreaNuevaFotoRealizaActividadGuardia?> _listaFotos = [];
  List<CreaNuevaFotoRealizaActividadGuardia?> get getListaFotos => _listaFotos;
  void setNewPictureFile(String? path) {
    _newPictureFile = File?.fromUri(Uri(path: path));
    upLoadImagen(_newPictureFile);
    _listaFotos
        .add(CreaNuevaFotoRealizaActividadGuardia(id, _newPictureFile!.path));
    id = id + 1;
    notifyListeners();
  }

  void setEditarFoto(int id, String path) {
    _listaFotos.add(CreaNuevaFotoRealizaActividadGuardia(id, path));

    notifyListeners();
  }

  void eliminaFoto(int id) {
    _listaFotos.removeWhere((element) => element!.id == id);

    notifyListeners();
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
      // final fotoUrl = responseFoto.urls[0];
      // print(fotoUrl);

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
    // for (var item in _listaFotosUrl) {
    //   // print('imagen URL: $item');
    // }
  }

  void eliminaFotoRealizaConsigna(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    _listaFotosRealizaActividades.removeWhere((element) => element!.id == id);

    notifyListeners();
  }

  //================================== ELIMINAR  COMUNICADO  ==============================//
  Future relizaGuardiaActividad(int? _idActividad, BuildContext context) async {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadRealizaGuardiaActividad = {
      "tabla": "actividadtrabajo", // defecto
      "rucempresa": infoUser!.rucempresa, // login
      "rol": infoUser.rol, //login
      "actId": _idActividad, // id de actividad
      "actIdPersona": infoUser.id, // login
      "detalle": _inputObservacionesRealizaActivities,
      "fotos": _listaFotosUrl,
      "video": _urlVideo,
      "qr": _infoQR,
      "rondas": []
    };

    // print(
    //     '================================== PAYLOAD EJECUTA ACTIVIDADES   ==============================');
    // print('$_pyloadRealizaGuardiaActividad');
    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadRealizaGuardiaActividad);
  }
  //==========================TRABAJAMOS CON VIDEO  ===============================//

  // String? _pathVideo =
  //     'https://movietrailers.apple.com/movies/independent/unhinged/unhinged-trailer-1_h720p.mov';
  // String? get getPathVideo => _pathVideo;
  String? _pathVideo = '';
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
    // 'url del video es =======*******************************========> : $_urlVideo');
    notifyListeners();
  }
//============================LOAD VIDEO===========================================//

  final List<dynamic> _listaVideosUrl = [];
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
      // final _urlVideo = responseVideo.urls[0];
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

  //===================LEE CODIGO QR==========================//

  String? _nombrePuestoQR = '';
  String? get getNombrePuestoQR => _nombrePuestoQR;
  void setNombrePuestoQR(String? value) {
    _nombrePuestoQR = value;
    // print('NOMBRE PUESTO QR =====> : $_nombrePuestoQR');
    // notifyListeners();
  }

  Map<int, String>? _elementoQR = {};
  String? _elementoPuestoQR = '';
  Map<int, String>? get getElementoQR => _elementoQR;
  String? _infoQR = '';
  String? get getInfoQR => _infoQR;
    List<String>? splitData ;

  void setInfoQR(String? value) {
      // print('_DATA QR  =====> : ${value}');
    // _infoQR = value;
    // print('info =====> : $_infoQR');

if(value!.isNotEmpty){
  if(value=='http'){
 value='';
  }else{
 splitData = value.split('-');

    _elementoPuestoQR = splitData![3].trim();
  }
   
  

}else{
  value='';
}

  
  
   if (_elementoPuestoQR == _nombrePuestoQR) {
      _elementoQR = {for (int i = 0; i < splitData!.length; i++) i: splitData![i]};

      // print('========================= NOMBRE DEL PUESTO SI ES IGUAL =====> ${_nombrePuestoQR!.length} : ${_elementoPuestoQR!.length}');

    } else {
      _elementoQR = {};
      NotificatiosnService.showSnackBarError('Puesto no Asignado');
      // print('========================= NOMBRE DEL PUESTO NOOOOOOOO ES IGUAL =====> ${_nombrePuestoQR!.length} : ${_elementoPuestoQR!.length}');

    }
    notifyListeners();
  }

//================== VALIDA CODIGO QR INICIA TURNO ===========================//
  Future<void> validaCodigoQR(BuildContext context) async {}
// ===========================REALIZAZ RONDA ACTIVIDAD=============================================//
// Map<String,dynamic> dataRondas={};
  List<dynamic> dataRondas = [];

  String _nombrePuntoPuesto = '';
  String? _fechaActualParse;

  String get getNombrePuntoPuesto => _nombrePuntoPuesto;
  void set getNombrePuntoPuesto(String nombrePunto) {
// var now = DateTime.now();
// final f=DateFormat('yyyy-MM-dd').format(DateTime.now());
// final h=DateFormat('HH:mm').format(DateTime.now());
    _fechaActualParse =
        '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm').format(DateTime.now())}';
    // print('_fechaActualParse: $_fechaActualParse');
    _nombrePuntoPuesto = nombrePunto;

    notifyListeners();
  }

  String _rondaSave = '';
  String _rondaGet = '';
  bool _rondaCompleta = false;
  bool get getRondaCompleta => _rondaCompleta;
  List<dynamic> _listaPuestos = [];
  final List<dynamic> _listaRespMovil = [];
  List<dynamic> get getlistaRespMovil => _listaRespMovil;
  List<dynamic> _listaCompletaParaGuardar = [];
  List<dynamic> get getlistaCompletaParaGuardar => _listaCompletaParaGuardar;
  // List<dynamic> _itemPuesto = [];

  int? _actividadId;
  int? get getRondaId => _actividadId;
  int? _numLugares;
  int? get getNumLugares => _numLugares;
  void setNumLugares(int? idAct, int? numLugares) {
    _numLugares = numLugares;
    _actividadId = idAct;
//  print('_rondaId : $_rondaId ==== numLugares $numLugares');
//  print('_numLugares : $_numLugares');
//  validaDataDispositivo();
// notifyListeners();
  }

//******************************** VALIDA DATA DEL DISPOSITIVO ********************************** */

  void validaDataDispositivo() async {
    final tablaResponspMovil = await Auth.instance.getRondasActividad();
//  await Auth.instance.deleteRondasActividad();
    if (tablaResponspMovil != null) {
      _listaPuestos = json.decode(tablaResponspMovil);
//
      for (var item in _listaPuestos) {
        if (item['idActividad'] == _actividadId &&
            item['rondas'].length == _numLugares) {
// print('SI ES IGUAL: $_actividadId === ${item['idActividad']}');
// print('RONDAS: ${item['rondas'].length}');
// print('david estamos listos}');
          _listaCompletaParaGuardar = _listaPuestos;
          _rondaCompleta = true;

          notifyListeners();
        } else {
          // print('NOOOOO ES IGUAL');
        }
      }

      // print('SE REDIBUJA');
    } else {
      // print('La informcion es NULA');
    }
  }

//****************************************************** AGREGA RONDA AL DISPOSITIVO ********************************** */

  Future<void> realizaRondaPunto(int? idRonda) async {
    if (_listaPuestos.isNotEmpty) {
      List result =
          _listaPuestos.where((o) => o['idActividad'] == idRonda).toList();
      if (result.isNotEmpty) {
        //  print('dataANTES ${result[0]['rondas']}');
        result[0]['rondas']
            .removeWhere((e) => (e['nombre'] == _nombrePuntoPuesto));

        // print(result[0]['rondas']);
        // print('data ESPUES ${result[0]['rondas']}');
        result[0]['rondas'].add({
          "nombre": _nombrePuntoPuesto,
          "detalle": _detallePuntoPuesto,
          "fotos": _listaFotosUrl,
          "video": _urlVideo,
          "qr": _infoQR,
          "fecha": _fechaActualParse
        });

        _listaPuestos.removeWhere((e) => (e['idActividad'] == idRonda));
        _listaPuestos.add(result[0]);
        _rondaSave = jsonEncode(_listaPuestos);
        await Auth.instance.saveRondasActividad(_rondaSave);
      } else {
        _listaPuestos.add(
          {
            "idActividad": idRonda,
            "rondas": [
              {
                "nombre": _nombrePuntoPuesto,
                "detalle": _detallePuntoPuesto,
                "fotos": _listaFotosUrl,
                "video": _urlVideo,
                "qr": _infoQR,
                "fecha": _fechaActualParse
              },
            ]
          },
        );
        _rondaSave = jsonEncode(_listaPuestos);
        await Auth.instance.saveRondasActividad(_rondaSave);
        notifyListeners();
      }
    } else {
      // print('LA MATRIZ ESTA VACIA');
      _listaPuestos.add(
        {
          "idActividad": idRonda,
          "rondas": [
            {
              "nombre": _nombrePuntoPuesto,
              "detalle": _detallePuntoPuesto,
              "fotos": _listaFotosUrl,
              "video": _urlVideo,
              "qr": _infoQR,
              "fecha": _fechaActualParse
            },
          ]
        },
      );
      _rondaSave = jsonEncode(_listaPuestos);
      await Auth.instance.saveRondasActividad(_rondaSave);
      notifyListeners();
    }
  }

// ******************************************************************************************************************************************//

  String? _detallePuntoPuesto = '';
  String? get getInputPuntoPuesto => _detallePuntoPuesto;
  void setInputPuntoPuestoChange(String? text) {
    _detallePuntoPuesto = text;
    // print('DETALLE punto : $_detallePuntoPuesto');
    notifyListeners();
  }

//================================== OBTENEMOS TODAS LOS PUESTOS DE LA ACTIVIDAD  ==============================//

  List _listaTodosLosPuntosDeRonda = [];
  List get getListaTodosLosPuntosDeRonda => _listaTodosLosPuntosDeRonda;

  void setListaTodosLosPuntosDeRonda(List data) {
    _listaTodosLosPuntosDeRonda = data;
    // print('data : ${_listaTodosLosPuntosDeRonda.length}');
    notifyListeners();
  }

  bool? _errorPuntosRonda; // sera nulo la primera vez
  bool? get getErrorPuntosRonda => _errorPuntosRonda;

  Future getTodosLosPuntosDeRonda(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllActividades(
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
      _errorPuntosRonda = true;

      setListaTodosLosPuntosDeRonda(response['data']);
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorPuntosRonda = false;
      notifyListeners();
      return null;
    }

    return null;
  }

//========================== ENVIA  LA RONDA AL SERVIDOR  CUANDO YA ESTA COMPLETA ===============//
  Future guardarRonda(int? idRonda, BuildContext context) async {
    // print('LISTA COMPLETA: $_listaCompletaParaGuardar');

    for (var item in _listaPuestos) {
      if (item['idActividad'] == idRonda) {
        // print('SI ES IGUA : ${item['idActividad']} == $idRonda');
        // print('SI ES IGUA : $item');

        // print('RONDA COMPLETA : ${item['rondas']}');

        final serviceSocket =
            Provider.of<SocketService>(context, listen: false);

        final infoUser = await Auth.instance.getSession();

        // print(
        //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
        final _pyloadGuardiaRondaCompleta = {
          "tabla": "actividadtrabajo", // defecto
          "rucempresa": infoUser!.rucempresa, // login
          "rol": infoUser.rol, //login
          "actId": idRonda, // id de actividad
          "actIdPersona": infoUser.id, // login
          "detalle": _inputObservacionesRealizaActivities,
          "fotos": _listaFotosUrl,
          "video": _urlVideo,
          "qr": _infoQR,
          "rondas": item['rondas']
        };

        // print(
        //     '================================== PAYLOAD EJECUTA ACTIVIDADES   ==============================');
        // print('$_pyloadGuardiaRondaCompleta');
        serviceSocket.socket!
            .emit('client:actualizarData', _pyloadGuardiaRondaCompleta);
      } else {
        //  print('NOOOOO  ES IGUA : ${item['idActividad']} == $idRonda');
      }
    }
  }

  //================================== OBTENGO ACTIVIDAD  ==============================//

  String? _fechaInicio = '';
  String? get getFechaInicio => _fechaInicio;

  String? _fechaFin = '';
  String? get getFechaFin => _fechaFin;

  int? _numeroDias;
  int? get getNumeroDias => _numeroDias;

  String? _trabajoCumplido;
  String? get getTrabajoCumplido => _trabajoCumplido;





  void getActividad(
    dynamic actividad,
    Session? usuario,
  ) {
    // print('Actividad Elegida==================> $actividad');
    // print('Actividad Usuario==================> ${usuario!.usuario}');
    // print('Actividad Rol==================> ${usuario.rol}');
    if (actividad['actFechasActividadConsultaDB'].isNotEmpty) {
      DateTime fechaInicio =
          DateTime.parse(actividad['actFechasActividadConsultaDB'][0]);
      DateTime fechafin = DateTime.parse(
          actividad['actFechasActividadConsultaDB']
              [actividad['actFechasActividadConsultaDB'].length - 1]);

      _fechaInicio = fechaInicio.toString().substring(0, 10);
      _fechaFin = fechafin.toString().substring(0, 10);

      // print('fechaInicio: ${fechaInicio.toString().substring(0,10)}');
      //   print('fechafin: ${fechafin.toString().substring(0,10)}');

      Duration dias = fechafin.difference(fechaInicio);
      int diasTrabajar = dias.inDays;

      _numeroDias = (diasTrabajar == 0) ? (diasTrabajar + 1) : diasTrabajar;
      // print('Numero de Dias: $_numeroDias');

      // ======================VERIFICA SI ESTA DESIGNADO ========================//
      // print(
      //     'PERFIL DE LA PERSONA : ${widget.tipo!.contains('SUPERVISOR')}');

      bool? _asignado;

      int? _progreso;

      if (usuario!.rol!.contains('SUPERVISOR')) {
        for (var e in actividad['actSupervisores']) {
          if (e['docnumero'] == usuario.usuario && e['asignado'] == true) {
            //        supervisoresDesignados.add(e);
            _asignado = true;
            _progreso = e['trabajos'].length;
            if (_numeroDias! > _progreso!) {
              _trabajoCumplido = 'EN PROGRESO';
              // print(' trabajos: $_trabajoCumplido}');
            } else if (_numeroDias == _progreso) {
              _trabajoCumplido = 'REALIZADO';
              // print(' trabajos: $_trabajoCumplido}');
            } else if (_numeroDias! < _progreso) {
              _trabajoCumplido = 'NO REALIZADO';
              // print(' trabajos: $_trabajoCumplido}');
            }
            // print(' trabajos: $_progreso}');
          } else {
            // print('SUPERVISOR NOooooo ESTA DESIGNADO: $e');
          }
        }
      }
      if (usuario.rol!.contains('GUARDIA')) {
        for (var e in actividad['actAsignacion']) {
          if (e['docnumero'] == usuario.usuario && e['asignado'] == true) {
            //        supervisoresDesignados.add(e);
            _asignado = true;
            _progreso = e['trabajos'].length;
            if (_numeroDias! > _progreso!) {
              _trabajoCumplido = 'EN PROGRESO';
            } else if (_numeroDias == _progreso) {
              _trabajoCumplido = 'REALIZADO';
            } else if (_numeroDias! < _progreso) {
              _trabajoCumplido = 'NO REALIZADO';
            }
            // print(' GUARDIA SI ESTA DESIGNADO: $e}');
          } else {
            // print('GUARDIA NOooooo ESTA DESIGNADO: $e');
          }
        }
      }

      notifyListeners();
    }
  }

  //======================================================================================');

}
