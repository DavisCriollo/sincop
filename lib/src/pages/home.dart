import 'dart:io';

import 'package:badges/badges.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/controllers/activities_controller.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/models/auth_response.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/actividades_page.dart';
import 'package:sincop_app/src/pages/lista_comunicados_guardias.dart';
import 'package:sincop_app/src/pages/lista_informes_guardias_page.dart';
import 'package:sincop_app/src/pages/mis_notificaciones1_push.dart';
import 'package:sincop_app/src/pages/mis_notificaciones2_push.dart';
import 'package:sincop_app/src/pages/novedades_page.dart';
import 'package:sincop_app/src/pages/splash_page.dart';
import 'package:sincop_app/src/service/local_notifications.dart';
import 'package:sincop_app/src/service/notification_push.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/drawer_custom.dart';
import 'package:sincop_app/src/widgets/item_menu_home.dart';

class HomeMenu extends StatefulWidget {
  final String? validaTurno;
  final String? ubicacionGPS;
  final Session? user;
  final List<String?>? tipo;
  final AuthResponse? dataUser;

  const HomeMenu(
      {Key? key,
      this.validaTurno,
      this.ubicacionGPS,
      this.user,
      this.tipo,
      this.dataUser})
      : super(key: key);

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //  setUpNotificationPlugins();
      initData();
    });
    super.initState();
  }

// =======================   ==========================//
  String marcaMovil = '';
// =========================================================================//

  void initData() async {
    // ===================== VERIFICO DE QUE DISPOSITIVO EL GUARDIA INICIA TURNO  ================//
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      // print('Running on ${webBrowserInfo.userAgent}');
      marcaMovil = '${webBrowserInfo.userAgent}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      marcaMovil = '${iosInfo.utsname.machine}';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      marcaMovil = '${androidInfo.model}';
    } else if (Platform.isWindows) {
// print('Running on ${windowsInfo.toMap().toString()}');  // e.g. "Moto G (4)"
    }
    final controller = HomeController();
    controller.setTipoDispositivo(marcaMovil);
// =======================================================================================//

    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final loadInfoNotificacion =
        Provider.of<HomeController>(context, listen: false);
    loadInfoNotificacion.buscaNotificacionesPush('');
    // loadInfoNotificacion.buscaNotificaciones2Push('');
    // loadInfoNotificacion.cuentaNotificacionesNOLeidas();
    // loadInfoNotificacion.cuentaNotificaciones2NOLeidas();

    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'notificacionleido') {
        loadInfoNotificacion.buscaNotificacionesPush('');
        // print('FFFF ${data}');
        // loadInfoNotificacion.buscaNotificaciones2Push('');
        // loadInfoNotificacion.cuentaNotificacionesNOLeidas();
        // loadInfoNotificacion.cuentaNotificaciones2NOLeidas();
      }
    });
    serviceSocket.socket!.on('server:nuevanotificacion', (data) async {
      loadInfoNotificacion.buscaNotificacionesPush('');
      // loadInfoNotificacion.buscaNotificaciones2Push('');
      // loadInfoNotificacion.cuentaNotificacionesNOLeidas();
      // loadInfoNotificacion.cuentaNotificaciones2NOLeidas();
      // selectNotification(data);
    });

//================================//
    WidgetsFlutterBinding.ensureInitialized();
    await PushNotificationService.initializeApp();
    LocalNotifications.init();
    listenNotifications();
    //================================//

    // WidgetsFlutterBinding.ensureInitialized();

    // loadInfoNotificacion.cuentaNotificacionesNOLeidas();
    // loadInfoNotificacion.cuentaNotificaciones2NOLeidas();

