import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';

import '../models/lista_allConsignas_clientes.dart';

class DetalleConsignasRealizadasGuardias extends StatefulWidget {
  final ConAsignacion? consignas;
  const DetalleConsignasRealizadasGuardias({Key? key, this.consignas})
      : super(key: key);

  @override
  State<DetalleConsignasRealizadasGuardias> createState() =>
      _DetalleConsignasRealizadasGuardiasState();
}

class _DetalleConsignasRealizadasGuardiasState
    extends State<DetalleConsignasRealizadasGuardias> {
  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Trabajo Realizadas'),
      ),
      body: Container(
        // color: Colors.red,
        width: size.wScreen(100.0),
        height: size.hScreen(100),
        child: ListView.builder(
          itemCount: widget.consignas!.trabajos!.length,
          itemBuilder: (BuildContext context, int index) {
            final trabajo = widget.consignas!.trabajos![index];
            return InkWell(
              onTap: () {},
              child: Card(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.iScreen(1.5),
                      vertical: size.iScreen(0.5)),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: size.iScreen(0.5),
                                bottom: size.iScreen(0.0)),
                            // width: size.wScreen(100.0),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: size.iScreen(0.5),
                                      bottom: size.iScreen(0.0)),
                                  // width: size.wScreen(100.0),
                                  child: Text(
                                    'Detalle: ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.5),
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  // color: Colors.red,
                                  margin: EdgeInsets.only(
                                      top: size.iScreen(0.5),
                                      bottom: size.iScreen(0.0)),
                                  width: size.wScreen(60.0),
                                  child: Text(
                                    '${trabajo['detalle']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.5),
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: size.iScreen(0.5),
                                bottom: size.iScreen(0.0)),
                            // width: size.wScreen(100.0),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: size.iScreen(0.5),
                                      bottom: size.iScreen(0.0)),
                                  // width: size.wScreen(100.0),
                                  child: Text(
                                    'fecha: ',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.5),
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Container(
                                  // color: Colors.red,
                                  margin: EdgeInsets.only(
                                      top: size.iScreen(0.5),
                                      bottom: size.iScreen(0.0)),
                                  width: size.wScreen(60.0),
                                  child: Text(
                                    '${trabajo['fecha']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.5),
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                         
                           //==========================================//
                    trabajo['fotos'].isNotEmpty
                        ? _CamaraOption(
                            size: size, trabajo:trabajo)
                        : Container(),
                    //*****************************************/
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
                      //         'Persona: ',
                      //         style: GoogleFonts.lexendDeca(
                      //             fontSize: size.iScreen(1.5),
                      //             color: Colors.black87,
                      //             fontWeight: FontWeight.normal),
                      //       ),
                      //     ),
                      //     Container(
                      //       // color: Colors.red,
                      //       margin: EdgeInsets.only(
                      //           top: size.iScreen(0.5),
                      //           bottom: size.iScreen(0.0)),
                      //       width: size.wScreen(60.0),
                      //       child: Text(
                      //         '${consignas.nombres}',
                      //         overflow: TextOverflow.ellipsis,
                      //         style: GoogleFonts.lexendDeca(
                      //             fontSize: size.iScreen(1.5),
                      //             color: Colors.black87,
                      //             fontWeight: FontWeight.bold),
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
                      //         'Trabajos realizados: ',
                      //         style: GoogleFonts.lexendDeca(
                      //             fontSize: size.iScreen(1.5),
                      //             color: Colors.black87,
                      //             fontWeight: FontWeight.normal),
                      //       ),
                      //     ),
                      //     Container(
                      //       // color: Colors.red,
                      //       margin: EdgeInsets.only(
                      //           top: size.iScreen(0.5),
                      //           bottom: size.iScreen(0.0)),
                      //       width: size.wScreen(60.0),
                      //       child: Text(
                      //         '${consignas.trabajos!.length}',
                      //         overflow: TextOverflow.ellipsis,
                      //         style: GoogleFonts.lexendDeca(
                      //             fontSize: size.iScreen(1.5),
                      //             color: Colors.black87,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            );

            // ListTile(
            //   title: Text('${consignas.nombres}'),
            //   subtitle: Row(
            //     children: [
            //       Text('${consignas.trabajos!.length}'),
            //       Text('${consignas.trabajos!.length}'),
            //     ],
            //   ),
            // );
          },
        ),
      ),
    );
  }
}


class _CamaraOption extends StatelessWidget {
 dynamic trabajo;
   _CamaraOption({
    Key? key,
    required this.size,
   
    required this.trabajo,
  }) : super(key: key);

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: size.wScreen(100.0),
            // color: Colors.blue,
            margin: EdgeInsets.symmetric(
              vertical: size.iScreen(1.0),
              horizontal: size.iScreen(0.0),
            ),
            child: Text('Fotografía:',
                style: GoogleFonts.lexendDeca(
                    // fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)),
          ),
          SingleChildScrollView(
            child:
               Wrap(
                children: (trabajo!['fotos']as List).map((e) {



              return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.iScreen(2.0),
                          vertical: size.iScreen(1.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
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
                          child:  FadeInImage(
                            placeholder: const AssetImage('assets/imgs/loader.gif'),
                            image: NetworkImage(e['url']),
                          ),
                        ),
                      ),
                    );
            }).toList()),
          
          
          ),
        ],
      ),
      onTap: () {
        print('activa FOTOGRAFIA');
      },
    );
  }
}

Widget? getImage(String? picture) {
  if (picture == null) {
    return Image.asset('assets/imgs/no-image.png', fit: BoxFit.cover);
  }
  if (picture.startsWith('http')) {
    return const FadeInImage(
      placeholder: AssetImage('assets/imgs/loader.gif'),
      image: NetworkImage('url'),
    );
  }

  return Image.file(
    File(picture),
    fit: BoxFit.cover,
  );
}

