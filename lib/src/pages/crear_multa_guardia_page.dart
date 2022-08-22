import 'dart:io';



import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';

import 'package:sincop_app/src/models/crea_foto_multas.dart';

import 'package:sincop_app/src/pages/view_photo_multas.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';


class CrearMultaGuardia extends StatefulWidget {
  const CrearMultaGuardia({Key? key}) : super(key: key);

  //  final Result? infoMultaGuardia;
  // const CrearMultaGuardia({Key? key, this.infoMultaGuardia}) : super(key: key);

  @override
  State<CrearMultaGuardia> createState() => _CrearMultaGuardiaState();
}

class _CrearMultaGuardiaState extends State<CrearMultaGuardia> {
  TextEditingController _fechaMultaController = TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    final loadData = MultasGuardiasContrtoller();
    _fechaMultaController.text = loadData.getFechaActul;
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    // _fechaMultaController.text=DateTime.now().toString();
    final tipoMultaController = Provider.of<MultasGuardiasContrtoller>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFF343A40), // primaryColor,
          title: Text(
            'Crear Multa ${tipoMultaController.getPorcentajeTipoMulta}%',
            style: GoogleFonts.lexendDeca(
                fontSize: size.iScreen(2.8),
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: size.iScreen(1.5)),
              child: IconButton(
                  splashRadius: 28,
                  onPressed: () {
                    _onSubmit(context, tipoMultaController);
                  },
                  icon: Icon(
                    Icons.save_outlined,
                    size: size.iScreen(4.0),
                  )),
            ),
          ],
        ),
        body: Container(
          width: size.iScreen(100.0),
          height: size.iScreen(100.0),
          margin: EdgeInsets.only(
              bottom: size.iScreen(0.0), top: size.iScreen(0.0)),
          padding: EdgeInsets.symmetric(
            horizontal: size.iScreen(1.5),
            vertical: size.iScreen(1.5),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: tipoMultaController.multasGuardiaFormKey,
              child: Column(
                children: [
                  // Text('${tipoMultaController.getIdMulta}'),
                  // Text('${tipoMultaController.getOrigenMulta}'),
                  // Text('${tipoMultaController.getTipoMulta}'),
                  // Text('${tipoMultaController.getPorcentajeTipoMulta}'),
                  // Text('${tipoMultaController.getTextoTipoMulta}'),
                  //*****************************************/
                  //*****************************************/
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fecha de Registro:',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: size.wScreen(40),
                        margin:
                            EdgeInsets.symmetric(horizontal: size.wScreen(3.5)),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: _fechaMultaController,
                          decoration: InputDecoration(
                            hintText: 'yyyy-mm-dd',
                            hintStyle: const TextStyle(color: Colors.black38),
                            suffixIcon: IconButton(
                              color: Colors.red,
                              splashRadius: 20,
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _selectFechaRegistro(
                                    context, tipoMultaController);
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
                              return 'Ingrese fecha de registro';
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
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/

                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Novedad:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        )),
                  ),
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  Container(
                    // width: size.wScreen(35),
                    margin: EdgeInsets.symmetric(horizontal: size.wScreen(3.5)),
                    child: Text(
                      "${tipoMultaController.getTextoTipoMulta}",
                      // infoConsignaCliente!.conDesde
                      //     .toString()
                      //     .replaceAll(" 00:00:00.000", ""),
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.8),
                        // color: Colors.black45,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  // SizedBox(
                  //   width: size.wScreen(100.0),
                  //   // color: Colors.blue,
                  //   child: Text('Buscar Personal:',
                  //       style: GoogleFonts.lexendDeca(
                  //         // fontSize: size.iScreen(2.0),
                  //         fontWeight: FontWeight.normal,
                  //         color: Colors.grey,
                  //       )),
                  // ),
                  // TextFormField(
                  //   // controller: textUsuario,
                  //   // initialValue: 'demo',
                  //   // initialValue: (textUsuario.text==true)? textUsuario.text:'',

                  //   decoration: InputDecoration(
                  //     suffixIcon: GestureDetector(
                  //       onTap: () async {
                  //         _searchGuardia(tipoMultaController);
                  //       },
                  //       child: const Icon(
                  //         Icons.search,
                  //         color: Color(0XFF343A40),
                  //       ),
                  //     ),
                  //   ),
                  //   textAlign: TextAlign.start,
                  //   style: const TextStyle(

                  //       // fontSize: size.iScreen(3.5),
                  //       // fontWeight: FontWeight.bold,
                  //       // letterSpacing: 2.0,
                  //       ),
                  //   onChanged: (text) {
                  //     tipoMultaController.onInputBuscaGuardiaChange(text);
                  //   },
                  //   validator: (text) {
                  //     if (text!.trim().isNotEmpty) {
                  //       return null;
                  //     } else {
                  //       return 'Ingrese dato para búsqueda';
                  //     }
                  //   },
                  //   onSaved: (value) {
                  //     // codigo = value;
                  //     // tipoMultaController.onInputFDetalleNovedadChange(value);
                  //   },
                  // ),
                  //*****************************************/
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/

                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Persona:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        )),
                  ),
                  Container(
                    // width: size.wScreen(35),
                    margin: EdgeInsets.symmetric(
                        horizontal: size.wScreen(1.0),
                        vertical: size.iScreen(1.0)),
                    child: SizedBox(
                      width: size.wScreen(100.0),
                      child: Text(
                        "${tipoMultaController.getNomPersonaMulta}",
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Detalle de Novedad:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        )),
                  ),
                  TextFormField(
                    // controller: textUsuario,
                    // initialValue: 'demo',
                    // initialValue: (textUsuario.text==true)? textUsuario.text:'',
                    maxLines: 2,
                    decoration: const InputDecoration(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(

                        // fontSize: size.iScreen(3.5),
                        // fontWeight: FontWeight.bold,
                        // letterSpacing: 2.0,
                        ),
                    onChanged: (text) {
                      tipoMultaController.onInputDetalleNovedadChange(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese detalle de la multa';
                      }
                    },
                    onSaved: (value) {
                      // codigo = value;
                      // tipoMultaController.onInputFDetalleNovedadChange(value);
                    },
                  ),
                  //==========================================//
                  tipoMultaController.getListaFotosMultas.isNotEmpty
                      ? _CamaraOption(
                          size: size, multasController: tipoMultaController)
                      : Container(),
                  //*****************************************/
                  //==========================================//
                  tipoMultaController.getPathVideo!.isNotEmpty
                      ? _CamaraVideo(
                          size: size,
                          multasControler: tipoMultaController,
                        )
                      : Container(),
                  //*****************************************/
                  //==========================================//
                  tipoMultaController.getListaCorreosClienteMultas.isNotEmpty
                      ? _CompartirClienta(
                          size: size, multasController: tipoMultaController)
                      : Container(),
                  //*****************************************/
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
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
                bottomSheet(tipoMultaController, context, size);
              },
              backgroundColor: Colors.purpleAccent,
              heroTag: "btnCamara",
              child: const Icon(Icons.camera_alt_outlined),
            ),
            SizedBox(
              height: size.iScreen(1.5),
            ),
         
            FloatingActionButton(
              backgroundColor: tipoMultaController.getUrlVideo!.isEmpty
                  ? Colors.blue
                  : Colors.grey,
              heroTag: "btnVideo",
              child: tipoMultaController.getUrlVideo!.isEmpty
                  ? const Icon(Icons.videocam_outlined, color: Colors.white)
                  : const Icon(
                      Icons.videocam_outlined,
                      color: Colors.black,
                    ),
              onPressed: tipoMultaController.getUrlVideo!.isEmpty
                  ? () {
                      bottomSheetVideo(tipoMultaController, context, size);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (BuildContext context) {
                      //   return const CameraUtilitarios(
                      //     modulo: 'multas',
                      //   );
                      // }));
                    }
                  : null,
            ),
            SizedBox(
              height: size.iScreen(1.5),
            ),
            // //********************COMPARTIR***************************//
            // FloatingActionButton(
            //   backgroundColor: const Color(0XFF343A40),
            //   heroTag: "btnCompartir",
            //   child: const Icon(Icons.share),
            //   onPressed: () {
            //     // _modalBuscaPersonaMultaCompartir(size, tipoMultaController);
            //     // tipoMultaController.getTodosLosClientesMultas('');
            //     // Navigator.pushNamed(context, 'buscarClientesMultaGuardia');
            //     tipoMultaController.buscaInfoClientes('');
            //     Navigator.pushNamed(context, 'buscarClientesVarios');
            //   },
            // ),
            // SizedBox(
            //   height: size.iScreen(1.5),
            // ),
          ],
        ),
      ),
    );
  }

  //================================================= SELECCIONA FECHA INICIO ==================================================//
  _selectFechaRegistro(
      BuildContext context, MultasGuardiasContrtoller multasController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      String? anio, mes, dia;
      anio = '${picked.year}';
      mes = (picked.month < 10) ? '0${picked.month}' : '${picked.month}';
      dia = (picked.day < 10) ? '0${picked.day}' : '${picked.day}';

      // setState(() {
      final _fechaMulta =
          '${anio.toString()}-${mes.toString()}-${dia.toString()}';
      _fechaMultaController.text = _fechaMulta;
      multasController.onInputFechaMultaChange(_fechaMulta);
      // print('FechaInicio: $_fechaInicio');
      // });
    }
  }

  void bottomSheetVideo(
    MultasGuardiasContrtoller multasController,
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
                    _funcionCamaraVideo(ImageSource.camera, multasController);
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
                    _funcionCamaraVideo(ImageSource.gallery, multasController);
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

  void _funcionCamaraVideo(
      ImageSource source, MultasGuardiasContrtoller multasController) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(
      source: source,
    );

    if (pickedFile == null) {
      return;
    }
    print(
        'TENEMOS VIDEO :==========================+++++++++++++++++++++++++>  ${pickedFile.path}');
    multasController.setPathVideoMultas(pickedFile.path);

//===============================//
// _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
  }

  void bottomSheet(
    MultasGuardiasContrtoller multasController,
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
                    _funcionCamara(ImageSource.camera, multasController);
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
                    _funcionCamara(ImageSource.gallery, multasController);
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

  void _downloadImage(String? image) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(image!);
      if (imageId == null) {
        return;
      }
      //  NotificatiosnService.showSnackBarSuccsses("Descarga realizada");

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void _funcionCamara(
    ImageSource source,
    MultasGuardiasContrtoller multasController,
  ) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile == null) {
      return;
    }
    multasController.setNewPictureFile('${pickedFile.path}');
    print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
    _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalCompartirUser(
      Responsive size, MultasGuardiasContrtoller multasController) {
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
                  Text('COMPARTIR',
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
                          String barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                                  '#34CAF0', 'Cancelar', false, ScanMode.QR);
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
                          _modalBuscaPersonaMultaCompartir(
                              size, multasController);
                          // print('EEEERRRRR');
                          // actividadesController.setOpcionActividad(1);
                          Navigator.pop(context);
                          // Navigator.pushNamed(context, 'validaAccesoTurno');
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

//====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalBuscaPersonaMultaCompartir(
    Responsive size,
    MultasGuardiasContrtoller multasControler,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Buscar Cliente ',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
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

                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Ingrese datos de búsqueda:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        )),
                  ),
                  TextFormField(
                    // controller: textUsuario,
                    // initialValue: 'demo',
                    // initialValue: (textUsuario.text==true)? textUsuario.text:'',

                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          // _searchGuardia(multasControler);
                        },
                        child: const Icon(
                          Icons.search,
                          color: Color(0XFF343A40),
                        ),
                      ),
                    ),
                    textAlign: TextAlign.start,
                    style: const TextStyle(

                        // fontSize: size.iScreen(3.5),
                        // fontWeight: FontWeight.bold,
                        // letterSpacing: 2.0,
                        ),
                    onChanged: (text) {
                      multasControler.onInputBuscaPersonaChange(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese dato para búsqueda';
                      }
                    },
                    onSaved: (value) {
                      // codigo = value;
                      // tipoMultaController.onInputFDetalleNovedadChange(value);
                    },
                  ),
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/

                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Resultado búsqueda:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        )),
                  ),
                  Container(
                    // width: size.wScreen(35),
                    margin: EdgeInsets.symmetric(
                        horizontal: size.wScreen(1.0),
                        vertical: size.iScreen(1.0)),
                    child: SizedBox(
                      width: size.wScreen(100.0),
                      child: Text(
                        // (multasControler.getErrorInfoCompartirGuardia == true)
                        //     ? "${tipoMultaController.getInfoGuardia[0].perDocNumero}"
                        //     : 'No Hay Información',
                        'No Hay Información',
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  //*****************************************/

                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: size.iScreen(1.0), bottom: size.iScreen(2.0)),
                    height: size.iScreen(3.5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF0A4280),
                        ),
                      ),
                      onPressed: () async {
                        ProgressDialog.show(context);
                        // await multasControler.actualizaEstadoMulta(
                        //     context, multa);

                        ProgressDialog.dissmiss(context);
                        Navigator.pop(context);
                      },
                      child: Text('Asignar',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //********************************************************************************************************************//
  void _onSubmit(
    BuildContext context,
    MultasGuardiasContrtoller controller,
  ) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
      if (controller.getCedPersonaMulta == null) {
        NotificatiosnService.showSnackBarDanger(
            'Debe asignar a una persona la multa');
      } else {
        final conexion = await Connectivity().checkConnectivity();
        if (conexion == ConnectivityResult.none) {
          NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
        } else if (conexion == ConnectivityResult.wifi ||
            conexion == ConnectivityResult.mobile) {
          ProgressDialog.show(context);
          await controller.creaMultaGuardia(context);
          // await controller.upLoadImagen();
          ProgressDialog.dissmiss(context);
          Navigator.pop(context);
          Navigator.pop(context);
          // Navigator.pop(context);
        }
      }
    }
  }
}

