import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/activities_controller.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/widgets/no_data.dart';

class VistaRondaRealizadasGuardias extends StatelessWidget {
  final int? codigoActicidad;
  final dynamic infoActividad;
  final Session? usuario;
  const VistaRondaRealizadasGuardias(
      {Key? key, this.infoActividad, this.codigoActicidad, this.usuario})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String perfil = '';

    final infoActividadRealizada = {};
    final trabajosRonda = [];
    final listaRonda = [];

    final actividadesController =
        Provider.of<ActivitiesController>(context, listen: false);
    // print('codigo dde actividad: ${codigoActicidad}');

    final Responsive size = Responsive.of(context);
    // print('codigo dde actividad FFFFFF: ${codigoActicidad}');
    print('USUARIO: ${usuario!.rol}');
    if (usuario!.rol!.contains('SUPERVISOR')) {
      print('SI ES SUPERVISOR');
      perfil = 'SUPERVISOR';
    } else if (usuario!.rol!.contains('GUARDIA')) {
      print('SI ES GUARDIA');
      perfil = 'GUARDIA';
    }

    return SafeArea(
      bottom: true,
      child: Scaffold(
          backgroundColor: const Color(0xffF2F2F2),
          appBar: AppBar(
            // backgroundColor: const Color(0XFF343A40), // primaryColor,
            title: Text(
              'Actividad Realizada',
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
          body: FutureBuilder(
            future: actividadesController.getTodasLasActividades(''),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        height: size.iScreen(2.0),
                      ),
                      const Text('Cargando Rondas Realizadas... '),
                    ],
                  ),
                );
              }

