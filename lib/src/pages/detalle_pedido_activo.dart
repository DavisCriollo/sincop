import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/dataTable/detalle_pedidos_activos_datasource.dart';
import 'package:sincop_app/src/dataTable/lista_pedidos_datasource.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';

class DetallePedidoActivo extends StatefulWidget {
  final int? codigoPedido;
  const DetallePedidoActivo({Key? key, this.codigoPedido}) : super(key: key);

  @override
  State<DetallePedidoActivo> createState() => _DetallePedidoActivoState();
}

class _DetallePedidoActivoState extends State<DetallePedidoActivo> {
  @override
  Widget build(BuildContext context) {
// print('ID: ${widget.codigoPedido}');
    final _infoPedido = {};
    final List<dynamic> _listaPedidos = [];

    final pedidoController =
        Provider.of<LogisticaController>(context, listen: false);
    final Responsive size = Responsive.of(context);
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        // backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: Text(
          'Detalle de Pedido',
          style: GoogleFonts.lexendDeca(
              fontSize: size.iScreen(2.8),
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
        //  actions: [
        //   //  IconButton(onPressed: (){}, icon: icon)
        //  ],
      ),
      body: FutureBuilder(
        future: pedidoController.getTodosLosPedidosActivos(''),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            for (var e in pedidoController.getListaTodosLosPedidosActivos) {
              if (e['disId'] == widget.codigoPedido) {
                _infoPedido.addAll(e);
                _listaPedidos.addAll(e['disPedidos']);
                //  print('object: ${_listaPedidos.length}');
                return Container(
                  // color: Colors.red,
                  margin: EdgeInsets.symmetric(horizontal: size.iScreen(0.0)),
                  padding: EdgeInsets.only(
                    // top: size.iScreen(0.5),
                    left: size.iScreen(0.5),
                    right: size.iScreen(0.5),
                    // bottom: size.iScreen(0.5),
                  ),
                  width: size.wScreen(100.0),
                  height: size.hScreen(100),
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
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
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
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
                              width: size.wScreen(60.0),
                              child: Text(
                                '${_infoPedido['disEstado']}',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.5),
                                    color:
                                        (_infoPedido['disEstado'] == 'ENVIADO')
                                            ? Colors.blue
                                            : (_infoPedido['disEstado'] ==
                                                    'PENDIENTE')
                                                ? Colors.orange
                                                : (_infoPedido['disEstado'] ==
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
                              top: size.iScreen(0.5),
                              bottom: size.iScreen(0.0)),
                          width: size.wScreen(100.0),
                          child: Text(
                            'Cliente: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                               color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                        ),//***********************************************/
                        SizedBox(
                          height: size.iScreen(0.5),
                        ),
                        //*****************************************/
                        Container(
                          margin: EdgeInsets.only(
                              top: size.iScreen(0.1),
                              bottom: size.iScreen(0.0)),
                          width: size.wScreen(100.0),
                          child: Text(
                            // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                            _infoPedido['disNombreCliente'],
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: size.iScreen(0.5),
                              bottom: size.iScreen(0.0)),
                          width: size.wScreen(100.0),
                          child: Text(
                            'Guardia: ',
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
                              top: size.iScreen(0.1),
                              bottom: size.iScreen(0.0)),
                          width: size.wScreen(100.0),
                          child: Text(
                            // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                            _infoPedido['disPersonas'][0]['nombres'],
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
                              // width: size.wScreen(100.0),
                              child: Text(
                                'Tipo de entrega: ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.5),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                              Container(
                          margin: EdgeInsets.only(
                              top: size.iScreen(0.1),
                              bottom: size.iScreen(0.0)),
                          // width: size.wScreen(100.0),
                          child: Text(
                            // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                            _infoPedido['disEntrega'],
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                                color: Colors.black87,
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
                              top: size.iScreen(0.5),
                              bottom: size.iScreen(0.0)),
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
                              top: size.iScreen(0.1),
                              bottom: size.iScreen(0.0)),
                          width: size.wScreen(100.0),
                          child: Text(
                            // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                            _infoPedido['disObservacion'],
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
                              top: size.iScreen(0.5),
                              bottom: size.iScreen(0.0)),
                          width: size.wScreen(100.0),
                          child: Text(
                            'Pedidos: ',
                            style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.5),
                                color: Colors.black87,
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
                                top: size.iScreen(0.1),
                                bottom: size.iScreen(0.0)),
                            width: size.wScreen(100.0),
                            child: PaginatedDataTable(
                              arrowHeadColor:primaryColor,
                              columns: [
                                DataColumn(
                                    label: Text('Nombre',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    numeric: true,
                                    label: Text('Cantidad',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                                DataColumn(
                                    label: Text('Serie',
                                        style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey))),
                              ],
                              source: ListaDetallepedidosActivosDTS(
                                  _listaPedidos, size, context),
                              rowsPerPage: _listaPedidos.length,
                            )),
                        //***********************************************/
                        SizedBox(
                          height: size.iScreen(1.0),
                        ),
                        //*****************************************/
                      ],
                    ),
                  ),
                );
              }
            }
          }
          return Container();
        },
      ),
    );
  }
}
