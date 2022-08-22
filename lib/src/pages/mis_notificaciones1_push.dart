import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/activities_controller.dart';

import 'package:sincop_app/src/controllers/consignas_clientes_controller.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
import 'package:sincop_app/src/pages/actividades_page.dart';
import 'package:sincop_app/src/pages/alerta_page.dart';
import 'package:sincop_app/src/pages/consigna_leida_cliente_page.dart';
import 'package:sincop_app/src/pages/consigna_leida_guardia_page.dart';
import 'package:sincop_app/src/pages/crea_consigna_cliente_page.dart';
import 'package:sincop_app/src/pages/detalle_notificacion1.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';

import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaNotificacionesPush extends StatefulWidget {
  final informacion;
  const ListaNotificacionesPush({Key? key, this.informacion}) : super(key: key);

  @override
  State<ListaNotificacionesPush> createState() =>
      _ListaNotificacionesPushState();
}

class _ListaNotificacionesPushState extends State<ListaNotificacionesPush> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final loadInfo = Provider.of<HomeController>(context, listen: false);
    // loadInfo.buscaNotificacionesPush('');

    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    serviceSocket.socket?.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'notificacionleido') {
        loadInfo.buscaNotificacionesPush('');
        //  loadInfo.cuentaNotificacionesNOLeidas();
        
        // NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        // backgroundColor: primaryColor,
        title: const Text('Mis Notificaciones'),
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
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: size.iScreen(1.0),
        ),

        // color: Colors.red,
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),

        child: Consumer<HomeController>(
          builder: (_, providers, __) {
            if (providers.getErrorNotificacionesPush == null) {
              return const NoData(
                label: 'No existen datos para mostar',
              );
            } else if (providers.getErrorNotificacionesPush == false) {
              return const NoData(
                label: 'No existen datos para mostar',
              );
            } else if (providers.getListaNotificacionesPush.isEmpty) {
              return const NoData(
                label: 'No existen datos para mostar',
              );
              // Text("sin datos");
            }

            return ListView.builder(
              itemCount: providers.getListaNotificacionesPush.length,
              itemBuilder: (BuildContext context, int index) {
                final notificacion =
                    providers.getListaNotificacionesPush[index];
                return Slidable(
                  key: ValueKey(index),
                  // The start action pane is the one at the left or the top side.
                  startActionPane: const ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion:  ScrollMotion(),

                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      // SlidableAction(
                      //   backgroundColor: Colors.purple,
                      //   foregroundColor: Colors.white,
                      //   icon: Icons.edit,
                      //   // label: 'Editar',
                      //   onPressed: (context) {},
                      // ),
                      // SlidableAction(
                      //   onPressed: (context) {},
                      //   backgroundColor: Colors.red.shade700,
                      //   foregroundColor: Colors.white,
                      //   icon: Icons.delete_forever_outlined,
                      //   // label: 'Eliminar',
                      // ),
                     
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      // providers.leerNotificacionPush(notificacion);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: ((context) => DetalleNotificacion1Page(
                      //         informacion: notificacion
                      //         )),
                      //   ),
                      // );
                       providers.leerNotificacionPush(notificacion);
                       Provider.of<ActivitiesController>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getTodasLasActividades(
                                                                      '');
                                                              // Navigator.pushNamed(
                                                              //     context,
                                                              //     'actividades',);
                                                              Navigator.of(context).push(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          const ActividadesPage(
                                                                            // usuario:
                                                                            //     widget.user,
                                                                          )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: size.iScreen(0.5)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.iScreen(1.5),
                          vertical: size.iScreen(0.5)),
                      decoration: BoxDecoration(
                        color: notificacion['notVisto'] == 'NO'
                            ? const Color.fromARGB(255, 206, 229, 246)
                            : Colors.white,
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: size.iScreen(0.5),
                                      bottom: size.iScreen(0.0)),
                                  width: size.wScreen(100.0),
                                  child: Text(
                                    // '${notificacion['notTipo']} - ${notificacion['notId']} - ${notificacion['notVisto']}',
                                    '${notificacion['notTipo']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.6),
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(
                                //       top: size.iScreen(0.5),
                                //       bottom: size.iScreen(0.0)),
                                //   width: size.wScreen(100.0),
                                //   child: Text(
                                //     'notificacion.conDetalle}',
                                //     overflow: TextOverflow.ellipsis,
                                //     style: GoogleFonts.lexendDeca(
                                //         fontSize: size.iScreen(1.5),
                                //         color: Colors.black87,
                                //         fontWeight: FontWeight.normal),
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0)),
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        'Empresa: ',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0)),
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        '${notificacion['notEmpresa']}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
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
                                        'Contenido: ',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: size.iScreen(0.5),
                                            bottom: size.iScreen(0.0)),
                                        width: size.wScreen(100.0),
                                        child: Text(
                                          '${notificacion['notContenido']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.5),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: size.iScreen(0.5),
                                      bottom: size.iScreen(0.0)),
                                  width: size.wScreen(100.0),
                                  child: Text(
                                    notificacion['notFecReg']
                                        .toString()
                                        .replaceAll(".000Z", "")
                                        .replaceAll("T", " "),
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.5),
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     // Text(
                          //     //   'Estado',
                          //     //   style: GoogleFonts.lexendDeca(
                          //     //       fontSize: size.iScreen(1.6),
                          //     //       color: Colors.black87,
                          //     //       fontWeight: FontWeight.normal),
                          //     // ),
                          //     // CupertinoSwitch(
                          //     //   // key: Key('$index'),
                          //     //   value: (consigna.conEstado == 'ACTIVA')
                          //     //       ? true
                          //     //       : false,
                          //     //   onChanged: (value) {
                          //     //     _modalEstadoConsigna(
                          //     //         size, consignasControler);
                          //     //   },
                          //     // ),
                          //     //***********************************************/
                          //     // SizedBox(
                          //     //   height: size.iScreen(0.5),
                          //     // ),

                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: quinaryColor,
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => const ConsignaClientePage()));
      //     // Navigator.pushNamed(context, 'consignaCliente');
      //   },
      // )
    );
  }

