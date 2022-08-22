import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
import 'package:sincop_app/src/controllers/cambio_puesto_controller.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/turno_extra_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/dropdown_motivo_turno_extra.dart';
import 'package:provider/provider.dart';

class CreaTurnoExtra extends StatefulWidget {
  CreaTurnoExtra({Key? key}) : super(key: key);

  @override
  State<CreaTurnoExtra> createState() => _CreaTurnoExtraState();
}

class _CreaTurnoExtraState extends State<CreaTurnoExtra> {
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
    final turnoExtraController = Provider.of<TurnoExtraController>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: const Color(0xFFEEEEEE),
            appBar: AppBar(
              // backgroundColor: primaryColor,
              title: Text(
                'Crear Turno Extra',
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
                        _onSubmit(context, turnoExtraController);
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
                    key: turnoExtraController.turnoExtraFormKey,
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
                                child: Consumer<TurnoExtraController>(
                                  builder: (_, persona, __) {
                                    return (persona.nombreGuardia == '' ||
                                            persona.nombreGuardia == null)
                                        ? Text(
                                            'No hay guardia designado',
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: size.iScreen(1.8),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          )
                                        : Text(
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
                                      size, turnoExtraController);
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
                        //***********************************************/
                        SizedBox(
                          height: size.iScreen(1.0),
                        ),
                        //*****************************************/

                        Container(
                          width: size.wScreen(100.0),

                          // color: Colors.blue,
                          child: Text('Cliente :',
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
                                child: Consumer<TurnoExtraController>(
                                  builder: (_, persona, __) {
                                    return (persona.nombreCliente == '' ||
                                            persona.nombreCliente == null)
                                        ? Text(
                                            'No hay cliente seleccionado',
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: size.iScreen(1.8),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          )
                                        : Text(
                                            '${persona.nombreCliente} ',
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
                                  turnoExtraController.resetDropDown();
                                  _modalSeleccionaCliente(
                                      size, turnoExtraController);
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
                          child: Text('Nuevo Puesto:',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.iScreen(2.0),
                              vertical: size.iScreen(0)),
                          width: size.wScreen(100),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Consumer<TurnoExtraController>(
                              builder: (_, puesto, __) {
                                return DropdownButton(
                                  isExpanded: true,
                                  hint: Text('Seleccione Puesto',
                                      // estadoCompra.tipoDoc.toString(),
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        // fontWeight: FontWeight.w500,
                                        color: Colors.black45,
                                      )),
                                  items: (puesto
                                          .getListaPuestosCliente.isNotEmpty)
                                      ? puesto.getListaPuestosCliente
                                          .map((e) => DropdownMenuItem(
                                                child: Center(
                                                    child: Text(e['puesto'],
                                                        textAlign:
                                                            TextAlign.center)),
                                                value: e['puesto'],
                                              ))
                                          .toList()
                                      : null,
                                  value: puesto.labelNuevoPuesto,
                                  onChanged: (value) {
                                    // puesto.setPuestoNuevoCliente(value.toString());
                                    puesto
                                        .setLabelINuevoPuesto(value.toString());
                                  },
                                );
                              },
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
                          child: Text('Fecha de turno extra :',
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
                                      hintStyle: const TextStyle(
                                          color: Colors.black38),
                                      suffixIcon: IconButton(
                                        color: Colors.red,
                                        splashRadius: 20,
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          _selectFechaInicio(
                                              context, turnoExtraController);
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
                                      hintStyle: const TextStyle(
                                          color: Colors.black38),
                                      suffixIcon: IconButton(
                                        color: Colors.red,
                                        splashRadius: 20,
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          _seleccionaHoraInicio(
                                              context, turnoExtraController);
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
                                      hintStyle: const TextStyle(
                                          color: Colors.black38),
                                      suffixIcon: IconButton(
                                        color: Colors.red,
                                        splashRadius: 20,
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          _selectFechaFin(
                                              context, turnoExtraController);
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
                                      hintStyle: const TextStyle(
                                          color: Colors.black38),
                                      suffixIcon: IconButton(
                                        color: Colors.red,
                                        splashRadius: 20,
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          _seleccionaHoraFin(
                                              context, turnoExtraController);
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
                        const DropMenuMotivoTurnoExtra(
                          data: [
                            'FALTA INJUSTIFICADA',
                            'PERMISO MEDICO',
                            'ABANDONO DE PUESTO',
                            'EVENTO ESPECIAL',
                          ],
                          hinText: 'seleccione Motivo',
                        ),
                        //***********************************************/
                        //***********************************************/
                        SizedBox(
                          height: size.iScreen(2.0),
                        ),
                        //*****************************************/
                        Container(
                          width: size.wScreen(100.0),

                          // color: Colors.blue,
                          child: Text('Autorizado por:',
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
                            turnoExtraController.onAutorizadoPorChange(text);
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
                            turnoExtraController.onDetalleChange(text);
                          },
                          validator: (text) {
                            if (text!.trim().isNotEmpty) {
                              return null;
                            } else {
                              return 'Ingrese detalle del aviso';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  //********************************************************************************************************************//
  void _onSubmit(BuildContext context, TurnoExtraController controller) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
      if (controller.nombreGuardia!.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar guardia');
      } else if (controller.labelMotivoTurnoExtra!.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar motivo');
      } else if (controller.labelNuevoPuesto!.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar motivo');
      } else {
        await controller.crearTurnoExtra(context);

        Navigator.pop(context);
      }
    }
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalSeleccionaGuardia(
      Responsive size, TurnoExtraController turnoExtraController) {
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
                          _validaScanQRGuardia(turnoExtraController);
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
                          Provider.of<AvisoSalidaController>(context,
                                  listen: false)
                              .buscaInfoGuardias('');
                          Navigator.pushNamed(context, 'buscaGuardias',
                              arguments: 'turnoExtra');
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

  //====== MUESTRA MODAL  =======//
  void _modalSeleccionaCliente(
      Responsive size, TurnoExtraController turnoExtraController) {
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
                          _validaScanQRCliente(turnoExtraController);
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
                          Provider.of<CambioDePuestoController>(context,
                                  listen: false)
                              .getTodosLosClientes('');
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'buscaClientes',
                              arguments: 'turnoExtra');
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
  _selectFechaInicio(
      BuildContext context, TurnoExtraController turnoExtraController) async {
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
      turnoExtraController.onInputFechaInicioChange(_fechaInicio);
      // print('FechaInicio: $_fechaInicio');
      // });
    }
  }

  //================================================= SELECCIONA FECHA FIN ==================================================//
  _selectFechaFin(
      BuildContext context, TurnoExtraController turnoExtraController) async {
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
        turnoExtraController.onInputFechaFinChange(_fechaFin);
        // print('FechaFin: $_fechaFin');
      });
    }
  }

  void _seleccionaHoraInicio(
      context, TurnoExtraController turnoExtraController) async {
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
        turnoExtraController.onInputHoraInicioChange(horaInicio);
        //  print('si: $horaInicio');
      });
    }
  }

  void _seleccionaHoraFin(
      context, TurnoExtraController turnoExtraController) async {
    TimeOfDay? _hora =
        await showTimePicker(context: context, initialTime: timerFin);
    if (_hora != null) {
      String? dateHora = (_hora.hour < 10) ? '0${_hora.hour}' : '${_hora.hour}';
      String? dateMinutos =
          (_hora.minute < 10) ? '0${_hora.minute}' : '${_hora.minute}';

      setState(() {
        timerFin = _hora;
        print(timerFin.format(context));
        String horaFin = '${dateHora}:${dateMinutos}';
        _horaFinController.text = horaFin;
        turnoExtraController.onInputHoraFinChange(horaFin);
        //  print('si: $horaFin');
      });
    }
  }

  //======================== VALIDA SCANQRgUARDIA =======================//
  void _validaScanQRGuardia(TurnoExtraController turnoExtraController) async {
    turnoExtraController.setInfoQRGuardia(
        await FlutterBarcodeScanner.scanBarcode(
            '#34CAF0', '', false, ScanMode.QR));
    if (!mounted) return;
    Navigator.pop(context);
  }

  //======================== VALIDA SCANQRgUARDIA =======================//
  void _validaScanQRCliente(TurnoExtraController turnoExtraController) async {
    turnoExtraController.setInfoQRCliente(
        await FlutterBarcodeScanner.scanBarcode(
            '#34CAF0', '', false, ScanMode.QR));
    if (!mounted) return;
    Navigator.pop(context);
  }
}