//     PushNotificationService.messageStream.listen((payload) {
//       // loadInfoNotificacion.buscaNotificacionesPush('');
//       // loadInfoNotificacion.buscaNotificaciones2Push('');
//       // loadInfoNotificacion.cuentaNotificacionesNOLeidas();
//       // loadInfoNotificacion.cuentaNotificaciones2NOLeidas();
//   // listenAlertNotifications();
// Navigator.push(
//       context,
//       // MaterialPageRoute<void>(builder: (context) => ListaNotifications(payload:payload)),
//       MaterialPageRoute<void>(builder: (context) => AlertaPage()),
//     );
//     });
//     if(loadInfoNotificacion.getPayloadAlerta=='Alerta')
//     {
//     print('SI ES  ALERTA');
//     // Navigator.push(
//     //   context,
//     //   // MaterialPageRoute<void>(builder: (context) => ListaNotifications(payload:payload)),
//     //   MaterialPageRoute<void>(builder: (context) => AlertaPage()),
//     // );
// }else{
//   print('NOOOOO   ES  ALERTA');
//   // Navigator.push(
//   //     context,
//   //     // MaterialPageRoute<void>(builder: (context) => ListaNotifications(payload:payload)),
//   //     MaterialPageRoute<void>(builder: (context) => AlertaPage()),
//   //   );
//   //   });
// }
  }

  void listenNotifications() =>
      LocalNotifications.onNotification.stream.listen(selectNotification);

  void selectNotification(String? payload) async {
    if (payload != null && payload.isNotEmpty && payload == 'MULTA') {
      print('SIIIII ES UNA ALERT notification payload: ${payload}');
    }
//  print('NOTIFICACION RECIBIDA: ${payload[0]}');
    // if (payload != null && payload.isNotEmpty && payload== 'Alerta') {
    //   print('SIIIII ES UNA ALERT notification payload: ${payload}');

    // } else if (payload != null && payload.isNotEmpty && payload != 'Alerta') {
    //   print('NOOOOOOOO  ES UNA ALERT notification payload: $payload');
    //   Navigator.push(
    //   context,
    //   // MaterialPageRoute<void>(builder: (context) => ListaNotifications(payload:payload)),
    //   MaterialPageRoute<void>(builder: (context) => const ListaNotificaciones2Push()),
    // );

    // }

// if (payload != null && payload.isNotEmpty ) {
//       print('NOTIFICACION RECIBIDA: ${payload}');

//     }

    // if (payload != null && payload.isNotEmpty) {
    //   await Navigator.pushNamed(context, 'listaNotificaciones2Push');
    // }
  }

  @override
  Widget build(BuildContext context) {
    print('============= RECARGA LA PAGINA ==================');
    final Responsive size = Responsive.of(context);
    final homeController = Provider.of<HomeController>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,

            title: Text(
              widget.user!.rucempresa!,
              style: GoogleFonts.lexendDeca(
                  fontSize: size.iScreen(2.5),
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0XFF153E76),
                    Color(0XFF0076A7),
                    // Color(0XFF005B97),
                    // Color(0XFF0075BE),
                    // Color(0XFF1E9CD7),
                    // Color(0XFF3DA9F4),
                  ],
                ),
              ),
            ),
            actions: [
              (widget.tipo!.contains('GUARDIA') ||
                      widget.tipo!.contains('SUPERVISOR') ||
                      widget.user!.usuario == 'talentohumano'
                  //  widget.tipo!.contains('talentohumano')
                  )
                  ? Consumer<HomeController>(
                      builder: (_, countPush, __) {
                        return Badge(
                          badgeColor: (countPush.getNumNotificaciones == 0)
                              ? Colors.transparent
                              : Colors.red,
                          elevation:
                              (countPush.getNumNotificaciones == 0) ? 0 : 5,
                          position: const BadgePosition(top: 5.0, start: 25.0),
                          badgeContent: Text(
                            (countPush.getNumNotificaciones > 9)
                                ? '9+'
                                : (countPush.getNumNotificaciones == 0)
                                    ? ''
                                    : '${countPush.getNumNotificaciones}',

                            // badgeColor: (countPush.getListaNotificacionesPushNoLeidas.isEmpty)? Colors.transparent:Colors.red,
                            // elevation: (countPush.getListaNotificacionesPushNoLeidas.isEmpty)?0:5,
                            // position: const BadgePosition(top: 5.0, start: 25.0),
                            // badgeContent: Text(
                            //   (countPush.getListaNotificacionesPushNoLeidas.length > 9)
                            //       ? '9+'
                            //       : (countPush.getListaNotificacionesPushNoLeidas.isEmpty)
                            //           ? ''
                            //           : '${countPush.getListaNotificacionesPushNoLeidas.length}',

                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(0),
                            width: 45,
                            height: 45,
                            padding: EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: (countPush.getBtnIniciaTurno == true ||
                                      widget.validaTurno != null)
                                  ? () {
                                      Provider.of<HomeController>(context,
                                              listen: false)
                                          .buscaNotificacionesPush('');
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                              // const ListaConsignasGuardiasPage()
                                              const ListaNotificacionesPush()));
                                    }
                                  : null,
                              child: CircleAvatar(
                                backgroundColor: const Color(0XFF0076A7),
                                radius: 100,
                                child: Image.asset(
                                  'assets/imgs/Recurso 2.png',
                                  width: size.iScreen(2.5),
                                ), //Text
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox(), //CirlceAv

              Container(
                margin: EdgeInsets.only(
                  right: size.iScreen(1.0),
                ),
                child: Consumer<HomeController>(
                  builder: (_, count2Push, __) {
                    return Badge(
                      badgeColor: (count2Push.getNumNotificaciones2 == 0)
                          ? Colors.transparent
                          : Colors.red,
                      elevation:
                          (count2Push.getNumNotificaciones2 == 0) ? 0 : 5,
                      position: const BadgePosition(top: 5.0, start: 25.0),
                      badgeContent: Text(
                        (count2Push.getNumNotificaciones2 > 9)
                            ? '9+'
                            : (count2Push.getNumNotificaciones2 == 0)
                                ? ''
                                : '${count2Push.getNumNotificaciones2}',

                        // badgeColor: (count2Push
                        //         .getListaNotificaciones2PushNoLeidas.isEmpty)
                        //     ? Colors.transparent
                        //     : Colors.red,
                        // elevation: (count2Push
                        //         .getListaNotificaciones2PushNoLeidas.isEmpty)
                        //     ? 0
                        //     : 5,
                        // position: const BadgePosition(top: 5.0, start: 25.0),
                        // badgeContent: Text(
                        //   // '${count2Push.getListaNotificaciones2PushNoLeidas.length}',
                        //   (count2Push.getListaNotificaciones2PushNoLeidas.length >
                        //           9)
                        //       ? '9+'
                        //       : (count2Push.getListaNotificaciones2PushNoLeidas
                        //               .isEmpty)
                        //           ? ''
                        //           : '${count2Push.getNumNotificaciones2}',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                      child:
                          //  Icon(Icons.notifications,size: size.iScreen(3.0),)),
                          IconButton(
                              splashRadius: 28,
                              onPressed:
                                  (count2Push.getBtnIniciaTurno == true ||
                                          widget.validaTurno != null)
                                      ? () {
                                          Provider.of<HomeController>(context,
                                                  listen: false)
                                              .buscaNotificacionesPush('');
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      // const ListaConsignasGuardiasPage()
                                                      ListaNotificaciones2Push(
                                                          user: widget.user)));
                                        }
                                      : null,
                              icon: Icon(
                                Icons.notifications,
                                size: size.iScreen(3.5),
                                color: Colors.white,
                              )),
                    );
                  },
                ),

                //  Icon(Icons.notifications,size: size.iScreen(3.0),)),
              ),

              //  Icon(Icons.notifications,size: size.iScreen(3.0),)),
            ],
          ),
          drawer: CustomDrawer(tipo: widget.tipo, users: widget.user),
          body: Container(
            // color: Colors.red,
            width: size.wScreen(100.0),
            height: size.hScreen(100.0),
            padding: EdgeInsets.only(
              top: size.iScreen(0.0),
              right: size.iScreen(0.0),
              left: size.iScreen(0.0),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      // InkWell(
                      //   onTap: () => LocalNotifications.showNotification(
                      //     title: 'Titles',
                      //     body: 'Bodys',
                      //     payload: 'Dato recibido desde el servidor JUANITO',
                      //   ),
                      //   child:
                      Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(top: size.iScreen(2.0)),
                          // width: size.iScreen(100.0),
                          // height: size.iScreen(1.0),
                          child: FadeInImage(
                            image: NetworkImage(
                              widget.user!.logo!,
                              scale: size.wScreen(2.5),
                            ),
                            placeholder:
                                const AssetImage('assets/imgs/loader.gif'),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/imgs/no-image.jpg',
                                  width: size.iScreen(10.0));
                            },
                            fit: BoxFit.fitWidth,
                          )
                          // Image.network(widget.user!.logo!,errorBuilder: (context, error, stackTrace) {
                          //   return 'https://manarhealings.net/wp-content/plugins/sfwd-lms/assets/images/nologo.jpg';
                          // }),
                          // widget.user!.logo!=null?

                          //:'https://manarhealings.net/wp-content/plugins/sfwd-lms/assets/images/nologo.jpg'
                          //     FadeInImage(
                          //   placeholder:
                          //       const AssetImage('assets/imgs/loader.gif'),
                          //   image: NetworkImage(
                          //     widget.user!.logo==null?'https://manarhealings.net/wp-content/plugins/sfwd-lms/assets/images/nologo.jpg': widget.user!.logo!,
                          //     scale: size.wScreen(2.5),
                          //   ),
                          // ),

                          ),
                      // ),
                      Expanded(
                        child: Container(
                          // color: Colors.red,
                          child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  //==============================================//
                                  Text(
                                      (widget.tipo!.contains('GUARDIA'))
                                          ? 'GUARDIA'
                                          : (widget.tipo!
                                                  .contains('SUPERVISOR'))
                                              ? 'SUPERVISOR'
                                              : '',
                                      style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.8),
                                          // color: Colors.white,
                                          fontWeight: FontWeight.normal)),
                                  //==============================================//
                                  Consumer<HomeController>(
                                    builder: (_, valueBtnTurno, __) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: (valueBtnTurno
                                                            .getBtnIniciaTurno ==
                                                        true ||
                                                    widget.validaTurno != null)
                                                ? primaryColor
                                                : const Color(0XFF3C3C3B),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        width: size.wScreen(55.0),
                                        height: size.hScreen(5.0),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(0.0),
                                          vertical: size.iScreen(1.0),
                                        ),
                                        child: MaterialButton(
                                            elevation: 20.0,
                                            // splashColor:color ,
                                            onPressed: () {
                                              if (valueBtnTurno
                                                          .getBtnIniciaTurno ==
                                                      true ||
                                                  widget.validaTurno != null) {
                                                _modalFinalizarTurno(
                                                    size, homeController);
                                              } else {
                                                _modalInciaTurno(
                                                    size, homeController);
                                              }

                                              // if (
                                              //   providerHome
                                              //             .getValidaBtnTurno ==
                                              //         true ||
                                              //     widget.validaTurno !=
                                              //         null) {
                                              //   _modalFinalizarTurno(
                                              //       size,
                                              //       providerHome);
                                              // } else {
                                              //   // _modalTerminosCondiciones(size, providerHome);
                                              //   //Navigator.pop(context);
                                              //   _modalInciaTurno(
                                              //       size,
                                              //       providerHome);
                                              //   // _validaScanQR(controllerHome);
                                              //   // Navigator.pop(context);
                                              // }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                (valueBtnTurno.getBtnIniciaTurno ==
                                                            true ||
                                                        widget.validaTurno !=
                                                            null)
                                                    ? Text(
                                                        'Finalizar Turno ',
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        2.0),
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      )
                                                    : Text(
                                                        'Iniciar Turno ',
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        2.0),
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                // : Container(),
                                                const Icon(Icons.access_time,
                                                    color: Colors.white),
                                              ],
                                            )),
                                      );
                                    },
                                  ),

                                  //==============================================//
                                  Consumer<HomeController>(
                                    builder: (_, valueValidaTurno, __) {  
                                      return Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          // ========= ITEM NOVEDADES ======//

                                          ( //widget.tipo!.contains('CLIENTE') ||
                                                  widget.tipo!.contains(
                                                          'GUARDIA') ||
                                                      widget.tipo!.contains(
                                                          'SUPERVISOR'))
                                              ? ItemsMenuHome(
                                                  onTap: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? () {
                                                          // Navigator.pushNamed(
                                                          //     context, 'novedades');
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NovedadesPage(
                                                                      tipo: widget
                                                                          .tipo,
                                                                      user: widget
                                                                          .user)));
                                                        }
                                                      : null,
                                                  label: 'Novedades',
                                                  icon: 'news.png',
                                                  color: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? const Color(0XFFEF557B)
                                                      : Colors.grey,
                                                )
                                              : const SizedBox(),

                                          // ========= ITEM NOVEDADES ======//
                                          (widget.tipo!.contains('GUARDIA') ||
                                                  widget.tipo!
                                                      .contains('SUPERVISOR'))
                                              ? ItemsMenuHome(
                                                  onTap: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? () {
                                                          Provider.of<ActivitiesController>(
                                                                  context,
                                                                  listen: false)
                                                              .getTodasLasActividades(
                                                                  '');
                                                          // Navigator.pushNamed(
                                                          //     context,
                                                          //     'actividades',);
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ActividadesPage(
                                                                            tipo:
                                                                                widget.tipo,
                                                                            usuario:
                                                                                widget.user,
                                                                          )));
                                                        }
                                                      : null,
                                                  label: 'Actividades',
                                                  icon: 'activities.png',
                                                  color: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? Colors.brown
                                                      : Colors.grey,
                                                )
                                              : const SizedBox(),

                                          // ========= ITEM LOGISTICA ======//
                                          (widget.tipo!.contains('SUPERVISOR'))
                                              ? ItemsMenuHome(
                                                  onTap: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? () {
                                                          // Navigator.pushNamed(
                                                          //           context,
                                                          //           'pedidos');
                                                          Provider.of<LogisticaController>(
                                                                  context,
                                                                  listen: false)
                                                              .getTodosLosPedidosGuardias(
                                                                  '');
                                                          Navigator.pushNamed(
                                                              context,
                                                              'logisticaPage');
                                                        }
                                                      : null,
                                                  label: 'Logística',
                                                  icon: 'logistic.png',
                                                  color: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                )
                                              : const SizedBox(),

                                          // ========= ITEM INFORMES ======//
                                          (widget.tipo!.contains('GUARDIA') ||
                                                  widget.tipo!
                                                      .contains('SUPERVISOR'))
                                              ? ItemsMenuHome(
                                                  onTap: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? () {
                                                          // informeController
                                                          //     .buscaInformeGuardias(
                                                          // Provider.of<InformeController>(
                                                          //         context,
                                                          //         listen:
                                                          //             false)
                                                          //     .buscaInformeGuardias(
                                                          //         '');
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ListaInformesGuardiasPage(
                                                                          usuario:
                                                                              widget.user)));
                                                        }
                                                      : null,
                                                  label: 'Informes',
                                                  icon: 'report.png',
                                                  color: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? Colors.green
                                                      : Colors.grey,
                                                )
                                              : const SizedBox(),
                                          // ========= ITEM BITACORA ======//
                                          (widget.tipo == 'admin')
                                              ? ItemsMenuHome(
                                                  onTap: () {
                                                    print('Bitácora');
                                                  },
                                                  label: 'Bitácora',
                                                  icon: 'report.png',
                                                  color: Colors.pinkAccent,
                                                )
                                              : const SizedBox(),
                                          // ========= ITEM CONSIGNAS ======//
                                          (widget.tipo!.contains('CLIENTE') ||
                                                  widget.tipo!
                                                      .contains('GUARDIA'))
                                              ? ItemsMenuHome(
                                                  onTap: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? () {
                                                          if (widget.tipo!
                                                              .contains(
                                                                  'CLIENTE')) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                'listaConsignasClientes');
                                                          } else if (widget
                                                              .tipo!
                                                              .contains(
                                                                  'GUARDIA')) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                'listaConsignasGuardias');
                                                          }
                                                        }
                                                      : null,
                                                  label: 'Consignas',
                                                  icon: 'control.png',
                                                  color: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? Colors.cyan
                                                      : Colors.grey)
                                              : const SizedBox(),
                                          // ========= ITEM COMUNICADOS ======//
                                          (widget.tipo!.contains('CLIENTE') ||
                                                  widget.tipo!
                                                      .contains('GUARDIA') ||
                                                  widget.tipo!
                                                      .contains('SUPERVISOR'))
                                              ? ItemsMenuHome(
                                                  onTap: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? () {
                                                          if (valueValidaTurno
                                                                      .getBtnIniciaTurno ==
                                                                  true ||
                                                              widget.validaTurno !=
                                                                  null) {
                                                            (widget.tipo!.contains(
                                                                    'CLIENTE'))
                                                                ? Navigator
                                                                    .pushNamed(
                                                                        context,
                                                                        'listaComunicadosClientes')
                                                                : Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const ListaComunicadosGuardiasPage()));
                                                          }

                                                          //  Navigator.pushNamed(
                                                          //                 context, 'listaComunicadosClientes');
                                                          //  Navigator.pushNamed(
                                                          //                 context, 'ListaComunicadosGuardiasPage');
                                                        }
                                                      : null,
                                                  label: 'Comunicados',
                                                  icon: 'megaphone.png',
                                                  color: (valueValidaTurno
                                                                  .getBtnIniciaTurno ==
                                                              true ||
                                                          widget.validaTurno !=
                                                              null)
                                                      ? Colors.deepOrange
                                                      : Colors.grey,
                                                )
                                              : const SizedBox(),
                                          // ========= ITEM ESTADO DE CUENTES ======//
                                          (widget.tipo!.contains('CLIENTE'))
                                              ? ItemsMenuHome(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        'listaEstadoCuentaClientes');
                                                  },
                                                  label: 'Estado de Cuenta',
                                                  icon: 'profits.png',
                                                  color: Colors.green,
                                                )
                                              : const SizedBox(),
                                          // ========= ITEM ALERTA ======//
                                          Container(
                                            width: size.iScreen(14.0),
                                            height: size.iScreen(14.0),
                                            decoration: BoxDecoration(
                                                boxShadow: const <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.black54,
                                                      blurRadius: 5.0,
                                                      offset: Offset(0.0, 0.75))
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            margin: EdgeInsets.all(
                                                size.iScreen(1.0)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.red),
                                                  //  borderRadius: BorderRadius.circular(15)),
                                                  child: MaterialButton(
                                                    elevation: 20.0,
                                                    splashColor:
                                                        const Color(0XFFFB473B),
                                                    onPressed: () async {
                                                      // homeController.enviaAlerta(
                                                      Provider.of<HomeController>(
                                                              context,
                                                              listen: false)
                                                          .enviaAlerta(
                                                              widget.user!
                                                                  .usuario!,
                                                              widget.tipo,
                                                              widget.user!
                                                                  .rucempresa!,
                                                              widget
                                                                  .ubicacionGPS);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Image.asset(
                                                            'assets/imgs/alarma.png',
                                                            color: Colors.white,
                                                            width: size
                                                                .iScreen(8.0)),
                                                        Text(
                                                          'Alerta',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.6),
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  )

                                  //==============================================//
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: size.iScreen(-2),
                  right: size.iScreen(-4),
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(size.iScreen(5.0)),
                    // width: size.iScreen(1.0),
                    // height: size.iScreen(1.0),
                    child: (widget.tipo!.contains('CLIENTE'))
                        ? Image.asset(
                            'assets/imgs/LogoClientes.png',
                            width: size.iScreen(13.0),
                          )
                        : (widget.tipo!.contains('GUARDIA'))
                            ? Image.asset(
                                'assets/imgs/Guardias.png',
                                width: size.iScreen(13.0),
                              )
                            : Image.asset(
                                'assets/imgs/Guardias.png',
                                width: size.iScreen(13.0),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _modalFinalizarTurno(Responsive size, HomeController homeController) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // final homeControllers= Provider.of<HomeController>(context);
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FINALIZAR TURNO',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.5),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  IconButton(
                      splashRadius: size.iScreen(3.0),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: size.iScreen(3.5),
                      )),
                ],
              ),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('¿ Está seguro de finalizar turno ?',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.5),
                              // color: textPrimaryColor,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: size.iScreen(2.5),
                      horizontal: size.iScreen(2.5)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      ),
                    ),
                    onPressed: () async {
                      //=============================================//

                      try {
                        final status = await Permission.location.request();
                        if (status == PermissionStatus.granted) {
                          ProgressDialog.show(context);
                          await homeController.getCurrentPosition();
                          // setState(() {
                          homeController.setBtnTurno(false);
                          homeController.setTerminosCondiciones(false);

                          await Auth.instance.deleteTurnoSesionUser();
                          await Auth.instance.deleteTurnoSesion();
                          homeController.finalizarTurno(context);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, 'splash')
                              .then((value) => setState(() {}));

                          // });

                          ProgressDialog.dissmiss(context);
                        } else if (status == PermissionStatus.denied ||
                            status == PermissionStatus.restricted ||
                            status == PermissionStatus.permanentlyDenied ||
                            status == PermissionStatus.limited) {
                          openAppSettings();
                        }
                        // ProgressDialog.show(context);
                      } on PlatformException {
                        NotificatiosnService.showSnackBarError(
                            'No se pudo finalizar Turno');
                      }
                      //=============================================//
                    },
                    child: Text('Finalizar',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.1),
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
              ],
            ),
          );
        });
  }

