import 'package:flutter/material.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/models/crea_nuevo_pedido.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class PedidosGuardiasDTS extends DataTableSource {
  final BuildContext context;
   final String? estadoPedido;
  final List<CreaNuevoItemPedido> nuevoPedido;
  final Responsive size;

  PedidosGuardiasDTS(this.nuevoPedido, this.size, this.context, this.estadoPedido);

  @override
  DataRow? getRow(int index) {

// print('=======> $estadoPedido');

    nuevoPedido.sort((a, b) => b.id.compareTo(a.id));
    final pedido = nuevoPedido[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        
       estadoPedido=='Nuevo'? DataCell(
            Row(
              children: [
                const Icon(
                  Icons.close_sharp,
                  color: Color(0XFFEF5350),
                ),
                const SizedBox(width: 30.0),
                Text(pedido.nombre),
              ],
            ), onTap: () {
             
          final controllerCompras =
              Provider.of<LogisticaController>(context, listen: false);
          controllerCompras.eliminaPedidoAgregado(pedido.id);
              }
        ):DataCell(  Row(
              children: [
                const Icon(
                  Icons.close_sharp,
                  color: Color(0XFFEF5350),
                ),
                const SizedBox(width: 30.0),
                Text(pedido.nombre),
              ],
            )),
        DataCell(Text(pedido.cantidad)),
        DataCell(Text(pedido.tipo)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => nuevoPedido.length;

  @override
  int get selectedRowCount => 0;
}
