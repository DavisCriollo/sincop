import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/dataTable/pedidos_supervisor_datasource.dart';
import 'package:sincop_app/src/pages/buscar_guardias_pedidos.dart';
import 'package:sincop_app/src/pages/buscar_cliente_pedidos.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/dropdown_frecuencia_consigna_cliente.dart';
import 'package:sincop_app/src/widgets/dropdown_nombre_item_pedido.dart';
import 'package:sincop_app/src/widgets/dropdown_tipo_pedido.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class EditarPedidoPage extends StatefulWidget {
  const EditarPedidoPage({Key? key}) : super(key: key);

  @override
  State<EditarPedidoPage> createState() => _EditarPedidoPageState();
}

class _EditarPedidoPageState extends State<EditarPedidoPage> {
  TextEditingController textImplemento = TextEditingController();
  int _radioSelected = 1;
  bool _value = false;
  int val = -1;
  bool _estadoPedido = false;
  @override
  Widget build(BuildContext context) {
    final logisticaController =
        Provider.of<LogisticaController>(context, listen: true);
    Responsive size = Responsive.of(context);

    List<String> data = [];
    if (logisticaController.getEstadoPedido == 'ENVIADO') {
      data.addAll(['RECIBIDO', 'ANULADO']);
      _estadoPedido = true;
    } else if (logisticaController.getEstadoPedido == 'PENDIENTE') {
      data.add('ANULADO');
      _estadoPedido = true;
    }

    // print('WWWWSSS${logisticaController.getEstadoPedido}');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFEEEEEE),
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(
              'Editar Pedido',
              style: GoogleFonts.lexendDeca(
                  fontSize: size.iScreen(2.45),
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            actions: [
              (logisticaController.getNombreCliente!.isNotEmpty &&
                      logisticaController.getListaGuardiasVarios.isNotEmpty)
                  ? Container(
                      margin: EdgeInsets.only(right: size.iScreen(1.5)),
                      child: IconButton(
                          splashRadius: 28,
                          onPressed: () {
                            _onSubmit(context, logisticaController);
                          },
                          icon: Icon(
                            Icons.save_outlined,
                            size: size.iScreen(4.0),
                          )),
                    )
                  : const SizedBox(),
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
              child: Form(
                key: logisticaController.pedidoGuardiaFormKey,
                child: Column(
                  children: [
                    //***********************************************/
                    // SizedBox(
                    //   height: size.iScreen(1.0),
                    // ),
                    // //*****************************************/
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: size.iScreen(0.5),
                              bottom: size.iScreen(0.0)),
                          // width: size.wScreen(100.0),
                          child: Text(
                            'Estado: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                                color: Colors.black87,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: size.iScreen(0.5),
                              bottom: size.iScreen(0.0)),
                          width: size.wScreen(60.0),
                          child: DropMenuEstadoPedido(
                            // title: 'Tipo de documento:',
                            data: data,
                            hinText: 'Seleccione',
                          ),
                          // Text(
                          //   '${pedido['disEntrega']}',
                          //   style: GoogleFonts.lexendDeca(
                          //       fontSize: size
                          //           .iScreen(
                          //               1.5),
                          //       color: Colors
                          //           .black87,
                          //       fontWeight:
                          //           FontWeight
                          //               .bold),
                          // ),
                        ),
                      ],
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/

                    SizedBox(
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
                            child: Consumer<LogisticaController>(
                              builder: (_, persona, __) {
                                return (persona.getNombreCliente == '' ||
                                        persona.getNombreCliente == null)
                                    ? Text(
                                        'No hay cliente designada',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      )
                                    : Text(
                                        '${persona.getNombreCliente} ',
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
                        _estadoPedido == false
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () {
                                    _modalSeleccionaPersona(
                                        size, logisticaController, 'CLIENTE');
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
                              )
                            : Container(),
                      ],
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/

                    // SizedBox(
                    //   width: size.wScreen(100.0),

                    //   // color: Colors.blue,
                    //   child: Text('Guardia :',
                    //       style: GoogleFonts.lexendDeca(
                    //           // fontSize: size.iScreen(2.0),
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey)),
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         // color: Colors.red,
                    //         padding: EdgeInsets.only(
                    //           top: size.iScreen(1.0),
                    //           right: size.iScreen(0.5),
                    //         ),
                    //         child: Consumer<LogisticaController>(
                    //           builder: (_, guardia, __) {
                    //             return (guardia.getNombreGuardia == '' ||
                    //                     guardia.getNombreGuardia == null)
                    //                 ? Text(
                    //                     'No hay Guardia designada',
                    //                     style: GoogleFonts.lexendDeca(
                    //                         fontSize: size.iScreen(2.0),
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Colors.grey),
                    //                   )
                    //                 : Text(
                    //                     '${guardia.getNombreGuardia}',
                    //                     style: GoogleFonts.lexendDeca(
                    //                       fontSize: size.iScreen(1.8),
                    //                       fontWeight: FontWeight.normal,
                    //                       // color: Colors.grey
                    //                     ),
                    //                   );
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     ClipRRect(
                    //       borderRadius: BorderRadius.circular(8),
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           if (logisticaController
                    //               .getNombreCliente!.isNotEmpty) {
                    //             _modalSeleccionaPersona(
                    //                 size, logisticaController, 'GUARDIA');
                    //           } else {
                    //             NotificatiosnService.showSnackBarDanger(
                    //                 'Debe seleccionar un cliente  primero');
                    //           }
                    //         },
                    //         child: Container(
                    //           alignment: Alignment.center,
                    //           color: primaryColor,
                    //           width: size.iScreen(3.5),
                    //           padding: EdgeInsets.only(
                    //             top: size.iScreen(0.5),
                    //             bottom: size.iScreen(0.5),
                    //             left: size.iScreen(0.5),
                    //             right: size.iScreen(0.5),
                    //           ),
                    //           child: Icon(
                    //             Icons.search_outlined,
                    //             color: Colors.white,
                    //             size: size.iScreen(2.8),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    //*****************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Row(
                      children: [
                        Container(
                          // width: size.wScreen(100.0),

                          // color: Colors.blue,
                          child: Row(
                            children: [
                              Text('Guardias: ',
                                  style: GoogleFonts.lexendDeca(
                                      // fontSize: size.iScreen(2.0),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey)),
                              // (logisticaController
                              //         .getListaGuardiasVarios.isNotEmpty)
                              //     ? Consumer<LogisticaController>(
                              //         builder: (_, value, __) {
                              //           return Text(
                              //               ' ${value.getListaGuardiasVarios.length}',
                              //               style: GoogleFonts.lexendDeca(
                              //                   fontSize: size.iScreen(1.7),
                              //                   fontWeight: FontWeight.bold,
                              //                   color: Colors.grey));
                              //         },
                              //       )
                              //     : const SizedBox(),
                            ],
                          ),
                        ),
                        SizedBox(width: size.iScreen(1.0)),
                        _estadoPedido == false
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () {
                                    if (logisticaController
                                        .getNombreCliente!.isNotEmpty) {
                                      _modalSeleccionaPersona(
                                          size, logisticaController, 'GUARDIA');
                                    } else {
                                      NotificatiosnService.showSnackBarDanger(
                                          'Debe seleccionar un cliente  primero');
                                    }
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
                            : Container(),
                      ],
                    ),

                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    //==========================================//
                    logisticaController.getListaGuardiasVarios.isNotEmpty
                        ? _ListaGuardias(
                            estadoPedido: _estadoPedido,
                            size: size,
                            logisticaController: logisticaController)
                        : Text('Seleccionar guardias',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),

                    //========================================//
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/

                    SizedBox(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Entrega :',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    // ===========RADIO ENTREGA ==============

                    Consumer<LogisticaController>(
                      builder: (_, valueEntrega, __) {
                        return Container(
                          // color: Colors.red,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.iScreen(0.1)),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.iScreen(1.5),
                              vertical: size.iScreen(0.5)),
                          width: size.wScreen(100.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            const Text('DOTACIÓN'),
                            
                           Radio(
                                value: 1,
                                groupValue: valueEntrega.labelValorEntrega??1,
                                // groupValue:
                                //   valueEntrega.labelEntrega,
                                onChanged: (value) {
                                  // setState(() {
                                  //   val = 1;
                                  //   valueEntrega.setLabelEntrega(value);
                                  //   // print(val);
                                  // });
                                },
                                activeColor: primaryColor,
                                toggleable: false,
                              ),
                              
                             const Text('DESCUENTO'),
                            Radio(
                                value: 2,
                                groupValue: valueEntrega.labelValorEntrega??val,
                                
                                // groupValue:
                                //     valueEntrega.labelValorEntrega,
                                    // valueEntrega.labelValorEntrega,
                                onChanged:null, 
                                  // (value) {
                                  //   setState(() {
                                  //     val = 2;
                                  //     valueEntrega.setLabelEntrega(value);
                                  //     // print(val);
                                  //   });
                                  // },
                                activeColor: primaryColor,
                                toggleable: false,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    //==========================================//
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Container(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      child: Text('Observación:',
                          style: GoogleFonts.lexendDeca(
                              // fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.normal,
                              color: Colors.grey)),
                    ),
                    TextFormField(
                      readOnly: (_estadoPedido = true) ? true : false,
                      initialValue: logisticaController.getInputObservacion,
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
                        logisticaController.onObservacionChange(text);
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
                      height: size.iScreen(2.0),
                    ),
                    //*****************************************/
                    //***********************************************/
                    // Container(
                    //   child: SearchField(suggestions:  SearchFieldListItem<dynamic>[
                    //     'CAMISA',
                    //     'pantalon',
                    //     'botas',
                    //     'tolete',
                    //     'gorra',
                    //     'poncho',
                    //     'camara',
                    //   ]),
                    // ),
                    //*****************************************/

                    Row(
                      children: [
                        Container(
                          // width: size.wScreen(100.0),

                          // color: Colors.blue,
                          child: Row(
                            children: [
                              Text('Pedidos: ',
                                  style: GoogleFonts.lexendDeca(
                                      // fontSize: size.iScreen(2.0),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey)),
                              (logisticaController.getNuevoPedido.isNotEmpty)
                                  ? Text(
                                      ' ${logisticaController.getNuevoPedido.length}',
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.7),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey))
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        SizedBox(width: size.iScreen(1.0)),
                        _estadoPedido == false
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () {
                                    textImplemento.text = '';

                                    _modalAgregaPedido(
                                        size, logisticaController);
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
                            : Container(),
                        Spacer(),
                        // Row(
                        //   children: [
                        //     Text('Total: ',
                        //         style: GoogleFonts.lexendDeca(
                        //             // fontSize: size.iScreen(2.0),
                        //             fontWeight: FontWeight.normal,
                        //             color: Colors.grey)),

                        //     Text(
                        //       '${logisticaController.getTotalCantidad}',
                        //       style: GoogleFonts.lexendDeca(
                        //         fontSize: size.iScreen(2.0),
                        //         fontWeight: FontWeight.normal,
                        //         // color: Colors.grey,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: size.iScreen(1.0),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    (logisticaController.getNuevoPedido.isNotEmpty)
                        ? PaginatedDataTable(
                            columns: [
                              DataColumn(
                                  label: Row(
                                children: [
                                  Text('X'),
                                  SizedBox(width: 30.0),
                                  Text('Nombre',
                                      style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey))
                                ],
                              )),
                              DataColumn(
                                  numeric: true,
                                  label: Text('Cantidad',
                                      style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey))),
                              DataColumn(
                                  label: Text('Tipo',
                                      style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey))),
                            ],
                            source: PedidosGuardiasDTS(
                              logisticaController.getNuevoPedido,
                              size,
                              context,
                              'Falso',
                            ),
                            rowsPerPage:
                                logisticaController.getNuevoPedido.length,
                          )
                        // : const SizedBox(),
                        : const NoData(label: 'No hay pedidos registrados '),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalSeleccionaPersona(
      Responsive size, LogisticaController logisticaController, String tipo) {
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
                  Text('SELECCIONAR $tipo',
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
                          if (tipo == 'CLIENTE') {
                            logisticaController.getTodosLosClientesPedido('');
                            Navigator.pushNamed(context, 'buscaClientePedidos');
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute<void>(
                            //         builder: (BuildContext context) =>
                            //             const BuscarClientesDistribucion()));
                          } else if (tipo == 'GUARDIA') {
                            // logisticaController.getTodosLosGuardiasPedido('');
                            // Navigator.pushNamed(context, 'buscaGuardiasPedido');
                            logisticaController.buscaInfoGuardiasPedidos('');
                            // // Navigator.pushNamed(context, 'buscaGuardiasPedido');
                            Navigator.pushNamed(
                                context, 'buscarGuardiasVariosPedidos');
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

  //====== MUESTRA AGREGAR PEDIDO =======//
  void _modalAgregaPedido(
      Responsive size, LogisticaController logisticaController) {
    logisticaController.resetBusquedaImplemento();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(2.0), vertical: size.wScreen(1.0)),
              content: Form(
                key: logisticaController.validaNuevoPedidoGuardiaFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AGREGAR PEDIDO',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // color: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.iScreen(1.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Tipo de Pedido:',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  color: Colors.black45,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              //***********************************************/
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //*****************************************/
                              Consumer<LogisticaController>(
                                builder: (_, value, __) {
                                  return Text(
                                    (value.getTipoPedido != '')
                                        ? '${value.getTipoPedido}'
                                        : ' ',
                                    style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      color: Colors.black45,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),

                              // const DropMenuTpoPedido(
                              //   // title: 'Tipo de documento:',
                              //   data: [
                              //     'VESTIMENTA',
                              //     'UTILITARIO',
                              //   ],
                              //   hinText: 'Seleccione',
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.iScreen(1.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Cantidad:',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  color: Colors.black45,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: size.iScreen(10.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  // keyboardType: TextInputType.number,
                                  // inputFormatters: <TextInputFormatter>[ WhitelistingTextInputFormatter.digitsOnly ],

                                  decoration: const InputDecoration(
                                      // suffixIcon: Icon(Icons.beenhere_outlined)
                                      ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(

                                      // fontSize: size.iScreen(3.5),
                                      // fontWeight: FontWeight.bold,
                                      // letterSpacing: 2.0,
                                      ),
                                  onChanged: (text) {
                                    logisticaController.setItemCantidad(text);
                                  },
                                  validator: (text) {
                                    if (text!.trim().isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'falta cantidad';
                                    }
                                  },
                                ),
                              ),
                            ],
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
                      padding:
                          EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            //  color: Colors.red,
                            width: size.wScreen(100.0),
                            child: Text(
                              'Nombre de Implemento:',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // const DropMenuNombreItemPedido(
                          //   // title: 'Tipo de documento:',
                          //   data: [
                          //     'CAMISAS',
                          //     'RADIO',
                          //     'TOLETE',
                          //     'CAMARA',
                          //     'LINTERNA',
                          //     'CELULAR',
                          //     'BOTAS',
                          //     'PONCHO',
                          //   ],
                          //   hinText: 'Seleccione',
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                //  color: Colors.red,
                                width: size.iScreen(30.0),
                                child: TextFormField(
                                  controller: textImplemento,
                                  readOnly: true,
                                  // inputFormatters: [
                                  //   FilteringTextInputFormatter.allow(
                                  //       RegExp(r'^(\d+)?\.?\d{0,2}'))
                                  // ],
                                  decoration: const InputDecoration(
                                      // suffixIcon: Icon(Icons.beenhere_outlined)
                                      ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(

                                      // fontSize: size.iScreen(3.5),
                                      // fontWeight: FontWeight.bold,
                                      // letterSpacing: 2.0,
                                      ),
                                  onChanged: (text) {
                                    logisticaController.setItemCantidad(text);
                                  },
                                  validator: (text) {
                                    if (text!.trim().isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Debe seleccionar implemento ';
                                    }
                                  },
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () {
                                    logisticaController
                                        .buscaImplementoPedido('');
                                    Navigator.pushNamed(
                                            context, 'agregaPedidosGuardia')
                                        .then((value) {
                                      textImplemento.text = logisticaController
                                          .getImplementoItem!;
                                    });
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  width: size.wScreen(100.0),
                  //  color: Colors.red,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: size.iScreen(15.0)),
                    //  width: size.iScreen(20.0),
                    height: size.iScreen(3.5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          primaryColor,
                        ),
                      ),
                      onPressed: () {
                        _agregarPedido(logisticaController);
                      },
                      child: Text('Agregar',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _agregarPedido(LogisticaController logisticaController) async {
    final isValid = logisticaController.validateFormValidaMulta();
    if (!isValid) return;
    if (isValid) {
      if (logisticaController.getImplementoItem != null &&
          logisticaController.getItemCantidad != null) {
        logisticaController.agregaNuevoPedido();
        // logisticaController.resetBusquedaImplemento();
        Navigator.pop(context);
      }
    }
  }

//********************************************************************************************************************//
  void _onSubmit(
      BuildContext context, LogisticaController logisticaController) async {
    final isValid = logisticaController.validateForm();
    if (!isValid) return;
    if (isValid) {
      if (logisticaController.getNuevoPedido.isEmpty) {
        NotificatiosnService.showSnackBarDanger('Debe agregar pedidos');
      } 
      else if (logisticaController.labelNombreEstado==null) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar el estado ');
      } 
      else if (logisticaController.getNombreCliente!.isNotEmpty ||
          logisticaController.getNombreCliente != null ||
          logisticaController.getNombreGuardia!.isNotEmpty ||
          logisticaController.getNombreGuardia != null) {
        logisticaController.editarPedido(context);

        Navigator.pop(context);
      } else {
        NotificatiosnService.showSnackBarDanger('Debe realizar un pedido');
      }
    }
  }
}

class _ListaGuardias extends StatelessWidget {
  final bool estadoPedido;
  final LogisticaController logisticaController;
  const _ListaGuardias({
    Key? key,
    required this.size,
    required this.logisticaController,
    required this.estadoPedido,
  }) : super(key: key);

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Consumer<LogisticaController>(
        builder: (_, provider, __) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.5)),
            // color: Colors.red,
            width: size.wScreen(100.0),
            height: size.iScreen(
                provider.getListaGuardiasVarios.length.toDouble() * 5.5),
            child: ListView.builder(
              itemCount: provider.getListaGuardiasVarios.length,
              itemBuilder: (BuildContext context, int index) {
                final guardia = provider.getListaGuardiasVarios[index];
                return Card(
                  child: Row(
                    children: [
                      estadoPedido == false
                          ? InkWell(
                              onTap: () {
                                provider.eliminaGuardiaPedido(guardia['id']);
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: size.iScreen(0.5)),
                                child: const Icon(Icons.delete_forever_outlined,
                                    color: Colors.red),
                              ),
                            )
                          : Container(),
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
