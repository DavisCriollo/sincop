import 'dart:io';

import 'package:better_player/better_player.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/comunicados_clientes_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/utils/dialogs.dart';



import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';

import '../models/lista_allNovedades_guardia.dart';

class DetalleMultaGuardiaPage extends StatefulWidget {
  final Result? infoMultaGuardia;

  const DetalleMultaGuardiaPage({Key? key,  this.infoMultaGuardia}) : super(key: key);


  @override
  State<DetalleMultaGuardiaPage> createState() => _DetalleMultaGuardiaPageState();
}

class _DetalleMultaGuardiaPageState extends State<DetalleMultaGuardiaPage> {


@override
void initState() {
 
//  initData();
  
  super.initState();
  
}

//  void initData() {
//     final loadData = MultasGuardiasContrtoller();
//     loadData.getTodosLosClientesMultas('');
//   }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);

    final multasController = Provider.of<MultasGuardiasContrtoller>(context);
  
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: primaryColor,
            title:  Text('Detalle de Multa  '"${widget.infoMultaGuardia!.nomPorcentaje} %"''),
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
            // Container(
            //   margin: EdgeInsets.only(right: size.iScreen(1.5)),
            //   child: IconButton(
            //       splashRadius: 28,
            //       onPressed: () {
            //         _onSubmit(context, multasController);
            //       },
            //       icon: Icon(
            //         Icons.save_outlined,
            //         size: size.iScreen(4.0),
            //       )),
            // ),
          ],
          ),
          body: Container(
            // color: Colors.red,
            margin: EdgeInsets.only(top: size.iScreen(3.0)),
            padding: EdgeInsets.symmetric(horizontal: size.iScreen(2.0)),
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
                            widget.infoMultaGuardia!.nomFecReg
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
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      // 'item Novedad: ${controllerActividades.getItemMulta}',
                      '"${widget.infoMultaGuardia!.nomDetalle}"',
                      textAlign: TextAlign.center,
                      //
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.3),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),

               
                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Observaciones:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                    //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
 //==========================================//
                  Container(
                    // margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      '${widget.infoMultaGuardia!.nomObservacion}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                   //*****************************************/
           
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
 //==========================================//
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Nombre:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      '${widget.infoMultaGuardia!.nomNombrePer}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                        
                
                  //*****************************************/
             

                  Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Documento:',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                       Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(1.0)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${widget.infoMultaGuardia!.nomDocuPer}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Spacer(),
                      SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Estado:',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                       Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(1.0)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${widget.infoMultaGuardia!.nomEstado}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                 
                 
                    ],
                  ),
                 //***********************************************/
                 
                  Row(
                    children: [
                      SizedBox(
                        // width: size.wScreen(100.0),
                        // color: Colors.blue,
                        child: Text('Ciudad:',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    // width: size.wScreen(100.0),
                    child: Text(
                      ' ${widget.infoMultaGuardia!.nomCiudad}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                    ],
                  ),
                  
                  //==========================================//
                  Consumer<MultasGuardiasContrtoller>(builder: (_, provders, __) { 
                    return   provders.getListaCorreosClienteMultas.isNotEmpty
                      ? _CompartirClienta(
                          size: size, multasController: multasController)
                      : Container();

                  },),
                 
                 (widget.infoMultaGuardia!.nomFotos!.isNotEmpty)?
                  _CamaraOption(
                      size: size,
                      multasController: multasController,
                      infoMultasGuardia: widget.infoMultaGuardia!):Container(),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
 //==========================================//
                   widget.infoMultaGuardia!.nomVideo!.isNotEmpty
                        ? _CamaraVideo(
                            size: size,
                            // infoMultaGuardiaController: infoMultaGuardiaController,
                            multa: widget.infoMultaGuardia
                          )
                        : Container(),
                    //*****************************************/
                  
                
                   //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
 //==========================================//
                 
                  
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                
                  //*****************************************/
                ],
              ),
            ),
          ),
//           floatingActionButton:  //********************COMPARTIR***************************//
//             FloatingActionButton(
//               backgroundColor: const Color(0XFF343A40),
//               heroTag: "btnCompartir",
//               child: const Icon(Icons.share),
//               onPressed: () {
//                 multasController.getTodosLosClientesMultas('');
//                 // Navigator.pushNamed(context, 'buscarClientesMultaGuardia');

