import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/models/crea_fotos.dart';
import 'package:sincop_app/src/models/lista_allInforme_guardias.dart';

import 'package:sincop_app/src/pages/camara_page.dart';
import 'package:sincop_app/src/pages/view_photo_crea_Informe.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';

class DetalleInformeGuardiaPage extends StatefulWidget {
  // Informe? informe;
  dynamic informe;
  DetalleInformeGuardiaPage({Key? key, this.informe}) : super(key: key);

  @override
  State<DetalleInformeGuardiaPage> createState() =>
      _DetalleInformeGuardiaPageState();
}

class _DetalleInformeGuardiaPageState extends State<DetalleInformeGuardiaPage> {
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
    Responsive size = Responsive.of(context);
    final informeController = Provider.of<InformeController>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFEEEEEE),
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(
              'Detalle de Informe',
              style: GoogleFonts.lexendDeca(
                  fontSize: size.iScreen(2.45),
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
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
                    Row(
                      children: [
                        Container(
                          // width: size.wScreen(100.0),

                          // color: Colors.blue,
                          child: Text('Elaborado por: ',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                        ),
                         Container(
                      // width: size.wScreen(100.0),
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                        // top: size.iScreen(1.0),
                        // right: size.iScreen(0.5),
                      ),
                      child: Text(
                        ' ${widget.informe!['infGenerado']}',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.4),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
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
                      child: Text('Dirigido a :',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    Container(
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                        top: size.iScreen(1.0),
                        right: size.iScreen(0.5),
                      ),
                      child: Text(
                        '${widget.informe!['infNomDirigido']}',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
                        ),
                      ),
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Row(
                      children: [
                        Container(
                          // width: size.wScreen(100.0),

                          // color: Colors.blue,
                          child: Text('Asunto: ',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                        ),
                         Container(
                      // width: size.wScreen(100.0),
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                        // top: size.iScreen(1.0),
                        // right: size.iScreen(0.5),
                      ),
                      child: Text(
                        ' ${widget.informe!['infAsunto']}',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
                        ),
                      ),
                    ),
                      ],
                    ),
                   

                    // //***********************************************/
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
                    // Container(
                    //   width: size.wScreen(100.0),
                    //   // color: Colors.red,
                    //   padding: EdgeInsets.only(
                    //     top: size.iScreen(1.0),
                    //     right: size.iScreen(0.5),
                    //   ),
                    //   child: Text(
                    //     '${widget.informe!['infTipoNovedad']}',
                    //     style: GoogleFonts.lexendDeca(
                    //       fontSize: size.iScreen(1.8),
                    //       fontWeight: FontWeight.normal,
                    //       // color: Colors.grey
                    //     ),
                    //   ),
                    // ),
                    // //*****************************************/
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
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    Container(
                      width: size.wScreen(100),
                      margin:
                          EdgeInsets.symmetric(horizontal: size.wScreen(3.5)),
                      child: Text(
                        widget.informe!['infFechaSuceso']
                            .toString()
                            .replaceAll("T", "  "),
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    Container(
                      width: size.wScreen(100.0),
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                        top: size.iScreen(1.0),
                        right: size.iScreen(0.5),
                      ),
                      child: Text(
                        '${widget.informe!['infLugar']}',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
                        ),
                      ),
                    ),

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
                    Container(
                      width: size.wScreen(100.0),
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                        top: size.iScreen(1.0),
                        right: size.iScreen(0.5),
                      ),
                      child: Text(
                        '${widget.informe!['infPerjudicado']}',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
                        ),
                      ),
                    ),
                    // //***********************************************/
                    // SizedBox(
                    //   height: size.iScreen(1.0),
                    // ),

                    // //*****************************************/
                    // Container(
                    //   width: size.wScreen(100.0),

                    //   // color: Colors.blue,
                    //   child: Text('Motivo:',
                    //       style: GoogleFonts.lexendDeca(
                    //           // fontSize: size.iScreen(2.0),
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey)),
                    // ),
                    // Container(
                    //   width: size.wScreen(100.0),
                    //   // color: Colors.red,
                    //   padding: EdgeInsets.only(
                    //     top: size.iScreen(1.0),
                    //     right: size.iScreen(0.5),
                    //   ),
                    //   child: Text(
                    //     '${widget.informe!['infPorque']}',
                    //     style: GoogleFonts.lexendDeca(
                    //       fontSize: size.iScreen(1.8),
                    //       fontWeight: FontWeight.normal,
                    //       // color: Colors.grey
                    //     ),
                    //   ),
                    // ),
                    // //*****************************************/

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
                    Container(
                      width: size.wScreen(100.0),
                      // color: Colors.red,
                      padding: EdgeInsets.only(
                        top: size.iScreen(1.0),
                        right: size.iScreen(0.5),
                      ),
                      child: Text(
                        '${widget.informe!['infSucedido']}',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
                        ),
                      ),
                    ),
                    //*****************************************/

                    //==========================================//
                    widget.informe!['infGuardias']!.isNotEmpty
                        ? _ListaGuardias(size: size, informe: widget.informe)
                        : Container(),
                    //*****************************************/
                    //*****************************************/

                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    SizedBox(
                      width: size.wScreen(100.0),
                      // color: Colors.blue,
                      child:
                          Text('Fotos:  ${widget.informe!['infFotos']!.length}',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                    ),
                    //*****************************************/

                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    // //==========================================//
                    widget.informe!['infFotos']!.isNotEmpty
                        // ? _CamaraOption(
                        //     size: size,
                        //     informeController: informeController,
                        //     informe: widget.informe)
                        ? SizedBox(
                            child: ListView.builder(
                              itemCount: widget.informe!['infFotos']!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/imgs/loader.gif'),
                                      image: NetworkImage(
                                        '${widget.informe!['infFotos']![index]['url']}',
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
                            height: size.iScreen(
                                widget.informe!['infFotos']!.length.toDouble() *
                                    36.0),
                          )
                        : Container(),
                    // // //*****************************************/
                    // // //==========================================//
                    widget.informe!['infVideo']!.isNotEmpty
                        ? _CamaraVideo(
                            size: size,
                            // informeController: informeController,
                            informe: widget.informe)
                        : Container(),

                    //*****************************************/

                    SizedBox(
                      height: size.iScreen(3.0),
                    ),
                    //*****************************************/
                  ],
                ),
              ),
            ),
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
      if (controller.getListaGuardiaInforme.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar guardia');
      } else if (controller.getTextDirigido == null) {
        NotificatiosnService.showSnackBarDanger('Debe elegir a persona');
      } else {
        ProgressDialog.show(context);
        await controller.crearInforme(context);
        // await controller.upLoadImagen();
        ProgressDialog.dissmiss(context);
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
      lastDate: DateTime(2025),
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
      setState(() {
        timeInicio = _hora;
        String horaInicio = '${timeInicio.hour}:${timeInicio.minute}';
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
    // print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
// _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalSeleccionaPersona(
      Responsive size, InformeController informeController) {
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
                  Text('SELECCIONAR CLIENTE',
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
                          "Nómina de Personal",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          // informeController.setOpcionActividad(3);
                          //
                          // informeController.resetValuesInformes();
                          // Navigator.pop(context);
                          //   // informeController.buscaGuardiaInforme('');
                          informeController.getTodosLosClientesInformes('');
                          //   // informeController.buscaGuardiaInforme('');

                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, 'buscaClienteInformeGuardia');
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
}

class _CamaraOption extends StatelessWidget {
  final InformeController informeController;
  final dynamic informe;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.informeController,
    required this.informe,
  }) : super(key: key);

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.wScreen(100.0),
            // height: size.hScreen(100.0),
            // color: Colors.blue,
            margin: EdgeInsets.symmetric(
              vertical: size.iScreen(1.0),
              horizontal: size.iScreen(0.0),
            ),
            child: Text('Fotografía: ${informe!['infFotos']!.length}',
                style: GoogleFonts.lexendDeca(
                    // fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)),
          ),
          ListView.builder(
            itemCount: informe!['infFotos']!.length,
            itemBuilder: (BuildContext context, int index) {
              return Text('dadadad');
            },
          ),
          // ListView.builder(
          //   itemCount: informe!['infFotos']!.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return FadeInImage(
          //       placeholder: const AssetImage('assets/imgs/loader.gif'),
          //       image: NetworkImage(
          //         '${informe!['infFotos']![index]['url']}',
          //       ),
          //     );
          //   },
          // ),

          // height: size.hScreen(informe!.infFotos!.length.toDouble()*20),
          // SingleChildScrollView(
          //   child:
          //   Wrap(
          //       children: informe!.infFotos!.map((e) {
          //     return Stack(
          //       children: [
          //         GestureDetector(
          //             // child: Hero(
          //             //   tag: image!.id,
          //             child: Container(
          //           margin: EdgeInsets.symmetric(
          //               horizontal: size.iScreen(2.0),
          //               vertical: size.iScreen(1.0)),
          //           child: Container(
          //             decoration: const BoxDecoration(
          //                 // color: Colors.red,
          //                 // border: Border.all(color: Colors.grey),
          //                 // borderRadius: BorderRadius.circular(10),
          //                 ),
          //             padding: EdgeInsets.symmetric(
          //               vertical: size.iScreen(0.0),
          //               horizontal: size.iScreen(0.0),
          //             ),
          //             child: ListView.builder(
          //               itemCount: informe!.infFotos!.length,
          //               itemBuilder: (BuildContext context, int index) {
          //                 return FadeInImage(
          //                   placeholder:
          //                       const AssetImage('assets/imgs/loader.gif'),
          //                   image: NetworkImage(
          //                     '${informe!.infFotos![index]['url']}',
          //                   ),
          //                 );
          //               },
          //               //   ),
          //               // Wrap(
          //               //   children: informe!.infFotos!
          //               //       .map((e) => Stack(
          //               //         children: [
          //               //           Container(
          //               //                     margin: EdgeInsets.symmetric(
          //               //                         horizontal: size.iScreen(2.0),
          //               //                         vertical: size.iScreen(1.0)),
          //               //                     child: ClipRRect(
          //               //                       borderRadius: BorderRadius.circular(10),
          //               //                       child: Container(
          //               //                         decoration: BoxDecoration(
          //               //                           // color: Colors.red,
          //               //                           border: Border.all(color: Colors.grey),
          //               //                           borderRadius: BorderRadius.circular(10),
          //               //                         ),
          //               //                         // width: size.wScreen(50.0),
          //               //                         // height: size.hScreen(40.0),
          //               //                         padding: EdgeInsets.symmetric(
          //               //                           vertical: size.iScreen(0.0),
          //               //                           horizontal: size.iScreen(0.0),
          //               //                         ),
          //               //                         child:
          //               //                         FadeInImage(
          //               //                           placeholder:
          //               //                               AssetImage('assets/imgs/loader.gif'),
          //               //                           image: NetworkImage(
          //               //                             '${e['url']}',

          //               //                           ),
          //               //                         ),
          //               //                       ),
          //               //                     ),
          //               //                   ),

          //               //      ],
          //               //       )

          //               //           // _ItemFoto(
          //               //           //     size: size,
          //               //           //     informeController: informeController,
          //               //           //     image: e),
          //               //           )
          //               //       .toList(),
          //               // ),
          //             ),
          //             width: size.wScreen(100.0),
          //             height: size.hScreen(informe!.infFotos!.length.toDouble()*20),
          //             // height: size.hScreen(100.0),
          //           ),
          //         )),
          //       ],
          //     );
          //   }).toList()),

          // ),
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

class _ItemFoto extends StatelessWidget {
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
    return GestureDetector(
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
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => PreviewScreenConsignas(image: image)));
      },
    );
  }
}

