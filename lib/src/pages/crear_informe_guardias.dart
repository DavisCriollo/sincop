import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/models/crea_fotos.dart';
import 'package:sincop_app/src/models/session_response.dart';

import 'package:sincop_app/src/pages/view_photo_crea_Informe.dart';

import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/widgets/dropdown_informe_para.dart';

class CrearInformeGuardiaPage extends StatefulWidget {
  final Session? usuario;
  const CrearInformeGuardiaPage({Key? key, this.usuario}) : super(key: key);

  @override
  State<CrearInformeGuardiaPage> createState() =>
      _CrearInformeGuardiaPageState();
}

class _CrearInformeGuardiaPageState extends State<CrearInformeGuardiaPage> {
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  // late VideoPlayerController _videoPlayerController;
  // late InformeController controllerInformes;
  final informesVideo = InformeController();

  late TimeOfDay timeInicio;

  @override
  void initState() {
    timeInicio = TimeOfDay.now();
// _videoPlayerController = VideoPlayerController.network(
//       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
//       // closedCaptionFile: _loadCaptions(),
//       videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),);

    // informesVideo.getUrlVideo;

//     _videoPlayerController =
//         // VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
//         VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
//  _videoPlayerController.initialize();
//     _videoPlayerController.play();

    // "https://www.youtube.com/watch?v=UJJpyUIESMw",

    // closedCaptionFile: _loadCaptions(),
    // videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    super.initState();
  }

