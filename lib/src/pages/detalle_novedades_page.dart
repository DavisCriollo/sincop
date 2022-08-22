import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/controllers/novedades_controller.dart';
import 'package:sincop_app/src/models/crea_fotos_detalle_novedad.dart';
import 'package:sincop_app/src/pages/view_image_page.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class DetalleNovedades extends StatefulWidget {
  const DetalleNovedades({Key? key}) : super(key: key);
  @override
  State<DetalleNovedades> createState() => _DetalleNovedadesState();
}

class _DetalleNovedadesState extends State<DetalleNovedades> {
  final TextEditingController textObsercaciones = TextEditingController();
  //  _speech=ActividadesController(stt.SpeechToText());

  // stt.SpeechToText? _speech;

  // bool _isListening = false;
  // String? _textSpeech = 'Presione el boton para Hablar';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final controllerActividades = Provider.of<ActividadesController>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        appBar: AppBar(
          backgroundColor: const Color(0XFF343A40), // primaryColor,
          title: Text(
            'Detalle de Novedad',
            style: GoogleFonts.lexendDeca(
                fontSize: size.iScreen(2.8),
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          //  actions: [
          //   //  IconButton(onPressed: (){}, icon: icon)
          //  ],
        ),
        body: Container(
            // color: Colors.red,
            width: size.wScreen(100.0),
            height: size.hScreen(100.0),
            padding: EdgeInsets.only(
              top: size.iScreen(0.0),
              left: size.iScreen(2.5),
              right: size.iScreen(2.5),
            ),
            child: SingleChildScrollView(
              reverse: false,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      // 'item Novedad: ${controllerActividades.getItemMulta}',
                      '"${controllerActividades.getTextoMulta}"',
                      textAlign: TextAlign.center,
                      //
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  controllerActividades.getListaFotos.isNotEmpty
                      ? _CamaraOption(
                          size: size,
                          controllerActividades: controllerActividades)
                      : Container(),
                  controllerActividades.getIsVideo
                      ? _VideoOption(size: size)
                      : Container(),
                  _Observaciones(
                      size: size,
                      textObsercaciones: textObsercaciones,
                      controllerActividades: controllerActividades),
                  //========================================//
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      // 'item Novedad: ${controllerActividades.getItemMulta}',
                      "${controllerActividades.getCoords}",
                      textAlign: TextAlign.center,
                      //
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  //========================================//
                  Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.symmetric(
                        horizontal: size.iScreen(5.0),
                        vertical: size.iScreen(3.0)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.iScreen(3.0),
                        vertical: size.iScreen(0.8)),
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: size.iScreen(3.0),
                        width: size.iScreen(10.0),
                        child: Text('Guardar',
                            style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            )),
                      ),
                      onTap: () async {
                        _guardarNovedad(controllerActividades);
                      },
                    ),
                  ),
                ],
              ),
            )),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //********************VOZ***************************//
            // FloatingActionButton(
            //    heroTag: "btnVoz",
            //   child: AvatarGlow(
            //       animate: controllerActividades.getIsListenig,
            //       glowColor: Colors.red, //Theme.of(context).primaryColor,
            //       endRadius: 30,
            //       duration: const Duration(milliseconds: 1000),
            //       repeatPauseDuration: const Duration(milliseconds: 100),
            //       repeat: true,
            //       child: Icon(controllerActividades.getIsListenig
            //           ? Icons.mic
            //           : Icons.mic_none_outlined)),
            //   onPressed: () {
            //     _onListen(controllerActividades);
            //   },
            // ),

            //********************CAMARA***************************//
            SizedBox(
              height: size.iScreen(1.5),
            ),
            FloatingActionButton(
              backgroundColor: Colors.purpleAccent,
              heroTag: "btnCamara",
              child: Icon(controllerActividades.getListaFotos.length <= 2
                  ? Icons.camera_alt_outlined
                  : Icons.no_photography_outlined),
              onPressed: (controllerActividades.getListaFotos.length <= 2)
                  ? () async {
                      bottomSheet(controllerActividades, context, size);
                    }
                  : null,
            ),
            //********************VIDEO***************************//
            SizedBox(
              height: size.iScreen(1.5),
            ),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              heroTag: "btnVideo",
              child: Icon(controllerActividades.getIsVideo
                  ? Icons.videocam_off_outlined
                  : Icons.videocam_outlined),
              onPressed: () {
                controllerActividades
                    .setIsVideo(!controllerActividades.getIsVideo);
              },
            ),
            SizedBox(
              height: size.iScreen(1.5),
            ),
            //********************COMPARTIR***************************//
            FloatingActionButton(
              backgroundColor: Colors.green,
              heroTag: "btnCompartir",
              child: const Icon(Icons.share),
              onPressed: () {
                _modalCompartirUser(size, controllerActividades);
              },
            ),
            SizedBox(
              height: size.iScreen(1.5),
            ),
            //********************COMPARTIR***************************//
            FloatingActionButton(
              backgroundColor: Colors.red,
              heroTag: "btnDescargar",
              child: const Icon(Icons.download),
              onPressed: () {
              // _downloadImage();
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void _onListen(ActividadesController controllerActividades) async {
    if (!controllerActividades.getIsListenig) {
      bool available = await controllerActividades.getSpeech!.initialize(
        onStatus: (val) {
          if (val == 'done') {
            controllerActividades.setIsListenig(false);
            controllerActividades.getSpeech!.stop();
          }
          print('OnStatus: $val');
        },
        onError: (val) => print('OnError: $val'),
      );

      if (available) {
        controllerActividades.setIsListenig(true);
// setState(() {
//   _isListening=true;
// });
        controllerActividades.getSpeech!.listen(
            onDevice: true,
            onResult: (val) {
              // print('object: $val');
              // controllerActividades.setTextSpeech(val.recognizedWords);
              controllerActividades.setTextSpeech(val.recognizedWords);
              if (val.hasConfidenceRating && val.confidence > 0) {
                controllerActividades.setConfidence(val.confidence);
              }

              textObsercaciones.text =
                  '${controllerActividades.getTextSpeech!} ';
// _textSpeech=val.recognizedWords;
            }
            // else,
            );
      }
    } else {
      controllerActividades.setIsListenig(false);
      controllerActividades.getSpeech!.stop();
      // setState(() {
      //   _isListening=false;
      //   _speech!.stop();
      // });
    }
  }

//  void accesoGPS(PermissionStatus status) {
//     // print(status);
//     switch (status) {
//       // case PermissionStatus.granted:
//       //   Navigator.pushReplacementNamed(context, 'home');
//       //   break;

//       case PermissionStatus.denied:
//       case PermissionStatus.restricted:
//       case PermissionStatus.permanentlyDenied:
//       case PermissionStatus.limited:
//         openAppSettings();
//     }
//   }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalCompartirUser(
      Responsive size, ActividadesController actividadesController) {
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

  void _guardarNovedad(
    ActividadesController controllerActividades,
  ) async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      ProgressDialog.show(context);
      await controllerActividades.getCurrentPosition();
      ProgressDialog.dissmiss(context);
      await controllerActividades.getCurrentPosition();
    }
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.restricted ||
        status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.limited) {
      openAppSettings();
    }
  }

  void bottomSheet(
    ActividadesController controllerActividades,
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
                    _funcionCamara(ImageSource.camera, controllerActividades);
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
                    _funcionCamara(ImageSource.gallery, controllerActividades);
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
      ImageSource source, ActividadesController controllerActividades) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile == null) {
      return;
    }
    controllerActividades.setNewPictureFile('${pickedFile.path}');
    print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