              if (snapshot.hasData) {
                if (actividadesController.getListaTodasLasActividades.isEmpty)
                  return const NoData(label: 'No Tiene Actividades Realizadas');
                if (actividadesController
                    .getListaTodasLasActividades.isNotEmpty) {
                  for (var e
                      in actividadesController.getListaTodasLasActividades) {
                    if (e['actId'] == codigoActicidad) {
                      infoActividadRealizada.addAll(e);

                      final List guardiasDesignados = [];
                      for (var e in infoActividadRealizada['actAsignacion']) {
                        if (e['asignado'] == true) {
                          guardiasDesignados.add(e['nombres']);
                        }
                      }

                      final List supervisoresDesignados = [];
                      for (var e in infoActividadRealizada['actSupervisores']) {
                        if (e['asignado'] == true) {
                          supervisoresDesignados.add(e['nombres']);
                        }
                      }

// print('ACTIVIDAD: ${infoActividadRealizada['actSupervisores'].runtimeType}');

                      // infoActividadRealizada['actSupervisores'].forEach((e) {
                      //   if (e['docnumero'] == usuario!.usuario) {
                      //     // print(" DOCUMENTO: ${e['trabajos']}");
                      //     trabajosRonda.addAll(e['trabajos']);
                      //     // print(" MAPA LISTO: ${trabajosRonda.values}");
                      //     print(" MAPA LISTO: ${e['trabajos'].values.runtimeType}");
                      //     // print(" MAPA LISTO: ${trabajosRonda.keys}");
                      //     // print(" MAPA LISTO: ${trabajosRonda.keys}");
                      //   }
                      // });

// infoActividadRealizada['actSupervisores'].asMap().entries.map((entry) {
//     int idx = entry.key;
//     String val = entry.value;
//  print(' el valor: ${val}');
//     return val;
// });
                      if (infoActividadRealizada['actSupervisores']
                          .isNotEmpty) {
                        if (perfil == 'SUPERVISOR') {
                          for (var item
                              in infoActividadRealizada['actSupervisores']) {
                            if (item['docnumero'] == usuario!.usuario) {
                              // print("Key  ${item['trabajos']}");
                              if (item['trabajos'].isNotEmpty) {
                                for (var entry in item['trabajos'].entries) {
                                  // print(entry.key);
                                  // print(' el valor: ${entry.value.runtimeType}');

                                  trabajosRonda.add(entry.value);
                                }
                                trabajosRonda[0].forEach((e) {
                                  listaRonda.add(e);
                                });
                              }
                            }
                          }
                        } else if (perfil == 'GUARDIA') {
                          for (var item
                              in infoActividadRealizada['actAsignacion']) {
                            if (item['docnumero'] == usuario!.usuario) {
                              // print("Key  ${item['trabajos']}");
                              if (item['trabajos'].isNotEmpty) {
                                for (var entry in item['trabajos'].entries) {
                                  // print(entry.key);
                                  // print(' el valor: ${entry.value.runtimeType}');

                                  trabajosRonda.add(entry.value);
                                }
                                trabajosRonda[0].forEach((e) {
                                  listaRonda.add(e);
                                });
                              }
                            }
                          }
                        }
                      }
                      return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            // color:Colors.red,
                            margin: EdgeInsets.only(top: size.iScreen(0.0)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.iScreen(1.0)),
                            width: size.wScreen(100.0),
                            height: size.hScreen(93),
                            child: Column(
                              children: [
                                // Text('${usuario!.rol![0]}'),

                                ///***********************************************/
                                SizedBox(
                                  height: size.iScreen(1.0),
                                ),

                                //*****************************************/
                                Container(
                                  width: size.wScreen(100),
                                  child: Text('Actividad:',
                                      style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey)),
                                ),
                                Text('"${infoActividadRealizada['actAsunto']}"',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(2.0),
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),

                                ///***********************************************/
                                SizedBox(
                                  height: size.iScreen(1.0),
                                ),

                                //*****************************************/
                                trabajosRonda.isNotEmpty
                                    ? Expanded(
                                        child: ListView.builder(
                                          itemCount: trabajosRonda.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return
                                                //  Column(
                                                //    children: [
                                                //      Text('${trabajosRonda[index]}'),
                                                //      Divider(),

                                                ExpansionTile(
                                                    title: Text(
                                                        'Ronda: ${index + 1}',
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                          // fontSize: size.iScreen(2.0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                    children: [
                                                  Container(
                                                    height: size.iScreen(40.0),
                                                    child: ListView.builder(
                                                      itemCount:
                                                          trabajosRonda[index]
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int i) {
                                                        final _listaTrabajosRealizadosRonda =
                                                            trabajosRonda[index]
                                                                [i];
                                                        final List _listaFotos =
                                                            _listaTrabajosRealizadosRonda[
                                                                'fotos'];

                                                        return Column(
                                                          children: [
                                                            //*****************************************/
                                                            SizedBox(
                                                              width:
                                                                  size.wScreen(
                                                                      100.0),
                                                              // color: Colors.blue,
                                                              child: Text(
                                                                  'Fecha:',
                                                                  style: GoogleFonts
                                                                      .lexendDeca(
                                                                          // fontSize: size.iScreen(2.0),
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color:
                                                                              Colors.grey)),
                                                            ),
                                                            Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    vertical: size
                                                                        .iScreen(
                                                                            0.5)),
                                                                width: size
                                                                    .wScreen(
                                                                        100.0),
                                                                child: Text(
                                                                  ' ${_listaTrabajosRealizadosRonda['fecha']}'
                                                                      .toString()
                                                                      .replaceAll(
                                                                          "T",
                                                                          " "),
                                                                  // .replaceAll(".000Z", "")
                                                                  style: GoogleFonts
                                                                      .lexendDeca(
                                                                    // fontSize: size.iScreen(2.0),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    // color: Colors.grey,
                                                                  ),
                                                                )),
//                                               //***********************************************/
                                                            //*****************************************/
                                                            SizedBox(
                                                              width:
                                                                  size.wScreen(
                                                                      100.0),
                                                              // color: Colors.blue,
                                                              child: Text(
                                                                  'Lugar:',
                                                                  style: GoogleFonts
                                                                      .lexendDeca(
                                                                          // fontSize: size.iScreen(2.0),
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color:
                                                                              Colors.grey)),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.symmetric(
                                                                  vertical: size
                                                                      .iScreen(
                                                                          0.5)),
                                                              width:
                                                                  size.wScreen(
                                                                      100.0),
                                                              child: Text(
                                                                '${_listaTrabajosRealizadosRonda['nombre']}',
                                                                style: GoogleFonts
                                                                    .lexendDeca(
                                                                        fontSize:
                                                                            size.iScreen(
                                                                                1.8),
                                                                        // color: Colors.white,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                              ),
                                                            ),
                                                            //***********************************************/
                                                            SizedBox(
                                                              height: size
                                                                  .iScreen(1.0),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.wScreen(
                                                                      100.0),
                                                              // color: Colors.blue,
                                                              child: Text(
                                                                  'Detalle:',
                                                                  style: GoogleFonts
                                                                      .lexendDeca(
                                                                          // fontSize: size.iScreen(2.0),
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color:
                                                                              Colors.grey)),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.symmetric(
                                                                  vertical: size
                                                                      .iScreen(
                                                                          0.5)),
                                                              width:
                                                                  size.wScreen(
                                                                      100.0),
                                                              child: Text(
                                                                '${_listaTrabajosRealizadosRonda['detalle']}',
                                                                style: GoogleFonts
                                                                    .lexendDeca(
                                                                        fontSize:
                                                                            size.iScreen(
                                                                                1.8),
                                                                        // color: Colors.white,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                              ),
                                                            ),
                                                            //***********************************************/
                                                            SizedBox(
                                                              height: size
                                                                  .iScreen(1.0),
                                                            ),
                                                            '${_listaTrabajosRealizadosRonda['qr']}'
                                                                    .isNotEmpty
                                                                ? Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: size
                                                                            .wScreen(100.0),
                                                                        // color: Colors.blue,
                                                                        child: Text(
                                                                            'Información QR :',
                                                                            style: GoogleFonts.lexendDeca(
                                                                                // fontSize: size.iScreen(2.0),
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.grey)),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                size.iScreen(1.0)),
                                                                        width: size
                                                                            .wScreen(100.0),
                                                                        child:
                                                                            Text(
                                                                          '${_listaTrabajosRealizadosRonda['qr']}',
                                                                          style: GoogleFonts.lexendDeca(
                                                                              fontSize: size.iScreen(1.8),
                                                                              // color: Colors.white,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                                            SizedBox(
                                                              height: size
                                                                  .iScreen(1.0),
                                                            ),
                                                            //*****************************************/
                                                            //***********************************************/
                                                            SizedBox(
                                                              height: size
                                                                  .iScreen(1.0),
                                                            ),
                                                            //*****************************************/
                                                            _listaFotos
                                                                    .isNotEmpty
                                                                ? SizedBox(
                                                                    width: size
                                                                        .wScreen(
                                                                            100.0),
                                                                    // color: Colors.blue,
                                                                    child: Text(
                                                                        'Fotos: ${_listaFotos.length}',
                                                                        style: GoogleFonts.lexendDeca(
                                                                            // fontSize: size.iScreen(2.0),
                                                                            fontWeight: FontWeight.normal,
                                                                            color: Colors.grey)),
                                                                  )
                                                                : const SizedBox(),
                                                            _listaFotos
                                                                    .isNotEmpty
                                                                ? Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            size.iScreen(0.5)),
                                                                    width: size
                                                                        .wScreen(
                                                                            100.0),
                                                                    child: _listaFotos
                                                                            .isNotEmpty
                                                                        ? SingleChildScrollView(
                                                                            child: Wrap(
                                                                                children: _listaFotos.map((e) {
                                                                              return Container(
                                                                                margin: EdgeInsets.symmetric(horizontal: size.iScreen(2.0), vertical: size.iScreen(1.0)),
                                                                                child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: Container(
                                                                                    decoration: const BoxDecoration(
                                                                                        // color: Colors.red,
                                                                                        // border: Border.all(color: Colors.grey),
                                                                                        // borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                    width: size.wScreen(100.0),
                                                                                    // height: size.hScreen(20.0),
                                                                                    padding: EdgeInsets.symmetric(
                                                                                      vertical: size.iScreen(0.0),
                                                                                      horizontal: size.iScreen(0.0),
                                                                                    ),
                                                                                    child: FadeInImage(
                                                                                      placeholder: const AssetImage('assets/imgs/loader.gif'),
                                                                                      image: NetworkImage(e['url']),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).toList()),
                                                                          )
                                                                        : Center(
                                                                            child: Text('No exiten fotos para mostrar:',
                                                                                style: GoogleFonts.lexendDeca(
                                                                                    // fontSize: size.iScreen(2.0),
                                                                                    fontWeight: FontWeight.normal,
                                                                                    color: Colors.grey)),
                                                                          ),
                                                                  )
                                                                : const SizedBox(),
                                                            //***********************************************/

                                                            '${_listaTrabajosRealizadosRonda['video']}'
                                                                    .isNotEmpty
                                                                ? Column(
                                                                    children: [
                                                                      Container(
                                                                        width: size
                                                                            .wScreen(100.0),
                                                                        // color: Colors.blue,
                                                                        margin:
                                                                            EdgeInsets.symmetric(
                                                                          vertical:
                                                                              size.iScreen(1.0),
                                                                          horizontal:
                                                                              size.iScreen(0.0),
                                                                        ),
                                                                        child: Text(
                                                                            'Video:',
                                                                            style: GoogleFonts.lexendDeca(
                                                                                // fontSize: size.iScreen(2.0),
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.grey)),
                                                                      ),
                                                                      AspectRatio(
                                                                        aspectRatio:
                                                                            16 /
                                                                                16,
                                                                        child: BetterPlayer
                                                                            .network(
                                                                          // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

                                                                          '${_listaTrabajosRealizadosRonda['video']}',
                                                                          betterPlayerConfiguration:
                                                                              const BetterPlayerConfiguration(
                                                                            aspectRatio:
                                                                                16 / 16,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                : Container(),

//                                               //*****************************************/
                                                            // Container(
                                                            //   width:
                                                            //       size.wScreen(100.0),
                                                            //   // color: Colors.blue,
                                                            //   margin:
                                                            //       EdgeInsets.symmetric(
                                                            //     vertical:
                                                            //         size.iScreen(1.0),
                                                            //     horizontal:
                                                            //         size.iScreen(0.0),
                                                            //   ),
                                                            //   child: Text('- - - - - - - - - - - - - - ',
                                                            //   textAlign: TextAlign.center,
                                                            //       style: GoogleFonts
                                                            //           .lexendDeca(
                                                            //               // fontSize: size.iScreen(2.0),

                                                            //               fontWeight:
                                                            //                   FontWeight
                                                            //                       .normal,
                                                            //               color: Colors
                                                            //                   .grey)),
                                                            // ),
//                                               //*****************************************/
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ]);
                                          },
                                        ),
                                      )
                                    : const NoData(
                                        label:
                                            'No tiene Actividades Realizadas'),
                              ],
                            ),
                          ));
                    }
                  }
                } else {
                  const NoData(label: 'No Tiene Actividades Realizadas');
                }
              }
              return Container();

              // ===============werwerwerwer=============

              // ===============ywieryuwyeiruywieurryiw=============
            },
          )),
    );
  }
}

// TABS

// Container(
//   // color:Colors.red,
//   margin: EdgeInsets.only(top: size.iScreen(0.0)),
//   padding:
//       EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
//   width: size.wScreen(100.0),
//   height: size.hScreen(93),
//   child: DefaultTabController(
//     length: 2,
//     child: Column(
//       children: [
//         //***********************************************/
//         SizedBox(
//           height: size.iScreen(1.0),
//         ),

//         //*****************************************/
//         Container(
//           width: size.wScreen(100),
//           child: Text('Actividad:',
//               style: GoogleFonts.lexendDeca(
//                   // fontSize: size.iScreen(2.0),
//                   fontWeight: FontWeight.normal,
//                   color: Colors.grey)),
//         ),
//         Text('"${infoActividadRealizada['actAsunto']}"',
//             style: GoogleFonts.lexendDeca(
//               fontSize: size.iScreen(2.0),
//               // fontWeight: FontWeight.bold,
//               color: Colors.black,
//             )),
//         SingleChildScrollView(
//           child: TabBar(
//             onTap: (index) {
//               // logisticaController.getTodosLosPedidosGuardias('');
//               // logisticaController.getTodasLasDistrubuciones('');
//               // logisticaController.setIndexTapLogistica = index;
//               // logisticaController.onSearchText('');

//               //   logisticaController.getTodasLasComprasProcesadas(
//               //       'PROCESADAS', '');
//               //   logisticaController.getTodasLasComprasPendientes(
//               //       'PENDIENTES', '');
//               //   logisticaController.getTodasLasComprasAnuladas('ANULADAS', '');
//               // print('object');
//             },
//             indicatorColor: primaryColor,
//             labelColor: primaryColor,
//             unselectedLabelColor: primaryColor,
//             tabs: const [
//               Tab(text: 'Guardias'),
//               Tab(text: 'Supervisores'),
//             ],
//           ),
//         ),
//         Expanded(
//           child: TabBarView(
//             children: [
//               //====================TAB 1=================//
//               guardiasDesignados.isNotEmpty
//                   ? ListView.builder(
//                       itemCount:
//                           guardiasDesignados.length,
//                       itemBuilder: (BuildContext context,
//                           int index) {
//                         final List
//                             _listaTrabajosRealizados =
//                             infoActividadRealizada[
//                                     'actAsignacion']
//                                 [index]['trabajos'];

//                         return ExpansionTile(
//                             title: Text(
//                                 guardiasDesignados[index],
//                                 style: GoogleFonts
//                                     .lexendDeca(
//                                   // fontSize: size.iScreen(2.0),
//                                   fontWeight:
//                                       FontWeight.bold,
//                                   color: Colors.black,
//                                 )),
//                             children: <Widget>[
//                               _listaTrabajosRealizados
//                                       .isNotEmpty
//                                   ? SizedBox(
//                                       child: ListView
//                                           .builder(
//                                         scrollDirection:
//                                             Axis.vertical,
//                                         itemCount:
//                                             _listaTrabajosRealizados
//                                                 .length,
//                                         // itemCount: _listaAsignacion[index]['trabajos'],
//                                         itemBuilder:
//                                             (BuildContext
//                                                     context,
//                                                 int index) {
//                                           final trabajo =
//                                               _listaTrabajosRealizados[
//                                                   index];
//                                           final List
//                                               _listaFotos =
//                                               _listaTrabajosRealizados[
//                                                       index]
//                                                   [
//                                                   'fotos'];
//                                           return Column(
//                                             children: [
//                                               //*****************************************/
//                                               SizedBox(
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 // color: Colors.blue,
//                                                 child: Text(
//                                                     'Detalle:',
//                                                     style: GoogleFonts.lexendDeca(
//                                                         // fontSize: size.iScreen(2.0),
//                                                         fontWeight: FontWeight.normal,
//                                                         color: Colors.grey)),
//                                               ),
//                                               Container(
//                                                 margin: EdgeInsets.symmetric(
//                                                     vertical:
//                                                         size.iScreen(0.5)),
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 child:
//                                                     Text(
//                                                   trabajo[
//                                                       'detalle'],
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(1.8),
//                                                       // color: Colors.white,
//                                                       fontWeight: FontWeight.normal),
//                                                 ),
//                                               ),
//                                               //***********************************************/
//                                               SizedBox(
//                                                 height: size
//                                                     .iScreen(
//                                                         1.0),
//                                               ),

//                                               //*****************************************/
//                                               SizedBox(
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 // color: Colors.blue,
//                                                 child: Text(
//                                                     'Fecha:',
//                                                     style: GoogleFonts.lexendDeca(
//                                                         // fontSize: size.iScreen(2.0),
//                                                         fontWeight: FontWeight.normal,
//                                                         color: Colors.grey)),
//                                               ),
//                                               Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       vertical: size.iScreen(
//                                                           0.5)),
//                                                   width: size.wScreen(
//                                                       100.0),
//                                                   child:
//                                                       Text(
//                                                     ' ${trabajo['fecha']}'
//                                                         .toString(),
//                                                     // .replaceAll(".000Z", "")
//                                                     // .replaceAll("T", " "),
//                                                     style:
//                                                         GoogleFonts.lexendDeca(
//                                                       // fontSize: size.iScreen(2.0),
//                                                       fontWeight:
//                                                           FontWeight.normal,
//                                                       // color: Colors.grey,
//                                                     ),
//                                                   )),
//                                               //***********************************************/
//                                               //***********************************************/
//                                               SizedBox(
//                                                 height: size
//                                                     .iScreen(
//                                                         1.0),
//                                               ),
//                                               // trabajo['qr']
//                                               //         .isNotEmpty
//                                               //     ? Column(
//                                               //         children: [
//                                               //           SizedBox(
//                                               //             width: size.wScreen(100.0),
//                                               //             // color: Colors.blue,
//                                               //             child: Text('Información QR :',
//                                               //                 style: GoogleFonts.lexendDeca(
//                                               //                     // fontSize: size.iScreen(2.0),
//                                               //                     fontWeight: FontWeight.normal,
//                                               //                     color: Colors.grey)),
//                                               //           ),
//                                               //           Container(
//                                               //             margin: EdgeInsets.symmetric(vertical: size.iScreen(1.0)),
//                                               //             width: size.wScreen(100.0),
//                                               //             child: Text(
//                                               //               ' ${trabajo['qr']}',
//                                               //               style: GoogleFonts.lexendDeca(
//                                               //                   fontSize: size.iScreen(1.8),
//                                               //                   // color: Colors.white,
//                                               //                   fontWeight: FontWeight.normal),
//                                               //             ),
//                                               //           ),
//                                               //         ],
//                                               //       )
//                                               //     : const SizedBox(),
//                                               SizedBox(
//                                                 height: size
//                                                     .iScreen(
//                                                         1.0),
//                                               ),
//                                               //*****************************************/
//                                               _listaFotos
//                                                       .isNotEmpty
//                                                   ? SizedBox(
//                                                       width:
//                                                           size.wScreen(100.0),
//                                                       // color: Colors.blue,
//                                                       child: Text('Fotos: ${_listaFotos.length}',
//                                                           style: GoogleFonts.lexendDeca(
//                                                               // fontSize: size.iScreen(2.0),
//                                                               fontWeight: FontWeight.normal,
//                                                               color: Colors.grey)),
//                                                     )
//                                                   : const SizedBox(),
//                                               _listaFotos
//                                                       .isNotEmpty
//                                                   ? Container(
//                                                       margin:
//                                                           EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
//                                                       width:
//                                                           size.wScreen(100.0),
//                                                       child: _listaFotos.isNotEmpty
//                                                           ? SingleChildScrollView(
//                                                               child: Wrap(
//                                                                   children: _listaFotos.map((e) {
//                                                                 return Container(
//                                                                   margin: EdgeInsets.symmetric(horizontal: size.iScreen(2.0), vertical: size.iScreen(1.0)),
//                                                                   child: ClipRRect(
//                                                                     borderRadius: BorderRadius.circular(5),
//                                                                     child: Container(
//                                                                       decoration: const BoxDecoration(
//                                                                           // color: Colors.red,
//                                                                           // border: Border.all(color: Colors.grey),
//                                                                           // borderRadius: BorderRadius.circular(10),
//                                                                           ),
//                                                                       width: size.wScreen(100.0),
//                                                                       // height: size.hScreen(20.0),
//                                                                       padding: EdgeInsets.symmetric(
//                                                                         vertical: size.iScreen(0.0),
//                                                                         horizontal: size.iScreen(0.0),
//                                                                       ),
//                                                                       child: FadeInImage(
//                                                                         placeholder: const AssetImage('assets/imgs/loader.gif'),
//                                                                         image: NetworkImage(e['url']),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 );
//                                                               }).toList()),
//                                                             )
//                                                           : Center(
//                                                               child: Text('No exiten fotos para mostrar:',
//                                                                   style: GoogleFonts.lexendDeca(
//                                                                       // fontSize: size.iScreen(2.0),
//                                                                       fontWeight: FontWeight.normal,
//                                                                       color: Colors.grey)),
//                                                             ),
//                                                     )
//                                                   : const SizedBox(),
//                                               //***********************************************/
//                                               // trabajo['video']!
//                                               //         .isNotEmpty
//                                               //     ? Column(
//                                               //         children: [
//                                               //           Container(
//                                               //             width: size.wScreen(100.0),
//                                               //             // color: Colors.blue,
//                                               //             margin: EdgeInsets.symmetric(
//                                               //               vertical: size.iScreen(1.0),
//                                               //               horizontal: size.iScreen(0.0),
//                                               //             ),
//                                               //             child: Text('Video:',
//                                               //                 style: GoogleFonts.lexendDeca(
//                                               //                     // fontSize: size.iScreen(2.0),
//                                               //                     fontWeight: FontWeight.normal,
//                                               //                     color: Colors.grey)),
//                                               //           ),
//                                               //           AspectRatio(
//                                               //             aspectRatio: 16 / 16,
//                                               //             child: BetterPlayer.network(
//                                               //               // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

//                                               //               '${trabajo['video']}',
//                                               //               betterPlayerConfiguration: const BetterPlayerConfiguration(
//                                               //                 aspectRatio: 16 / 16,
//                                               //               ),
//                                               //             ),
//                                               //           )
//                                               //         ],
//                                               //       )
//                                               //     : Container(),

//                                               //*****************************************/
//                                               //***********************************************/
//                                               SizedBox(
//                                                 height: size
//                                                     .iScreen(
//                                                         2.0),
//                                               ),
//                                               // // //==========================================//
//                                               //*****************************************/
//                                               Divider(
//                                                 color:
//                                                     primaryColor,
//                                                 height: size
//                                                     .iScreen(
//                                                         2.0),
//                                               ),
//                                               //*****************************************/
//                                               //***********************************************/
//                                               SizedBox(
//                                                 height: size
//                                                     .iScreen(
//                                                         3.0),
//                                               ),
//                                               //*****************************************/
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                       // height: size.hScreen(_listaTrabajosRealizados.length.toDouble() ),
//                                       height: size
//                                           .hScreen(80),
//                                     )
//                                   : const SizedBox(),
//                             ]);
//                       },
//                     )
//                   : const NoData(
//                       label:
//                           'No hay Guardias designados'),
//               //====================TAB 2=================//
//               supervisoresDesignados.isNotEmpty
//                   ? ListView.builder(
//                       itemCount:
//                           supervisoresDesignados.length,
//                       itemBuilder: (BuildContext context,
//                           int index) {
//                         // final supervisor = supervisoresDesignados[index];
//                         final List
//                             _listaTrabajosRealizados =
//                             infoActividadRealizada[
//                                     'actSupervisores'][index];

//                         return ExpansionTile(
//                             title: Text(
//                                 supervisoresDesignados[
//                                     index],
//                                 style: GoogleFonts
//                                     .lexendDeca(
//                                   // fontSize: size.iScreen(2.0),
//                                   fontWeight:
//                                       FontWeight.bold,
//                                   color: Colors.black,
//                                 )),
//                             children: <Widget>[
//                               _listaTrabajosRealizados
//                                       .isNotEmpty
//                                   ? SizedBox(
//                                       child: ListView
//                                           .builder(
//                                         scrollDirection:
//                                             Axis.vertical,
//                                         itemCount:
//                                             _listaTrabajosRealizados
//                                                 .length,
//                                         // itemCount: _listaSupervisores[index]['trabajos'],
//                                         itemBuilder:
//                                             (BuildContext
//                                                     context,
//                                                 int index) {
//                                           final trabajo =
//                                               _listaTrabajosRealizados[
//                                                   index];
//                                           final List
//                                               _listaFotos =
//                                               _listaTrabajosRealizados[
//                                                       index]
//                                                   [
//                                                   'fotos'];
//                                           return Column(
//                                             children: [
//                                               //*****************************************/
//                                               SizedBox(
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 // color: Colors.blue,
//                                                 child: Text(
//                                                     'Detalle:',
//                                                     style: GoogleFonts.lexendDeca(
//                                                         // fontSize: size.iScreen(2.0),
//                                                         fontWeight: FontWeight.normal,
//                                                         color: Colors.grey)),
//                                               ),
//                                               Container(
//                                                 margin: EdgeInsets.symmetric(
//                                                     vertical:
//                                                         size.iScreen(0.5)),
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 child:
//                                                     Text(
//                                                   trabajo[
//                                                       'detalle'],
//                                                   style: GoogleFonts.lexendDeca(
//                                                       fontSize: size.iScreen(1.8),
//                                                       // color: Colors.white,
//                                                       fontWeight: FontWeight.normal),
//                                                 ),
//                                               ),
//                                               //***********************************************/
//                                               SizedBox(
//                                                 height: size
//                                                     .iScreen(
//                                                         1.0),
//                                               ),

//                                               //*****************************************/
//                                               SizedBox(
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 // color: Colors.blue,
//                                                 child: Text(
//                                                     'Fecha:',
//                                                     style: GoogleFonts.lexendDeca(
//                                                         // fontSize: size.iScreen(2.0),
//                                                         fontWeight: FontWeight.normal,
//                                                         color: Colors.grey)),
//                                               ),
//                                               Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       vertical: size.iScreen(
//                                                           0.5)),
//                                                   width: size.wScreen(
//                                                       100.0),
//                                                   child:
//                                                       Text(
//                                                     ' ${trabajo['fecha']}'
//                                                         .toString(),
//                                                     // .replaceAll(".000Z", "")
//                                                     // .replaceAll("T", " "),
//                                                     style:
//                                                         GoogleFonts.lexendDeca(
//                                                       // fontSize: size.iScreen(2.0),
//                                                       fontWeight:
//                                                           FontWeight.normal,
//                                                       // color: Colors.grey,
//                                                     ),
//                                                   )),
//                                               //***********************************************/
//                                               //***********************************************/
//                                               // SizedBox(
//                                               //   height: size
//                                               //       .iScreen(
//                                               //           1.0),
//                                               // ),
//                                               // trabajo['qr']
//                                               //         .isEmpty
//                                               //     ? const SizedBox()
//                                               //     : Column(
//                                               //         children: [
//                                               //           SizedBox(
//                                               //             width: size.wScreen(100.0),
//                                               //             // color: Colors.blue,
//                                               //             child: Text('Información QR :',
//                                               //                 style: GoogleFonts.lexendDeca(
//                                               //                     // fontSize: size.iScreen(2.0),
//                                               //                     fontWeight: FontWeight.normal,
//                                               //                     color: Colors.grey)),
//                                               //           ),
//                                               //           Container(
//                                               //             margin: EdgeInsets.symmetric(vertical: size.iScreen(1.0)),
//                                               //             width: size.wScreen(100.0),
//                                               //             child: Text(
//                                               //               ' ${trabajo['qr']}',
//                                               //               style: GoogleFonts.lexendDeca(
//                                               //                   fontSize: size.iScreen(1.8),
//                                               //                   // color: Colors.white,
//                                               //                   fontWeight: FontWeight.normal),
//                                               //             ),
//                                               //           ),
//                                               //         ],
//                                               //       ),
//                                               // SizedBox(
//                                               //   height: size
//                                               //       .iScreen(
//                                               //           1.0),
//                                               // ),
//                                               //*****************************************/
//                                               SizedBox(
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 // color: Colors.blue,
//                                                 child: Text(
//                                                     'Fotos: ${_listaFotos.length}',
//                                                     style: GoogleFonts.lexendDeca(
//                                                         // fontSize: size.iScreen(2.0),
//                                                         fontWeight: FontWeight.normal,
//                                                         color: Colors.grey)),
//                                               ),
//                                               Container(
//                                                 margin: EdgeInsets.symmetric(
//                                                     vertical:
//                                                         size.iScreen(0.5)),
//                                                 width: size
//                                                     .wScreen(
//                                                         100.0),
//                                                 child: _listaFotos
//                                                         .isNotEmpty
//                                                     ? SingleChildScrollView(
//                                                         child: Wrap(
//                                                             children: _listaFotos.map((e) {
//                                                           return Container(
//                                                             margin: EdgeInsets.symmetric(horizontal: size.iScreen(2.0), vertical: size.iScreen(1.0)),
//                                                             child: ClipRRect(
//                                                               borderRadius: BorderRadius.circular(5),
//                                                               child: Container(
//                                                                 decoration: const BoxDecoration(
//                                                                     // color: Colors.red,
//                                                                     // border: Border.all(color: Colors.grey),
//                                                                     // borderRadius: BorderRadius.circular(10),
//                                                                     ),
//                                                                 width: size.wScreen(100.0),
//                                                                 // height: size.hScreen(20.0),
//                                                                 padding: EdgeInsets.symmetric(
//                                                                   vertical: size.iScreen(0.0),
//                                                                   horizontal: size.iScreen(0.0),
//                                                                 ),
//                                                                 child: FadeInImage(
//                                                                   placeholder: const AssetImage('assets/imgs/loader.gif'),
//                                                                   image: NetworkImage(e['url']),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         }).toList()),
//                                                       )
//                                                     : Center(
//                                                         child: Text('No exiten fotos para mostrar:',
//                                                             style: GoogleFonts.lexendDeca(
//                                                                 // fontSize: size.iScreen(2.0),
//                                                                 fontWeight: FontWeight.normal,
//                                                                 color: Colors.grey)),
//                                                       ),
//                                               ),
//                                               //***********************************************/
//                                               // trabajo['video']!
//                                               //         .isNotEmpty
//                                               //     ? Column(
//                                               //         children: [
//                                               //           Container(
//                                               //             width: size.wScreen(100.0),
//                                               //             // color: Colors.blue,
//                                               //             margin: EdgeInsets.symmetric(
//                                               //               vertical: size.iScreen(1.0),
//                                               //               horizontal: size.iScreen(0.0),
//                                               //             ),
//                                               //             child: Text('Video:',
//                                               //                 style: GoogleFonts.lexendDeca(
//                                               //                     // fontSize: size.iScreen(2.0),
//                                               //                     fontWeight: FontWeight.normal,
//                                               //                     color: Colors.grey)),
//                                               //           ),
//                                               //           AspectRatio(
//                                               //             aspectRatio: 16 / 16,
//                                               //             child: BetterPlayer.network(
//                                               //               // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

//                                               //               '${trabajo['video']}',
//                                               //               betterPlayerConfiguration: const BetterPlayerConfiguration(
//                                               //                 aspectRatio: 16 / 16,
//                                               //               ),
//                                               //             ),
//                                               //           )
//                                               //         ],
//                                               //       )
//                                               //     : Container(),

//                                               //*****************************************/
//                                               Divider(
//                                                 color:
//                                                     primaryColor,
//                                                 height: size
//                                                     .iScreen(
//                                                         2.0),
//                                               ),
//                                               //***********************************************/
//                                               SizedBox(
//                                                 height: size
//                                                     .iScreen(
//                                                         3.0),
//                                               ),
//                                               // // //==========================================//
//                                               //*****************************************/
//                                             ],
//                                           );
//                                         },
//                                       ),
//                                       // height: size.hScreen(_listaTrabajosRealizados.length.toDouble() ),
//                                       height: size
//                                           .hScreen(85),
//                                     )
//                                   : const SizedBox(),
//                             ]);
//                       },
//                     )
//                   : const NoData(
//                       label:
//                           'No hay Supervisores designados'),
//             ],
//           ),
//         ),
//       ],
//     ),
//   ),
// ),
