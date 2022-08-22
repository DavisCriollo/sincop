import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/dataTable/lista_item_devolucion_datasource.dart';
import 'package:sincop_app/src/dataTable/lista_item_pedido_devolucion_datasource.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/widgets/no_data.dart';

class RealizaDevolucion extends StatefulWidget {
  const RealizaDevolucion({
    Key? key,
  }) : super(key: key);

  @override
  State<RealizaDevolucion> createState() => _RealizaDevolucionState();
}

class _RealizaDevolucionState extends State<RealizaDevolucion> {
  @override
  Widget build(BuildContext context) {
    final logisticaController =
        Provider.of<LogisticaController>(context, listen: false);

    Responsive size = Responsive.of(context);
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color(0XFF343A40), // primaryColor,
          title: const Text('Realizar Devolución'),
          actions: [
            Consumer<LogisticaController>(
              builder: (_, submits, __) {
                return submits.getNuevoItemDevolucionPedido.isNotEmpty
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
                    : const SizedBox();
              },
            ),
          ],
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
          margin: EdgeInsets.symmetric(
            horizontal: size.iScreen(1.0),
          ),

          // color: Colors.red,
          width: size.wScreen(100.0),
          height: size.hScreen(100.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                      margin: EdgeInsets.only(
                          top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                      // width: size.wScreen(100.0),
                      child: Text(
                        'Estado: ',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                      width: size.wScreen(60.0),
                      child: Text(
                        '${logisticaController.getPedidoDevolucion['disEstado']}',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            color: (logisticaController
                                        .getPedidoDevolucion['disEstado'] ==
                                    'ENVIADO')
                                ? Colors.blue
                                : (logisticaController
                                            .getPedidoDevolucion['disEstado'] ==
                                        'PENDIENTE')
                                    ? Colors.orange
                                    : (logisticaController.getPedidoDevolucion[
                                                'disEstado'] ==
                                            'RECIBIDO')
                                        ? Colors.green
                                        : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                //***********************************************/
                SizedBox(
                  height: size.iScreen(0.5),
                ),
                //*****************************************/
                Container(
                  margin: EdgeInsets.only(
                      top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                  width: size.wScreen(100.0),
                  child: Text(
                    'Cliente: ',
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.5),
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                ), //***********************************************/
                SizedBox(
                  height: size.iScreen(0.5),
                ),
                //*****************************************/
                Container(
                  margin: EdgeInsets.only(
                      top: size.iScreen(0.1), bottom: size.iScreen(0.0)),
                  width: size.wScreen(100.0),
                  child: Text(
                    // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                    logisticaController.getPedidoDevolucion['disNombreCliente'],
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.5),
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //***********************************************/
                SizedBox(
                  height: size.iScreen(0.5),
                ),
                //*****************************************/

                Container(
                  margin: EdgeInsets.only(
                      top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                  width: size.wScreen(100.0),
                  child: Text(
                    'Observación: ',
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.5),
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                //***********************************************/
                SizedBox(
                  height: size.iScreen(0.5),
                ),
                //*****************************************/
                Container(
                  margin: EdgeInsets.only(
                      top: size.iScreen(0.1), bottom: size.iScreen(0.0)),
                  width: size.wScreen(100.0),
                  child: Text(
                    // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                    logisticaController.getPedidoDevolucion['disObservacion'],
                    style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(1.5),
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
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
                      child: Row(
                        children: [
                          Text('Pedidos: ',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                          (logisticaController.getNuevoPedido.isNotEmpty)
                              ? Consumer<LogisticaController>(
                                  builder: (_, numPedido, __) {
                                    return Text(
                                        ' ${numPedido.getNuevoPedido.length}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.7),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey));
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(width: size.iScreen(1.0)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onTap: () {
                          // textImplemento.text = '';

                          // _modalAgregaPedido(size, logisticaController);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // color: primaryColor,
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
                    ),
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
                Consumer<LogisticaController>(
                  builder: (_, values, __) {
                    return (values.getListaItemsProductos.isNotEmpty)
                        ?
                        
                        
                        
                        
                        
                        
                         PaginatedDataTable(
                          // horizontalMargin : 0.0,
                          columnSpacing : 25.0,
                            columns: [
                              DataColumn(
                                  label: Row(
                                children: [
                                  // Text('!'),
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
                              // DataColumn(
                              //     label: Text('Tipo',
                              //         style: GoogleFonts.lexendDeca(
                              //             // fontSize: size.iScreen(2.0),
                              //             fontWeight: FontWeight.normal,
                              //             color: Colors.grey))),
                            ],
                            source: ListaPedidosDevolucionDTS(
                              size,
                              context,
                              values.getListaItemsProductos,
                              values,
                            ),
                            rowsPerPage: values.getListaItemsProductos.length,
                          )
                        // : const SizedBox(),
                        : const NoData(label: 'No hay pedidos registrados ');
                  },
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
                      child: Row(
                        children: [
                          Text('Devolución: ',
                              style: GoogleFonts.lexendDeca(
                                  // fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                          (logisticaController.getNuevoPedido.isNotEmpty)
                              ? Consumer<LogisticaController>(
                                  builder: (_, numPedido, __) {
                                    return Text(
                                        ' ${numPedido.getNuevoPedido.length}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.7),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey));
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(width: size.iScreen(1.0)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onTap: () {
                          // textImplemento.text = '';

                          // _modalAgregaPedido(size, logisticaController);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // color: primaryColor,
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
                    ),
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
                Consumer<LogisticaController>(
                  builder: (_, values, __) {
                    return (values.getNuevoItemDevolucionPedido.isNotEmpty)
                        ? PaginatedDataTable(
                            columnSpacing : 25.0,
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
                              // DataColumn(
                              //     label: Text('Tipo',
                              //         style: GoogleFonts.lexendDeca(
                              //             // fontSize: size.iScreen(2.0),
                              //             fontWeight: FontWeight.normal,
                              //             color: Colors.grey))),
                            ],
                            source: DevolucionPedidosDTS(
                              size,
                              context,
                              values.getNuevoItemDevolucionPedido,
                            ),
                            rowsPerPage:
                                values.getNuevoItemDevolucionPedido.length,
                          )
                        // : const SizedBox(),
                        : const NoData(
                            label: 'No hay productos para devolución ');
                  },
                )
              ],
            ),
          ),
        ));
  }

  void _onSubmit(
      BuildContext context, LogisticaController logisticaController) {
    logisticaController.crearDevolucion(context);
    Navigator.pop(context);

  }
}
