import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
// import 'package:sincop_app/src/pages/busca_guardias.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/dropdown_motivo_aviso_salida.dart';
import 'package:provider/provider.dart';

class CreaAvisoSalida extends StatefulWidget {
  const CreaAvisoSalida({Key? key}) : super(key: key);

  @override
  State<CreaAvisoSalida> createState() => _CreaAvisoSalidaState();
}

class _CreaAvisoSalidaState extends State<CreaAvisoSalida> {
   final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
 late TimeOfDay timeInicio;


  @override
  void initState() {
     timeInicio = TimeOfDay.now();
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
    final avisoSalidaController =
        Provider.of<AvisoSalidaController>(context, listen: false);
    Responsive size = Responsive.of(context);
    return SafeArea(
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xFFEEEEEE),
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(
              'Crear Aviso de Salida',
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
                      _onSubmit(context, avisoSalidaController);
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
                  key: avisoSalidaController.avisoSalidaFormKey,
                  child: Column(children: [
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
                              Consumer<AvisoSalidaController>(
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
                                _modalSeleccionaPersona(
                                    size, avisoSalidaController);
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
                      Container(
                        width: size.wScreen(100.0),
      
                        // color: Colors.blue,
                        child: Text('Motivo:',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ),
                      const DropMenuAvisoSalida(data: [
                        'FINALIZACION DE PUESTO',
                        'FALTAS REITERADAS PUESTO',
                        'AVISO DEL TRABAJADOR',
                        'RENUNCIA VOLUNTARIA',
                      ],hinText: 'seleccione Motivo',) ,  
                          //***********************************************/
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
                          avisoSalidaController.onDetalleChange(text);
                        },
                        validator: (text) {
                          if (text!.trim().isNotEmpty) {
                            return null;
                          } else {
                            return 'Ingrese detalle del aviso';
                          }
                        },
                      ),
                        //*****************************************/
                      SizedBox(
                        height: size.iScreen(2.0),
                      ),
                      Container(
                        width: size.wScreen(100),
                        child: Text(
                          'Fecha y hora de salida:',
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
                                    _selectFecha(context, avisoSalidaController);
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
                                  return 'Ingrese fecha del aviso';
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
                                    _seleccionaHora(context, avisoSalidaController);
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
                                  return 'Ingrese hora del aviso';
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
                        //==========================================//
                        Consumer<AvisoSalidaController>(builder: (_, valueFotos, __) { 
                          return valueFotos.getListaFotosInforme.isNotEmpty
                          ? _CamaraOption(
                              size: size, avisoSalidaController: valueFotos)
                          : Container();
                         },),
                     
                      //*****************************************/
                      //***********************************************/
                      SizedBox(
                        width: size.iScreen(1.0),
                      ),
                      //*****************************************/
                       //==========================================//
                        Consumer<AvisoSalidaController>(builder: (_, valueFotos, __) { 
                          return valueFotos.getUrlVideo!.isNotEmpty
                          ?_CamaraVideo(
                              size: size,
                              avisoSalidaController: avisoSalidaController,
                            )
                          : Container();
                         },),
                      //==========================================//
                     
                      SizedBox(
                        height: size.iScreen(3.0),
                      ),   
                  ]),
                ),
              ),),
              floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    bottomSheet(avisoSalidaController, context, size);
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
                  backgroundColor: avisoSalidaController.getPathVideo!.isEmpty
                      ? Colors.blue
                      : Colors.grey,
                  heroTag: "btnVideo",
                  child: avisoSalidaController.getPathVideo!.isEmpty
                      ? const Icon(Icons.videocam_outlined, color: Colors.white)
                      : const Icon(
                          Icons.videocam_outlined,
                          color: Colors.black,
                        ),
                  onPressed: avisoSalidaController.getPathVideo!.isEmpty
                      ? () {
                          bottomSheetVideo(avisoSalidaController, context, size);
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


//================================================= SELECCIONA FECHA INICIO ==================================================//
  _selectFecha(
      BuildContext context,  AvisoSalidaController avisoSalidaController) async {
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
      avisoSalidaController.onInputFechaAvisoSalidaChange(_fechaInicio);
      // print('FechaInicio: $_fechaInicio');
      // });
    }
  }

  void _seleccionaHora(context,AvisoSalidaController avisoSalidaController) async {
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
        avisoSalidaController.onInputHoraAvisoSalidaChange(horaInicio);
        //  print('si: $horaInicio');
      });
    }
  }

   //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalSeleccionaPersona(
      Responsive size, AvisoSalidaController avisoSalidaController) {
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
                  Text('SELECCIONAR ',
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
                          _validaScanQRGuardia(avisoSalidaController);
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
                          "Nómina de Guardias",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          Navigator.pop(context);
                         
                            avisoSalidaController.buscaInfoGuardias('');
                            Navigator.pushNamed(context, 'buscaGuardias',arguments:'avisoSalida' );
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

  //********************************************************************************************************************//
  void _onSubmit(BuildContext context, AvisoSalidaController controller) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
     
        // ProgressDialog.show(context);
        await controller.crearAvisoSalida(context);
        // await controller.upLoadImagen();
        // ProgressDialog.dissmiss(context);
        Navigator.pop(context);
      }
    }
  
 void bottomSheet(
    AvisoSalidaController avisoSalidaController,
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
                    _funcionCamara(ImageSource.camera, avisoSalidaController);
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
                    _funcionCamara(ImageSource.gallery, avisoSalidaController);
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
    AvisoSalidaController avisoSalidaController,
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
                    _funcionCamaraVideo(ImageSource.camera, avisoSalidaController);
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
                    _funcionCamaraVideo(ImageSource.gallery, avisoSalidaController);
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
      ImageSource source, AvisoSalidaController avisoSalidaController) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    if (pickedFile == null) {
      return;
    }
    avisoSalidaController.setNewPictureFile('${pickedFile.path}');
    print('TENEMOS IMAGEN:=====>  ${pickedFile.path}');