  @override
  void dispose() {
    _fechaInicioController.clear();
    _horaInicioController.clear();
    // _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final persona =
        widget.usuario!.rol!.contains('GUARDIA') ? "SUPERVISORES" : 'CLIENTES';
    Responsive size = Responsive.of(context);
    final informeController = Provider.of<InformeController>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFEEEEEE),
          appBar: AppBar(
            // backgroundColor: primaryColor,
            title: Text(
              'Crear Informe',
              style: GoogleFonts.lexendDeca(
                  fontSize: size.iScreen(2.45),
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
            actions: [
              Container(
                margin: EdgeInsets.only(right: size.iScreen(1.5)),
                child: IconButton(
                    splashRadius: 28,
                    onPressed: () {
                      _onSubmit(context, informeController);
                    },
                    icon: Icon(
                      Icons.save_outlined,
                      size: size.iScreen(4.0),
                    )),
              ),
            ],
          ),
          body: Container(
            //  color: Colors.red,
            width: size.wScreen(100.0),
            height: size.hScreen(100.0),
            padding: EdgeInsets.only(
              left: size.iScreen(1.0),
              right: size.iScreen(1.0),
              // top: size.iScreen(2.0),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: informeController.informesGuardiasFormKey,
                child: Column(
                  children: [
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Para:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    DropMenuInformePara(
                      data: [
                        persona,
                        'JEFE DE OPERACIONES',
                      ],
                      hinText: 'Seleccione Persona',
                    ),
                    //***********************************************/

                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Dirigido a :',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            // color: Colors.red,
                            padding: EdgeInsets.only(
                              top: size.iScreen(1.0),
                              right: size.iScreen(0.5),
                            ),
                            child: Consumer<InformeController>(
                              builder: (_, persona, __) {
                                return (persona.getTextDirigido == '')
                                    ? Text(
                                        'No hay persona designada',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )
                                    : Text(
                                        '${persona.getTextDirigido} ',
                                        style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.8),
                                          fontWeight: FontWeight.normal,
                                          // color: Colors.grey
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: informeController.labelInformePara != null
                                ? () {
                                    _modalSeleccionaPersona(
                                        size,
                                        informeController,
                                        informeController.labelInformePara!);
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              color: informeController.labelInformePara != null
                                  ? primaryColor
                                  : Colors.grey,
                              width: size.iScreen(3.5),
                              padding: EdgeInsets.only(
                                top: size.iScreen(0.5),
                                bottom: size.iScreen(0.5),
                                left: size.iScreen(0.5),
                                right: size.iScreen(0.5),
                              ),
                              child: Icon(
                                Icons.search_outlined,
                                color: Colors.white,
                                size: size.iScreen(2.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Asunto:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.beenhere_outlined)
                          ),
                      textAlign: TextAlign.start,
                      style: const TextStyle(

                          // fontSize: size.iScreen(3.5),
                          // fontWeight: FontWeight.bold,
                          // letterSpacing: 2.0,
                          ),
                      onChanged: (text) {
                        informeController.setInputAsuntoChange(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese asunto del informe';
                        }
                      },
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Lugar:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.beenhere_outlined)
                          ),
                      textAlign: TextAlign.start,
                      style: const TextStyle(

                          // fontSize: size.iScreen(3.5),
                          // fontWeight: FontWeight.bold,
                          // letterSpacing: 2.0,
                          ),
                      onChanged: (text) {
                        informeController.setInputLugarChange(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese lugar';
                        }
                      },
                    ),
                    //*****************************************/
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Implicado:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.beenhere_outlined)
                          ),
                      textAlign: TextAlign.start,
                      style: const TextStyle(

                          // fontSize: size.iScreen(3.5),
                          // fontWeight: FontWeight.bold,
                          // letterSpacing: 2.0,
                          ),
                      onChanged: (text) {
                        informeController.setInputPejudicadoChange(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese implicado';
                        }
                      },
                    ),

                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Detalle:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          // suffixIcon: Icon(Icons.beenhere_outlined)
                          ),
                      textAlign: TextAlign.start,
                      style: const TextStyle(

                          // fontSize: size.iScreen(3.5),
                          // fontWeight: FontWeight.bold,
                          // letterSpacing: 2.0,
                          ),
                      onChanged: (text) {
                        informeController.setInputDetalleChange(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese detalle del suceso';
                        }
                      },
                    ),
                    //***********************************************/
                    // SizedBox(
                    //   height: size.iScreen(1.0),
                    // ),
                    // //*****************************************/
                    // Container(
                    //   width: size.wScreen(100.0),

                    //   // color: Colors.blue,
                    //   child: Text('Tipo de novedad:',
                    //       style: GoogleFonts.lexendDeca(
                    //           // fontSize: size.iScreen(2.0),
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey)),
                    // ),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //       // suffixIcon: Icon(Icons.beenhere_outlined)
                    //       ),
                    //   textAlign: TextAlign.start,
                    //   style: const TextStyle(

                    //       // fontSize: size.iScreen(3.5),
                    //       // fontWeight: FontWeight.bold,
                    //       // letterSpacing: 2.0,
                    //       ),
                    //   onChanged: (text) {
                    //     informeController.setInputTipoNovedadChange(text);
                    //   },
                    //   validator: (text) {
                    //     if (text!.trim().isNotEmpty) {
                    //       return null;
                    //     } else {
                    //       return 'Ingrese tipo de novedad';
                    //     }
                    //   },
                    // ),
                    //*****************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
                    ),
                    Container(
                      width: size.wScreen(100),
                      child: Text(
                        'Fecha y hora del suceso:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(1.8),
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: size.wScreen(35),
                          margin: EdgeInsets.symmetric(
                              horizontal: size.wScreen(3.5)),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            readOnly: true,
                            controller: _fechaInicioController,
                            decoration: InputDecoration(
                              hintText: 'yyyy-mm-dd',
                              hintStyle: const TextStyle(color: Colors.black38),
                              suffixIcon: IconButton(
                                color: Colors.red,
                                splashRadius: 20,
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _selectFecha(context, informeController);
                                },
                                icon: const Icon(
                                  Icons.date_range_outlined,
                                  color: primaryColor,
                                  size: 30,
                                ),
                              ),
                            ),
                            // keyboardType: keyboardType,
                            // readOnly: readOnly,
                            // initialValue: initialValue,
                            textInputAction: TextInputAction.none,
                            onChanged: (value) {},
                            onSaved: (value) {},
                            validator: (text) {
                              if (text!.trim().isNotEmpty) {
                                return null;
                              } else {
                                return 'Ingrese fecha del suceso';
                              }
                            },
                            style: const TextStyle(
                                // letterSpacing: 2.0,
                                // fontSize: size.iScreen(3.0),
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Container(
                          width: size.wScreen(35),
                          margin: EdgeInsets.symmetric(
                              horizontal: size.wScreen(3.5)),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            readOnly: true,
                            controller: _horaInicioController,
                            decoration: InputDecoration(
                              hintText: '00:00',
                              hintStyle: const TextStyle(color: Colors.black38),
                              suffixIcon: IconButton(
                                color: Colors.red,
                                splashRadius: 20,
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _seleccionaHora(context, informeController);
                                },
                                icon: const Icon(
                                  Icons.access_time_outlined,
                                  color: primaryColor,
                                  size: 30,
                                ),
                              ),
                            ),
                            // keyboardType: keyboardType,
                            // readOnly: readOnly,
                            // initialValue: initialValue,
                            textInputAction: TextInputAction.none,
                            onChanged: (value) {},
                            onSaved: (value) {},
                            validator: (text) {
                              if (text!.trim().isNotEmpty) {
                                return null;
                              } else {
                                return 'Ingrese hora del suceso';
                              }
                            },
                            style: const TextStyle(
                                // letterSpacing: 2.0,
                                // fontSize: size.iScreen(3.0),
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),

                    // SizedBox(
                    //   height: size.iScreen(1.0),
                    // ),
                    // //*****************************************//
                    // Container(
                    //   width: size.wScreen(100.0),

                    //   // color: Colors.blue,
                    //   child: Text('Motivo:',
                    //       style: GoogleFonts.lexendDeca(
                    //           // fontSize: size.iScreen(2.0),
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey)),
                    // ),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //       // suffixIcon: Icon(Icons.beenhere_outlined)
                    //       ),
                    //   textAlign: TextAlign.start,
                    //   style: const TextStyle(

                    //       // fontSize: size.iScreen(3.5),
                    //       // fontWeight: FontWeight.bold,
                    //       // letterSpacing: 2.0,
                    //       ),
                    //   onChanged: (text) {
                    //     informeController.setInputMotivoChange(text);
                    //   },
                    //   validator: (text) {
                    //     if (text!.trim().isNotEmpty) {
                    //       return null;
                    //     } else {
                    //       return 'Ingrese motivo';
                    //     }
                    //   },
                    // ),
                    //*****************************************/

                    widget.usuario!.rol!.contains('GUARDIA')
                        ? const SizedBox()
                        : Column(
                            children: [
                              //*****************************************/
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //*****************************************/
                              Container(
                                width: size.wScreen(100.0),

                                // color: Colors.blue,
                                child: Text('Conclusiones:',
                                    style: GoogleFonts.lexendDeca(
                                        // fontSize: size.iScreen(2.0),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              TextFormField(
                                maxLines: 2,
                                decoration: const InputDecoration(
                                    // suffixIcon: Icon(Icons.beenhere_outlined)
                                    ),
                                textAlign: TextAlign.start,
                                style: const TextStyle(

                                    // fontSize: size.iScreen(3.5),
                                    // fontWeight: FontWeight.bold,
                                    // letterSpacing: 2.0,
                                    ),
                                onChanged: (text) {
                                  informeController
                                      .setInputConclusionesChange(text);
                                },
                                validator: (text) {
                                  if (text!.trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Ingrese Conclusiones';
                                  }
                                },
                              ),
                              //*****************************************/
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //*****************************************/
                              Container(
                                width: size.wScreen(100.0),

                                // color: Colors.blue,
                                child: Text('Recomendaciones:',
                                    style: GoogleFonts.lexendDeca(
                                        // fontSize: size.iScreen(2.0),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              TextFormField(
                                maxLines: 2,
                                decoration: const InputDecoration(
                                    // suffixIcon: Icon(Icons.beenhere_outlined)
                                    ),
                                textAlign: TextAlign.start,
                                style: const TextStyle(

                                    // fontSize: size.iScreen(3.5),
                                    // fontWeight: FontWeight.bold,
                                    // letterSpacing: 2.0,
                                    ),
                                onChanged: (text) {
                                  informeController
                                      .setInputRecomendacionesChange(text);
                                },
                                validator: (text) {
                                  if (text!.trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Ingrese drecomendaciones';
                                  }
                                },
                              ),
                            ],
                          ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),

                    //*****************************************/
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    widget.usuario!.rol!.contains('GUARDIA')
                        ? const SizedBox()
                        : Row(
                            children: [
                              Container(
                                // width: size.wScreen(100.0),
                                // color: Colors.blue,
                                child: Consumer<InformeController>(
                                  builder: (_, valor, __) {
                                    return Row(
                                      children: [
                                        Text('Guardias: ',
                                            style: GoogleFonts.lexendDeca(
                                                // fontSize: size.iScreen(2.0),
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey)),
                                        (valor.getTextDirigido != '')
                                            ? Text(
                                                ' ${valor.getListaGuardiaInforme.length}',
                                                style: GoogleFonts.lexendDeca(
                                                    fontSize: size.iScreen(1.7),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey))
                                            : const SizedBox(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: size.iScreen(1.0)),
                              Consumer<InformeController>(
                                builder: (_, values, __) {
                                  return values.getTextDirigido != '' 
                                  // ||
                                  //         values.getTextDirigido != ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: GestureDetector(
                                            onTap: () {
                                              // values.buscaInfoGuardias('');
                                              // Navigator.pushNamed(
                                              //     context, 'buscarGuardiasVarios');

                                              values
                                                  .buscaInfoGuardiasPorCliente(
                                                      '');
                                              Navigator.pushNamed(context,
                                                  'buscarPersonalInformeGuardia');

                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute<void>(
                                              //         builder: (BuildContext context) =>
                                              //             const BuscarGuardiasVarios()));
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: primaryColor,
                                              width: size.iScreen(3.05),
                                              padding: EdgeInsets.only(
                                                top: size.iScreen(0.5),
                                                bottom: size.iScreen(0.5),
                                                left: size.iScreen(0.5),
                                                right: size.iScreen(0.5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: size.iScreen(2.0),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox();
                                },
                              )
                            ],
                          ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    //==========================================//
                    widget.usuario!.rol!.contains('GUARDIA')
                        ? const SizedBox()
                        : Consumer<InformeController>(
                            builder: (_, valueGuardias, __) {
                              return valueGuardias
                                      .getListaGuardiaInforme.isNotEmpty
                                  ? _ListaGuardias(
                                      size: size,
                                      informeController: valueGuardias)
                                  : Text('Seleccionar guardias',
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.8),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey));
                            },
                          ),

                    //========================================//

                    //==========================================//
                    informeController.getListaFotosInforme.isNotEmpty
                        ? _CamaraOption(
                            size: size, informeController: informeController)
                        : Container(),
                    //*****************************************/
                    //***********************************************/
                    SizedBox(
                      width: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    //==========================================//
                    informeController.getUrlVideo!.isNotEmpty
                        ? _CamaraVideo(
                            size: size,
                            informeController: informeController,
                          )
                        : Container(),
                    //*****************************************/

                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(3.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  bottomSheet(informeController, context, size);
                },
                backgroundColor: Colors.purpleAccent,
                heroTag: "btnCamara",
                child: const Icon(Icons.camera_alt_outlined),
              ),
              SizedBox(
                height: size.iScreen(1.5),
              ),
              //********************VIDEO***************************//
              // FloatingActionButton(
              //   backgroundColor:  informeController.getUrlVideo!.isEmpty?Colors.blue:Colors.grey,
              //   heroTag: "btnVideo",
              //   child: informeController.getUrlVideo!.isEmpty
              //       ? const Icon(
              //           Icons.videocam_outlined,
              //           color: Colors.white
              //         )
              //       : const Icon(
              //           Icons.videocam_outlined,
              //           color: Colors.black,
              //         ),
              //   onPressed: informeController.getUrlVideo!.isEmpty
              //       ? () {
              //           Navigator.push(context,
              //               MaterialPageRoute(builder: (BuildContext context) {
              //             return const CameraUtilitarios(
              //               modulo: 'informes',
              //             );
              //           }));
              //         }
              //       : null,
              // ),
              //********************VIDEO***************************//
              FloatingActionButton(
                backgroundColor: informeController.getPathVideo!.isEmpty
                    ? Colors.blue
                    : Colors.grey,
                heroTag: "btnVideo",
                child: informeController.getPathVideo!.isEmpty
                    ? const Icon(Icons.videocam_outlined, color: Colors.white)
                    : const Icon(
                        Icons.videocam_outlined,
                        color: Colors.black,
                      ),
                onPressed: informeController.getPathVideo!.isEmpty
                    ? () {
                        bottomSheetVideo(informeController, context, size);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (BuildContext context) {
                        //   return const CameraUtilitarios(
                        //     modulo: 'informes',
                        //   );
                        // }));
                      }
                    : null,
              ),
              SizedBox(
                height: size.iScreen(1.5),
              ),

              SizedBox(
                height: size.iScreen(1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //********************************************************************************************************************//
  void _onSubmit(BuildContext context, InformeController controller) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
      // if (controller.getListaGuardiaInforme.isEmpty) {
      //   NotificatiosnService.showSnackBarDanger('Debe seleccionar guardia');
      // } else
      if (controller.getTextDirigido == null) {
        NotificatiosnService.showSnackBarDanger('Debe elegir a persona');
      } else {
        // ProgressDialog.show(context);
        await controller.crearInforme(context);
        // await controller.upLoadImagen();
        // ProgressDialog.dissmiss(context);
        Navigator.pop(context);
      }
    }
  }

//================================================= SELECCIONA FECHA INICIO ==================================================//
  _selectFecha(
      BuildContext context, InformeController informeController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      String? anio, mes, dia;
      anio = '${picked.year}';
      mes = (picked.month < 10) ? '0${picked.month}' : '${picked.month}';
      dia = (picked.day < 10) ? '0${picked.day}' : '${picked.day}';

      // setState(() {
      final _fechaInicio =
          '${anio.toString()}-${mes.toString()}-${dia.toString()}';
      _fechaInicioController.text = _fechaInicio;
      informeController.onInputFechaInformeGuardiaChange(_fechaInicio);
      // print('FechaInicio: $_fechaInicio');
      // });
    }
  }

  void _seleccionaHora(context, InformeController informeController) async {
    TimeOfDay? _hora =
        await showTimePicker(context: context, initialTime: timeInicio);

    if (_hora != null) {
      String? dateHora = (_hora.hour < 10) ? '0${_hora.hour}' : '${_hora.hour}';
      String? dateMinutos =
          (_hora.minute < 10) ? '0${_hora.minute}' : '${_hora.minute}';

      setState(() {
        timeInicio = _hora;
        String horaInicio = '${dateHora}:${dateMinutos}';
        _horaInicioController.text = horaInicio;
        informeController.onInputHoraInformeGuardiaChange(horaInicio);
        //  print('si: $horaInicio');
      });
    }
  }

  void bottomSheet(
    InformeController informeController,
    BuildContext context,
    Responsive size,
  ) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              // title: Text(title, style: GoogleFonts.lexendDeca(
              //               fontSize: size.dp(1.8),
              //               fontWeight: FontWeight.w500,
              //               // color: Colors.white,
              //             )),

              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    // urls.launchWaze(lat, lng);s
                    _funcionCamara(ImageSource.camera, informeController);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Abrir Cámara',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.2),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(2.0),
                          ),
                          child: Icon(Icons.camera_alt_outlined,
                              size: size.iScreen(3.0))),
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    _funcionCamara(ImageSource.gallery, informeController);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Abrir Galería',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.2),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(2.0),
                          ),
                          child: Icon(Icons.image_outlined,
                              size: size.iScreen(3.0))),
                    ],
                  ),
                ),
              ],
              // cancelButton: CupertinoActionSheetAction(
              //   onPressed: () => Navigator.of(context).pop(),
              //   child: Text('Close'),
              // ),
            ));
  }

  void bottomSheetVideo(
    InformeController informeController,
    BuildContext context,
    Responsive size,
  ) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              // title: Text(title, style: GoogleFonts.lexendDeca(
              //               fontSize: size.dp(1.8),
              //               fontWeight: FontWeight.w500,
              //               // color: Colors.white,
              //             )),

              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    _funcionCamaraVideo(ImageSource.camera, informeController);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Video',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.2),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(2.0),
                          ),
                          child: Icon(Icons.image_outlined,
                              size: size.iScreen(3.0))),
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    _funcionCamaraVideo(ImageSource.gallery, informeController);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Galería',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.2),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          )),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(2.0),
                          ),
                          child: Icon(Icons.image_outlined,
                              size: size.iScreen(3.0))),
                    ],
                  ),
                ),
              ],
              // cancelButton: CupertinoActionSheetAction(
              //   onPressed: () => Navigator.of(context).pop(),
              //   child: Text('Close'),
              // ),
            ));
  }

  void _funcionCamara(
      ImageSource source, InformeController informeController) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile == null) {
      return;
    }
    informeController.setNewPictureFile('${pickedFile.path}');
    print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
