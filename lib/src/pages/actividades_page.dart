import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/controllers/activities_controller.dart';
// import 'package:sincop_app/src/controllers/novedades_controller.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/detalle_actividades_page.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
// import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
// import 'package:sincop_app/src/widgets/item_menu_novedades.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ActividadesPage extends StatefulWidget {
  final Session? usuario;
  final List<String?>? tipo;
  const ActividadesPage({Key? key, this.tipo, this.usuario}) : super(key: key);

  @override
  State<ActividadesPage> createState() => _ActividadesPageState();
}

class _ActividadesPageState extends State<ActividadesPage> {
  // final fechaActual = DateTime.now();
// bool _fechaEstado=false;

  // widget.tipo!.contains(
  //     'SUPERVISOR')

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
// final perfil= (widget.tipo!.contains('GUARDIA'))?'GUARDIA':'SUPERVISOR';
    final loadInfo = Provider.of<ActivitiesController>(context, listen: false);
    loadInfo.getTodasLasActividades('');

    // loadInfo.realizaRondaPunto();

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'actividad') {
        loadInfo.getTodasLasActividades('');
        // NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'actividad') {
        loadInfo.getTodasLasActividades('');
        // serviceSocket.socket!.clearListeners();
        // NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
      if (data['tabla'] == 'actividad') {
        loadInfo.getTodasLasActividades('');
        // NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket?.on('server:error', (data) {
      NotificatiosnService.showSnackBarError(data['msg']);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('TIPO: ${widget.tipo}');
    // print('FECHA ACTUAL: ${perfil}');
    int? diasCalculados;
    final Responsive size = Responsive.of(context);
    final controllerActividades = Provider.of<ActivitiesController>(context);
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        appBar: AppBar(
          // backgroundColor: const Color(0XFF343A40), // primaryColor,
          title: Text(
            'Mis Actividades',
            style: GoogleFonts.lexendDeca(
                fontSize: size.iScreen(2.8),
                color: Colors.white,
                fontWeight: FontWeight.normal),
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
          //  actions: [
          //   //  IconButton(onPressed: (){}, icon: icon)
          //  ],
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: 
          Container(
              // color: Colors.red,
              width: size.wScreen(100.0),
              // height: size.hScreen(100.0),
              padding: EdgeInsets.only(
                top: size.iScreen(0.0),
                left: size.iScreen(0.5),
                right: size.iScreen(0.5),
              ),
              child: Consumer<ActivitiesController>(
                builder: (_, provider, __) {
                  if (provider.getErrorActividades == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            height: size.iScreen(2.0),
                          ),
                          const Text('Cargando Actividades.... '),
                        ],
                      ),
                    );
                  } else if (provider.getListaTodasLasActividades.isEmpty) {
                    return const NoData(
                      label: 'No existen actividades para mostar',
                    );
                  } else if (provider.getListaTodasLasActividades.isEmpty) {
                    return const NoData(
                      label: 'No existen datos para mostar',
                    );
                    // Text("sin datos");
                  }
                  return ListView.builder(
                    itemCount: provider.getListaTodasLasActividades.length,
                    itemBuilder: (BuildContext context, int index) {
//================= REVISAMOS NUMERO DE DIAS =======================//

                      // List personalDesignado =[];
                      List supervisoresDesignados = [];
                      final List guardiasDesignados = [];
                      for (var e in provider.getListaTodasLasActividades[index]
                          ['actAsignacion']) {
                        if (e['asignado'] == true) {
                          guardiasDesignados.add(e['nombres']);
                        }
                      }
                      for (var e in provider.getListaTodasLasActividades[index]
                          ['actSupervisores']) {
                        if (e['asignado'] == true) {
                          supervisoresDesignados.add(e['nombres']);
                        }
                      }

                      final totalDesignados = guardiasDesignados.length +
                          supervisoresDesignados.length;

                      // return Text('data');
                      final actividad =
                          provider.getListaTodasLasActividades[index];

                      // =====================CALCULAMOS LOS DIAS DE LA ACIVIDAD======//

                      if (provider.getListaTodasLasActividades[index]['actFechasActividadConsultaDB'].isNotEmpty) {
                        DateTime fechaInicio = (DateTime.parse(provider.getListaTodasLasActividades[index]['actFechasActividadConsultaDB'][0]));
                        DateTime fechaFin = DateTime.parse(provider.getListaTodasLasActividades[index]['actFechasActividadConsultaDB'][provider.getListaTodasLasActividades[index]
                                        ['actFechasActividadConsultaDB'].length -
                                1]);
                        // print('FECHA INICIO: ${fechaInicio}');
                        // print('FECHA FIN: ${fechaFin}');
                        Duration diasDiferencia =
                            fechaFin.difference(fechaInicio);
                        int diasDeTrabajo = diasDiferencia.inDays;

                        diasCalculados = (diasDeTrabajo == 0)
                            ? (diasDeTrabajo + 1)
                            : diasDeTrabajo;
                        // print(diasCalculados);
                      }

// ======================VERIFICA SI ESTA DESIGNADO ========================//
                      // print(
                      //     'PERFIL DE LA PERSONA : ${widget.tipo!.contains('SUPERVISOR')}');

                      bool? _asignado;
                      String? _trabajoCumplido;
                      int? _progreso;

                      if (widget.tipo!.contains('SUPERVISOR')) {
                        for (var e
                            in provider.getListaTodasLasActividades[index]
                                ['actSupervisores']) {
                          if (e['docnumero'] == widget.usuario!.usuario &&
                              e['asignado'] == true) {
                            //        supervisoresDesignados.add(e);
                            _asignado = true;
                            _progreso = e['trabajos'].length;
                            if (diasCalculados! > _progreso!) {
                              _trabajoCumplido = 'EN PROGRESO';
                            } else if (diasCalculados == _progreso) {
                              _trabajoCumplido = 'REALIZADO';
                            } else if (diasCalculados! < _progreso) {
                              _trabajoCumplido = 'NO REALIZADO';
                            }
                            // print(' SUPERVISOR SI ESTA DESIGNADO: $e}');
                          } else {
                            // print('SUPERVISOR NOooooo ESTA DESIGNADO: $e');
                          }
                        }
                      }
                      if (widget.tipo!.contains('GUARDIA')) {
                        for (var e
                            in provider.getListaTodasLasActividades[index]
                                ['actAsignacion']) {
                          if (e['docnumero'] == widget.usuario!.usuario &&
                              e['asignado'] == true) {
                            //        supervisoresDesignados.add(e);
                            _asignado = true;
                            _progreso = e['trabajos'].length;
                            if (diasCalculados! > _progreso!) {
                              _trabajoCumplido = 'EN PROGRESO';
                            } else if (diasCalculados == _progreso) {
                              _trabajoCumplido = 'REALIZADO';
                            } else if (diasCalculados! < _progreso) {
                              _trabajoCumplido = 'NO REALIZADO';
                            }
                            // print(' GUARDIA SI ESTA DESIGNADO: $e}');
                          } else {
                            // print('GUARDIA NOooooo ESTA DESIGNADO: $e');
                          }
                        }
                      }
// ==============================================//
// ======================VERIFICA SI ESTA DESIGNADO ========================//

// int? _progreso;
                      // for (var e in provider.getListaTodasLasActividades[index]['actSupervisores']) {

                      //   // print('====> $index _progreso : ${e['trabajos'].length}');
                      //   _progreso=e['trabajos'].length;
                      // }
// ==============================================//

                      // final fechaRecibida = provider
                      //     .getListaTodasLasActividades[index]['actHasta']
                      //     .replaceAll("T", " ");
                      // final fechaHasta = DateTime.parse(fechaRecibida);

                      return Slidable(
                        startActionPane: const ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: ScrollMotion(),

                          children: [
                            // SlidableAction(
                            //   backgroundColor: Colors.purple,
                            //   foregroundColor: Colors.white,
                            //   icon: Icons.edit,
                            //   // label: 'Editar',
                            //   onPressed: (context) {
                            //     // Navigator.push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //         builder: ((context) =>
                            //     //             CreaEditaComunicadoClientePage(
                            //     //               infoComunicadoCliente: comunicado,
                            //     //               accion: 'Editar',
                            //     //             )))
                            //     //             );
                            //   },
                            // ),
                            // SlidableAction(
                            //   onPressed: (context) async {
                            //     // ProgressDialog.show(context);
                            //     // await multasControler.eliminaMultaGuardia(
                            //     //     context, multas);
                            //     ProgressDialog.dissmiss(context);
                            //   },
                            //   backgroundColor: Colors.red.shade700,
                            //   foregroundColor: Colors.white,
                            //   icon: Icons.delete_forever_outlined,
                            //   // label: 'Eliminar',
                            // ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            //      Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: ((context) => ConsignaLeidaGuardiaPage(
                            //         infoConsignaCliente: consigna)),
                            //   ),
                            // );
                            // Navigator.pushNamed(context, 'detalleMultaGuardia');



                              controllerActividades.getActividad(actividad,widget.usuario);

                            final Session? usuario =
                                await Auth.instance.getSession();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => DetalleActividades(
                                          infoActividad: actividad,
                                          usuario: usuario,
                                        ))));
                          },
                          child: ClipRRect(
                            // borderRadius: BorderRadius.circular(8),
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.only(top: size.iScreen(0.5)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.iScreen(1.0),
                                    vertical: size.iScreen(0.5)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 1.0,
                                        offset: Offset(0.0, 1.0))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         'DIAS:  ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         '$diasCalculados ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         'Trabs :  ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),

                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         '$_progreso ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         'Asig:  ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child:

                                          //       Text('$_asignado ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         'Est:  ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child:

                                          //       Text('$_progreso ',
                                          //       // Text(' ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize:
                                          //                 size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Asunto: ',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize:
                                                          size.iScreen(1.5),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  // color: Colors.red,
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(55.0),
                                                  child: Text(
                                                    '${actividad['actAsunto']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         'Condición: ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         actividad['actNomActividad'] ==
                                          //                 ''
                                          //             ? 'NO DEFINIDA'
                                          //             : '${actividad['actNomActividad']}',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.bold),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         'Fecha desde: ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         actividad['actDesde']
                                          //             .toString()
                                          //             .replaceAll("T", " "),
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.bold),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         'Fecha hasta: ',
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(1.5),
                                          //             color: Colors.black87,
                                          //             fontWeight:
                                          //                 FontWeight.normal),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       margin: EdgeInsets.only(
                                          //           top: size.iScreen(0.5),
                                          //           bottom: size.iScreen(0.0)),
                                          //       // width: size.wScreen(100.0),
                                          //       child: Text(
                                          //         actividad['actHasta']
                                          //             .toString()
                                          //             .replaceAll("T", " "),
                                          //         style: GoogleFonts.lexendDeca(
                                          //             fontSize: size.iScreen(1.5),
                                          //             color:
                                          //             //  (fechaHasta.compareTo(
                                          //             //             fechaActual) >
                                          //             //         0)
                                          //             //     ? Colors.green
                                          //             //     :
                                          //                 Colors.red,
                                          //             fontWeight:
                                          //                 FontWeight.bold),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Prioridad: ',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize:
                                                          size.iScreen(1.5),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  actividad['actPrioridad'],
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize:
                                                          size.iScreen(1.5),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Ubicación: ',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize:
                                                          size.iScreen(1.5),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    actividad['actUbicacion'] !=
                                                            ''
                                                        ? actividad[
                                                            'actUbicacion']
                                                        : 'No Designada',
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Puesto: ',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize:
                                                          size.iScreen(1.5),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(5.0),
                                                  child: Text(
                                                    actividad['atcPuesto'] != ''
                                                        ? actividad['atcPuesto']
                                                        : 'No Asignado',
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Personal Designado: ',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize:
                                                          size.iScreen(1.5),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  // '${personalDesignado.length} -  ${supervisoresDesignados.length}',
                                                  '${totalDesignados}',
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize:
                                                          size.iScreen(1.5),
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: size.iScreen(1.0),
                                            // top: size.iScreen(0.5),
                                            // bottom: size.iScreen(0.0)
                                          ),
                                          child: Text(
                                            'Progreso',
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: size.iScreen(1.6),
                                                // color: Colors.black87,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: size.iScreen(1.0),
                                              top: size.iScreen(0.5),
                                              bottom: size.iScreen(0.0)),
                                          // width: size.wScreen(100.0),
                                          child:
                                              // _trabajoCumplido==0?

                                              Text(
                                            // actividad['actProgreso'],
                                            // 'REALIZADO',
                                            _trabajoCumplido!,
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: size.iScreen(1.5),
                                                color: _trabajoCumplido ==
                                                        'REALIZADO'
                                                    ? secondaryColor
                                                    : _trabajoCumplido ==
                                                            'EN PROGRESO'
                                                        ? tercearyColor
                                                        : _trabajoCumplido ==
                                                                'NO REALIZADO'
                                                            ? Colors.red
                                                            : Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // :_trabajoCumplido==1?
                                          // Text(
                                          //   'EN PROGRESO',
                                          //   style: GoogleFonts.lexendDeca(
                                          //       fontSize: size.iScreen(1.5),
                                          //       color:_trabajoCumplido==1?tercearyColor:secondaryColor,
                                          //       fontWeight: FontWeight.bold),
                                          // ):_trabajoCumplido==2?
                                          // Text(
                                          //   'NO REALIZADO',
                                          //   style: GoogleFonts.lexendDeca(
                                          //       fontSize: size.iScreen(1.5),
                                          //       color: Colors.red,
                                          //       fontWeight: FontWeight.bold),
                                          // ):
                                          // Text(
                                          //   'NO REALIZADO',
                                          //   style: GoogleFonts.lexendDeca(
                                          //       fontSize: size.iScreen(1.5),
                                          //       color: Colors.red,
                                          //       fontWeight: FontWeight.bold),
                                          // ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )),
       
       
        ));
  }

  //======================= ACTUALIZA LA PANTALLA============================//
  Future<void> onRefresh() async {
    final controllerActividades =
        Provider.of<ActivitiesController>(context, listen: false);
    controllerActividades.getTodasLasActividades('');
  }
  //===================================================//

}
