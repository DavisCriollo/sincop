import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as _http;

import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/crea_fotos.dart';
import 'package:sincop_app/src/models/foto_url.dart';
import 'package:sincop_app/src/service/socket_service.dart';

class AusenciasController extends ChangeNotifier {
  GlobalKey<FormState> ausenciasFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();
  void resetValuesAusencias() {
    _idAusencia;
    _idGuardia;
    _cedulaGuardia = "";
    _nombreGuardia = "";
    // _labelMotivoAusencia = null;
    _inputDetalle = "";

    _inputFechaInicio = "";
    _inputHoraInicio = "";

    _inputFechaFin = "";
    _inputHoraFin = "";

    _listaFotosUrl = [];
    _puestoServicioGuardia=[];

    notifyListeners();
  }

  bool validateForm() {
    if (ausenciasFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void resetDropDown() {
    _labelMotivoAusencia = null;
// _listaAusencias=[];
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

  String? _inputDetalle;
  String? get getInputDetalle => _inputDetalle;
  void onDetalleChange(String? text) {
    _inputDetalle = text;
    // print(_inputDetalle);
    notifyListeners();
  }

//==================== LISTO TODOS  LOS CAMBIOS DE PUESTO====================//
  List _listaAusencias = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List get getListaAusencias => _listaAusencias;

  void setInfoBusquedaAusencias(List data) {
    _listaAusencias = data;
    // print('dataRefresca Pyloadata');
    // print('Lista de guardias SOCKET: ${_listaAusencias}');
    notifyListeners();
  }

  bool? _errorAusencias; // sera nulo la primera vez
  bool? get getErrorAusencias => _errorAusencias;
  set setErrorAusencias(bool? value) {
    _errorAusencias = value;
    notifyListeners();
  }

  Future buscaAusencias(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllAusencias(
      search: _search,
      // estado: 'GUARDIAS',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorAusencias = true;
      setInfoBusquedaAusencias(response['data']);
      // print('object;$_listaAusencias');
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorAusencias = false;
      notifyListeners();
      return null;
    }
  }

  void getInfomacionGuardia(dynamic guardia) {
    _idGuardia = guardia['perId'];
    _cedulaGuardia = guardia['perDocNumero'];
    _nombreGuardia = '${guardia['perNombres']} ${guardia['perApellidos']}';
    _puestoServicioGuardia = guardia['perPuestoServicio'];
    // print(
    //     '${_idGuardia}-${_cedulaGuardia}-${_nombreGuardia} - ${_puestoServicioGuardia!.length}');
  }

  //========================== VALIDA CAMPO  FECHA INICIO CONSIGNA =======================//
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

  //========================== VALIDA CAMPO  FECHA FIN CONSIGNA =======================//
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
    // print('Hora Fin:$_inputHoraFinConsigna');

    notifyListeners();
  }

//========================== DROPDOWN MOTIVO AUSENCIA =======================//
  String? _labelMotivoAusencia;

  String? get labelMotivoAusencia => _labelMotivoAusencia;

  void setLabelMotivoAusencia(String value) {
    _labelMotivoAusencia = value;
    // print('-----ss:$_labelMotivoAusencia');
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
        .add(CreaNuevaFotoausencias(id, _newPictureFile!.path));
    // _listaFotosCrearInforme.add({"id": id, "path": _newPictureFile});

    id = id + 1;
    notifyListeners();
  }

  void setEditarFoto(int id, String path) {
    _listaFotosCrearInforme.add(CreaNuevaFotoausencias(id, path));

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

  Future crearAusencia(BuildContext context) async {
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
    //     ' $_idGuardia  $_cedulaGuardia  $_nombreGuardia  $_nombreGuardia  $_puestoServicioGuardia  $_clienteNombre  $_clienteNombre $_inputDetalle  $_inputDetalle  $_listaFotosUrl');

    final _pyloadNuevaAusencia = {
      "tabla": "ausencia", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      "rol": infoUserLogin.rol, //loginlogin
      "ausIdPersona": _idGuardia,
      "ausDocuPersona": _cedulaGuardia,
      "ausNomPersona": _nombreGuardia,
      "ausPuesto": _puestoServicioGuardia,
      "ausMotivo":
          _labelMotivoAusencia, // select=> ENFERMEDADES IESS, PERMISO PERSONAL,PATERNIDAD,DEFUNCION FAMILIAR, INJUSTIFICADA
      "ausFechaDesde": '${_inputFechaInicio}T$_inputHoraInicio', // fecha hora
      "ausFechaHasta": '${_inputFechaFin}T$_inputHoraFin', // fecha hora
      "ausDetalle": _inputDetalle, // textarea
      "ausDocumento": "", // input file
      "ausFotos": _listaFotosUrl,
      "ausIdMulta": "", // interno
      "ausUser": turno['user'], // iniciado turno // usuario iniciado turno
      "ausEmpresa": infoUserLogin.rucempresa //login //login
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadNuevaAusencia);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!.emit('client:guardarData', _pyloadNuevaAusencia);
  }

//================================== ELIMINAR  MULTA  ==============================//
  Future eliminaAusencia(int? idAusencia) async {
    final serviceSocket = SocketService();
    final infoUser = await Auth.instance.getSession();
    final infoUserTurno = await Auth.instance.getTurnoSessionUsuario();
    final turno = jsonDecode(infoUserTurno);

    // print('==========================JSON  ===============================');
    final _pyloadEliminaAusenciao = {
      {
        "tabla": 'ausencia',
        "rucempresa": infoUser!.rucempresa,
        "ausId": idAusencia,
      }
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    // print('$idAusencia');
    serviceSocket.socket!.emit('client:eliminarData', _pyloadEliminaAusenciao);
  }

  int? _idAusencia;

  void getDataAusencia(dynamic ausencia) {
    _idAusencia = ausencia['ausId'];
    _idGuardia = int.parse(ausencia['ausIdPersona']);
    _cedulaGuardia = ausencia['ausDocuPersona'];
    _nombreGuardia = ausencia['ausNomPersona'];
    _labelMotivoAusencia = ausencia['ausMotivo'];
    _inputDetalle = ausencia['ausDetalle'];

    List<String>? dataFechaInicio = ausencia['ausFechaDesde']!.split('T');

    _inputFechaInicio = dataFechaInicio![0];
    _inputHoraInicio = dataFechaInicio[1];

    List<String>? dataFechaFin = ausencia['ausFechaHasta']!.split('T');

    _inputFechaFin = dataFechaFin![0];
    _inputHoraFin = dataFechaFin[1];

    _listaFotosUrl = ausencia['ausFotos'];
    _puestoServicioGuardia = ausencia['ausPuesto'];
  }

  Future editaAusencia(BuildContext context) async {
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
    //     ' $_idGuardia  $_cedulaGuardia  $_nombreGuardia  $_nombreGuardia  $_puestoServicioGuardia  $_clienteNombre  $_clienteNombre $_inputDetalle  $_inputDetalle  $_listaFotosUrl');

    final _pyloadEditaAusencia = {
      "tabla": "ausencia", // defecto
      "rucempresa": infoUserLogin!.rucempresa, //login
      "rol": infoUserLogin.rol, //loginlogin
      "ausId": _idAusencia,
      "ausIdPersona": _idGuardia,
      "ausDocuPersona": _cedulaGuardia,
      "ausNomPersona": _nombreGuardia,
      "ausPuesto": _puestoServicioGuardia,
      "ausMotivo":
          _labelMotivoAusencia, // select=> ENFERMEDADES IESS, PERMISO PERSONAL,PATERNIDAD,DEFUNCION FAMILIAR, INJUSTIFICADA
      "ausFechaDesde": '${_inputFechaInicio}T$_inputHoraInicio', // fecha hora
      "ausFechaHasta": '${_inputFechaFin}T$_inputHoraFin', // fecha hora
      "ausDetalle": _inputDetalle, // textarea
      "ausDocumento": "", // input file
      "ausFotos": _listaFotosUrl,
      "ausIdMulta": "", // interno
      "ausUser": turno['user'], // iniciado turno // usuario iniciado turno
      "ausEmpresa": infoUserLogin.rucempresa //login //login
    };

    // print(
    //     '==========================JSON PARA CREAR NUEVO GUARDIA ===============================');
    // print(_pyloadEditaAusencia);
    // print(
    //       '==========================JSON DE PERSONAL DEIGNADO ===============================');
    serviceSocket.socket!.emit('client:actualizarData', _pyloadEditaAusencia);
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






}