// _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
  }

  void _funcionCamaraVideo(
      ImageSource source, InformeController informeController) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(
      source: source,
    );

    if (pickedFile == null) {
      return;
    }
    print(
        'TENEMOS VIDEO :==========================+++++++++++++++++++++++++>  ${pickedFile.path}');
    informeController.setPathVideo(pickedFile.path);

//===============================//
// _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
  }

  //====== MUESTRA MODAL  =======//
  void _modalSeleccionaPersona(
      Responsive size, InformeController informeController, String persona) {
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('SELECCIONAR',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          )),
                      Container(
                        alignment: Alignment.center,
                        width: size.wScreen(50),
                        // color: Colors.red,
                        child: Text(persona,
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            )),
                      ),
                    ],
                  ),
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
                          String barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                                  '#34CAF0', 'Cancelar', false, ScanMode.QR);
                          print('QR===> $barcodeScanRes ');
                          // homeController.setOpcionActividad(1);
                          // informeController.resetValuesInformes();
                          // _validaScanQRMulta(size, informeController);
                          // Navigator.pop(context);
                          // _modalTerminosCondiciones(size, homeController);
                        },
                      ),
                      // const Divider(),
                      // ListTile(
                      //   tileColor: Colors.grey[200],
                      //   leading: const Icon(Icons.badge_outlined,
                      //       color: Colors.black),
                      //   title: Text(
                      //     "Código Personal",
                      //     style: GoogleFonts.lexendDeca(
                      //       fontSize: size.iScreen(1.5),
                      //       fontWeight: FontWeight.bold,
                      //       // color: Colors.white,
                      //     ),
                      //   ),
                      //   trailing: const Icon(Icons.chevron_right_outlined),
                      //   onTap: () {
                      //     // print('EEEERRRRR');

                      //     // Navigator.pop(context);
                      //     // Navigator.pushNamed(context, 'validaAccesoMultas');
                      //   },
                      // ),
                      const Divider(),
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading: const Icon(Icons.badge_outlined,
                            color: Colors.black),
                        title: Text(
                          "Nómina de $persona",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          if (persona == 'CLIENTES') {
                            informeController.getTodosLosClientesInformes('');
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, 'buscaClienteInformeGuardia');
                          } else {
                            informeController.buscaPersonaDirigidoAs('');
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, 'buscarPersonaInformes');
                          }
                        },
                      ),
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