//====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  // void _modalEstadoConsigna(
  //     Responsive size, ConsignasClientesController consignasControler) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return GestureDetector(
  //           onTap: () => FocusScope.of(context).unfocus(),
  //           child: AlertDialog(
  //             insetPadding: EdgeInsets.symmetric(
  //                 horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text('Aviso',
  //                         style: GoogleFonts.lexendDeca(
  //                           fontSize: size.iScreen(2.0),
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.red,
  //                         )),
  //                     IconButton(
  //                         splashRadius: size.iScreen(3.0),
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         icon: Icon(
  //                           Icons.close,
  //                           color: Colors.red,
  //                           size: size.iScreen(3.5),
  //                         )),
  //                   ],
  //                 ),
  //                 Text('Seguro de cambiar el estado de la consigna?',
  //                     style: GoogleFonts.lexendDeca(
  //                       fontSize: size.iScreen(2.0),
  //                       fontWeight: FontWeight.normal,
  //                       // color: Colors.white,
  //                     )),
  //                 SizedBox(
  //                   height: size.iScreen(2.0),
  //                 ),
  //                 Container(
  //                   margin: EdgeInsets.only(
  //                       top: size.iScreen(1.0), bottom: size.iScreen(2.0)),
  //                   height: size.iScreen(3.5),
  //                   child: ElevatedButton(
  //                     style: ButtonStyle(
  //                       backgroundColor: MaterialStateProperty.all(
  //                         const Color(0xFF0A4280),
  //                       ),
  //                     ),
  //                     onPressed: () {
  //                       // controllerActividades.setCoords = '';
  //                       // Navigator.pushNamed(
  //                       //     context, 'detalleDeNovedad');
  //                     },
  //                     child: Text('Si',
  //                         style: GoogleFonts.lexendDeca(
  //                             fontSize: size.iScreen(1.8),
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.normal)),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //  }
}
