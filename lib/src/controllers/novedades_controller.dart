import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/crea_fotos_detalle_novedad.dart';
import 'package:sincop_app/src/models/lista_allNovedades_guardia.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class ActividadesController extends ChangeNotifier {
  GlobalKey<FormState> actividadesFormKey = GlobalKey<FormState>();
   final _api = ApiProvider();
  stt.SpeechToText? _speech;
  stt.SpeechToText? get getSpeech => _speech;

  ActividadesController() {
   
    _speech = stt.SpeechToText();
    checkGPSStatus();
  }

  bool validateForm() {
    if (actividadesFormKey.currentState!.validate()) {
      // print('formLogin Oksss');
      return true;
    } else {
      // print('formLogin ERROR');
      return false;
    }
  }

  int? opcionMulta;

  int? get getOpcionMulta => opcionMulta;
  void setOpcionMulta(int? value) {
    opcionMulta = value;
    // print('OPCION CONTROLLER: $opcionMulta');
    notifyListeners();
  }

  //====== CAMPO BUSQUEDAS NOMINA =========//
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

  //  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchCompras;

  @override
  void dispose() {
    _deboucerSearchCompras?.cancel();
    super.dispose();
  }

  String _nameSearch = "";
  String get nameSearch => _nameSearch;

  void onSearchText(String data) {
    _nameSearch = data;

    // print('onSearch:$_nameSearch');

    // if (_nameSearch.length >= 3) {
    //   _deboucerSearchCompras?.cancel();
    //   _deboucerSearchCompras = Timer(const Duration(milliseconds: 700), () {
    //     // print('TAB DE BUSQUEDA :$_indexTapCompras');
    //     // print('dato de busqueda:$_nameSearch');
    //     if (_indexTapCompras == 0) {
    //       // print(' TAB $_indexTapCompras');
    //       // print('TAB DE BUSQUEDA :$_indexTapCompras');
    //       // print('dato de busqueda:$_nameSearch');
    //       getTodasLasComprasPendientes('PENDIENTES', _nameSearch);
    //     }
    //     if (_indexTapCompras == 1) {
    //       // print(' TAB $_indexTapCompras');
    //       // print('TAB DE BUSQUEDA :$_indexTapCompras');
    //       // print('dato de busqueda:$_nameSearch');
    //       getTodasLasComprasProcesadas('PROCESADAS', _nameSearch);
    //     }
    //     if (_indexTapCompras == 2) {
    //       // print(' TAB $_indexTapCompras');
    //       // print('TAB DE BUSQUEDA :$_indexTapCompras');
    //       // print('dato de busqueda:$_nameSearch');
    //       getTodasLasComprasAnuladas('ANULADAS', _nameSearch);
    //     }
    //     switch (_indexTapCompras) {
    //       case 0:
    //         getTodasLasComprasPendientes('PENDIENTES', _nameSearch);
    //         break;
    //       case 1:
    //         getTodasLasComprasPendientes('PROCESADAS', _nameSearch);
    //         break;
    //       case 2:
    //         getTodasLasComprasPendientes('ANULADAS', _nameSearch);
    //         break;
    //       default:
    //         getTodasLasComprasPendientes('PENDIENTES', _nameSearch);
    //     }
    //   });
    // } else {
    //   // getTodasLasComprasProcesadas('PROCESADAS', '');
    //   // getTodasLasComprasPendientes('PENDIENTES', '');
    //   // getTodasLasComprasAnuladas('ANULADAS', '');
    // }
  }
  //===================LEE CODIGO QR==========================//

  String? _infoQR = '';
  String? get getInfoQR => _infoQR;

  void setInfoQR(String? value) {
    _infoQR = value;
    // print('INFO QR ==========> : $_infoQR ');
    notifyListeners();
  }
  //===================SELECCIONAMOS EL LA OBCION DE LA MULTA==========================//

  String _textoMulta = '';

  var _itemMulta;
  get getItemMulta => _itemMulta;
  get getTextoMulta => _textoMulta;
  void setItenMulta(value, text) {
    _itemMulta = value;
    _textoMulta = text;
    // _inputValorfactura = 0.0;
    // _inventarioSINOF = (text == 3) ? 'SI' : 'NO';
    // print('--ITEM MULTA-->:$_itemMulta');
    // print('--ITEM TEXTO-->:$_textoMulta');

    notifyListeners();
  }
  //===================CONTROLAMOS EL BOTON DE ESCRIBIR MEDIANTE LA VOZ==========================//

  double _confidence = 1.0;
  double get getconfidenceg => _confidence;

  void setConfidence(double value) {
    _confidence = value;
    // print('--is listening-->:$_isListening');
    notifyListeners();
  }

  bool _isListening = false;
  bool get getIsListenig => _isListening;

  void setIsListenig(bool value) {
    _isListening = value;
    // print('--is listening-->:$_isListening');
    notifyListeners();
  }

  // String? _textFullSpeech = '';
  String? _textSpeech = '';
  String? get getTextSpeech => _textSpeech;
  // String? get getFullSpeech=>_textFullSpeech;
  void setTextSpeech(String? text) {
    _textSpeech = text;
    // _textFullSpeech=_textFullSpeech!;
    // print('--TEXTSPEECH-->:$_textSpeech');
    // print('--_textFullSpeech-->:$_textFullSpeech');
    notifyListeners();
  }

  //=============================BOTONES CAMARA Y VIDEO=================================//
  bool _isCamera = false;
  bool get getIsCamera => _isCamera;
  void setIsCamera(bool value) {
    _isCamera = value;
    // print('--IS CAMERA-->:$_isCamera');

    notifyListeners();
  }

  bool _isVideo = false;
  bool get getIsVideo => _isVideo;
  void setIsVideo(bool value) {
    _isVideo = value;
    // print('--IS VIDEO->:$_isVideo');

    notifyListeners();
  }

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