//======================== VAALIDA SCANQR =======================//
  void _validaScanQRMulta(
      Responsive size, InformeController informeController) async {
    try {
      await informeController.setInfoQRMultaGuardia(
          await FlutterBarcodeScanner.scanBarcode(
              '#34CAF0', '', false, ScanMode.QR));
      if (!mounted) return;
      ProgressDialog.show(context);

      ProgressDialog.dissmiss(context);
      final response = informeController.getErrorInfoGuardiaInforme;
      if (response == true) {
        // informeController.buscaGuardiaMultas();
        // Navigator.pushNamed(context, 'crearMultasGuardias');

      } else {
        NotificatiosnService.showSnackBarDanger('No existe registrto');
      }
    } on PlatformException {
      NotificatiosnService.showSnackBarError('No se pudo escanear ');
    }
  }
}

class _CamaraVideo extends StatelessWidget {
  const _CamaraVideo({
    Key? key,
    required this.size,
    required this.informeController,
  }) : super(key: key);

  final Responsive size;
  final InformeController informeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size.wScreen(100.0),
          // color: Colors.blue,
          margin: EdgeInsets.symmetric(
            vertical: size.iScreen(1.0),
            horizontal: size.iScreen(0.5),
          ),
          child: Text('Video:',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        ListTile(
          tileColor: Colors.grey.shade300,
          dense: true,
          title: Text(
            'Video seleccionado',
            style: GoogleFonts.lexendDeca(
                fontSize: size.iScreen(1.7),
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          leading: InkWell(
            onTap: () {
              informeController.eliminaVideo();
            },
            child: Container(
              margin: EdgeInsets.only(right: size.iScreen(0.5)),
              child:
                  const Icon(Icons.delete_forever_outlined, color: Colors.red),
            ),
          ),
          //  const Icon(Icons.delete_forever_outlined,
          //   color: Colors.red),

          trailing: Icon(
            Icons.video_file_outlined,
            size: size.iScreen(5.0),
          ),
          onTap: () {
            Navigator.pushNamed(context, 'videoSreen',
                arguments: '${informeController.getUrlVideo}');
          },
        ),
        // Card(
        //   child: Row(
        //     children: [
        //       //***********************************************/
        //       SizedBox(
        //         width: size.iScreen(1.0),
        //       ),
        //       //*****************************************/
        //       GestureDetector(
        //         onTap: () {
        //           informeController.eliminaVideo();
        //         },
        //         child: Container(
        //           margin: EdgeInsets.only(right: size.iScreen(0.5)),
        //           child: const Icon(Icons.delete_forever_outlined,
        //               color: Colors.red),
        //         ),
        //       ),
        //       Icon(
        //         Icons.video_file_outlined,
        //         size: size.iScreen(5.0),
        //       ),
        //       GestureDetector(
        //         onTap: () {
        //           Navigator.pushNamed(context, 'videoSreen',
        //               arguments: '${informeController.getUrlVideo}');
        //         },
        //         child: Expanded(
        //           child: Container(
        //             margin: EdgeInsets.symmetric(
        //                 horizontal: size.iScreen(1.0),
        //                 vertical: size.iScreen(1.0)),
        //             child: Text(
        //               'Video seleccionado',
        //               style: GoogleFonts.lexendDeca(
        //                   fontSize: size.iScreen(1.7),
        //                   color: Colors.grey,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class _CamaraOption extends StatefulWidget {
  final InformeController informeController;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.informeController,
  }) : super(key: key);

  final Responsive size;

  @override
  State<_CamaraOption> createState() => _CamaraOptionState();
}

class _CamaraOptionState extends State<_CamaraOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Consumer<InformeController>(
        builder: (_, fotoUrl, __) {
          return Column(
            children: [
              Container(
                width: widget.size.wScreen(100.0),
                // color: Colors.blue,
                margin: EdgeInsets.symmetric(
                  vertical: widget.size.iScreen(1.0),
                  horizontal: widget.size.iScreen(0.0),
                ),
                child:
                    Text('Fotografía:  ${fotoUrl.getListaFotosUrl!.length}   ',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
              ),
              SingleChildScrollView(
                child:
                    // Wrap(
                    //     children: informeController.getListaFotosInforme
                    //         .map((e) => _ItemFoto(
                    //             size: size,
                    //             informeController: informeController,
                    //             image: e))
                    //         .toList()),
                    Wrap(
                        children: fotoUrl.getListaFotosUrl!
                            .map(
                              (e) => Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: widget.size.iScreen(1.5)),
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/imgs/loader.gif'),
                                      image: NetworkImage('${e['url']}'),
                                    ),
                                  ),
                                  Positioned(
                                    top: -3.0,
                                    right: 4.0,
                                    // bottom: -3.0,
                                    child: IconButton(
                                      color: Colors.red.shade700,
                                      onPressed: () {
                                        setState(() {
                                          fotoUrl.eliminaFotoUrl(e['url']);
                                        });
                                        // bottomSheetMaps(context, size);
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        size: widget.size.iScreen(3.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList()),
              ),
            ],
          );
        },
      ),
      onTap: () {
        print('activa FOTOGRAFIA');
      },
    );
  }
}

class _ItemFoto extends StatelessWidget {
  // final CreaNuevaFotoInformeGuardias? image;
  final CreaNuevaFotoInformeGuardias? image;
  final InformeController informeController;

