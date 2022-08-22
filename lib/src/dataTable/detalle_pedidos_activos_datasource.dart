import 'package:flutter/material.dart';
// import 'package:sincop_app/src/controllers/logistica_controller.dart';
// import 'package:sincop_app/src/models/crea_nuevo_pedido.dart';
import 'package:sincop_app/src/utils/responsive.dart';
// import 'package:provider/provider.dart';

class ListaDetallepedidosActivosDTS extends DataTableSource {
  final BuildContext context;
  final List<dynamic> _listaPedidosActivos;
  final Responsive size;

  ListaDetallepedidosActivosDTS(this._listaPedidosActivos, this.size, this.context);

// final List<Map<String, dynamic>>itemsPedido=[];


  @override
  DataRow? getRow(int index) {


 _listaPedidosActivos.sort((a, b) => b['id'].compareTo(a['id']));
    return DataRow.byIndex(
      index: index,
      cells: [
         DataCell(Text(_listaPedidosActivos[index]['nombre'])),
        DataCell(Text(_listaPedidosActivos[index]['cantidad'])),
        // DataCell(Text(_listaPedidosActivos[index]['serie']!+null?_listaPedidosActivos[index]['serie']:'000')),
        DataCell(Text(_listaPedidosActivos[index]['serie'] ?? 'S/N')),
        
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listaPedidosActivos.length;

  @override
  int get selectedRowCount => 0;
}
