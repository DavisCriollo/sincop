import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as _http;
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/crea_fotos.dart';
import 'package:sincop_app/src/models/foto_url.dart';
import 'package:sincop_app/src/models/lista_allInforme_guardias.dart';
import 'package:sincop_app/src/service/socket_service.dart';


class AvisoSalidaController extends ChangeNotifier {
  GlobalKey<FormState> avisoSalidaFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();
  void resetValuesAvisoSalida() {
    _idGuardia;
    _cedulaGuardia;
    _nombreGuardia = '';
    _inputDetalle;
    _inputFechaAvisoSalida;
    _inputHoraAvisoSalida;
    _listaFotosAvisoSalida.clear();
    _listaFotosUrl!.clear();
    _listaVideosUrl.clear();
    notifyListeners();
  }

  bool validateForm() {
    if (avisoSalidaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  int? _idGuardia;
  String? _cedulaGuardia;
  String? _nombreGuardia;
  String? get nombreGuardia => _nombreGuardia;

  String? _inputDetalle;
  String? get getInputDetalle => _inputDetalle;
  void onDetalleChange(String? text) {
    _inputDetalle = text;
    // print(_inputDetalle);
    notifyListeners();
  }

//========================== DROPDOWN PERIODO CONSIGNA CLIENTE =======================//
  String? _labelAvisoSalida;

  String? get labelAvisoSalida => _labelAvisoSalida;

  void setLabelAvisoSalida(String value) {
    _labelAvisoSalida = value;
    // print('-----ss:$_labelAvisoSalida');
    notifyListeners();
  }

  //================================== FECHA Y HORA DEL COMUNICADO  ==============================//
  String? _inputFechaAvisoSalida;
  get getInputfechaAvisoSalida => _inputFechaAvisoSalida;
  void onInputFechaAvisoSalidaChange(String? date) {
    _inputFechaAvisoSalida = date;

    notifyListeners();
  }

  String? _inputHoraAvisoSalida;
  get getInputHoraAvisoSalida => _inputHoraAvisoSalida;
  void onInputHoraAvisoSalidaChange(String? date) {
    _inputHoraAvisoSalida = date;

    notifyListeners();
  }

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  int id = 0;
  File? _newPictureFile;
  File? get getNewPictureFile => _newPictureFile;
  List? _listaFotosUrl = [];
  List? get getListaFotosUrl => _listaFotosUrl;

  List<dynamic> _listaFotosAvisoSalida = [];
  List<dynamic> get getListaFotosInforme => _listaFotosAvisoSalida;
  void setNewPictureFile(String? path) {
    _newPictureFile = File?.fromUri(Uri(path: path));
    upLoadImagen(_newPictureFile);
    _listaFotosAvisoSalida
        .add(CreaNuevaFotoAvisoSalida(id, _newPictureFile!.path));
    // _listaFotosAvisoSalida.add({"id": id, "path": _newPictureFile});

    id = id + 1;
    notifyListeners();
  }

  void setEditarFoto(int id, String path) {
    _listaFotosAvisoSalida.add(CreaNuevaFotoAvisoSalida(id, path));

    notifyListeners();
  }

  void eliminaFoto(int id) {
    _listaFotosAvisoSalida.removeWhere((element) => element!.id == id);

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

  //==========================TRABAJAMOS CON VIDEO  ===============================//

  String? _pathVideo = '';
  // 'https://movietrailers.apple.com/movies/independent/unhinged/unhinged-trailer-1_h720p.mov';
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
    // for (var item in _listaFotosUrl!) {
    //   // print('imagen URL: $item');
    // }
  }

  void eliminaFotoUrl(String url) {
    _listaFotosUrl!.removeWhere((e) => e['url'] == url);
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

//==================== LISTO TODOS  LOS AVISOS====================//
  List _listaAvisosSalida = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaAvisosSalida => _listaAvisosSalida;

  void setInfoBusquedaAvisosSalida(List data) {
    _listaAvisosSalida = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de guardias SOCKET: ${_listaAvisosSalida}');
    notifyListeners();
  }

  bool? _errorAvisosSalida; // sera nulo la primera vez
  bool? get getErrorInformesGuardia => _errorAvisosSalida;
  set setErrorInformesGuardia(bool? value) {
    _errorAvisosSalida = value;
    notifyListeners();
  }

  Future buscaAvisosSalida(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllAvisosSalida(
      search: _search,
      // estado: 'GUARDIAS',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorAvisosSalida = true;
      setInfoBusquedaAvisosSalida(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorAvisosSalida = false;
      notifyListeners();
      return null;
    }
  }

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

//================================== CREA NUEVO AVISO  ==============================//

  void getInfomacionGuardia(
      int id, String cedula, String nombre, String apellido) {
    _idGuardia = id;
    _cedulaGuardia = cedula;
    _nombreGuardia = '$nombre $apellido';
// print('${_idguardia}-${_cedulaGuardia}-${_nombreGuardia}');
  }

  Future crearAvisoSalida(BuildContext context) async {
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
    final _pyloadNuevoAvisoSalida = {
      "tabla": "avisosalida", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      "rol": infoUserLogin.rol, //login
      "nomTipo": "AVISO SALIDA", // defecto
      "nomIdPersona": _idGuardia,
      "nomDocuPersona": _cedulaGuardia,
      "nomNomPersona": _nombreGuardia,
      "nomMotivo": _labelAvisoSalida,
      "nomDetalle": _inputDetalle,
      "nomEstado": "PENDIENTE",
      "nomFecha": '${_inputFechaAvisoSalida}T$_inputHoraAvisoSalida',
      "nomFotos": _listaFotosUrl,
      "nomVideos": _listaVideosUrl,
      "nomUser": turno['user'], // iniciado turno
      "nomEmpresa": infoUserLogin.rucempresa //login
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadNuevoAvisoSalida);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!.emit('client:guardarData', _pyloadNuevoAvisoSalida);
  }

  //================================== ELIMINAR  MULTA  ==============================//
  Future eliminaAvisoSalida(int? idAviso) async {
    final serviceSocket = SocketService();
    final infoUser = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();
    final turno = jsonDecode(infoUserTurno);

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadEliminaAvisoSalida = {
      {
        "tabla": 'avisosalida',
        "rucempresa": infoUser!.rucempresa,
        "nomId": idAviso,
      }
    };

    // print(
        // '==========================JSON PARA CREAR NUEVA COMPRA ===============================');

    serviceSocket.socket!
        .emit('client:eliminarData', _pyloadEliminaAvisoSalida);
    // serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
    //   if (data['tabla'] == 'informe') {

    buscaAvisosSalida('');
  }

  int? _idAviso;

  void getDataAvisoSalida(dynamic aviso) {
    _idAviso = aviso['nomId'];
    _idGuardia = int.parse(aviso['nomIdPersona']);
    _cedulaGuardia = aviso['nomDocuPersona'];
    _nombreGuardia = aviso['nomNomPersona'];
    _labelAvisoSalida = aviso['nomMotivo'];
    _inputDetalle = aviso['nomDetalle'];
    _inputFechaAvisoSalida = aviso['nomFecha'];
    _listaFotosUrl = aviso['nomFotos'];
    _listaVideosUrl = aviso['nomVideos'];
    // setLabelAvisoSalida(aviso['nomMotivo']);
    notifyListeners();
  }

//========================================================================//
  Future editarAvisoSalida() async {
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
    final _pyloadEditaAvisoSalida = {
      "tabla": "avisosalida", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      'nomId': _idAviso,
      "rol": infoUserLogin.rol, //login
      "nomTipo": "AVISO SALIDA", // defecto
      "nomIdPersona": _idGuardia,
      "nomDocuPersona": _cedulaGuardia,
      "nomNomPersona": _nombreGuardia,
      "nomMotivo": _labelAvisoSalida,
      "nomDetalle": _inputDetalle,
      "nomEstado": "PENDIENTE",
      "nomFecha": '${_inputFechaAvisoSalida}T$_inputHoraAvisoSalida',
      "nomFotos": _listaFotosUrl,
      "nomVideos": _listaVideosUrl,
      "nomUser": turno['user'], // iniciado turno
      "nomEmpresa": infoUserLogin.rucempresa //login
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadEditaAvisoSalida);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!
        .emit('client:actualizarData', _pyloadEditaAvisoSalida);
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
      // _puestoServicioGuardia = response['data'][0]['perPuestoServicio'];

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



}