_downloadImage(pickedFile.path);
//===============================//





    Navigator.pop(context);






  }

  void _downloadImage(String? image) async{
    try {
  // Saved with this method.
  var imageId = await ImageDownloader.downloadImage(image!);
  if (imageId == null) {
    return;
  }
   NotificatiosnService.showSnackBarSuccsses("Descarga realizada");

  // Below is a method of obtaining saved image information.
  var fileName = await ImageDownloader.findName(imageId);
  var path = await ImageDownloader.findPath(imageId);
  var size = await ImageDownloader.findByteSize(imageId);
  var mimeType = await ImageDownloader.findMimeType(imageId);
} on PlatformException catch (error) {
  print(error);
}
  }




}

class _Observaciones extends StatelessWidget {
  final ActividadesController controllerActividades;
  const _Observaciones({
    Key? key,
    required this.size,
    required this.textObsercaciones,
    required this.controllerActividades,
  }) : super(key: key);

  final Responsive size;
  final TextEditingController textObsercaciones;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: size.iScreen(1.0),
            horizontal: size.iScreen(0.0),
          ),
          width: size.wScreen(100.0),
          // color: Colors.blue,
          child: Text('Observaciones:',
              style: GoogleFonts.lexendDeca(
                  // fontSize: size.iScreen(2.0),
                  fontWeight: FontWeight.normal,
                  color: Colors.grey)),
        ),
        TextFormField(
          controller: textObsercaciones,
          maxLines: 5,
          autocorrect: true,
          textAlign: TextAlign.start,
          style: const TextStyle(),
          onChanged: (text) {
            // controller.onChangeUser(text);
          },
          validator: (text) {
            if (text!.trim().isNotEmpty) {
              return null;
            } else {
              return 'Usuario Inválido';
            }
          },
          onSaved: (value) {},
        ),
      ],
    );
  }
}

class _VideoOption extends StatelessWidget {
  const _VideoOption({
    Key? key,
    required this.size,
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
              horizontal: size.iScreen(1.0),
            ),
            child: Text('Video:',
                style: GoogleFonts.lexendDeca(
                    // fontSize: size.iScreen(2.0),
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.red,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.wScreen(100.0),
              height: size.hScreen(25.0),
              padding: EdgeInsets.symmetric(
                vertical: size.iScreen(0.0),
                horizontal: size.iScreen(0.0),
              ),
              child:
                  Image.asset('assets/imgs/no-video.jpeg', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
      onTap: () {
        print('activa VIDEO');
      },
    );
  }
}

class _CamaraOption extends StatelessWidget {
  final ActividadesController controllerActividades;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.controllerActividades,
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
                  children: controllerActividades.getListaFotos
                      .map((e) => _ItemFoto(
                          size: size,
                          controllerActividades: controllerActividades,
                          image: e))
                      .toList())),
        ],
      ),
      onTap: () {
        print('activa FOTOGRAFIA');
      },
    );
  }
}

class _ItemFoto extends StatelessWidget {
  final CreaNuevaFotoNovedad? image;
  final ActividadesController controllerActividades;

  const _ItemFoto({
    Key? key,
    required this.size,
    required this.controllerActividades,
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
                builder: (context) => PreviewScreen(image: image)));
          },
        ),
        Positioned(
          top: -3.0,
          right: 4.0,
          // bottom: -3.0,
          child: IconButton(
            color: Colors.red.shade700,
            onPressed: () {
              controllerActividades.eliminaFoto(image!.id);
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
      fit: BoxFit.cover,
      placeholder: AssetImage('assets/imgs/loader.gif'),
      image: NetworkImage('url'),
    );
  }

  return Image.file(
    File(picture),
    fit: BoxFit.cover,
  );
}
