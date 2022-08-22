import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/pages/detalle_pedido_activo.dart';
import 'package:sincop_app/src/pages/realiza_devolucion.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/no_data.dart';

class ListaPedidosPage extends StatefulWidget {
  const ListaPedidosPage({Key? key}) : super(key: key);

  @override
  State<ListaPedidosPage> createState() => _ListaPedidosPageState();
}

class _ListaPedidosPageState extends State<ListaPedidosPage> {
  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final logisticaController =
        Provider.of<LogisticaController>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        // backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: const Text('Lista de Pedidos'),
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
      body: // =============================================//
          Container(
        margin: EdgeInsets.symmetric(
          horizontal: size.iScreen(1.0),
        ),

        // color: Colors.red,
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),

        child: Consumer<LogisticaController>(
          builder: (_, providers, __) {
            // print('redibujo0');
            if (providers.getErrorAllPedidosActivos == null) {
              return Center(
                // child: CircularProgressIndicator(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cargando Datos...',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.5),
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (providers.getErrorAllPedidosActivos == false) {
              return const NoData(
                label: 'No existen datos para mostar',
              );
            } else if (providers.getListaTodosLosPedidosActivos.isEmpty) {
              return const NoData(
                label: 'No existen datos para mostar',
              );
              // Text("sin datos");
            }

            return ListView.builder(
              itemCount: providers.getListaTodosLosPedidosActivos.length,
              itemBuilder: (BuildContext context, int index) {
//                                         if(providers.getListaTodosLosPedidosActivos[
//                                                       index]['disEstado'] !=
//                                                   'RECIBIDO'||providers.getListaTodosLosPedidosActivos[
//                                                       index]['disEstado'] !=
//                                                   'ANULADO'){
// final estado= true;
//                                                   }

                final pedido = providers.getListaTodosLosPedidosActivos[index];
                return Slidable(
                  key: ValueKey(index),
                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: ScrollMotion(),

                    // // A pane can dismiss the Slidable.
                    // dismissible: DismissiblePane(onDismissed: () {}),

                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      // (providers.getListaTodosLosPedidosActivos[index]
                      //                 ['disEstado'] ==
                      //             'RECIBIDO' ||
                      //         providers.getListaTodosLosPedidosActivos[index]
                      //                 ['disEstado'] ==
                      //             'ANULADO')
                      //     ? Container()
                      //     :


                      // (providers.getListaTodosLosPedidosActivos[index]
                      //                 ['disEstado'] ==
                      //             'RECIBIDO' ||
                      //         providers.getListaTodosLosPedidosActivos[index]
                      //                 ['disEstado'] ==
                      //             'ANULADO')
                      //     ? Container()
                      //     :
                           SlidableAction(
                              backgroundColor:secondaryColor,
                              foregroundColor: Colors.white,
                              icon: Icons.assignment_return_outlined,
                              label: 'Devolver',
                              onPressed: (context) {
                                providers.resetValuesPedidos();
                                providers.getPedidoParaDevoluciones(pedido);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const RealizaDevolucion(
                                                // pedido: pedido,
                                                ))));

                                // providers.setNuevoPedido();

                                // providers.resetValuesPedidos();
                                // providers.infoPedidoEdicion(pedido);
                                // Navigator.pushNamed(context, 'editarPedidos');

                                //
                              },
                            ),
// (providers.getListaTodosLosPedidosGuardias[index]
//                                       ['disEstado'] ==
//                                   'RECIBIDO' ||
//                               providers.getListaTodosLosPedidosGuardias[index]
//                                       ['disEstado'] ==
//                                   'ANULADO')
//                           ? Container()
//                       :SlidableAction(
//                         onPressed: (context) async {
//                           //  ProgressDialog.show(context);
//                           // await providers.eliminaPedido(
//                           //     context, pedido['disId']);
//                               // ProgressDialog.dissmiss(context);
//                         },
//                         backgroundColor:quinaryColor,
//                         foregroundColor: Colors.white,
//                         icon: Icons.edit,
//                         label: 'Editar',
//                       ),

                      // SlidableAction(
                      //   onPressed: (context) {
                      //     // Navigator.of(context).push(
                      //     //     MaterialPageRoute(
                      //     //         builder: (context) =>
                      //     //             ViewPDFPage(
                      //     //                 pedido: pedido)));
                      //     //  launch("https://backsigeop.neitor.com/api/reportes/pedido?disId=${pedido['disId']}&rucempresa=${pedido['disEmpresa']}");
                      //     //  js.context.callMethod('open', ['https://backsigeop.neitor.com/api/reportes/pedido?disId=${pedido['disId']}&rucempresa=${pedido['disEmpresa']}']);
                      //     //  abrirPDFPedidos(pedido['disId'],pedido['disEmpresa']);
                      //   },
                      //   backgroundColor: Colors.blue,
                      //   foregroundColor: Colors.white,
                      //   icon: Icons.picture_as_pdf_rounded,
                      //   // label: 'Eliminar',
                      // ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      providers.resetValuesPedidos();
                      providers.getPedidoParaDevoluciones(pedido);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>  DetallePedidoActivo(
                                    codigoPedido: pedido['disId'],
                                  ))));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: size.iScreen(0.5)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.iScreen(1.5),
                          vertical: size.iScreen(0.5)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0)),
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        'Tipo: ',
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
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        '${pedido['disTipo']}', //- ${pedido['disId']}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0)),
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        'Cliente: ',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0)),
                                      width: size.wScreen(70.0),
                                      child: Text(
                                        '${pedido['disNombreCliente']}',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0)),
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        'Entrega: ',
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
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        '${pedido['disEntrega']}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
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
                                      child: Text(
                                        '${pedido['disEstado']}',
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: (pedido['disEstado'] ==
                                                    'ENVIADO')
                                                ? Colors.blue
                                                : (pedido['disEstado'] ==
                                                        'PENDIENTE')
                                                    ? Colors.orange
                                                    : (pedido['disEstado'] ==
                                                            'RECIBIDO')
                                                        ? Colors.green
                                                        : Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0)),
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        'Fecha de registro: ',
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
                                      // width: size.wScreen(100.0),
                                      child: Text(
                                        pedido['disFecReg']
                                            .toString()
                                            .replaceAll(".000Z", "")
                                            .replaceAll("T", "   "),
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: size.iScreen(1.5),
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold),
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
                  ),
                );
              },
            );
          },
        ),
      ),

      // =============================================//,
    );
  }
}