class _CamaraVideo extends StatelessWidget {
  const _CamaraVideo({
    Key? key,
    required this.size,
    required this.multasControler,
  }) : super(key: key);

  final Responsive size;
  final MultasGuardiasContrtoller multasControler;

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
              multasControler.eliminaVideo();
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
                arguments: '${multasControler.getUrlVideo}');
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
        //       InkWell(
        //         onTap: () {
        //           multasControler.eliminaVideo();
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

        //       InkWell(
        //         onTap: () {
        //           Navigator.pushNamed(context, 'videoSreen',
        //               arguments: '${multasControler.getUrlVideo}');
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

class _CamaraOption extends StatelessWidget {
  final MultasGuardiasContrtoller multasController;
  const _CamaraOption({
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
            child: Text('Fotografía:',
                style: GoogleFonts.lexendDeca(
                    // fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)),
          ),
          SingleChildScrollView(
            child: Wrap(
                children: multasController.getListaFotosMultas
                    .map((e) => _ItemFoto(
                        size: size,
                        multasController: multasController,
                        image: e))
                    .toList()),
          ),
        ],
      ),
      onTap: () {
        print('activa FOTOGRAFIA');
      },
    );
  }
}

class _ItemFoto extends StatelessWidget {
  final CreaNuevaFotoMultas? image;
  final MultasGuardiasContrtoller multasController;

  const _ItemFoto({
    Key? key,
    required this.size,
    required this.multasController,
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
                  width: size.wScreen(90.0),
                  // height: size.hScreen(100.0),
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
                builder: (context) => PreviewScreenMultas(image: image)));
          },
        ),
        Positioned(
          top: -3.0,
          right: 4.0,
          // bottom: -3.0,
          child: IconButton(
            color: Colors.red.shade700,
            onPressed: () {
              multasController.eliminaFoto(image!.id);
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
