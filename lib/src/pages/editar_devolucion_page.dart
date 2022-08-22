import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/dataTable/detalle_lista_edita_devolucion_datasource.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/dropdown_estado_devolucion.dart';
import 'package:sincop_app/src/widgets/no_data.dart';

class EditarDevolucionPage extends StatefulWidget {
  const EditarDevolucionPage({Key? key}) : super(key: key);

  @override
  State<EditarDevolucionPage> createState() => _EditarDevolucionPageState();
}

class _EditarDevolucionPageState extends State<EditarDevolucionPage> {
  bool _estadoDevolucionPedido = false;
  @override
  Widget build(BuildContext context) {
    final logisticaController =
        Provider.of<LogisticaController>(context, listen: false);
    Responsive size = Responsive.of(context);

    // List<String> data = [];
    // if (logisticaController.labelNombreEstadoDevolucionPedido == 'ENVIADO') {
    //   data.addAll(['RECIBIDO', 'ANULADO']);
    //   _estadoDevolucionPedido = true;
    // } else if (logisticaController.labelNombreEstadoDevolucionPedido == 'PENDIENTE') {
    //   data.add('ANULADO');
    //   _estadoDevolucionPedido = true;
    // }
    //  if (logisticaController.labelNombreEstadoDevolucionPedido == 'PENDIENTE') {
    // data.add('ANULADO');
    //   _estadoDevolucionPedido = true;
    // }
    List<dynamic> _listaPersonas = [];
    _listaPersonas = logisticaController.getDataDevolucion['disPersonas'];
    List<dynamic> _listaItemsDevoluciones = [];
    _listaItemsDevoluciones = logisticaController.getDataDevolucion['disPedidos'];

    // print('PERSONAS: $_listaPersonas');

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Editar Devolución',
          style: GoogleFonts.lexendDeca(
              fontSize: size.iScreen(2.45),
              color: Colors.white,
              fontWeight: FontWeight.normal),
        ),
        actions: [
          Consumer<LogisticaController>(builder: (_, valueInfo, __) {  
            return (valueInfo.getEstadoDevolucion==true)? 
              Container(
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
                ): const SizedBox();
          },),
          
              
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
        height: size.hScreen(100.0),
        child:
            // //*****************************************/
            SingleChildScrollView(
          child: Column(
            children: [
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
                          color: Colors.black87,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                    width: size.wScreen(60.0),
                    child: DropMenuEstadoDevolucionPedido(
                      // title: 'Tipo de documento:',
                      data: logisticaController.getDataEstadoDevolucion,
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
              //    //***********************************************/
              // SizedBox(
              //   height: size.iScreen(0.5),
              // ),
              // //*****************************************/
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
                  logisticaController.getDataDevolucion['disNombreCliente'],
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
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: size.iScreen(0.5), bottom: size.iScreen(0.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      'Personas: ',
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
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       top: size.iScreen(0.1),
                  //       bottom: size.iScreen(0.0)),
                  //   width: size.wScreen(100.0),
                  //   child: Text(
                  //     // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                  //     _infoPedido['disPersonas'][0]['nombres'],
                  //     style: GoogleFonts.lexendDeca(
                  //         fontSize: size.iScreen(1.5),
                  //         color: Colors.black87,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  Container(
                    height:
                        size.iScreen((_listaPersonas.length * 3).toDouble()),
                    child: ListView.builder(
                      itemCount:
                          _listaPersonas.length, // _listaPersonas.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(
                          // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                          _listaPersonas[0]['nombres'],
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.5),
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //*****************************************/
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
                           logisticaController.getDataDevolucion['disEntrega'],
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
                                'Observaciones: ',
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
                          width: size.wScreen(100.0),
                          child: Text(
                            // 'pedidodisEntrega dadas asdasd asda ad asdasd asdasd asdasd asdasd ' ,
                            logisticaController.getDataDevolucion['disObservacion'],
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
                        _listaItemsDevoluciones.isNotEmpty
                        ?Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.iScreen(0.5),
                                  bottom: size.iScreen(0.0)),
                              width: size.wScreen(100.0),
                              child: Text(
                                'Implementos: ',
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
                              source: ListaDetalleEditaDevolucionPedidosDTS(
                                  _listaItemsDevoluciones, size, context),
                              rowsPerPage: _listaItemsDevoluciones.length,
                            ))
                          ],
                        ):const NoData(label: 'No hay elementos para mostrar'),
                        //***********************************************/
                        SizedBox(
                          height: size.iScreen(0.5),
                        ),
                        //*****************************************/
            ],
          ),
        ),
        //***********************************************/,
      ),
    );
  }
    //********************************************************************************************************************//
  void _onSubmit(BuildContext context,LogisticaController logisticaController) async {
   
      if (logisticaController.getEstadoDevolucion==false) {
        NotificatiosnService.showSnackBarDanger('Debe seleccionar Estado');
      } else {
        await logisticaController.editarDevolucionPedido(context);

        Navigator.pop(context);
      }
    
  }
}