// //  multasController.getTodosLosClientes('');
//                             // Navigator.pop(context);
//                             Navigator.pushNamed(context, 'buscaClientes',
//                                 arguments: 'cambioPuesto');





//               },
//             ),
            // SizedBox(
            //   height: size.iScreen(1.5),
            // ),
        ),
      ),
    );
  }

  //********************************************************************************************************************//
  void _onSubmit(
    BuildContext context,
    MultasGuardiasContrtoller controller,
  ) async {
   
     
          ProgressDialog.show(context);
          await controller.creaMultaGuardia(context);
          // await controller.upLoadImagen();
          ProgressDialog.dissmiss(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
        
      
    }
  }



class _CamaraOption extends StatelessWidget {
  final MultasGuardiasContrtoller multasController;
  final Result infoMultasGuardia;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.multasController,
    required this.infoMultasGuardia,
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
            child: Text('Fotografía: ${infoMultasGuardia.nomFotos!.length}',
                style: GoogleFonts.lexendDeca(
                    // fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)),
          ),
          SingleChildScrollView(
            child:
               Wrap(
                children: infoMultasGuardia.nomFotos!.map((e) {



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
                            image: NetworkImage(e.url!),
                          ),
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

class _CamaraVideo extends StatelessWidget {

  final Result? multa;
  const _CamaraVideo({
    Key? key,
    required this.size,
    //required this.informeController,
     required this.multa,
    // required this.videoController,
  }) : super(key: key);

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          margin: EdgeInsets.symmetric(
            vertical: size.iScreen(1.0),
            horizontal: size.iScreen(0.0),
          ),
          child: Text('Video:',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
                            AspectRatio(
                              aspectRatio:16/16 ,
                              child: 
                              BetterPlayer.network(
                                // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                               
                                '${multa!.nomVideo![0]['url']}',
                                betterPlayerConfiguration:
                                    const BetterPlayerConfiguration(
                                      aspectRatio: 16/16,
                                    ),
                              ),
                            )


      ],
    );
  }
}

class _CompartirClienta extends StatelessWidget {
  final MultasGuardiasContrtoller multasController;
  const _CompartirClienta({
    Key? key,
    required this.size,
    required this.multasController,
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
            child: Text('Compartir a:',
                style: GoogleFonts.lexendDeca(
                    // fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)),
          ),
          Consumer<MultasGuardiasContrtoller>(
            builder: (_, provider, __) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.5)),
                //color: Colors.red,
                width: size.wScreen(100.0),
                height: size.iScreen(
                    provider.getListaCorreosClienteMultas.length.toDouble() *
                        6.3),
                child: ListView.builder(
                  itemCount: provider.getListaCorreosClienteMultas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cliente =
                        provider.getListaCorreosClienteMultas[index];
                    return Card(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              provider.eliminaClienteMulta(cliente['id']);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: size.iScreen(0.5)),
                              child: const Icon(Icons.delete_forever_outlined,
                                  color: Colors.red),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.iScreen(1.0),
                                  vertical: size.iScreen(1.0)),
                              child: Text(
                                '${cliente['nombres']}',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.7),
                                    // color: Colors.black54,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    // Card(
                    //   child: ListTile(
                    //     visualDensity: VisualDensity.compact,
                    //     title: Text(
                    //       '${cliente['nombres']}',
                    //       style: GoogleFonts.lexendDeca(
                    //           fontSize: size.iScreen(1.6),
                    //           // color: Colors.black54,
                    //           fontWeight: FontWeight.normal),
                    //     ),
                    //     // subtitle: Text(
                    //     //   '{cliente.cliCelular} - {cliente.cliTelefono}',
                    //     //   style: GoogleFonts.lexendDeca(
                    //     //       fontSize: size.iScreen(1.7),
                    //     //       // color: Colors.black54,
                    //     //       fontWeight: FontWeight.normal),
                    //     // ),
                    //     onTap: () {
                    //       // provider.setListaClienteMultasClear();
                    //       provider.eliminaClienteMulta(cliente['id']);
                    //       // print('${cliente['id']}');

                    //     },
                    //     trailing:const Icon(Icons.delete_forever_outlined,color:
                    //     Colors.red)
                    //   ),
                    // );
                  },
                ),
              );
            },
          )
        ],
      ),
      onTap: () {
        print('activa FOTOGRAFIA');
      },
    );
  }
}
