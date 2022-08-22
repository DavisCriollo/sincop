import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/utils/responsive.dart';

import '../models/crea_foto_multas.dart';

class CrearApelacionPage extends StatefulWidget {
  const CrearApelacionPage({Key? key}) : super(key: key);

  @override
  State<CrearApelacionPage> createState() => _CrearApelacionPageState();
}

class _CrearApelacionPageState extends State<CrearApelacionPage> {
  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final multasController = Provider.of<MultasGuardiasContrtoller>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: const Color(0xFFEEEEEE),
            appBar: AppBar(
              // backgroundColor: primaryColor,
              title: const Text('Crear Apelación'),
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
              actions: [
                // (logisticaController.getNombreCliente!.isNotEmpty &&
                //         logisticaController.getNombreGuardia!.isNotEmpty)
                //     ?
                Container(
                  margin: EdgeInsets.only(right: size.iScreen(1.5)),
                  child: IconButton(
                      splashRadius: 28,
                      onPressed: () {
                        _onSubmit(context, multasController);
                      },
                      icon: Icon(
                        Icons.save_outlined,
                        size: size.iScreen(4.0),
                      )),
                )
                // : const SizedBox(),
              ],
            ),
            body: Container(
                // color: Colors.red,
                margin: EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
                padding: EdgeInsets.only(
                  top: size.iScreen(0.5),
                  left: size.iScreen(0.5),
                  right: size.iScreen(0.5),
                  bottom: size.iScreen(0.5),
                ),
                width: size.wScreen(100.0),
                height: size.hScreen(100),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: multasController.validaMultasApelacionFormKey,
                    child: Column(
                      children: [
                        //***********************************************/
                        SizedBox(
                          height: size.iScreen(2.0),
                        ),
                        //*****************************************/
                        SizedBox(
                          width: size.wScreen(100.0),
      
                          // color: Colors.blue,
                          child: Text('Detalle de apelación:',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                        ),
                        TextFormField(
                           maxLines: 3,
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
                            multasController.onInputDetalleApelacionChange(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese detalle de la apelación';
                            }
                          },
                        ),
                        //***********************************************/
                         //==========================================//
                  multasController.getListaFotosMultas.isNotEmpty
                      ? _CamaraOption(
                          size: size, multasController: multasController)
                      : Container(),
                  //*****************************************/
                      ],
                    ),
                  ),
                )),
            floatingActionButton:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                onPressed: () {
                  bottomSheet(multasController, context, size);
                },
                backgroundColor: Colors.purpleAccent,
                heroTag: "btnCamara",
                child: const Icon(Icons.camera_alt_outlined),
              ),
              SizedBox(
                height: size.iScreen(1.5),
              ),
            ])),
      ),
    );
  }

  void _onSubmit(
      BuildContext context, MultasGuardiasContrtoller controller) async {
    final isValid = controller.validateFormApelacionMulta();
    if (!isValid) return;
    if (isValid) {
      // if (controller.nombreGuardia!.isEmpty) {
      //   NotificatiosnService.showSnackBarDanger('Debe seleccionar guardia');
      // }else if (controller.labelMotivoAusencia==null) {
      //   NotificatiosnService.showSnackBarDanger('Debe seleccionar motivo');
      // } else {
      // ProgressDialog.show(context);
      await controller.creaApelacionMulta(context);
      // await controller.upLoadImagen();
      // ProgressDialog.dissmiss(context);
      Navigator.pop(context);
    }
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
    multasController.setNewPictureFileApelacion('${pickedFile.path}');
    print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
    // _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
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
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => PreviewScreenMultas(image: image)));
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