

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:sincop_app/src/api/authentication_client.dart';
// import 'package:sincop_app/src/models/auth_response.dart';
// import 'package:sincop_app/src/models/session_response.dart';
// import 'package:sincop_app/src/service/notifications_service.dart';
// import 'package:geolocator/geolocator.dart' as Geolocator;
// import 'package:sincop_app/src/service/socket_service.dart';

// class ValidaTurnoController extends ChangeNotifier {
//  Session? _infoUser;
//   Session? get infoUser => _infoUser;
//   AuthResponse? usuarios;

//  //===================CODIGO DE ACCESO A NOVEDADES==========================//
//   String _textoCodigAccesoTurno = '';
//   String? get getCodigoAccesoNovedades => _textoCodigAccesoTurno;
//   void onChangeCodigoAccesoTurno(String text) {
//     _textoCodigAccesoTurno = text;
//     notifyListeners();
//   }



//   bool? _btnTurno = false;
//   bool? get getBtnTurno => _btnTurno;

//   void setBtnTurno(bool? value) async {
//     print('object ESGTADO BGTN $value');
//   //   if (value == false) {
//   //     await Auth.instance.deleteTurnoSesion();
//   //     _btnIniciaTurno = false;
//   //        notifyListeners();
//   //     print('BOTON INICIA TURNO ESTADO :$_btnIniciaTurno');
//   //   } else {
//   //     _btnIniciaTurno = true;
//   //     print('BOTON INICIA TURNO ESTADO :$_btnIniciaTurno');
//   //        notifyListeners();
//   //   }
//     // notifyListeners();
//   }



// //========================== GEOLOCATOR =======================//
//   String? _coordenadas = "";
//   Geolocator.Position? _position;
//   Geolocator.Position? get position => _position;
//   String? _selectCoords = "";
//   String? get getCoords => _selectCoords;
//   set setCoords(String? value) {
//     _selectCoords = value;
//     notifyListeners();
//   }

//   Future<bool?> checkGPSStatus() async {
//     final isEnable = await Geolocator.Geolocator.isLocationServiceEnabled();
//     Geolocator.Geolocator.getServiceStatusStream().listen((event) {
//       final isEnable = (event.index == 1) ? true : false;
//     });
//     return isEnable;
//   }

//   Future<void> getCurrentPosition() async {
//     // checkGPSStatus();
//     late Geolocator.LocationSettings locationSettings;

//     locationSettings = const Geolocator.LocationSettings(
//       accuracy: Geolocator.LocationAccuracy.high,
//       distanceFilter: 100,
//     );
//     _position =
//         await Geolocator.GeolocatorPlatform.instance.getCurrentPosition();
//     _position = position;
//     _selectCoords = ('${position!.latitude},${position!.longitude}');
//     _coordenadas = _selectCoords;

//     // print('GPS ACTUAL: ${position!.latitude},${position!.longitude}');
//     // print('GPS _selectCoords : ${_selectCoords}');
//     notifyListeners();
//   }


//   //===================CHECK TERMINOS Y CONDICIONES ==========================//
//   bool _terminosCondiciones = false;
//   bool get getTerminosCondiciones => _terminosCondiciones;

//   void setTerminosCondiciones(bool value) {
//     _terminosCondiciones = value;

//     notifyListeners();
//   }



//   //===================LEE CODIGO QR==========================//

//   Map<int, String>? _elementoQR = {};
//   String? _infoQRTurno = '';
//   String? get getInfoQRTurno => _infoQRTurno;

//   void setInfoQRTurno(String? value) {
//     _infoQRTurno = value;
//     // print('info Turno: $_infoQRTurno');

//     final split = _infoQRTurno!.split('-');
//     _elementoQR = {for (int i = 0; i < split.length; i++) i: split[i]};
// //
//     notifyListeners();
//   }




//   String? _tipoDispositivo = '';
//   String? get getTipoDispositivo => _tipoDispositivo;

//   void setTipoDispositivo(String? value) {
//     _tipoDispositivo = value;

//     // print('_tipoDispositivo =====> : $_tipoDispositivo');

//     // notifyListeners();
//   }


// //================== VALIDA CODIGO QR INICIA TURNO ===========================//
//   Future<void> validaCodigoQRTurno(BuildContext context) async {
//     final serviceSocket = SocketService();

//     // print(
//     //     '========================= INICIAR TURNO ================================');
//     // print('SCANEO----->:$_infoQRTurno');
//     // print('COORDENADAS----->:$_coordenadas');
//     // print('========================PAILOAD=================================');
//     _infoUser = await Auth.instance.getSession();
//     // print('========================PAILOAD=================================');
//     final _pyloadDataIniciaTurno = {
//       "tabla": "registro", // info Quemada
//       "rucempresa": _infoUser!.rucempresa, // dato del login
//       "rol": _infoUser!.rol, // dato del login
//       "regId": "", // va vacio
//       "regCodigo": _elementoQR![0], // leer del qr
//       "regRegistro": "QR",
//       "regDocumento": "", // va vacio
//       "regNombres": "", // va vacio
//       "regPuesto": "", // va vacio
//       'regTerminosCondiciones': _terminosCondiciones,
//       "regCoordenadas": {
//         // tomar coordenadas
//         "latitud": position!.latitude,
//         "longitud": position!.longitude,
//       },
//       "regDispositivo": _tipoDispositivo, // DISPOSITIVO
//       "regEstadoIngreso": "INICIADA", // INICIADA O FINALIZADA
//       "regEmpresa": _infoUser!.rucempresa, // dato del login
//       "regUser": _infoUser!.usuario, // dato del login
//       "regFecReg": "", // va vacio
//       "Todos": "" // va vacio
//     };

