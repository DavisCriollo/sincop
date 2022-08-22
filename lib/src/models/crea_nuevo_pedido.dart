// class CreaNuevoItemPedido {
//   int id;
//   // int? cantidadDevolucion;
//   String nombre, cantidad,tipo,serie,idProduct;
//   // String nombre, cantidad,tipo,serie,pedido;
//   // String pedido;

//   CreaNuevoItemPedido(this.id, this.nombre, this.cantidad,this.tipo,this.serie,this.idProduct);
//   // CreaNuevoItemPedido(this.id,this.cantidadDevolucion, this.nombre, this.cantidad,this.tipo,this.serie,this.pedido);

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'nombre': nombre,
//       'cantidad': cantidad,
//       'tipo': tipo,
//       'serie': serie,
//       'idProduct': idProduct,
//         };
//     // return {
//     //   'id': id,
//     //   'nombre': nombre,
//     //   'cantidad': cantidad,
//     //   'tipo': tipo,
//     //   'serie': serie,
//     //   "estado":pedido,
//     //   "cantidadDevolucion": 0
//     //     };
//   }
// }
class CreaNuevoItemPedido {
  int id;
  int? cantidadDevolucion=0;
  // String nombre, cantidad,tipo,serie,idProduct;
  String nombre, cantidad,tipo,serie,pedido;
  // String pedido;

  // CreaNuevoItemPedido(this.id, this.nombre, this.cantidad,this.tipo,this.serie,this.pedido,);
  CreaNuevoItemPedido(this.id,this.cantidadDevolucion, this.nombre, this.cantidad,this.tipo,this.serie,this.pedido);

  Map<String, dynamic> toJson() {
    // return {
    //   'id': id,
    //   'nombre': nombre,
    //   'cantidad': cantidad,
    //   'tipo': tipo,
    //   'serie': serie,
    //   'idProduct': idProduct,
    //     };
    return {
      'id': id,
      'nombre': nombre,
      'cantidad': cantidad,
      'tipo': tipo,
      'serie': serie,
      "estado":pedido,
      "cantidadDevolucion": cantidadDevolucion
        };
  }
}
