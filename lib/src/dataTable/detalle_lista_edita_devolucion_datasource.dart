import 'package:flutter/material.dart';
// import 'package:sincop_app/src/controllers/logistica_controller.dart';
// import 'package:sincop_app/src/models/crea_nuevo_pedido.dart';
import 'package:sincop_app/src/utils/responsive.dart';
// import 'package:provider/provider.dart';

class ListaDetalleEditaDevolucionPedidosDTS extends DataTableSource {
  final BuildContext context;
  final List<dynamic> _listaDevolucionPedidos;
  final Responsive size;

  ListaDetalleEditaDevolucionPedidosDTS(this._listaDevolucionPedidos, this.size, this.context);

// final List<Map<String, dynamic>>itemsPedido=[];


  @override
  DataRow? getRow(int index) {


 _listaDevolucionPedidos.sort((a, b) => b['id'].compareTo(a['id']));
    return DataRow.byIndex(
      index: index,
      cells: [
         DataCell(Text(_listaDevolucionPedidos[index]['nombre'])),
        DataCell(Text(_listaDevolucionPedidos[index]['cantidad'])),
        // DataCell(Text(_listaDevolucionPedidos[index]['serie']!+null?_listaDevolucionPedidos[index]['serie']:'000')),
        DataCell(Text(_listaDevolucionPedidos[index]['serie'] ?? 'S/N')),
        
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listaDevolucionPedidos.length;

  @override
  int get selectedRowCount => 0;
}
