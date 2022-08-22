import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/activities_controller.dart';
import 'package:sincop_app/src/controllers/novedades_controller.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/lista_consignas_realizadas_guardias.dart';
import 'package:sincop_app/src/pages/realizar_actividad_guardia.dart';
import 'package:sincop_app/src/pages/rondas_guardias.dart';
import 'package:sincop_app/src/pages/vista_actividad_realizada.dart';
import 'package:sincop_app/src/pages/vista_ronda_realizada_guardias.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';

class DetalleActividades extends StatefulWidget {
  final dynamic infoActividad;
  final Session? usuario;
  const DetalleActividades({Key? key, this.infoActividad, this.usuario})
      : super(key: key);

  @override
  State<DetalleActividades> createState() => _DetalleActividadesState();
}

class _DetalleActividadesState extends State<DetalleActividades> {
  @override
  void initState() {
    // initData();
    super.initState();
  }

  initData() async {
// final actividaddesController=ActivitiesController();
// actividaddesController.getTodasLasActividades('');
  }

  @override
  Widget build(BuildContext context) {
    // print('USUAIO cedula : ${widget.usuario!.usuario}');
    // print('USUAIO supervisor : ${widget.infoActividad}');
    final actividadesController =
        Provider.of<ActivitiesController>(context, listen: false);

    //  actividadesController.setRondaId(widget.infoActividad['actId']);

//  actividadesController.getTodasLasActividades('');
    // final fechaRecibida = widget.infoActividad['actHasta']
    //     .replaceAll(".000Z", "")
    //     .replaceAll("T", " ");
    // final fechaHasta = DateTime.parse(fechaRecibida);
    final fechaActual = DateTime.now();
    // print('FECHA ACTUAL: ${fechaActual}');
// bool _fechaEstado=false;

//  if (fechaHasta.compareTo(fechaActual) < 0) {
//       print("FECHA ACTUAL DDD: $fechaActual ES MAYOR QUE FECHA RECIVIDA: $fechaRecibida");
//     //  setFechaEstado(true);
//     _fechaEstado=true;
//      }

    bool _guardiaDesignado = false;
    bool _supervisorDesignado = false;

    // for (var e in widget.infoActividad['actAsignacion']) {
    //   if (e['docnumero'] == widget.usuario!.usuario) {
    //     _guardiaDesignado = true;
    //   }
    // }
    // for (var e in widget.infoActividad['actSupervisores']) {
    //   if (e['docnumero'] == widget.usuario!.usuario) {
    //     _supervisorDesignado = true;
    //   }
    // }
    // final Map guardiasDesignados = {};
    // for (var e in widget.infoActividad['actAsignacion']) {
    //   if (e['asignado'] == true) {
    //     guardiasDesignados.addAll({
    //       "documento": e['docnumero'],
    //       "nombre": e['nombres'],
    //     });
    //     //  _guardiaDesignado = true;
    //   }
    // }
    // final Map supervisoresDesignados = {};
    // for (var e in widget.infoActividad['actSupervisores']) {
    //   if (e['asignado'] == true) {
    //        supervisoresDesignados.addAll({
    //       "documento": e['docnumero'],
    //       "nombre": e['nombres'],
    //     });
    //     //  _supervisorDesignado = true;
    //   }
    // }
    final List _guardiasDesignados = [];
    final List _nombresGuardiasDesignados = [];
    for (var e in widget.infoActividad['actAsignacion']) {
      if (e['asignado'] == true) {
        _guardiasDesignados.add(
          e['docnumero'],
        );
        _nombresGuardiasDesignados.add(
          e['nombres'],
        );
        //  _guardiaDesignado = true;
      }
    }
    // print(' NO ES GUARDIS: $_guardiasDesignados ');
    if (_guardiasDesignados.isNotEmpty) {
      for (var e in _guardiasDesignados) {
        if (e == widget.usuario!.usuario) {
          //        guardiasDesignados.add(e);
          _guardiaDesignado = true;
          // print(' GUARDIA SI ESTA DESIGNADO: $e');
        } else {
          // print(' GUARDIA NO ESTA DESIGNADO: $e');
        }
      }
    } else {
      // print(' MATRIZ GUARDIA VACIA');
      _guardiaDesignado = false;
    }

    final List _supervisoresDesignados = [];
    final List _nombresSupervisoresDesignados = [];
    for (var e in widget.infoActividad['actSupervisores']) {
      if (e['asignado'] == true) {
        _supervisoresDesignados.add(
          e['docnumero'],
        );
        _nombresSupervisoresDesignados.add(
          e['nombres'],
        );
        //  _supervisorDesignado = true;
      }
    }
    // print(' SUPERVISOR: $_supervisoresDesignados ');

    if (_supervisoresDesignados.isNotEmpty) {
      for (var e in _supervisoresDesignados) {
        if (e == widget.usuario!.usuario) {
          //        supervisoresDesignados.add(e);
          _supervisorDesignado = true;
          // print(' SUPERVISOR SI ESTA DESIGNADO: $e}');
        } else {
          // print('SUPERVISOR NO ESTA DESIGNADO: $e');
        }
      }
    } else {
      // print(' MATRIZ SUPERVISOR VACIA');
      _supervisorDesignado = false;
    }

    // =====================CALCULAMOS LOS DIAS DE LA ACIVIDAD======//

    // if (provider.getListaTodasLasActividades[index]['actFechasActividadConsultaDB'].isNotEmpty) {
    //   DateTime fechaInicio = (DateTime.parse(provider.getListaTodasLasActividades[index]['actFechasActividadConsultaDB'][0]));
    //   DateTime fechaFin = DateTime.parse(provider.getListaTodasLasActividades[index]
    //           ['actFechasActividadConsultaDB'][provider.getListaTodasLasActividades[index]
    //                   ['actFechasActividadConsultaDB'].length -
    //           1]);
    //   // print('FECHA INICIO: ${fechaInicio}');
    //   // print('FECHA FIN: ${fechaFin}');
    //   Duration diasDiferencia =
    //       fechaFin.difference(fechaInicio);
    //   int diasDeTrabajo = diasDiferencia.inDays;

    //   diasCalculados = (diasDeTrabajo == 0)
    //       ? (diasDeTrabajo + 1)
    //       : diasDeTrabajo;
    //   // print(diasCalculados);
    // }

    final Responsive size = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        // backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: Text(
          'Detalle de Actividad',
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
              ],
            ),
          ),
        ),
      ),
      body:
          // Text('${widget.infoActividad['actAsunto']}'),
          Container(
        margin: EdgeInsets.only(
            top: size.iScreen(1.0),
            left: size.iScreen(1.0),
            right: size.iScreen(1.0)),
        padding: EdgeInsets.symmetric(horizontal: size.iScreen(0.0)),
        width: size.wScreen(100.0),
        height: size.hScreen(100),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: size.wScreen(100.0),
                // color: Colors.blue,
                child: Row(
                  children: [
                    Text('Asunto:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                    const Spacer(),
                    Text(
                        ' ${widget.infoActividad['actFecReg']}'
                            .toString()
                            .replaceAll(".000Z", "")
                            .replaceAll("T", " "),
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.iScreen(0.1)),
                width: size.wScreen(100.0),
                child: Text(
                  // 'item Novedad: ${controllerActividades.getItemMulta}',
                  // '"${widget.infoActividad['actAsunto']}" ${widget.infoActividad['actId']} ',
                  '"${widget.infoActividad['actAsunto']}"',
                  textAlign: TextAlign.center,
                  //
                  style: GoogleFonts.lexendDeca(
                      fontSize: size.iScreen(2.0),
                      // color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
              //***********************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),

              //*****************************************/
              SizedBox(
                width: size.wScreen(100.0),
                // color: Colors.blue,
                child: Text('Cliente:',
                    style: GoogleFonts.lexendDeca(
                        // fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                width: size.wScreen(100.0),
                child: Text(
                  '${widget.infoActividad['actNombreCliente']}',
                  style: GoogleFonts.lexendDeca(
                      fontSize: size.iScreen(1.8),
                      // color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
              //***********************************************/
              SizedBox(
                height: size.iScreen(0.5),
              ),

              // SizedBox(
              //   width: size.wScreen(100.0),
              //   child: Text(
              //     'Fecha:',
              //     style: GoogleFonts.lexendDeca(
              //       // fontSize: size.iScreen(1.8),
              //       color: Colors.black45,
              //       // fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // //***********************************************/
              // SizedBox(
              //   height: size.iScreen(0.5),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         Text(
              //           'Desde:',
              //           style: GoogleFonts.lexendDeca(
              //             // fontSize: size.iScreen(1.8),
              //             color: Colors.black45,
              //             // fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         Container(
              //           // width: size.wScreen(35),
              //           margin:
              //               EdgeInsets.symmetric(horizontal: size.wScreen(0.5)),
              //           child: Text(
              //             '${widget.infoActividad['actDesde']}'
              //                 .toString()
              //                 .replaceAll("T", " "),
              //             style: GoogleFonts.lexendDeca(
              //               fontSize: size.iScreen(1.8),
              //               // color: Colors.black45,
              //               // fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Text(
              //           'Hasta:',
              //           style: GoogleFonts.lexendDeca(
              //             // fontSize: size.iScreen(1.8),
              //             color: Colors.black45,
              //             // fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         Container(
              //           // width: size.wScreen(35),
              //           margin:
              //               EdgeInsets.symmetric(horizontal: size.wScreen(0.5)),
              //           child: Text(
              //             '${widget.infoActividad['actHasta']}'
              //                 .toString()
              //                 .replaceAll("T", " "),
              //             style: GoogleFonts.lexendDeca(
              //               fontSize: size.iScreen(1.8),
              //               color:
              //               // (fechaHasta.compareTo(fechaActual) < 0)
              //               //     // _fechaEstado==true?
              //               //     ? Colors.red
              //               //     :
              //                   Colors.green,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // //***********************************************/
              // SizedBox(
              //   height: size.iScreen(0.5),
              // ),

              // //*****************************************/
              SizedBox(
                width: size.wScreen(100.0),
                // color: Colors.blue,
                child: Text('Observaciones:',
                    style: GoogleFonts.lexendDeca(
                        // fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                width: size.wScreen(100.0),
                child: Text(
                  '${widget.infoActividad['actObservacion']}',
                  style: GoogleFonts.lexendDeca(
                      fontSize: size.iScreen(1.8),
                      // color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
              //***********************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),

              //***********************************************/
              Row(
                children: [
                  Text(
                    'Prioridad:',
                    style: GoogleFonts.lexendDeca(
                      // fontSize: size.iScreen(1.8),
                      color: Colors.black45,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    // width: size.wScreen(35),
                    margin: EdgeInsets.symmetric(horizontal: size.wScreen(0.5)),
                    child: Text(
                      '  ${widget.infoActividad['actPrioridad']}',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.8),
                        // color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              //***********************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),

              //***********************************************/
              SizedBox(
                width: size.wScreen(100.0),
                // color: Colors.blue,
                child: Text('Fecha de actividad:',
                    style: GoogleFonts.lexendDeca(
                        // fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        color: Colors.grey)),
              ),
              //***********************************************/
              SizedBox(
                height: size.iScreen(1.0),
              ),

              //***********************************************/
              Consumer<ActivitiesController>(
                builder: (_, valueFechas, __) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Desde:',
                            style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            // width: size.wScreen(35),
                            margin: EdgeInsets.symmetric(
                                horizontal: size.wScreen(0.5)),
                            child: Text(
                              '  ${valueFechas.getFechaInicio}',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                // color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Hasta:',
                            style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            // width: size.wScreen(35),
                            margin: EdgeInsets.symmetric(
                                horizontal: size.wScreen(0.5)),
                            child: Text(
                              '  ${valueFechas.getFechaFin}',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                // color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              // //***********************************************/
              // SizedBox(
              //   height: size.iScreen(2.0),
              // ),
              // //*****************************************/
              // SizedBox(
              //   width: size.wScreen(100.0),
              //   child: Text(
              //     'Repetir:',
              //     style: GoogleFonts.lexendDeca(
              //       // fontSize: size.iScreen(1.8),
              //       color: Colors.black45,
              //       // fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              //***********************************************/
              // SizedBox(
              //   height: size.iScreen(2.0),
              // ),

              //***********************************************/
              // SizedBox(
              //   width: size.wScreen(100.0),
              //   height: size.iScreen(5.0),
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 4,//widget.infoActividad['actDiasRepetir'].length,
              //     itemBuilder: (BuildContext context, int index) {
              //       String dia = widget.infoActividad['actDiasRepetir'][index];

              //       return Container(
              //         width: size.iScreen(5.0),
              //         height: size.iScreen(5.0),
              //         margin: EdgeInsets.symmetric(
              //           horizontal: size.iScreen(1.8),
              //         ),
              //         // padding: EdgeInsets.all(size.iScreen(1.0)),
              //         decoration: BoxDecoration(
              //           color: Colors.blue,
              //           borderRadius: BorderRadius.circular(100),
              //         ),
              //         child: Center(
              //           child: Text(
              //             dia.substring(0, 2),
              //             style: GoogleFonts.lexendDeca(
              //               fontSize: size.iScreen(1.8),
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),

              //***********************************************/
              _nombresGuardiasDesignados.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: size.iScreen(2.0),
                        ),
                        //*****************************************/
                        SizedBox(
                          width: size.wScreen(100.0),
                          child: Text(
                            'Guardias: ${_nombresGuardiasDesignados.length}',
                            style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //***********************************************/
                        SizedBox(
                          height: size.iScreen(1.0),
                        ),
                      ],
                    )
                  : const SizedBox(),
              _nombresGuardiasDesignados.isNotEmpty
                  ? SizedBox(
                      width: size.wScreen(100.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _nombresGuardiasDesignados.length,
                        itemBuilder: (BuildContext context, int index) {
                          // if (widget.infoActividad['actAsignacion'][index]
                          //         ['asignado'] ==
                          //     true) {
                          //   guardiasDesignados.addAll(
                          //       widget.infoActividad['actAsignacion'][index]
                          //           );
                          final guardia = _nombresGuardiasDesignados[index];
                          // }

                          return
                              // widget.infoActividad['actAsignacion'][index]
                              //             ['asignado'] ==
                              //         true
                              //     ?
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: size.iScreen(0.2)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.iScreen(0.5),
                                      horizontal: size.iScreen(0.5)),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(2)),
                                  width: size.wScreen(98.0),
                                  child: Text(
                                    // '${widget.infoActividad['actAsignacion'][index]['nombres']}',
                                    '$guardia',
                                    style: GoogleFonts.lexendDeca(
                                      // fontSize: size.iScreen(1.8),
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ));
                          // : const SizedBox();
                        },
                      ),
                      height: widget.infoActividad['actAsignacion'].length *
                          size.iScreen(3.8),
                    )
                  : const SizedBox(),
              //***********************************************/
              //***********************************************/
              _supervisoresDesignados.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: size.iScreen(1.0),
                        ),
                        //*****************************************/
                        SizedBox(
                          width: size.wScreen(100.0),
                          child: Text(
                            'Supervisores: ${_supervisoresDesignados.length}',
                            style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //***********************************************/
                        SizedBox(
                          height: size.iScreen(1.0),
                        ),
                      ],
                    )
                  : const SizedBox(),

              // widget.infoActividad['actSupervisores'].length > 0
              _supervisoresDesignados.isNotEmpty
                  // widget.infoActividad['actSupervisores'].length > 0
                  ? SizedBox(
                      width: size.wScreen(100.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _nombresSupervisoresDesignados.length,
                        itemBuilder: (BuildContext context, int index) {
                          final supervisores =
                              _nombresSupervisoresDesignados[index];

                          return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.iScreen(0.2)),
                              padding: EdgeInsets.symmetric(
                                  vertical: size.iScreen(0.5),
                                  horizontal: size.iScreen(0.5)),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(2)),
                              width: size.wScreen(98.0),
                              child: Text(
                                '$supervisores',
                                style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(1.8),
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ));
                        },
                      ),
                      height: widget.infoActividad['actSupervisores'].length *
                          size.iScreen(3.5),
                    )
                  : Text(
                      'No hay supervisores designados',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.8),
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

              //***********************************************/
              SizedBox(
                height: size.iScreen(2.0),
              ),
              //==========================================//
              // widget.infoActividad['actFotosActividad']
              //     ? _CamaraOption(
              //         size: size, trabajo:trabajo)
              //     : Container(),

              SizedBox(
                height: size.iScreen(1.0),
              ),
              //*****************************************/
              //*****************************************/
              widget.infoActividad['actFotosActividad'].isNotEmpty
                  ? SizedBox(
                      width: size.wScreen(100.0),
                      child: Text(
                        'Fotos: ${widget.infoActividad!['actFotosActividad']!.length}',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(1.8),
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
              //***********************************************/
              // //==========================================//
              widget.infoActividad['actFotosActividad'].isNotEmpty
                  // ? _CamaraOption(
                  //     size: size,
                  //     informeController: informeController,
                  //     informe: widget.informe)
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: size.iScreen(0.5),
                          horizontal: size.iScreen(0.5)),
                      child: ListView.builder(
                        itemCount:
                            widget.infoActividad!['actFotosActividad']!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                // color: Colors.red,
                                margin: EdgeInsets.symmetric(
                                    vertical: size.iScreen(0.5),
                                    horizontal: size.iScreen(0.0)),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/imgs/loader.gif'),
                                  image: NetworkImage(
                                    '${widget.infoActividad!['actFotosActividad']![index]['url']}',
                                  ),
                                ),
                              ),
                              //*****************************************/

                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //*****************************************/
                            ],
                          );
                        },
                      ),
                      height: size.iScreen(widget
                              .infoActividad!['actFotosActividad']!.length
                              .toDouble() *
                          40.0),
                    )
                  : Container(),
              // // //*****************************************/

              //*****************************************/
              //*****************************************/
              SizedBox(
                height: size.iScreen(0.0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              if (widget.infoActividad['actAsunto'] == 'RONDAS') {
                actividadesController.getTodasLasActividades('');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VistaRondaRealizadasGuardias(
                        codigoActicidad: widget.infoActividad['actId'],
                        usuario: widget.usuario,
                        infoActividad: widget.infoActividad)));

                //  Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => RealizarActividadGuardia(
                //           // infoConsignasRealizada: infoConsignaCliente
                //           )));
              } else {
                actividadesController.getTodasLasActividades('');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VistaActividadRealizadasGuardias(
                        codigoActicidad: widget.infoActividad['actId'],
                        usuario: widget.usuario,
                        infoActividad: widget.infoActividad)));
              }
            },
            heroTag: "btnVisualizar",
            child: const Icon(Icons.content_paste_search_outlined),
          ),
          SizedBox(
            height: size.iScreen(1.5),
          ),

          //      Wrap(
          //       children: widget.infoActividad['actAsignacion'].map((e){
          // if (e['docnumero'] == widget.usuario!.usuario && e['asignado'] == true ) {
          //     FloatingActionButton(
          //               backgroundColor: primaryColor,
          //               heroTag: "btnRealizar",
          //               onPressed: () {

          //              actividadesController.resetValuesActividades();
          //                 Navigator.of(context).push(MaterialPageRoute(
          //                     builder: (context) => RealizarActividadGuardia(
          //                           infoActividad: widget.infoActividad,
          //                         )));
          //               },
          //               child: const Icon(Icons.rate_review_outlined),
          //             );
          //   }

          //       }),
          //      ),
          // widget.infoActividad['actAsignacion']

          // _guardiaDesignado == true

          //          ||
          //     _supervisorDesignado == true &&
          //         (fechaHasta.compareTo(fechaActual) > 0)
          // ?

         actividadesController.getTrabajoCumplido != 'REALIZADO'
          // ||
          //         actividadesController.getTrabajoCumplido != 'NO REALIZADO'
              ? FloatingActionButton(
                  backgroundColor: primaryColor,
                  heroTag: "btnRealizar",
                  onPressed: () {
                    if (widget.infoActividad['actAsunto'] == 'RONDAS') {
                      actividadesController.resetValuesActividades();
                      actividadesController.getTodosLosPuntosDeRonda('');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PuntosDeRondaPage(
                                infoActividad: widget.infoActividad,
                              )));
                    } else {
                      actividadesController.resetValuesActividades();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RealizarActividadGuardia(
                                infoActividad: widget.infoActividad,
                              )));
                    }
                  },
                  child: const Icon(Icons.rate_review_outlined),
                )
              : const SizedBox(),

          // : const SizedBox(),

          //***********************************************/
          SizedBox(
            height: size.iScreen(2.0),
          ),
        ],
      ),
    );
  }
}
