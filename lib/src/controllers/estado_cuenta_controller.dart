import 'package:flutter/material.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/lista_allEstados_cuenta_cliente.dart';

class EstadoCuentaController extends ChangeNotifier{

  final _api = ApiProvider();
  
EstadoCuentaController(){
getEstadosDeCuentaClientes('');
}

//================================= OBTENEMOS TODAS LAS CONSIGNAS  ==============================//
  List<Result> _listaTodoslosEstadosdeCuentaCliente = [];
  List<Result> get getTodoslosEstadosdeCuentaCliente =>
      _listaTodoslosEstadosdeCuentaCliente;
  List<EstCuota> _listaTodasLasCuotasCliente = [];
  List<EstCuota> get getListaTodasLasCuotasCliente =>
      _listaTodasLasCuotasCliente;

  void setTodoslosEstadosdeCuentaCliente(List<Result> data) {
    _listaTodoslosEstadosdeCuentaCliente = data;
    // print('data : ${_listaTodoslosEstadosdeCuentaCliente}');
    notifyListeners();
  }

  bool? _errorAllEstadosCuenta; // sera nulo la primera vez
  bool? get getErrorAllEstadosCuenta => _errorAllEstadosCuenta;

  Future getEstadosDeCuentaClientes(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllEstadosdeCuentaClientes(
      cantidad: 100,
      page: 0,
      search: search,
      input: 'estId',
      orden: false,
      datos: '',
      rucempresa: '${dataUser!.rucempresa}',
      token: '${dataUser.token}',
    );

    if (response != null) {
      _errorAllEstadosCuenta = true;
      setTodoslosEstadosdeCuentaCliente(response.data.results);

for (var e in response.data.results) {
   _listaTodasLasCuotasCliente=e.estCuotas!;
 }


// for (var i = 0; i < count; i++) {
  
// }
      // _listaTodoslosEstadosdeCuentaCliente.forEach((e) {
      //   _listaTodasLasCuotasCliente=response.data.results.
      // })
      
//  print('-datos LISTA ->${_listaTodasLasCuotasCliente.length}');
//  print('-datos LISTA ->${_listaTodasLasCuotasCliente.length}');
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorAllEstadosCuenta = false;
      notifyListeners();
      return null;
    }
    return null;
  }







}