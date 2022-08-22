import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/controllers/ausencias_controller.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/dropdown_motivo_ausencia.dart';
import 'package:provider/provider.dart';

class CreaAusencia extends StatefulWidget {
  const CreaAusencia({Key? key}) : super(key: key);

  @override
  State<CreaAusencia> createState() => _CreaAusenciaState();
}

class _CreaAusenciaState extends State<CreaAusencia> {
    TextEditingController _fechaInicioController = TextEditingController();
  TextEditingController _fechaFinController = TextEditingController();
  TextEditingController _horaInicioController = TextEditingController();
  TextEditingController _horaFinController = TextEditingController();

  late TimeOfDay timerInicio;
  late TimeOfDay timerFin;

@override
  void initState() {
   initload();
    super.initState();
  }
 void initload() async {
    timerInicio = TimeOfDay.now();
    timerFin = TimeOfDay.now();
  }

  @override
  void dispose() {
    _fechaInicioController.clear();
    _fechaFinController.clear();
    _horaFinController.clear();
    _horaFinController.clear();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final ausenciaController=Provider.of<AusenciasController>(context);
    return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Crear Ausencia',
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
            // (logisticaController.getNombreCliente!.isNotEmpty &&
            //         logisticaController.getNombreGuardia!.isNotEmpty)
            //     ?
            Container(
              margin: EdgeInsets.only(right: size.iScreen(1.5)),
              child: IconButton(
                  splashRadius: 28,
                  onPressed: () {
                    _onSubmit(context, ausenciaController);
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
              key:ausenciaController.ausenciasFormKey ,
              child: Column(
                children: [
                //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/

                    SizedBox(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Guardia :',
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
                            child:
                            Consumer<AusenciasController>(
                              builder: (_, persona, __)
                               {
                                return (persona.nombreGuardia == '' ||
                                        persona.nombreGuardia == null)
                                    ? 
                                  Text(
                                        'No hay guardia designado',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.8),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )
                                    :
                                     Text(
                                        '${persona.nombreGuardia} ',
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
                            onTap: () {
                              _modalSeleccionaGuardia(
                                  size, ausenciaController);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: primaryColor,
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
                (ausenciaController.puestosServicioGuardia != null)
                    ? Consumer<AusenciasController>(
                        builder: (_, valuePuestos, __) {
                          return Column(
                            children: [
                              SizedBox(
                                width: size.wScreen(100.0),

                                // color: Colors.blue,
                                child: Text('Puesto de Servicio :',
                                    style: GoogleFonts.lexendDeca(
                                        // fontSize: size.iScreen(2.0),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              (valuePuestos.puestosServicioGuardia!.isNotEmpty)
                                  ? Container(
                                      height: size.iScreen(valuePuestos
                                              .puestosServicioGuardia!.length *
                                          6.7),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: valuePuestos
                                            .puestosServicioGuardia!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final servicio = valuePuestos
                                              .puestosServicioGuardia![index];
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: size.iScreen(0.1)),
                                            color: Colors.grey.shade300,
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.iScreen(0.5)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Puesto: ',
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                // fontSize: size.iScreen(2.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .grey)),
                                                    Expanded(
                                                      child: Text(
                                                          '${servicio['puesto']}',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                            // fontSize: size.iScreen(2.0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            // color: Colors.grey,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Cliente: ',
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                // fontSize: size.iScreen(2.0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .grey)),
                                                    Expanded(
                                                      child: Text(
                                                          '${servicio['razonsocial']}',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                            // fontSize: size.iScreen(2.0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            // color: Colors.grey,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          );
                        },
                      )
                    : Container(
                        width: size.wScreen(100.0),
                        child: Text('No tiene puesto designado:',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
      //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Motivo:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    const DropMenuMotivoAusencia(data: [
                      'ENFERMEDAD IESS',
                      'PERMISO PERSONAL',
                      'PATERNIDAD',
                      'DEFUNCIÓN FAMILIAR',
                      'INJUSTIFICADA',
                    ],hinText: 'seleccione Motivo',) ,  
                        //***********************************************/
                        //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
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
                                          context, ausenciaController);
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
                                      _seleccionaHoraInicio(
                                          context, ausenciaController);
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
                                    return 'Ingrese hora de inicio';
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
                                controller: _fechaFinController,
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
                                      _selectFechaFin(
                                          context, ausenciaController);
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
                                    return 'Ingrese fecha de límite';
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
                                      _seleccionaHoraFin(
                                          context, ausenciaController);
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
                                    return 'Ingrese hora Límite';
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
                        ausenciaController.onDetalleChange(text);
                      },
                      validator: (text) {
                        if (text!.trim().isNotEmpty) {
                          return null;
                        } else {
                          return 'Ingrese detalle del aviso';
                        }
                      },
                    ),
                      //***********************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Row(
                        children: [
                          Text('Subir documento:',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                                  SizedBox(width:size.iScreen(2.0)),
                                   ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: () {
                            
                              // _cargaArchivo();
                              


                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: primaryColor,
                              width: size.iScreen(3.5),
                              padding: EdgeInsets.only(
                                top: size.iScreen(0.5),
                                bottom: size.iScreen(0.5),
                                left: size.iScreen(0.5),
                                right: size.iScreen(0.5),
                              ),
                              child: Icon(
                                Icons.upload_file_outlined,
                                color: Colors.white,
                                size: size.iScreen(2.5),
                              ),
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                      //***********************************************/
                    SizedBox(
                      height: size.iScreen(2.0),
                    ),
                    //*****************************************/
                    Text('Aqui ira el Documento',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                               //==========================================//
                    ausenciaController.getListaFotosInforme.isNotEmpty
                        ? _CamaraOption(
                            size: size, ausenciasController: ausenciaController)
                        : Container(),
                    //*****************************************/
                    //***********************************************/
                    SizedBox(
                      width: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    
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
                  bottomSheet(ausenciaController, context, size);
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
              // FloatingActionButton(
              //   backgroundColor: ausenciaController.getPathVideo!.isEmpty
              //       ? Colors.blue
              //       : Colors.grey,
              //   heroTag: "btnVideo",
              //   child: informeController.getPathVideo!.isEmpty
              //       ? const Icon(Icons.videocam_outlined, color: Colors.white)
              //       : const Icon(
              //           Icons.videocam_outlined,
              //           color: Colors.black,
              //         ),
              //   onPressed: informeController.getPathVideo!.isEmpty
              //       ? () {
              //           bottomSheetVideo(informeController, context, size);
              //           // Navigator.push(context,
              //           //     MaterialPageRoute(builder: (BuildContext context) {
              //           //   return const CameraUtilitarios(
              //           //     modulo: 'informes',
              //           //   );
              //           // }));
              //         }
              //       : null,
              // ),
              SizedBox(
                height: size.iScreen(1.5),
              ),

              SizedBox(
                height: size.iScreen(1.5),
              ),
            ],
          ),
       
       
       
        );
  }

  void bottomSheet(
    AusenciasController informeController,
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
      ImageSource source, AusenciasController informeController) async {
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
//********************************************************************************************************************//
  void _onSubmit(BuildContext context, AusenciasController controller) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
      if (controller.nombreGuardia!.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar guardia');
      }else if (controller.labelMotivoAusencia==null) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar motivo');
      } else {
        // ProgressDialog.show(context);
        await controller.crearAusencia(context);
        // await controller.upLoadImagen();
        // ProgressDialog.dissmiss(context);
        Navigator.pop(context);
      }
    }
  }
  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalSeleccionaGuardia(
      Responsive size, AusenciasController ausenciasController) {
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
                  Text('SELECCIONAR GUARDIA',
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
                          _validaScanQRGuardia(ausenciasController);
                          // homeController.setOpcionActividad(1);
                          // informeController.resetValuesInformes();
                          // _validaScanQRMulta(size, informeController);
                          // Navigator.pop(context);
                          // _modalTerminosCondiciones(size, homeController);
                        },
                      ),
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
                          Navigator.pop(context);
                      Provider.of<AvisoSalidaController>(context,listen: false).buscaInfoGuardias('');
                            Navigator.pushNamed(context, 'buscaGuardias',arguments:'ausencia' );
                            //  Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute<void>(
                            //       builder: (BuildContext context) =>
                            //           const BuscarGuardias(modulo: 'avisoSalida',)));
                            
                         
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
   //================================================= SELECCIONA FECHA INICIO ==================================================//
  _selectFechaInicio(BuildContext context,
     AusenciasController ausenciasController) async {
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
      final _fechaInicio =
          '${anio.toString()}-${mes.toString()}-${dia.toString()}';
      _fechaInicioController.text = _fechaInicio;
      ausenciasController.onInputFechaInicioChange(_fechaInicio);
      // print('FechaInicio: $_fechaInicio');
      // });
    }
  }

  //================================================= SELECCIONA FECHA FIN ==================================================//
  _selectFechaFin(BuildContext context,
       AusenciasController ausenciasController) async {
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

      setState(() {
        final _fechaFin =
            '${anio.toString()}-${mes.toString()}-${dia.toString()}';
        _fechaFinController.text = _fechaFin;
        ausenciasController.onInputFechaFinChange(_fechaFin);
        // print('FechaFin: $_fechaFin');
      });
    }
  }
    void _seleccionaHoraInicio(
      context,  AusenciasController ausenciasController) async {
    TimeOfDay? _hora =
        await showTimePicker(context: context, initialTime: timerInicio);

    if (_hora != null) {
      String? dateHora = (_hora.hour < 10) ? '0${_hora.hour}' : '${_hora.hour}';
      String? dateMinutos =
          (_hora.minute < 10) ? '0${_hora.minute}' : '${_hora.minute}';

      setState(() {
        timerInicio = _hora;
        String horaInicio = '${dateHora}:${dateMinutos}';
        _horaInicioController.text = horaInicio;
        ausenciasController.onInputHoraInicioChange(horaInicio);
        //  print('si: $horaInicio');
      });
    }
  }

  void _seleccionaHoraFin(
      context,  AusenciasController ausenciasController) async {
    TimeOfDay? _hora =
        await showTimePicker(context: context, initialTime: timerFin);
    if (_hora != null) {
        String? dateHora = (_hora.hour < 10) ? '0${_hora.hour}' : '${_hora.hour}';
      String? dateMinutos =
          (_hora.minute < 10) ? '0${_hora.minute}' : '${_hora.minute}';

      setState(() {
        timerFin = _hora;
        print(timerFin.format(context));
        String horaFin ='${dateHora}:${dateMinutos}';
        _horaFinController.text = horaFin;
        ausenciasController.onInputHoraFinChange(horaFin);
        //  print('si: $horaFin');
      });
    }
  }

//   void _cargaArchivo()async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();

// if (result != null) {
//   File file = File(result.files.single.path!);
//   print('========******************** > $file');
// } else {
//   // User canceled the picker
// }
//   }



  //======================== VALIDA SCANQRgUARDIA =======================//
  void _validaScanQRGuardia(AusenciasController ausenciasController) async {
    ausenciasController.setInfoQRGuardia(
        await FlutterBarcodeScanner.scanBarcode(
            '#34CAF0', '', false, ScanMode.QR));
    if (!mounted) return;
    Navigator.pop(context);
  }

  //======================== VALIDA SCANQRgUARDIA =======================//
  // void _validaScanQRCliente(AusenciasController ausenciasController) async {
  //   ausenciasController.setInfoQRCliente(
  //       await FlutterBarcodeScanner.scanBarcode(
  //           '#34CAF0', '', false, ScanMode.QR));
  //   if (!mounted) return;
  //   Navigator.pop(context);
  // }




}
class _CamaraOption extends StatefulWidget {
  final AusenciasController ausenciasController;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.ausenciasController,
  }) : super(key: key);

  final Responsive size;

  @override
  State<_CamaraOption> createState() => _CamaraOptionState();
}

class _CamaraOptionState extends State<_CamaraOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: 

Consumer<AusenciasController>(builder: (_, fotoUrl, __) { 

return  Column(
        children: [
          Container(
            width: widget.size.wScreen(100.0),
            // color: Colors.blue,
            margin: EdgeInsets.symmetric(
              vertical: widget.size.iScreen(1.0),
              horizontal: widget.size.iScreen(0.0),
            ),
            child: Text(
                'Fotografía:  ${fotoUrl.getListaFotosUrl!.length}   ',
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
     
     

 },),

     
     
     
      onTap: () {
        print('activa FOTOGRAFIA');
      },
    );
  }
}