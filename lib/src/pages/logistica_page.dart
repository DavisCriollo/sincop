import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/dataTable/pedidos_supervisor_datasource.dart';
import 'package:sincop_app/src/pages/buscar_guardias_pedidos.dart';
import 'package:sincop_app/src/pages/buscar_cliente_pedidos.dart';
import 'package:sincop_app/src/pages/detalle_pedido_guardia.dart';

import 'package:sincop_app/src/pages/view_pdf_page.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:sincop_app/src/urls/urls.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/dropdown_frecuencia_consigna_cliente.dart';
import 'package:sincop_app/src/widgets/dropdown_nombre_item_pedido.dart';
import 'package:sincop_app/src/widgets/dropdown_tipo_pedido.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LogisticaPage extends StatefulWidget {
  const LogisticaPage({Key? key}) : super(key: key);

  @override
  State<LogisticaPage> createState() => _LogisticaPageState();
}

class _LogisticaPageState extends State<LogisticaPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    //=====================================//
    //=====================================//
    final loadInfo = Provider.of<LogisticaController>(context, listen: false);
    final socketService = SocketService();
    socketService.socket!.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'pedido') {
        loadInfo.getTodosLosPedidosGuardias('');

        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    socketService.socket?.on('server:error', (data) {
      // NotificatiosnService.showSnackBarError(data['msg']??'');
      // print('IMPRiMO EL ERROR: ${data['msg']}');
      // print('IMPRiMO LA DATA: $data');
    });
    socketService.socket!.on('server:eliminadoExitoso', (data) async {
      if (data['tabla'] == 'pedido') {
        loadInfo.getTodosLosPedidosGuardias('');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    socketService.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'pedido') {
        loadInfo.getTodosLosPedidosGuardias('');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });

    loadInfo.getTodosLosPedidosGuardias('');
    loadInfo.getTodasLasDevoluciones('');
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final logisticaController =
        Provider.of<LogisticaController>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          // backgroundColor: primaryColor,
          title: Text(
            'Logística',
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
        ),
        body: DefaultTabController(
          length: 2,
          child: Container(
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
            child: Column(
              children: [
                SingleChildScrollView(
                  child: TabBar(
                    onTap: (index) {
                      // logisticaController.getTodosLosPedidosGuardias('');
                      // logisticaController.getTodasLasDistrubuciones('');

                      logisticaController.getTodosLosPedidosGuardias('');
                      logisticaController.getTodasLasDevoluciones('');

                      logisticaController.setIndexTapLogistica = index;
                      // logisticaController.onSearchText('');
                    },
                    indicatorColor: primaryColor,
                    labelColor: primaryColor,
                    unselectedLabelColor: primaryColor,
                    tabs: const [
                      Tab(text: 'PEDIDOS'),
                      Tab(text: 'DEVOLUCIONES'),
                      // Tab(text: 'DISTRIBUCIÓN'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Stack(
                        children: [
                          // =============================================//
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
                                if (providers.getErrorAllPedidos == null) {
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
                                } else if (providers.getErrorAllPedidos ==
                                    false) {
                                  return const NoData(
                                    label: 'No existen datos para mostar',
                                  );
                                } else if (providers
                                    .getListaTodosLosPedidosGuardias.isEmpty) {
                                  return const NoData(
                                    label: 'No existen datos para mostar',
                                  );
                                  // Text("sin datos");
                                }

                                return ListView.builder(
                                  itemCount: providers
                                      .getListaTodosLosPedidosGuardias.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
//                                         if(providers.getListaTodosLosPedidosGuardias[
//                                                       index]['disEstado'] !=
//                                                   'RECIBIDO'||providers.getListaTodosLosPedidosGuardias[
//                                                       index]['disEstado'] !=
//                                                   'ANULADO'){
// final estado= true;
//                                                   }

                                    final pedido = providers
                                        .getListaTodosLosPedidosGuardias[index];
                                    return Slidable(
                                      key: ValueKey(index),
                                     startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                    
                                        children: [
                                          
                                          (providers.getListaTodosLosPedidosGuardias[
                                                          index]['disEstado'] ==
                                                      'RECIBIDO' ||
                                                  providers.getListaTodosLosPedidosGuardias[
                                                          index]['disEstado'] ==
                                                      'ANULADO')
                                              ? Container()
                                              : SlidableAction(
                                                  backgroundColor:
                                                      Colors.purple,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                  // label: 'Editar',
                                                  onPressed: (context) {
                                                    // providers.setNuevoPedido();
                                    
                                                    providers
                                                        .resetValuesPedidos();
                                                    providers.infoPedidoEdicion(
                                                        pedido);
                                                    Navigator.pushNamed(context,
                                                        'editarPedidos');
                                    
                                                    //
                                                  },
                                                ),
                                    
                                          // SlidableAction(
                                          //   onPressed: (context) async {
                                          //     //  ProgressDialog.show(context);
                                          //     await providers.eliminaPedido(
                                          //         context, pedido['disId']);
                                          //     //     ProgressDialog.dissmiss(context);
                                          //   },
                                          //   backgroundColor:
                                          //       Colors.red.shade700,
                                          //   foregroundColor: Colors.white,
                                          //   icon: Icons.delete_forever_outlined,
                                          //   // label: 'Eliminar',
                                          // ),
                                    
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      DetallePedidoGuardia(
                                                          codigoPedido: pedido[
                                                              'disId']))));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: size.iScreen(0.5)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.iScreen(1.5),
                                              vertical: size.iScreen(0.5)),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          // color: Colors.red,
                                                          width: size.wScreen(15.0),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                       
                                                          child: Text(
                                                            'Tipo: ',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            '${pedido['disTipo']}',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          //  color: Colors.red,
                                                          width: size.wScreen(15.0),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            'Cliente: ',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                        Container(
                                                          // color: Colors.red,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          width: size
                                                              .wScreen(70.0),
                                                          child: Text(
                                                            '${pedido['disNombreCliente']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          //  color: Colors.red,
                                                          width: size.wScreen(15.0),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            'Entrega: ',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            '${pedido['disEntrega']}',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          //  color: Colors.red,
                                                          width: size.wScreen(15.0),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            'Estado: ',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          width: size
                                                              .wScreen(60.0),
                                                          child: Text(
                                                            '${pedido['disEstado']}',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size.iScreen(1.5),
                                                                color: (pedido['disEstado'] == 'ENVIADO')
                                                                    ? Colors.blue
                                                                    : (pedido['disEstado'] == 'PENDIENTE')
                                                                        ? Colors.orange
                                                                        : (pedido['disEstado'] == 'RECIBIDO')
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
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            'Fecha de registro: ',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            pedido['disFecReg']
                                                                .toString()
                                                                .replaceAll(
                                                                    ".000Z", "")
                                                                .replaceAll(
                                                                    "T", "   "),
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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

                          // =============================================//

                          Positioned(
                            bottom: 3.0,
                            right: 0.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: GestureDetector(
                                onTap: () {
                                  logisticaController.resetValuesPedidos();
                                  Navigator.pushNamed(context, 'creaPedido');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(size.iScreen(1.5)),
                                  color: primaryColor,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      // =======================TAB 2======================//
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: size.iScreen(0.0),
                        ),

                        // color: Colors.red,
                        width: size.wScreen(100.0),
                        height: size.hScreen(100.0),
                        child: Stack(
                          children: [
                            Consumer<LogisticaController>(
                              builder: (_, valueDevoluciones, __) {
                                if (valueDevoluciones.getErrorAllDistribucion ==
                                    null) {
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
                                } else if (valueDevoluciones
                                        .getErrorAllDistribucion ==
                                    false) {
                                  return const NoData(
                                    label: 'No existen datos para mostar',
                                  );
                                } else if (valueDevoluciones
                                    .getListaTodaLasDevoluciones.isEmpty) {
                                  return const NoData(
                                    label: 'No existen datos para mostar',
                                  );
                                  // Text("sin datos");
                                }

                                return ListView.builder(
                                  itemCount: valueDevoluciones
                                      .getListaTodaLasDevoluciones.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final devolucion = valueDevoluciones
                                        .getListaTodaLasDevoluciones[index];

                                    return Slidable(
                                      startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          // (valueDevoluciones.getListaTodosLosPedidosGuardias[index]['disEstado'] ==
                                          //             'RECIBIDO' ||
                                          //         valueDevoluciones
                                          //                     .getListaTodosLosPedidosGuardias[
                                          //                 index]['disEstado'] =='ANULADO')
                                          //         //         ||
                                          //         // valueDevoluciones
                                          //         //             .getListaTodosLosPedidosGuardias[
                                          //         //         index]['disEstado'] =='NO APROBADA')
                                          //     ? Container()
                                          //     :


                                      (devolucion['disEstado'] == 'PENDIENTE')?


                                               SlidableAction(
                                              backgroundColor: Colors.purple,
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              // label: 'Editar',
                                              onPressed: (context) {
                                                        // print('EDITAR: $devolucion');

                                                        valueDevoluciones.resetValuesPedidos();
                                                        valueDevoluciones.getInfoDevolucionPedido(devolucion);
                                                         Navigator.pushNamed(context, 'editarDevolucion');
                                              }):Container(),
                                         
                                         
                                         
                                         
                                         
                                          // SlidableAction(
                                          //   onPressed: (context) async {
                                          //     // ProgressDialog.show(context);
                                          //     // await multasControler.eliminaMultaGuardia(
                                          //     //     context, multas);
                                          //     ProgressDialog.dissmiss(context);
                                          //   },
                                          //   backgroundColor: Colors.red.shade700,
                                          //   foregroundColor: Colors.white,
                                          //   icon: Icons.delete_forever_outlined,
                                          //   // label: 'Eliminar',
                                          // ),
                                          //  SlidableAction(
                                          //         onPressed: (context) async {
                                          //           //  ProgressDialog.show(context);
                                          //           // await providers.eliminaPedido(
                                          //           //     context, pedido['disId']);
                                          //           // ProgressDialog.dissmiss(context);
                                          //           print('EDITAR');
                                          //         },
                                          //         backgroundColor: quinaryColor,
                                          //         foregroundColor: Colors.white,
                                          //         icon: Icons.edit,
                                          //         label: 'Editar',
                                          //       ),
                                        ],
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          top: size.iScreen(0.5),
                                          bottom: size.iScreen(0.0),
                                          left: size.iScreen(0.5),
                                          right: size.iScreen(0.5),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.iScreen(1.0),
                                            vertical: size.iScreen(0.5)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: const <BoxShadow>[
                                            // BoxShadow(
                                            //     color: Colors.black54,
                                            //     blurRadius: 1.0,
                                            //     offset: Offset(0.0, 1.0))
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: size
                                                                .iScreen(0.5),
                                                            bottom: size
                                                                .iScreen(0.0)),
                                                        // width: size.wScreen(100.0),
                                                        child: Text(
                                                          'Cliente: ',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          // color: Colors.red,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(55.0),
                                                          child: Text(
                                                            // 'SANI GROUP S.C',
                                                            '${devolucion['disNombreCliente']}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: size
                                                                .iScreen(0.5),
                                                            bottom: size
                                                                .iScreen(0.0)),
                                                        // width: size.wScreen(100.0),
                                                        child: Text(
                                                          'Fecha devolución : ',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            // '2022-08-02',
                                                            devolucion[
                                                                    'disFecReg']
                                                                .toString()
                                                                .replaceAll(
                                                                    "T", "  ")
                                                                .replaceAll(
                                                                    "000Z",
                                                                    " "),
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: size
                                                                .iScreen(0.5),
                                                            bottom: size
                                                                .iScreen(0.0)),
                                                        // width: size.wScreen(100.0),
                                                        child: Text(
                                                          'Productos : ',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: size
                                                                      .iScreen(
                                                                          0.5),
                                                                  bottom: size
                                                                      .iScreen(
                                                                          0.0)),
                                                          // width: size.wScreen(100.0),
                                                          child: Text(
                                                            // '7',
                                                            '${devolucion['disPedidos'].length}',
                                                            style: GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: size
                                                                .iScreen(0.5),
                                                            bottom: size
                                                                .iScreen(0.0)),
                                                        // width: size.wScreen(100.0),
                                                        child: Text(
                                                          'Estado: ',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: size
                                                                .iScreen(0.5),
                                                            bottom: size
                                                                .iScreen(0.0)),
                                                        width:
                                                            size.wScreen(60.0),
                                                        child:
                                                            //  Text(
                                                            //   '${pedido['disEstado']}',
                                                            //   style: GoogleFonts.lexendDeca(
                                                            //       fontSize: size.iScreen(1.5),
                                                            //       color: (pedido['disEstado'] == 'ENVIADO')
                                                            //           ? Colors.blue
                                                            //           : (pedido['disEstado'] == 'PENDIENTE')
                                                            //               ? Colors.orange
                                                            //               : (pedido['disEstado'] == 'RECIBIDO')
                                                            //                   ? Colors.green
                                                            //                   : Colors.red,
                                                            //       fontWeight: FontWeight.bold),
                                                            Text(
                                                          // 'RECIBIDO',
                                                          '${devolucion['disEstado']}',
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: size
                                                                      .iScreen(
                                                                          1.5),
                                                                  // color: Colors
                                                                  //     .green,
                                                                   color: (devolucion['disEstado'] == 'ENVIADO')
                                                                      ? Colors.blue
                                                                      : (devolucion['disEstado'] == 'PENDIENTE')
                                                                          ? Colors.orange
                                                                          : (devolucion['disEstado'] == 'RECIBIDO')
                                                                              ? Colors.green
                                                                              : Colors.red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Column(
                                            //   children: [
                                            //     Container(
                                            //       margin: EdgeInsets.only(
                                            //         right: size.iScreen(1.0),
                                            //         // top: size.iScreen(0.5),
                                            //         // bottom: size.iScreen(0.0)
                                            //       ),
                                            //       child: Text(
                                            //         'Progreso',
                                            //         style: GoogleFonts.lexendDeca(
                                            //             fontSize: size.iScreen(1.6),
                                            //             // color: Colors.black87,
                                            //             fontWeight: FontWeight.normal),
                                            //       ),
                                            //     ),
                                            //     Container(
                                            //       margin: EdgeInsets.only(
                                            //           right: size.iScreen(1.0),
                                            //           top: size.iScreen(0.5),
                                            //           bottom: size.iScreen(0.0)),
                                            //       // width: size.wScreen(100.0),
                                            //       child:
                                            //           // _trabajoCumplido==0?

                                            //           Text(

                                            //         // 'REALIZADO',
                                            //         _trabajoCumplido!,
                                            //         style: GoogleFonts.lexendDeca(
                                            //             fontSize: size.iScreen(1.5),
                                            //             color: _trabajoCumplido ==
                                            //                     'REALIZADO'
                                            //                 ? secondaryColor
                                            //                 : _trabajoCumplido ==
                                            //                         'EN PROGRESO'
                                            //                     ? tercearyColor
                                            //                     : _trabajoCumplido ==
                                            //                             'NO REALIZADO'
                                            //                         ? Colors.red
                                            //                         : Colors.red,
                                            //             fontWeight: FontWeight.bold),
                                            //       ),
                                            //       // :_trabajoCumplido==1?
                                            //       // Text(
                                            //       //   'EN PROGRESO',
                                            //       //   style: GoogleFonts.lexendDeca(
                                            //       //       fontSize: size.iScreen(1.5),
                                            //       //       color:_trabajoCumplido==1?tercearyColor:secondaryColor,
                                            //       //       fontWeight: FontWeight.bold),
                                            //       // ):_trabajoCumplido==2?
                                            //       // Text(
                                            //       //   'NO REALIZADO',
                                            //       //   style: GoogleFonts.lexendDeca(
                                            //       //       fontSize: size.iScreen(1.5),
                                            //       //       color: Colors.red,
                                            //       //       fontWeight: FontWeight.bold),
                                            //       // ):
                                            //       // Text(
                                            //       //   'NO REALIZADO',
                                            //       //   style: GoogleFonts.lexendDeca(
                                            //       //       fontSize: size.iScreen(1.5),
                                            //       //       color: Colors.red,
                                            //       //       fontWeight: FontWeight.bold),
                                            //       // ),
                                            //     ),
                                            //   ],
                                            // )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                               // =============================================//
                                    Positioned(
                                      bottom: 3.0,
                                      right: 0.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: GestureDetector(
                                          onTap: () {
                                            // logisticaController.resetValuesPedidos();
                                            // Navigator.pushNamed(context, 'creaPedido');

                                            // providers.setNuevoPedido();

                                            logisticaController
                                                .getTodosLosPedidosActivos('');
                                            Navigator.pushNamed(
                                                context, 'listaDePedidos');
                                          },
                                          child: Container(
                                            padding:
                                                EdgeInsets.all(size.iScreen(1.5)),
                                            color: secondaryColor,
                                            child: const Icon(
                                              Icons.list_alt_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    // =============================================//
                          ],
                        ),
                      ),

                      // =======================TAB 3======================//
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //     horizontal: size.iScreen(1.0),
                      //   ),

                      //   // color: Colors.red,
                      //   width: size.wScreen(100.0),
                      //   height: size.hScreen(100.0),

                      //   child: Consumer<LogisticaController>(
                      //     builder: (_, providers, __) {
                      //       print('redibujo1');
                      //       if (providers.getErrorAllDistribucion == null) {
                      //         return const Center(
                      //           child: CircularProgressIndicator(),
                      //         );
                      //       } else if (providers.getErrorAllDistribucion ==
                      //           false) {
                      //         return const NoData(
                      //           label: 'No existen datos para mostar',
                      //         );
                      //       } else if (providers
                      //           .getListaTodaLasDistrubuciones.isEmpty) {
                      //         return const NoData(
                      //           label: 'No existen datos para mostar',
                      //         );
                      //         // Text("sin datos");
                      //       }

                      //       return ListView.builder(
                      //         itemCount: providers
                      //             .getListaTodaLasDistrubuciones.length,
                      //         itemBuilder: (BuildContext context, int index) {
                      //           final pedido = providers
                      //               .getListaTodaLasDistrubuciones[index];
                      //           return Slidable(
                      //             key: ValueKey(index),
                      //             // The start action pane is the one at the left or the top side.
                      //             startActionPane: ActionPane(
                      //               // A motion is a widget used to control how the pane animates.
                      //               motion: const ScrollMotion(),

                      //               // // A pane can dismiss the Slidable.
                      //               // dismissible: DismissiblePane(onDismissed: () {}),

                      //               // All actions are defined in the children parameter.
                      //               children: [
                      //                 // A SlidableAction can have an icon and/or a label.
                      //                 SlidableAction(
                      //                   backgroundColor: Colors.purple,
                      //                   foregroundColor: Colors.white,
                      //                   icon: Icons.edit,
                      //                   // label: 'Editar',
                      //                   onPressed: (context) {
                      //                     //  Navigator.push(
                      //                     //         context,
                      //                     //         MaterialPageRoute(
                      //                     //             builder: ((context) =>
                      //                     //                 EditarConsignaClientePage(
                      //                     //                   infoConsignaCliente: consigna,
                      //                     //                   accion: 'Editar',
                      //                     //                 ))));
                      //                   },
                      //                 ),
                      //                 SlidableAction(
                      //                   onPressed: (context) async {
                      //                     //  ProgressDialog.show(context);
                      //                     //     await pedidosControler.eliminaConsignaCliente(
                      //                     //         context, consigna);
                      //                     //     ProgressDialog.dissmiss(context);
                      //                   },
                      //                   backgroundColor: Colors.red.shade700,
                      //                   foregroundColor: Colors.white,
                      //                   icon: Icons.delete_forever_outlined,
                      //                   // label: 'Eliminar',
                      //                 ),
                      //                 // SlidableAction(
                      //                 //   onPressed: (context) {
                      //                 //     Navigator.pushNamed(context, 'consignacionLeidaCliente');
                      //                 //   },
                      //                 //   backgroundColor: Colors.green,
                      //                 //   foregroundColor: Colors.white,
                      //                 //   icon: Icons.remove_red_eye_outlined,
                      //                 //   // label: 'Eliminar',
                      //                 // ),
                      //               ],
                      //             ),
                      //             child: GestureDetector(
                      //               onTap: () {
                      //                 //  Navigator.push(
                      //                 //         context,
                      //                 //         MaterialPageRoute(
                      //                 //             builder: ((context) =>
                      //                 //                 ConsignaLeidaClientePage(
                      //                 //                     infoConsignaCliente: consigna))));
                      //               },
                      //               child: Container(
                      //                 margin: EdgeInsets.only(
                      //                     top: size.iScreen(0.5)),
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: size.iScreen(1.5),
                      //                     vertical: size.iScreen(0.5)),
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //                 child: Row(
                      //                   children: [
                      //                     Expanded(
                      //                       child: Column(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.start,
                      //                         children: [
                      //                           Row(
                      //                             children: [
                      //                               Container(
                      //                                 margin: EdgeInsets.only(
                      //                                     top:
                      //                                         size.iScreen(0.5),
                      //                                     bottom: size
                      //                                         .iScreen(0.0)),
                      //                                 // width: size.wScreen(100.0),
                      //                                 child: Text(
                      //                                   'Tipo: ',
                      //                                   style: GoogleFonts
                      //                                       .lexendDeca(
                      //                                           fontSize: size
                      //                                               .iScreen(
                      //                                                   1.5),
                      //                                           color: Colors
                      //                                               .black87,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .normal),
                      //                                 ),
                      //                               ),
                      //                               Container(
                      //                                 margin: EdgeInsets.only(
                      //                                     top:
                      //                                         size.iScreen(0.5),
                      //                                     bottom: size
                      //                                         .iScreen(0.0)),
                      //                                 // width: size.wScreen(100.0),
                      //                                 child: Text(
                      //                                   '${pedido['disTipo']}',
                      //                                   style: GoogleFonts
                      //                                       .lexendDeca(
                      //                                           fontSize: size
                      //                                               .iScreen(
                      //                                                   1.5),
                      //                                           color: Colors
                      //                                               .black87,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .bold),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                           Row(
                      //                             children: [
                      //                               Container(
                      //                                 margin: EdgeInsets.only(
                      //                                     top:
                      //                                         size.iScreen(0.5),
                      //                                     bottom: size
                      //                                         .iScreen(0.0)),
                      //                                 // width: size.wScreen(100.0),
                      //                                 child: Text(
                      //                                   'Cliente: ',
                      //                                   style: GoogleFonts
                      //                                       .lexendDeca(
                      //                                           fontSize: size
                      //                                               .iScreen(
                      //                                                   1.5),
                      //                                           color: Colors
                      //                                               .black87,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .normal),
                      //                                 ),
                      //                               ),
                      //                               Container(
                      //                                 // color: Colors.red,
                      //                                 margin: EdgeInsets.only(
                      //                                     top:
                      //                                         size.iScreen(0.5),
                      //                                     bottom: size
                      //                                         .iScreen(0.0)),
                      //                                 width: size.wScreen(70.0),
                      //                                 child: Text(
                      //                                   '${pedido['disNombreCliente']}',
                      //                                   overflow: TextOverflow
                      //                                       .ellipsis,
                      //                                   style: GoogleFonts
                      //                                       .lexendDeca(
                      //                                           fontSize: size
                      //                                               .iScreen(
                      //                                                   1.5),
                      //                                           color: Colors
                      //                                               .black87,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .bold),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                           Row(
                      //                             children: [
                      //                               Container(
                      //                                 margin: EdgeInsets.only(
                      //                                     top:
                      //                                         size.iScreen(0.5),
                      //                                     bottom: size
                      //                                         .iScreen(0.0)),
                      //                                 // width: size.wScreen(100.0),
                      //                                 child: Text(
                      //                                   'Entrega: ',
                      //                                   style: GoogleFonts
                      //                                       .lexendDeca(
                      //                                           fontSize: size
                      //                                               .iScreen(
                      //                                                   1.5),
                      //                                           color: Colors
                      //                                               .black87,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .normal),
                      //                                 ),
                      //                               ),
                      //                               Container(
                      //                                 margin: EdgeInsets.only(
                      //                                     top:
                      //                                         size.iScreen(0.5),
                      //                                     bottom: size
                      //                                         .iScreen(0.0)),
                      //                                 // width: size.wScreen(100.0),
                      //                                 child: Text(
                      //                                   '${pedido['disEntrega']}',
                      //                                   style: GoogleFonts
                      //                                       .lexendDeca(
                      //                                           fontSize: size
                      //                                               .iScreen(
                      //                                                   1.5),
                      //                                           color: Colors
                      //                                               .black87,
                      //                                           fontWeight:
                      //                                               FontWeight
                      //                                                   .bold),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
