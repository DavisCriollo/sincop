import 'package:flutter/material.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/models/crea_nuevo_pedido.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class ListaPedidosGuardiasDTS extends DataTableSource {
  final BuildContext context;
  final List<dynamic> _listaPedidos;
  final Responsive size;

  ListaPedidosGuardiasDTS(this._listaPedidos, this.size, this.context);

// final List<Map<String, dynamic>>itemsPedido=[];


  @override
  DataRow? getRow(int index) {


 _listaPedidos.sort((a, b) => b['id'].compareTo(a['id']));
    return DataRow.byIndex(
      index: index,
      cells: [
         DataCell(Text(_listaPedidos[index]['nombre'])),
        DataCell(Text(_listaPedidos[index]['cantidad'])),
        // DataCell(Text(_listaPedidos[index]['serie']!+null?_listaPedidos[index]['serie']:'000')),
        DataCell(Text(_listaPedidos[index]['serie'] ?? 'S/N')),
        
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _listaPedidos.length;

  @override
  int get selectedRowCount => 0;
}