//======================== VAALIDA SCANQR =======================//
  void _validaScanQR(Responsive size, HomeController controllerHome) async {
    try {
      // String? barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      //     '#34CAF0', '', false, ScanMode.QR);
      // if (!mounted) return;
      // controllerHome.setInfoQRTurno(barcodeScanRes);
      // _modalTerminosCondiciones(size,controllerHome);
      controllerHome.setInfoQRTurno(await FlutterBarcodeScanner.scanBarcode(
          '#34CAF0', '', false, ScanMode.QR));
      if (!mounted) return;
      final status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        ProgressDialog.show(context);
        await controllerHome.getCurrentPosition();
        await controllerHome.validaCodigoQRTurno(context);
        ProgressDialog.dissmiss(context);
      }
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.restricted ||
          status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.limited) {
        openAppSettings();
      }
      // ProgressDialog.show(context);
    } on PlatformException {
      NotificatiosnService.showSnackBarError('No se pudo escanear ');
    }
  }

  ///====== MUESTRA MODAL TERMINOS Y CONDICIONES =======//
  void _modalTerminosCondiciones(
      Responsive size, HomeController homeController) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          final homeControllers = Provider.of<HomeController>(context);
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Términos y Condiciones',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  IconButton(
                      splashRadius: size.iScreen(3.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: size.iScreen(3.5),
                      )),
                ],
              ),
              actions: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: size.wScreen(100),
                  // color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(2.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Wrap(
                        // direction : Axis.horizontal,
                        runAlignment: WrapAlignment.spaceEvenly,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text(
                              'Debe aceptar términos y condiciones para poder continuar.',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.0),
                                  // color: textPrimaryColor,
                                  fontWeight: FontWeight.normal)),
                          InkWell(
                              child: Text('Ver más...',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(2.0),
                                      color: tercearyColor,
                                      fontWeight: FontWeight.bold)),
                              onTap: null //abrirPaginaPazViSeg(),
                              ),
                        ],
                      ),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: homeControllers.getTerminosCondiciones,
                      onChanged: (bool? value) {
                        homeControllers.setTerminosCondiciones(value!);
                      },
                    ),
                    Text('Términos y Condiciones ',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            // color: textPrimaryColor,
                            fontWeight: FontWeight.normal)),
                    //Checkbox
                  ], //<Widget>[]
                ), //Row

                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: size.iScreen(2.5),
                      horizontal: size.iScreen(2.5)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        !homeControllers.getTerminosCondiciones
                            ? Colors.grey
                            : const Color(0XFF3C3C3B),
                      ),
                    ),
                    onPressed: homeControllers.getTerminosCondiciones
                        ? () {
                            _validaScanQR(size, homeControllers);
                            Navigator.pop(context);

                            // Navigator.pushNamedAndRemoveUntil(context, "home",
                            //     (Route<dynamic> route) => false);
                          }
                        : null,
                    child: Text('Aceptar',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.3),
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalInciaTurno(Responsive size, HomeController homeController) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('INICIAR TURNO',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  IconButton(
                      splashRadius: size.iScreen(3.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: size.iScreen(3.5),
                      )),
                ],
              ),
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading:
                            const Icon(Icons.qr_code_2, color: Colors.black),
                        title: Text(
                          "Código QR",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () async {
                          // homeController.setOpcionActividad(1);
                          Navigator.pop(context);
                          _modalTerminosCondiciones(size, homeController);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading: const Icon(Icons.badge_outlined,
                            color: Colors.black),
                        title: Text(
                          "Código Personal",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          // print('EEEERRRRR');
                          //homeController.setOpcionActividad(1);
                          // Navigator.pop(context);
                          Navigator.pushNamed(context, 'validaAccesoTurno');
                        },
                      ),
                      // const Divider(),
                      // ListTile(
                      //   tileColor: Colors.grey[200],
                      //   leading:
                      //       const Icon(Icons.list_alt, color: Colors.black),
                      //   title: Text(
                      //     "Nómina de Personal",
                      //     style: GoogleFonts.lexendDeca(
                      //       fontSize: size.iScreen(1.5),
                      //       fontWeight: FontWeight.bold,
                      //       // color: Colors.white,
                      //     ),
                      //   ),
                      //   trailing: const Icon(Icons.chevron_right_outlined),
                      //   onTap: () {
                      //     homeController.setOpcionActividad(3);
                      //     Navigator.pop(context);
                      //     Navigator.pushNamed(context, 'validaAccesoMultas');
                      //   },
                      // ),

                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