//========================== PROCESO DE TOMAR FOTO DE CAMARA =======================//
  int id = 0;
  File? _newPictureFile;
  File? get getNewPictureFile => _newPictureFile;

  List<CreaNuevaFotoNovedad?> _listaFotos = [];
  List<CreaNuevaFotoNovedad?> get getListaFotos => _listaFotos;
  void setNewPictureFile(String? path) {
    _newPictureFile = File?.fromUri(Uri(path: path));
    _listaFotos.add(CreaNuevaFotoNovedad(id, _newPictureFile!.path));
    id = id + 1;
    notifyListeners();
  }


   void  eliminaFoto(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    _listaFotos.removeWhere((element) =>element!.id==id);
 
    notifyListeners();
    // print('------LISTA ---.${_listaFotos.length}');

    }
 void opcionesDecamara(ImageSource source)  async{
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

  //===================CODIGO DE ACCESO A MULTAS==========================//
String _textoCodigAccesoMultas = '';
String? get getCodigoAccesoMultas=>_textoCodigAccesoMultas;
  void onChangeCodigoAccesoMultas(String text) {
    _textoCodigAccesoMultas = text;
    // print('Actividades controller: $_textoCodigAccesoMultas');
  }

//  //================================== OBTENEMOS TODAS LAS NOVEDADES  ==============================//
//   List<Result> _listaTodasLasNovedades = [];
//   List<Result> get getListaTodasLasMultasGuardias =>_listaTodasLasNovedades;

//   void setListaTodasLasNovedades(List<Result> data) {
//     _listaTodasLasNovedades = data;
//     print('data : ${_listaTodasLasNovedades}');
//     notifyListeners();
//   }

//   bool? _errorNovedades; // sera nulo la primera vez
//   bool? get getErrorNovedades => _errorNovedades;

//   Future<AllNovedadesGuardia?> getTodasLasNovedadesGuardia(String? search) async {
//     final dataUser = await Auth.instance.getSession();
// // print('usuario : ${dataUser!.rucempresa}');
//     final response = await _api.getAllNovedadesGuardias(
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
//  print('data dddd: ${response.data.results[0].nomDetalle}');
//       _errorNovedades = true;
//       setListaTodasLasNovedades(response.data.results);
//       // _listaTodasLasNovedades=response.data.results;
//        print('data Lista: ${_listaTodasLasNovedades[0].nomCiudad}');
//       notifyListeners();
//       return response;
//     }
//     if (response == null) {
//       _errorNovedades = false;
//       notifyListeners();
//       return null;
//     }
//     return null;
//   }










}
