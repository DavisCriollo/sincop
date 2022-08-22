import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/models/crea_nuevo_pedido.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/utils/theme.dart';

class ListaPedidosDevolucionDTS extends DataTableSource {
  final BuildContext context;
  final LogisticaController logisticaController;
  //  final String? estadoPedido;
  final List? listaItemPedidoDevolucion;
  final Responsive size;

  ListaPedidosDevolucionDTS(
    this.size,
    this.context,
    this.listaItemPedidoDevolucion,
    this.logisticaController,
  );

  @override
  DataRow? getRow(int index) {
    listaItemPedidoDevolucion!.sort((a, b) => b['id'].compareTo(a['id']));

    final pedido = listaItemPedidoDevolucion![index];
    int _cantidadRestada = 0;
     int? _cantidadDevolucion ;
   
    // print('TITPO:${pedido['cantidadDevolucion'].runtimeType}');
    if(pedido['cantidadDevolucion'].runtimeType==int){
 print('si es INT');
    _cantidadRestada = int.parse(pedido['cantidad']) - (pedido['cantidadDevolucion']) as int;
    }
    else  if(pedido['cantidadDevolucion'].runtimeType==String){
   
    }

    // int? _cantidadDevolucion =
    //     int.parse(pedido['cantidadDevolucion'].toString());

    // _cantidadRestada = int.parse(pedido['cantidad']) - _cantidadDevolucion;

    if (int.parse(pedido['cantidad']) - int.parse(pedido['cantidadDevolucion']) > 0) {
      _cantidadRestada = int.parse(pedido['cantidad']) -
         int.parse((pedido['cantidadDevolucion']));
    } else  if (int.parse(pedido['cantidad']) - pedido['cantidadDevolucion'] == 0 || int.parse(pedido['cantidad']) - pedido['cantidadDevolucion'] < 0){
      _cantidadRestada = 0;
    }

    return DataRow.byIndex(
      index: index,
      cells: [
        //  estadoPedido=='Nuevo'?
        //  DataCell(
        //       Row(
        //         children: [
        //           const Icon(
        //             Icons.close_sharp,
        //             color: Color(0XFFEF5350),
        //           ),
        //           const SizedBox(width: 30.0),
        //           Text(pedido.nombre),
        //         ],
        //       ), onTap: () {

        //     final controllerCompras =
        //         Provider.of<LogisticaController>(context, listen: false);
        //     controllerCompras.eliminaPedidoAgregado(pedido.id);
        //         }
        //   ):
        DataCell(
            Row(
              children: [
                // const Icon(
                //   Icons.check_outlined,
                //   color: secondaryColor,
                // ),
                const SizedBox(width: 30.0),
                Text(
                  pedido['nombre'],
                  style: pedido['estado'] != 'PEDIDO'
                      ? const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        )
                      : GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.5),
                          // color: Colors.black45,
                          // fontWeight: FontWeight.bold,
                        ),
                )
              ],
            ),
            onTap: pedido['estado'] == 'PEDIDO'
                ? () {
                    logisticaController.agregarItemDevolucionPedido(pedido);

                    logisticaController.setItemscantidadDevolucion(
                        pedido['cantidad'].toString(),
                        pedido['cantidadDevolucion'].toString());
                    //  logisticaController.setItemCantidadDevolucion(pedido['cantidad']);
                    //  logisticaController.setItemCantidadDevolucion(logisticaController.getCantidadRestada.toString());
                    // logisticaController.setItemDevolucionDisponible(true);
                    _modalAgregaPedido(size, logisticaController, pedido);
                  }
                : null),
        DataCell(Text(_cantidadRestada.toString())),
        // DataCell(Text(pedido['tipo'])),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listaItemPedidoDevolucion!.length;

