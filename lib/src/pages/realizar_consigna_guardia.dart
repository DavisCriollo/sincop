import 'dart:io';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/controllers/consignas_clientes_controller.dart';
import 'package:sincop_app/src/models/crea_foto_realiza_consigna_guardia.dart';
import 'package:sincop_app/src/models/lista_allConsignas_clientes.dart';
import 'package:sincop_app/src/pages/view_photo_realiza_consigna_guardia.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';

class RealizarConsignaPage extends StatefulWidget {
  final Result? infoConsignaGuardia;
// final Result? infoConsignaCliente;

  const RealizarConsignaPage({Key? key, this.infoConsignaGuardia})
      : super(key: key);

  @override
  State<RealizarConsignaPage> createState() => _RealizarConsignaPageState();
}

class _RealizarConsignaPageState extends State<RealizarConsignaPage> {
  @override
  Widget build(BuildContext context) {
    final consignasController =
        Provider.of<ConsignasClientesController>(context);
    final Responsive size = Responsive.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: primaryColor,
            title: const Text('Realizar Consigna'),
            actions: [Container(
              margin: EdgeInsets.only(right: size.iScreen(1.5)),
              child: IconButton(
                  splashRadius: 28,
                  onPressed: () {
                    _onSubmit(context, consignasController,widget.infoConsignaGuardia);
                  },
                  icon: Icon(
                    Icons.save_outlined,
                    size: size.iScreen(4.0),
                  )),
            ),],
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
            padding: EdgeInsets.symmetric(horizontal: size.iScreen(2.0)),
            width: size.wScreen(100.0),
            height: size.hScreen(100),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: consignasController.consignasClienteFormKey,
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
                              widget.infoConsignaGuardia!.conFecReg
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
                      margin: EdgeInsets.symmetric(vertical: size.iScreen(0.5)),
                      width: size.wScreen(100.0),
                      child: Text(
                        // 'item Novedad: ${controllerActividades.getItemMulta}',
                        '"${widget.infoConsignaGuardia!.conAsunto}"',
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
                      margin: EdgeInsets.symmetric(vertical: size.iScreen(1.0)),
                      width: size.wScreen(100.0),
                      child: Text(
                        '${widget.infoConsignaGuardia!.conDetalle}',
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

                    //*****************************************/
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
                        consignasController.onInputObservacionesRealizaConsignaChange(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese Observaciones';
                        }
                      },
                      onSaved: (value) {
                        // codigo = value;
                        // tipoMultaController.onInputFDetalleNovedadChange(value);
                      },
                    ),

                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
                    ),
                    //==========================================//
                    consignasController
                            .getListaFotosListaFotosRealizaConsigna.isNotEmpty
                        ? _CamaraOption(
                            size: size,
                            consignasController: consignasController)
                        : Container(),
                    //*****************************************/
                    //========================================//
                  
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              bottomSheet(consignasController, context, size);
            },
            backgroundColor: Colors.purpleAccent,
            heroTag: "btnCamara",
            child: const Icon(Icons.camera_alt_outlined),
          ),
        ),
      ),
    );
  }

  void bottomSheet(
    ConsignasClientesController consignasController,
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
                    _funcionCamara(ImageSource.camera, consignasController);
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
                    _funcionCamara(ImageSource.gallery, consignasController);
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

  void _funcionCamara(ImageSource source,
      ConsignasClientesController consignasController) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile == null) {
      return;
    }
    consignasController.setNewPictureFileRealizaConsigna('${pickedFile.path}');
    print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
    _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
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

  //********************************************************************************************************************//
  void _onSubmit(
    BuildContext context,
    ConsignasClientesController consignasController,
    Result? infoConsignaGuardia
  ) async {
    final isValid = consignasController.validateForm();
    if (!isValid) return;
    if (isValid) {
      // if (consignasController.getCedPersona==null) {
      //   NotificatiosnService.showSnackBarDanger(
      //       'Debe asignar a una persona la multa');
      // }
      // else {
      final conexion = await Connectivity().checkConnectivity();
      if (conexion == ConnectivityResult.none) {
        NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
      } else if (conexion == ConnectivityResult.wifi ||
          conexion == ConnectivityResult.mobile) {
        // ProgressDialog.show(context);
        await consignasController.relizaGuardiaConsigna(infoConsignaGuardia!.conId ,context);
        // await controller.upLoadImagen();
        // ProgressDialog.dissmiss(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // }
      }
    }
  }
}

class _CamaraOption extends StatelessWidget {
  final ConsignasClientesController consignasController;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.consignasController,
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
                  children: consignasController
                      .getListaFotosListaFotosRealizaConsigna
                      .map((e) => _ItemFoto(
                          size: size,
                          consignasController: consignasController,
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
  final CreaNuevaFotoRealizaConsignaGuardia? image;
  final ConsignasClientesController consignasController;

  const _ItemFoto({
    Key? key,
    required this.size,
    required this.consignasController,
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
                    PreviewScreenRealizaConsignaGuardia(image: image)));
          },
        ),
        Positioned(
          top: -3.0,
          right: 4.0,
          // bottom: -3.0,
          child: IconButton(
            color: Colors.red.shade700,
            onPressed: () {
              consignasController.eliminaFotoRealizaConsigna(image!.id);
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