  const _ItemFoto({
    Key? key,
    required this.size,
    required this.informeController,
    required this.image,
  }) : super(key: key);

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Hero(
            tag: image!.id,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: size.iScreen(2.0), vertical: size.iScreen(1.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: size.wScreen(35.0),
                  height: size.hScreen(20.0),
                  padding: EdgeInsets.symmetric(
                    vertical: size.iScreen(0.0),
                    horizontal: size.iScreen(0.0),
                  ),
                  child: getImage(image!.path),
                ),
              ),
            ),
          ),
          onTap: () {
            // Navigator.pushNamed(context, 'viewPhoto');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PreviewScreenCreaInformeGuardia(image: image)));
          },
        ),
        Positioned(
          top: -3.0,
          right: 4.0,
          // bottom: -3.0,
          child: IconButton(
            color: Colors.red.shade700,
            onPressed: () {
              informeController.eliminaFoto(image!.id);
              // bottomSheetMaps(context, size);
            },
            icon: Icon(
              Icons.delete_forever,
              size: size.iScreen(3.5),
            ),
          ),
        ),
      ],
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

class _ListaGuardias extends StatelessWidget {
  final InformeController informeController;
  const _ListaGuardias({
    Key? key,
    required this.size,
    required this.informeController,
  }) : super(key: key);

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Consumer<InformeController>(
        builder: (_, provider, __) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.5)),
            // color: Colors.red,
            width: size.wScreen(100.0),
            height: size.iScreen(
                provider.getListaGuardiaInforme.length.toDouble() * 5.5),
            child: ListView.builder(
              itemCount: provider.getListaGuardiaInforme.length,
              itemBuilder: (BuildContext context, int index) {
                final guardia = provider.getListaGuardiaInforme[index];
                return Card(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          provider.eliminaGuardiaInforme(guardia['id']);
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
                            '${guardia['nombres']}',
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
              },
            ),
          );
        },
      ),
      onTap: () {
        print('activa FOTOGRAFIA');
      },
    );
  }
}