  @override
  int get selectedRowCount => 0;

//====== MUESTRA AGREGAR PEDIDO =======//
  void _modalAgregaPedido(Responsive size,
      LogisticaController logisticaController, dynamic pedido) {
    TextEditingController _cantidad = TextEditingController();
    @override
    void dispose() {
      _cantidad.clear();
      super.dispose();
    }

    logisticaController.resetItemDevolucion();
    logisticaController.setItemCantidadDevolucion(
        logisticaController.getCantidadRestada.toString());
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // print('DEVOLUCION: ${pedido['cantidadDevolucion']}');
          //  logisticaController.setItemsCantidadDevolucion();
          // logisticaController.setItemCantidadDevolucion(pedido['cantidad'].toString());
          // logisticaController.setItemscantidadDevolucion(pedido['cantidad'].toString(),pedido['cantidadDevolucion'].toString());
          // _cantidad.text = pedido['cantidad'];
          _cantidad.text = logisticaController.getCantidadRestada.toString();
          // logisticaController.setItemCantidadDevolucion(logisticaController.getCantidadRestada.toString());

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
                        Text('DEVOLVER PRODUCTO',
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
                              'Producto:',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          //***********************************************/
                          SizedBox(
                            height: size.iScreen(1.0),
                          ),
                          //*****************************************/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //***********************************************/
                              SizedBox(
                                height: size.iScreen(1.0),
                              ),
                              //*****************************************/
                              Expanded(
                                child: Text(
                                  '${pedido['nombre']}',
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.8),
                                    // color: Colors.black45,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              // Consumer<LogisticaController>(
                              //   builder: (_, value, __) {
                              //     return Expanded(
                              //       child: Text(
                              //         (value.getTipoPedido != '')
                              //             ? pedido.nombre
                              //             : ' ',
                              //         style: GoogleFonts.lexendDeca(
                              //           fontSize: size.iScreen(1.8),
                              //           // color: Colors.black45,
                              //           fontWeight: FontWeight.normal,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //***********************************************/
                    SizedBox(
                      height: size.iScreen(1.0),
                    ),
                    //*****************************************/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          // color: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.iScreen(1.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Stock:',
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

                              Text(
                                // '${pedido['cantidad']}',
                                logisticaController.getCantidadRestada
                                    .toString(),
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  // color: Colors.black45,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Consumer<LogisticaController>(
                                builder: (__, valueCantidad, Widget? child) {
                                  return SizedBox(
                                    width: size.iScreen(10.0),
                                    child: TextFormField(
                                      controller: _cantidad,
                                      // readOnly:
                                      //     valueCantidad.getTipoPedido == ''
                                      //         ? true
                                      //         : false,
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
                                        valueCantidad
                                            .setItemCantidadDevolucion(text);
                                        // final _estado=
                                        // valueCantidad.validaStock(text);
                                        // if(_estado==true){
                                        // print('@VERDADERO@ $_estado');

                                        // }else{
                                        // print('@FALSE@ $_estado');

                                        // }
                                      },
                                      validator: (text) {
                                        if (text!.trim().isNotEmpty) {
                                          return null;
                                        } else {
                                          return 'Cantidad inválida';
                                        }
                                      },
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
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
                        EdgeInsets.symmetric(horizontal: size.iScreen(14.0)),
                    //  width: size.iScreen(20.0),
                    height: size.iScreen(3.5),
                    child: Consumer<LogisticaController>(
                      builder: (_, itemProvider, __) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              itemProvider.getItemDevolucionDisponible == true
                                  ? primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          onPressed:
                              itemProvider.getItemDevolucionDisponible == true
                                  ? () {
                                      // itemProvider.agregarItemDevolucionPedido(pedido);
                                      itemProvider
                                          .agregaNuevoItemDevolucionPedido();
                                      // itemProvider.setItemCantidadDevolucion('');
                                      Navigator.pop(context);
                                    }
                                  : null,
                          // onPressed:  () {
                          //         itemProvider.agregarItemDevolucionPedido(pedido);
                          //       }

                          child: Text('Agregar',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
