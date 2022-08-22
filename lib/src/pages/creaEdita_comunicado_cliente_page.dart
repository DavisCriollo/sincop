import 'dart:io';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/controllers/comunicados_clientes_controller.dart';
import 'package:sincop_app/src/controllers/novedades_controller.dart';
import 'package:sincop_app/src/models/crear_foto_comunicado_guardia.dart';
import 'package:sincop_app/src/models/lista_allComunicados_clientes.dart';
import 'package:sincop_app/src/pages/view_image_page.dart';
import 'package:sincop_app/src/pages/view_photo_comunicados_page.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';

class CreaEditaComunicadoClientePage extends StatefulWidget {

  // TextEditingController _textAsunto= TextEditingController();
  // TextEditingController _textDetalle= TextEditingController();

  final Result? infoComunicadoCliente;
  final String? accion;
   const CreaEditaComunicadoClientePage({Key? key,this.accion,this.infoComunicadoCliente})
      : super(key: key);

  @override
  State<CreaEditaComunicadoClientePage> createState() => _CreaEditaComunicadoClientePageState();
}

class _CreaEditaComunicadoClientePageState extends State<CreaEditaComunicadoClientePage> {
 TextEditingController _fechaInicioController = TextEditingController();
  TextEditingController _fechaFinController = TextEditingController();
    TextEditingController _horaInicioController =  TextEditingController();
    TextEditingController _horaFinController =  TextEditingController();


late TimeOfDay timeInicio;
  late TimeOfDay timeFin;

@override
  void initState() {
     timeInicio = TimeOfDay.now();
 timeFin= TimeOfDay.now();
    super.initState();
  }
 @override
  void dispose() {
    _fechaInicioController.clear();
    _fechaFinController.clear();
    _horaInicioController.clear();
    _horaFinController.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final comunicadoController =
        Provider.of<ComunicadosController>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: primaryColor,
            title: const Text('Nuevo Comunicado'),
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
              child: Form(
                key: comunicadoController.comunicadosClienteFormKey,
                child: Column(
                  children: [
                    
                    //==========================================//
                    comunicadoController.getListaFotos.isNotEmpty
                      ? _CamaraOption(
                          size: size,
                          comunicadoController: comunicadoController)
                      : Container(),
                      //*****************************************/
                    
                    SizedBox(
                      height: size.iScreen(2.0),
                    ),

                    SizedBox(
                      width: size.wScreen(100.0),
                      // color: Colors.blue,
                      child: Text('Asunto:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    //==========================================//
                    TextFormField(
                      // controller: _textAsunto,
                      initialValue: widget.infoComunicadoCliente?.comAsunto,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.beenhere_outlined)),
                      textAlign: TextAlign.start,
                      style: const TextStyle(

                          // fontSize: size.iScreen(3.5),
                          // fontWeight: FontWeight.bold,
                          // letterSpacing: 2.0,
                          ),
                      onChanged: (text) {
                        comunicadoController.onChangeAsunto(text);
                      },
                      onSaved: (text) {
                        comunicadoController.onChangeAsunto(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese asunto del comunicado';
                        }
                      },
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
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
                    TextFormField(
                      // controller: _textDetalle,
                      initialValue: widget.infoComunicadoCliente?.comDetalle,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.article_outlined)),
                      textAlign: TextAlign.start,
                      style: const TextStyle(

                          // fontSize: size.iScreen(3.5),
                          // fontWeight: FontWeight.bold,
                          // letterSpacing: 2.0,
                          ),
                      onChanged: (text) {
                        comunicadoController.onChangeDetalle(text);
                      },
                      onSaved: (text) {
                        comunicadoController.onChangeDetalle(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese detalle del comunicado';
                        }
                      },
                    ),
                    //*****************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
                    ),
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
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
                              width: size.wScreen(35),
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.wScreen(3.5)),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                readOnly: true,
                                controller: _fechaInicioController,
                                decoration: InputDecoration(
                                  hintText: 'yyyy-mm-dd',
                                  hintStyle:
                                      const TextStyle(color: Colors.black38),
                                  suffixIcon: IconButton(
                                    color: Colors.red,
                                    splashRadius: 20,
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _selectFechaInicio(
                                          context, comunicadoController);
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
                                    return 'Ingrese fecha de inicio';
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hora:',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                color: Colors.black45,
                                // fontWeight: FontWeight.bold,
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
                                  hintStyle:
                                      const TextStyle(color: Colors.black38),
                                  suffixIcon: IconButton(
                                    color: Colors.red,
                                    splashRadius: 20,
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                          _seleccionaHoraInicio(context,comunicadoController);
                                      // _selectFechaFin(
                                      //     context, comunicadoController);
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
                                    return 'Ingrese fecha Límite';
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
                      ],
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
                    ),
                   
                    //*******************FECHA HORA HASTA **********************/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
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
                              width: size.wScreen(35),
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.wScreen(3.5)),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                readOnly: true,
                                controller: _fechaFinController,                                decoration: InputDecoration(
                                  hintText: 'yyyy-mm-dd',
                                  hintStyle:
                                      const TextStyle(color: Colors.black38),
                                  suffixIcon: IconButton(
                                    color: Colors.red,
                                    splashRadius: 20,
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _selectFechaFin(
                                          context, comunicadoController);
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
                                    return 'Ingrese fecha de inicio';
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
                        Column(
                          children: [
                            Text(
                              'Hora:',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
// InputTimePiker(label: 'Hora', size: size,),



                            Container(
                              width: size.wScreen(35),
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.wScreen(3.5)),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                readOnly: true,
                                controller: _horaFinController,
                                decoration: InputDecoration(
                                  hintText: '00:00',
                                  hintStyle:
                                      const TextStyle(color: Colors.black38),
                                  suffixIcon: IconButton(
                                    color: Colors.red,
                                    splashRadius: 20,
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                          _seleccionaHoraFin(context,comunicadoController);
                                      // _selectFechaFin(
                                      //     context, consignaController);
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
                                    return 'Ingrese fecha Límite';
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
                      ],
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
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
                          vertical: size.iScreen(0.5)),
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: size.iScreen(2.5),
                          width: size.iScreen(5.0),
                          child: Text('Crear',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              )),
                        ),
                        onTap: () {
                          // Navigator.pushNamed(context, 'clientes');

                          _onSubmit(context, comunicadoController,widget.infoComunicadoCliente);
                        },
                      ),
                    ),
                    //===========================================//
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton:  FloatingActionButton(onPressed: () {  
            bottomSheet(comunicadoController, context, size);
           
          },
           backgroundColor: Colors.purpleAccent,
              heroTag: "btnCamara",
             child:const Icon(Icons.camera_alt_outlined),
          ),


//  FloatingActionButton(
//               backgroundColor: Colors.purpleAccent,
//               heroTag: "btnCamara",
//               child: Icon(controllerActividades.getListaFotos.length <= 2
//                   ? Icons.camera_alt_outlined
//                   : Icons.no_photography_outlined),
//               onPressed: (controllerActividades.getListaFotos.length <= 2)
//                   ? () async {
//                       bottomSheet(controllerActividades, context, size);
//                     }
//                   : null,
//             ),







        ),
        
      ),
    );
  }