//     // print('========================PAILOAD=================================');
//     // print('$_pyloadDataIniciaTurno');
//     serviceSocket.socket!.emit('client:guardarData', _pyloadDataIniciaTurno);
//     serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
//       if (data['tabla'] == 'registro') {
//         // print('====RESPUESTA INICIA TURNO $data');
//         await Auth.instance.saveTurnoSession(true);
//         // _validaBtnTurno = true;

//           _btnTurno = true;

//         NotificatiosnService.showSnackBarSuccsses(data['msg']);

//         serviceSocket.socket?.clearListeners();
//         notifyListeners();
//         // Navigator.of(context).pop();
//       }
//     });
//     serviceSocket.socket?.on('server:error', (data) {
//       NotificatiosnService.showSnackBarError(data['msg']);
//       serviceSocket.socket?.clearListeners();
//       notifyListeners();
//     });
//   }

// //================== VALIDA CODIGO INICIA TURNO ===========================//
//   Future<void> validaCodigoTurno(BuildContext context) async {
//     // final serviceSocket = Provider.of<SocketService>(context, listen: false);
//     final serviceSocket = SocketService();
//     // print(
//     // '========================= INICIAR TURNO ================================');
//     // print('SCANEO----->:$_infoQRTurno');
//     // print('COORDENADAS----->:$_coordenadas');
//     // print('========================PAILOAD=================================');
//     final infoUser = await Auth.instance.getSession();
//     // print('========================PAILOAD=================================');
//     final _pyloadDataIniciaTurno = {
//       "tabla": "registro", // info Quemada
//       "rucempresa": infoUser!.rucempresa, // dato del login
//       "rol": infoUser.rol, // dato del login
//       "regId": "", // va vacio
//       "regCodigo": _textoCodigAccesoTurno, // leer del qr
//       "regDocumento": "", // va vacio
//       "regNombres": "", // va vacio
//       "regPuesto": "", // va vacio
//       'regTerminosCondiciones': _terminosCondiciones,
//       "regCoordenadas": {
//         // tomar coordenadas
//         "latitud": position!.latitude,
//         "longitud": position!.longitude,
//       },
//       "regRegistro": "CÓDIGO",
//       "regDispositivo": _tipoDispositivo, // tomar coordenadas
//       "regEstadoIngreso": "INICIADA", // INICIADA O FINALIZADA
//       "regEmpresa": infoUser.rucempresa, // dato del login
//       "regUser": infoUser.usuario, // dato del login
//       "regFecReg": "", // va vacio
//       "Todos": "" // va vacio
//     };

//     // print('========================PAILOAD=================================');
//     // print(' INICIA TURNO    $_pyloadDataIniciaTurno');
//     serviceSocket.socket!.emit('client:guardarData', _pyloadDataIniciaTurno);
//     serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
//       if (data['tabla'] == 'registro') {
//         // print('valida inicioar turno====> $data');
//         //      print('========================PAILOAD=================================');
//         // print('DATA INICIA TURNO OK=======> :    ${data['msg']}');
//         // print('ID REGISTRO:    ${data['regId']}');
//         // print('ID REGISTRO type:    ${data['regId']}');
//         await Auth.instance.saveIdRegistro('${data['regId']}');

//         final datosLogin = {
//           "turno": true,
//           "user": data['regDocumento'],
//         };
//         await Auth.instance.saveTurnoSession(true);
//         await Auth.instance.saveTurnoSessionUser(datosLogin);

// // setValidaBtnTurno(true);

//         // _validaBtnTurno = true;

//         //========variable inicia turno======//
//         setBtnTurno(true);
//         //====================================//

//         // NotificatiosnService.showSnackBarSuccsses(data['msg']);
//         // serviceSocket.socket?.clearListeners();
//         notifyListeners();
//         // Navigator.of(context).pop();
//       }
//     });
//     serviceSocket.socket?.on('server:error', (data) {
//       // print('DATA INICIA TURNO error=======> :    ${data['msg']}');
//       NotificatiosnService.showSnackBarError(data['msg']);
//       // serviceSocket.socket?.clearListeners();
//       notifyListeners();
//     });
//   }


// //==================FINALIZA TURNO ===========================//
//   Future<void> finalizarTurno(BuildContext context) async {
//     // final serviceSocket = Provider.of<SocketService>(context, listen: false);

//     final serviceSocket = SocketService();
//     final infoUser = await Auth.instance.getSession();
//     final idRegistro = await Auth.instance.getIdRegistro();

//     final _pyloadDataFinaizaTurno = {
//       "tabla": "registro", // info Quemada
//       "rucempresa": infoUser!.rucempresa, // dato del login

//       "regId": idRegistro, // va vacio
//     };

//     serviceSocket.socket!
//         .emit('client:actualizarData', _pyloadDataFinaizaTurno);
//     serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
//       if (data['tabla'] == 'registro') {
//         //========variable inicia turno======//
//         await Auth.instance.deleteTurnoSesion();
//            setBtnTurno(false);
//         // await Auth.instance.deleteTurnoSesionUser();
// //  await Auth.instance.saveTurnoSession(true);

//         //====================================//
//         // NotificatiosnService.showSnackBarSuccsses(data['msg']);
//         // serviceSocket.socket?.clearListeners();
//         notifyListeners();

//         // Navigator.of(context).push(
//         //      MaterialPageRoute(
//         //     builder: (context) => SplashPage(),
//         //   ),
//         // );
//       }
//     });

//     serviceSocket.socket?.on('server:error', (data) async {
//       //========variable inicia turno======//
//       setBtnTurno(false);
//       await Auth.instance.deleteTurnoSesion();
//       //====================================//
//       NotificatiosnService.showSnackBarError(data['msg']);

//       notifyListeners();
//     });
//   }






// }