//===============================//
// _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
  }

  void _funcionCamaraVideo(
      ImageSource source, AvisoSalidaController avisoSalidaController) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(
      source: source,
    );

    if (pickedFile == null) {
      return;
    }
    print(
        'TENEMOS VIDEO :==========================+++++++++++++++++++++++++>  ${pickedFile.path}');
    avisoSalidaController.setPathVideo(pickedFile.path);

//===============================//
// _downloadImage(pickedFile.path);
//===============================//
    Navigator.pop(context);

    // Navigator.pop(context);
  }


  //======================== VALIDA SCANQRgUARDIA =======================//
  void _validaScanQRGuardia(AvisoSalidaController avisoSalidaController) async {
    avisoSalidaController.setInfoQRGuardia(
        await FlutterBarcodeScanner.scanBarcode(
            '#34CAF0', '', false, ScanMode.QR));
    if (!mounted) return;
    Navigator.pop(context);
  }

  //======================== VALIDA SCANQRgUARDIA =======================//
  // void _validaScanQRCliente(AvisoSalidaController avisoSalidaController) async {
  //   avisoSalidaController.setInfoQRCliente(
  //       await FlutterBarcodeScanner.scanBarcode(
  //           '#34CAF0', '', false, ScanMode.QR));
  //   if (!mounted) return;
  //   Navigator.pop(context);
  // }



}


class _CamaraOption extends StatefulWidget {
  final AvisoSalidaController avisoSalidaController;
  const _CamaraOption({
    Key? key,
    required this.size,
    required this.avisoSalidaController,
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

Consumer<AvisoSalidaController>(builder: (_, fotoUrl, __) { 

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

class _CamaraVideo extends StatelessWidget {
  const _CamaraVideo({
    Key? key,
    required this.size,
    required this.avisoSalidaController,
  }) : super(key: key);

  final Responsive size;
  final AvisoSalidaController avisoSalidaController;

  @override
  Widget build(BuildContext context) {
    return 
    Consumer<AvisoSalidaController>(builder: (_, valueVideo, __) { 
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
        Card(
          child: Row(
            children: [
              //***********************************************/
              SizedBox(
                width: size.iScreen(1.0),
              ),
              //*****************************************/
              GestureDetector(
                onTap: () {
                  valueVideo.eliminaVideo();
                },
                child: Container(
                  margin: EdgeInsets.only(right: size.iScreen(0.5)),
                  child: const Icon(Icons.delete_forever_outlined,
                      color: Colors.red),
                ),
              ),
              Icon(
                Icons.video_file_outlined,
                size: size.iScreen(5.0),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'videoSreen',
                      arguments: '${valueVideo.getUrlVideo}');
                },
                child: Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: size.iScreen(1.0),
                        vertical: size.iScreen(1.0)),
                    child: Text(
                      'Video seleccionado',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.7),
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
 
     },);
   
 
  }
}