//================================================= SELECCIONA FECHA INICIO ==================================================//
  _selectFechaInicio(BuildContext context,
     ComunicadosController comunicadoController) async {
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
      comunicadoController.onInputFechaInicioComunicadoChange(_fechaInicio);
      // print('FechaInicio: $_fechaInicio');
      // });
    }
  }

  //================================================= SELECCIONA FECHA FIN ==================================================//
  _selectFechaFin(BuildContext context,
      ComunicadosController comunicadoController) async {
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

      setState(() {
        final _fechaFin =
            '${anio.toString()}-${mes.toString()}-${dia.toString()}';
        _fechaFinController.text = _fechaFin;
        comunicadoController.onInputFechaFinComunicadoChange(_fechaFin);
        // print('FechaFin: $_fechaFin');
      });
    }
  }


    void _seleccionaHoraInicio(context,ComunicadosController comunicadoController) async {
    TimeOfDay? _hora = await showTimePicker(context: context, initialTime: timeInicio);

    if (_hora != null) {
      setState(() {
        timeInicio = _hora;
         String horaInicio='${timeInicio.hour}:${timeInicio.minute}';
         _horaInicioController.text = horaInicio;
         comunicadoController.onInputHoraInicioComunicadoChange(horaInicio);
        //  print('si: $horaInicio');
       
        
      });
    }
  }
  void _seleccionaHoraFin(context,ComunicadosController comunicadoController) async {
    TimeOfDay? _hora = await showTimePicker(context: context, initialTime: timeFin);
    if (_hora != null) {
      setState(() {
        timeFin = _hora;
        print(timeFin.format(context));
         String horaFin='${timeFin.hour}:${timeFin.minute}';
         _horaFinController.text = horaFin;
         comunicadoController.onInputHoraFinComunicadoChange(horaFin);
        //  print('si: $horaFin');
        
      });
    }
  }
 

  //*******************************************************//
  void _onSubmit(
      BuildContext context, ComunicadosController controller,Result? comunicado) async {
    final isValid = controller.validateForm();
     controller.comunicadosClienteFormKey.currentState?.save();
    if (!isValid) return;
    if (isValid) {
      final conexion = await Connectivity().checkConnectivity();
      if (conexion == ConnectivityResult.none) {
        NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
      } else if (conexion == ConnectivityResult.wifi ||
          conexion == ConnectivityResult.mobile) {
        ProgressDialog.show(context);
        if(widget.accion=='Nuevo'){
        await controller.creaComunicadoCliente(context);

        }else if(widget.accion=='Editar'){
        await controller.editaComunicadoCliente(context,widget.infoComunicadoCliente);

        }
         ProgressDialog.dissmiss(context);
        Navigator.pop(context);
        // if (response != null) {

        // }
      }
    }
  }

  void bottomSheet(
    ComunicadosController controllerComunicados,
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
                    _funcionCamara(ImageSource.camera, controllerComunicados);
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
                    _funcionCamara(ImageSource.gallery, controllerComunicados);
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

  void _funcionCamara(
     ImageSource source, ComunicadosController comunicadoController) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile == null) {
      return;
    }
    comunicadoController.setNewPictureFile('${pickedFile.path}');
    print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
_downloadImage(pickedFile.path);
//===============================//
 Navigator.pop(context);




    // Navigator.pop(context);






  }
}


class _CamaraOption extends StatelessWidget {
  final ComunicadosController comunicadoController;
   const _CamaraOption({
    Key? key,
    required this.size,
    required this.comunicadoController,
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
                  children: comunicadoController.getListaFotos
                      .map((e) => _ItemFoto(
                          size: size,
                          comunicadoController: comunicadoController,
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
  final CreaNuevaFotoComunicadoGuardia? image;
  final ComunicadosController comunicadoController;

  const _ItemFoto({
    Key? key,
    required this.size,
    required this.comunicadoController,
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
                builder: (context) => PreviewScreenComunicados(image: image)));
          },
        ),
        Positioned(
          top: -3.0,
          right: 4.0,
          // bottom: -3.0,
          child: IconButton(
            color: Colors.red.shade700,
            onPressed: () {
              comunicadoController.eliminaFoto(image!.id);
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