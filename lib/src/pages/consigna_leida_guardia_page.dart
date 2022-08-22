import 'dart:io';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sincop_app/src/controllers/consignas_clientes_controller.dart';
import 'package:sincop_app/src/models/lista_allConsignas_clientes.dart';
import 'package:sincop_app/src/pages/lista_consignas_realizadas_guardias.dart';
import 'package:sincop_app/src/pages/realizar_consigna_guardia.dart';

import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';

class ConsignaLeidaGuardiaPage extends StatelessWidget {
  final Result? infoConsignaCliente;

  const ConsignaLeidaGuardiaPage({Key? key, this.infoConsignaCliente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);

    final consignasController =
        Provider.of<ConsignasClientesController>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: primaryColor,
            title: const Text('Detalle de Consigna'),
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
            // color: Colors.red,
            margin: EdgeInsets.only(top: size.iScreen(3.0)),
            padding: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
            width: size.wScreen(100.0),
            height: size.hScreen(100),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //*****************************************/
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
                        Spacer(),
                        Text(
                            infoConsignaCliente!.conFecReg
                                .toString()
                                .replaceAll(".000Z", ""),
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
                      '"${infoConsignaCliente!.conAsunto}"',
                      textAlign: TextAlign.center,
                      //
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.3),
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
                    child: Text('Detalle:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      '${infoConsignaCliente!.conDetalle}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  (infoConsignaCliente!.conFotosCliente!.isNotEmpty)
                      ? _CamaraOption(
                          size: size,
                          consignaController: consignasController,
                          infoConsignaCliente: infoConsignaCliente!)
                      : Container(),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),

                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    child: Text(
                      'Fecha:',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.8),
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),

                  //*****************************************/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Desde:',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            // width: size.wScreen(35),
                            margin: EdgeInsets.symmetric(
                                horizontal: size.wScreen(0.5)),
                            child: Text(
                              infoConsignaCliente!.conDesde
                                  .toString()
                                  .replaceAll(" 00:00:00.000", ""),
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
                              fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            // width: size.wScreen(35),
                            margin: EdgeInsets.symmetric(
                                horizontal: size.wScreen(0.5)),
                            child: Text(
                              infoConsignaCliente!.conHasta
                                  .toString()
                                  .replaceAll(" 00:00:00.000", ""),
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
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),

                  //*****************************************/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Frecuencia: ',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${infoConsignaCliente!.conFrecuencia}',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              // color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Prioridad: ',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' ${infoConsignaCliente!.conPrioridad}',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              // color: Colors.black45,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    child: Text(
                      'Repetir:',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.8),
                        color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),

//***********************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    height: size.iScreen(5.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: infoConsignaCliente!.conDiasRepetir!.length,
                      itemBuilder: (BuildContext context, int index) {
                        String dia =
                            infoConsignaCliente!.conDiasRepetir![index];

                        return Container(
                          width: size.iScreen(5.0),
                          height: size.iScreen(5.0),
                          margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(1.8),
                          ),
                          // padding: EdgeInsets.all(size.iScreen(1.0)),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              dia.substring(0, 2),
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),

//*****************************************/
                  //***********************************************/
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
                  // Navigator.pushNamed(context, 'listaConsignasRealizadasGuardia');
                 Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VistaConsignasRealizadasGuardias(
                          infoConsignasRealizada: infoConsignaCliente)));
                },
                
                heroTag: "btnVisualizar",
                child: const Icon(Icons.content_paste_search_outlined),
              ),
              SizedBox(
                height: size.iScreen(1.5),
              ),
              FloatingActionButton(
                backgroundColor: primaryColor,
                heroTag: "btnRealizar",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RealizarConsignaPage(
                          infoConsignaGuardia: infoConsignaCliente)));
                },
                child: const Icon(Icons.rate_review_outlined),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => RealizarConsignaPage(
              //             infoConsignaGuardia: infoConsignaCliente)));
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: size.iScreen(2.0), vertical: size.iScreen(0.5)),
              //     decoration: BoxDecoration(
              //         color: secondaryColor,
              //         borderRadius: BorderRadius.circular(5.0)),
              //     child: Text(
              //       'Visualizar Consignas',
              //       style: GoogleFonts.lexendDeca(
              //           fontSize: size.iScreen(1.8),
              //           color: Colors.white,
              //           fontWeight: FontWeight.normal),
              //     ),
              //   ),
              // ),

              //***********************************************/
              SizedBox(
                height: size.iScreen(2.0),
              ),
              //*****************************************/
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => RealizarConsignaPage(
              //             infoConsignaGuardia: infoConsignaCliente)));
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: size.iScreen(2.0), vertical: size.iScreen(0.5)),
              //     decoration: BoxDecoration(
              //         color: primaryColor,
              //         borderRadius: BorderRadius.circular(5.0)),
              //     child: Text(
              //       'Realizar Consigna',
              //       style: GoogleFonts.lexendDeca(
              //           fontSize: size.iScreen(1.8),
              //           color: Colors.white,
              //           fontWeight: FontWeight.normal),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CamaraOption extends StatelessWidget {
  final ConsignasClientesController consignaController;
  final Result infoConsignaCliente;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.consignaController,
    required this.infoConsignaCliente,
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
            child: Wrap(
                children: infoConsignaCliente.conFotosCliente!.map((e) {
              return Stack(
                children: [
                  GestureDetector(
                    // child: Hero(
                    //   tag: image!.id,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.iScreen(2.0),
                          vertical: size.iScreen(1.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: const BoxDecoration(

                              // border: Border.all(color: Colors.grey),
                              // borderRadius: BorderRadius.circular(10),
                              ),
                          width: size.wScreen(35.0),
                          height: size.hScreen(20.0),
                          padding: EdgeInsets.symmetric(
                            vertical: size.iScreen(0.0),
                            horizontal: size.iScreen(0.0),
                          ),
                          child: getImage(e.url),
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigator.pushNamed(context, 'viewPhoto');
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => PreviewScreenConsignas(image: image)));
                    },
                  ),
                ],
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
    return FadeInImage(
      fit: BoxFit.cover,
      placeholder: const AssetImage('assets/imgs/loader.gif'),
      image: NetworkImage(picture),
    );
  }

  return Image.file(
    File(picture),
    fit: BoxFit.cover,
  );
}