class _CamaraVideo extends StatelessWidget {
  final dynamic informe;
  const _CamaraVideo({
    Key? key,
    required this.size,
    //required this.informeController,
    required this.informe,
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
          aspectRatio: 16 / 16,
          child: BetterPlayer.network(
            // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

            '${informe!['infVideo']![0]['url']}',
            betterPlayerConfiguration: const BetterPlayerConfiguration(
              aspectRatio: 16 / 16,
            ),
          ),
        )
      ],
    );
  }
}

class _ListaGuardias extends StatelessWidget {
  // final InformeController informeController;
  final dynamic informe;
  const _ListaGuardias({
    Key? key,
    required this.size,
    required this.informe,
    // required this.informeController,
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
          child: Text('Guardias: ',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.5)),
          width: size.wScreen(100.0),
          height:
              size.iScreen(informe!['infGuardias']!.length.toDouble() * 5.0),
          child: ListView.builder(
            itemCount: informe!['infGuardias']!.length,
            itemBuilder: (BuildContext context, int index) {
              final guardia = informe!['infGuardias']![index];
              return guardia['asignado'] != false
                  ? Card(
                      child: Row(
                        children: [
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
                      //  ListTile(
                      //   visualDensity: VisualDensity.compact,
                      //   title:
                      //   // subtitle: Text(
                      //   //   '{cliente.cliCelular} - {cliente.cliTelefono}',
                      //   //   style: GoogleFonts.lexendDeca(
                      //   //       fontSize: size.iScreen(1.7),
                      //   //       // color: Colors.black54,
                      //   //       fontWeight: FontWeight.normal),
                      //   // ),
                      //   onTap: () {
                      //     // provider.setListaClienteMultasClear();
                      //     provider.eliminaGuardiaInforme(guardia['id']);
                      //     // print('${cliente['id']}');

                      //   },
                      //   trailing:const Icon(Icons.delete_forever_outlined,color:
                      //   Colors.red)
                      // ),
                    )
                  : const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
