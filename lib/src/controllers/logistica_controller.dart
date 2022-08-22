import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sincop_app/src/api/api_provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/models/agregar_item_devolucion.dart';
import 'package:sincop_app/src/models/crea_nuevo_pedido.dart';
import 'package:sincop_app/src/models/list_allGuardiasPedido.dart';
import 'package:sincop_app/src/models/list_allClientePedido.dart';
import 'package:sincop_app/src/models/list_allImplemento_pedido.dart';

import 'package:sincop_app/src/service/socket_service.dart';
import 'package:provider/provider.dart';
// import 'package:pazviseg_app/src/models/lista_allClientes.dart';

class LogisticaController extends ChangeNotifier {
  GlobalKey<FormState> pedidoGuardiaFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> validaNuevoPedidoGuardiaFormKey = GlobalKey<FormState>();
  final _api = ApiProvider();

  void resetValuesPedidos() {
    _docCliente = '';
    _nomCliente = '';
    _docCliente = '';
    _nomCliente = '';

    _docGuardia = '';
    _nomGuardia = '';
    // _labelEntrega;
    // _labelValorEntrega;
   
    _itemCantidad;
    _labelPedido;
    _nuevoPedido.clear();
    _listaGuardiaVarios.clear();
    _listaItemsProductos.clear();
    _pedidoDevolucion = '';
    _itemDevolucionDisponible = false;
    _nuevoItemDevolucionPedido.clear();
    _labelNombreEstadoDevolucionPedido;
    _estadoDevolucion=false;
    _labelNombreEstado;
    notifyListeners();
  }

  //===================OBTENEMOS EL IDE DEL TAB PARA LA BUSQUEDA==========================//
  int? _indexTapLogistica = 0;
  int? get getIndexTapLogistica => _indexTapLogistica;

  set setIndexTapLogistica(int value) {
    _indexTapLogistica = value;
    if (_indexTapLogistica == 0) {
      getTodosLosPedidosGuardias('');
      notifyListeners();
    } else if (_indexTapLogistica == 1) {
      getTodasLasDevoluciones('');
      notifyListeners();
    }

    // print('-----ss:$_indexTapLogistica');
    // notifyListeners();
  }

  void resetBusquedaImplemento() {
    _implementoItem = '';
    _tipoPedido = '';
    _seriePedido = '';
    _idInvProductoPedido = '';
    _cantidadDevolucionPedido;
    _estadoPedido = '';
    notifyListeners();
  }

  bool validateForm() {
    if (pedidoGuardiaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateFormValidaMulta() {
    if (validaNuevoPedidoGuardiaFormKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

//======================================== RADIO BUTTON ENTREGA=======================//
  // var _labelEntrega ='DESCUENTO';
  // var _labelValorEntrega=2 ;
  var _labelEntrega;
  var _labelValorEntrega;
  DateTime? _fechaActual;
  String? _fechaActualParse;

  String? get labelEntrega => _labelEntrega;
  get labelValorEntrega => _labelValorEntrega;

  void setLabelEntrega(value) {
    _labelValorEntrega = value;
    _labelEntrega = (value == 1) ? 'DOTACIÓN' : 'DESCUENTO';

    notifyListeners();
  }

//========================== TIPO DE IMPLEMETO =======================//s
  String? _tipoPedido = '';
  String? get getTipoPedido => _tipoPedido;

  void setTipoImplemento(String value) {
    _tipoPedido = value;
    // print('---pedido--ss:$_tipoPedido');
    notifyListeners();
  }

  String? _seriePedido = '';
  String? get getSeriePedido => _seriePedido;

  void setSeriePedido(String value) {
    _seriePedido = value;
    // print('---pedido--ss:$_tipoPedido');
    notifyListeners();
  }

  String? _estadosPedido = '';
  String? get getEstadosPedido => _estadosPedido;

  void setEstadosedido(String value) {
    _estadosPedido = value;
    // print('---pedido--ss:$_tipoPedido');
    notifyListeners();
  }

  int? _cantidadDevolucionPedido;
  int? get getCantidadDevolucionPedido => _cantidadDevolucionPedido;

  void setCantidadDevolucionPedido(int? value) {
    _cantidadDevolucionPedido = value;
    // print('---pedido--ss:$_tipoPedido');
    notifyListeners();
  }

  String? _idInvProductoPedido = '';
  String? get getidProductoPedido => _idInvProductoPedido;

  void setidProductoPedido(String value) {
    _idInvProductoPedido = value;
    // print('---pedido--ss:$_tipoPedido');
    notifyListeners();
  }
  // String? _idInvProductoPedido = '';
  // String? get getidProductoPedido => _idInvProductoPedido;

  // void setidProductoPedido(String value) {
  //   _idInvProductoPedido = value;
  //   // print('---pedido--ss:$_tipoPedido');
  //   notifyListeners();
  // }

  String? _labelPedido;
  String? get labelPedidoGuardia => _labelPedido;

  void setLabelPedidoGuardia(String value) {
    _labelPedido = value;
    // print('---pedido--ss:$_labelPedido');
    notifyListeners();
  }

//========================== DROPDOWN PERIODO  CLIENTE =======================//
  String? _labelNombreEstado;

  String? get labelNombreEstado => _labelNombreEstado;

  void setLabelNombreEstado(String value) async {
    _labelNombreEstado = value;
    if (_labelNombreEstado == 'RECIBIDO') {
      //    _fechaActual= DateTime.now();
      //    final DateFormat formatter = DateFormat('yyyy-MM-ddThh:mm');
      // _fechaActualParse = formatter.format(_fechaActual!);

      _fechaActualParse =
          '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm').format(DateTime.now())}';
print('_fechaActualParse: $_fechaActualParse');

    }
    print('Estado:$_labelNombreEstado');
    notifyListeners();
  }

//========================== CREA NUEVO ITEM PEDIDO =======================//

  int idItem = 0;
// String?_nombre,_tipo,_cantidad;

  final List<CreaNuevoItemPedido> _nuevoPedido = [];
  List<CreaNuevoItemPedido> get getNuevoPedido => _nuevoPedido;

  void setNuevoPedido(CreaNuevoItemPedido pedido) {
    _nuevoPedido.add(pedido);

    notifyListeners();
  }

  // void agregaNuevoPedido() {
  //   _nuevoPedido.add(
  //     CreaNuevoItemPedido(
  //       idItem,
  //       '$_implementoItem',
  //       '$_itemCantidad',
  //       '$_tipoPedido',
  //       '$_seriePedido',
  //       '$_idInvProductoPedido',
  //     ),
  //   );
  //   idItem = idItem + 1;

  //   // print('ID:$idItem');
  //   // sumatoria() ;
  //   notifyListeners();
  // }
  void agregaNuevoPedido() {
    _nuevoPedido.add(
      CreaNuevoItemPedido(
        int.parse(_idInvProductoPedido!),
        0,
        '$_implementoItem',
        '$_itemCantidad',
        '$_tipoPedido',
        '$_seriePedido',
        "PEDIDO",
      ),
    );
    // idItem = idItem + 1;

    // print('ID:${int.parse(_idInvProductoPedido!).runtimeType},');
    // sumatoria() ;
    notifyListeners();
  }

//============ELIMINA ELEMENTO DE LA LISTA DE RTENCIONES=====================//

  void eliminaPedidoAgregado(int rowSelect) {
    // print('IDrowddddSelect:$rowSelect');
    _nuevoPedido.removeWhere((e) => e.id == rowSelect);
//  sumatoria() ;
    notifyListeners();
  }

//================================== OBTENEMOS TODOS LOS PEDIDOS DE LOS GUARDIAS  ==============================//
  List<dynamic> _listaTodosLosPedidosGuardias = [];
  List<dynamic> get getListaTodosLosPedidosGuardias =>
      _listaTodosLosPedidosGuardias;

  void setListaTodosLosPedidosGuardias(List<dynamic> data) {
    _listaTodosLosPedidosGuardias = data;
// print('LISTA PEDIDOS : $_listaTodosLosPedidosGuardias');
    notifyListeners();
  }

  bool? _errorAllPedidos; // sera nulo la primera vez
  bool? get getErrorAllPedidos => _errorAllPedidos;

  Future getTodosLosPedidosGuardias(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllPedidos(
      search: search,
      tipo: 'PEDIDO',
      token: '${dataUser!.token}',
    );

    if (response != null) {
      _errorAllPedidos = true;

      setListaTodosLosPedidosGuardias(response['data']);
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorAllPedidos = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//================================== OBTENEMOS TODAS LAS DEVOLUCIONES  ==============================//
  List<dynamic> _listaTodaslasDevoluciones = [];
  List<dynamic> get getListaTodaLasDevoluciones => _listaTodaslasDevoluciones;

  void setListaTodasLasDevoluciones(List<dynamic> data) {




    _listaTodaslasDevoluciones = data;
    // print('LISTA DEVOLUCIONES : $_listaTodaslasDevoluciones');
    notifyListeners();
  }

  bool? _errorAllDevolucion; // sera nulo la primera vez
  bool? get getErrorAllDistribucion => _errorAllDevolucion;

  Future getTodasLasDevoluciones(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllDistribucion(
      search: search,
      tipo: 'DEVOLUCION',
      token: '${dataUser!.token}',
    );

    if (response != null) {
      _errorAllDevolucion = true;

      setListaTodasLasDevoluciones(response['data']);
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorAllDevolucion = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//================================== OBTENEMOS TODAS LAS DEVOLUCIONES  ==============================//
  List<dynamic> _listaTodosLosPedidosActivos = [];
  List<dynamic> get getListaTodosLosPedidosActivos =>
      _listaTodosLosPedidosActivos;

  void setListaTodosLosPedidosActivos(List<dynamic> data) {
    _listaTodosLosPedidosActivos = data;
    // print('LISTA DEVOLUCIONES : $_listaTodosLosPedidosActivos');
    notifyListeners();
  }

  bool? _errorAllPedidosActivos; // sera nulo la primera vez
  bool? get getErrorAllPedidosActivos => _errorAllPedidosActivos;

  Future getTodosLosPedidosActivos(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllPedidosActivos(
      search: search,
      tipo: 'DEVOLUCION',
      token: '${dataUser!.token}',
    );

    if (response != null) {
      _errorAllPedidosActivos = true;

      setListaTodosLosPedidosActivos(response['data']);
      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorAllPedidosActivos = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//  =================  CREO UN DEBOUNCE ==================//

  Timer? _deboucerSearchBuscaImplementoPedido;

  @override
  void dispose() {
    _deboucerSearchBuscaImplementoPedido?.cancel();
    _deboucerSearchBuscaClientePedidos?.cancel();
    _deboucerSearchBuscaGuardiasPedido?.cancel();
    _deboucerValidaStockItemPedido?.cancel();
    _deboucerValidaStockItemDevolucionPedido?.cancel();

    // _videoController.dispose();
    super.dispose();
  }

  String? _inputBuscaImplemento;
  get getInputBuscaGuardia => _inputBuscaImplemento;
  void onInputBuscaGuardiaChange(String? text) {
    _inputBuscaImplemento = text;
    // print('GUSCA GUARDIA MULTA :$_inputBuscaImplemento');

//================================================================================//
    if (_inputBuscaImplemento!.length >= 3) {
      _deboucerSearchBuscaImplementoPedido?.cancel();
      _deboucerSearchBuscaImplementoPedido =
          Timer(const Duration(milliseconds: 500), () {
        buscaImplementoPedido(_inputBuscaImplemento);
        // print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaImplemento!.isEmpty) {
      buscaImplementoPedido('');
    } else {
      buscaImplementoPedido('');
    }

    notifyListeners();
  }
//================================================================================//

  List<Implemento> _listaImplementoPedido = [];
  // List<TipoMulta> get getListaTodosLosTiposDeMultas => _listaTodosLosTiposDeMultas;
  List<Implemento> get getListaImplementoPedido => _listaImplementoPedido;

  void setInfoBusquedaImplementoPedido(List<Implemento> data) {
    _listaImplementoPedido = data;
    // print('Lista dde guardias : ${_listaImplementoPedido}');
    notifyListeners();
  }

  bool? _errorInfoImplementoPedido; // sera nulo la primera vez
  bool? get getErrorImplementoPedido => _errorInfoImplementoPedido;
  setErrorInfoImplementoPedido(bool? value) {
    _errorInfoImplementoPedido = value;
    notifyListeners();
  }

  Future<AllImplementoPedido?> buscaImplementoPedido(String? _search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllImplementoPedido(
      search: _search,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoImplementoPedido = true;
      // setInfoBusquedaImplementoPedido(response.data);
      // setIdPersonaMulta = response.data[0].perId;
      // setCedPersonaMulta = response.data[0].perDocNumero;
      // print('${response.data[0].perNombres} ${response.data[0].perApellidos}');
      //  _listaImplementoPedido=response.data;
      setInfoBusquedaImplementoPedido(response.data);

      // notifyListeners();
      // return response;
    }
    if (response == null) {
      _errorInfoImplementoPedido = false;
      notifyListeners();
      return null;
    }
  }

  //========================== DROPDOWN  =======================//
  Implemento? implemento;

  String? _implementoItem = '';

  String? get getImplementoItem => _implementoItem;
  String? _stockItem = '';

  String? get getStockItem => _implementoItem;
  //========================== OBTENEMOS LA INFORMACION DEL ITEM SELECCIONADO  =======================//
  void getImplemento(Implemento implemento) {
    _implementoItem = implemento.invNombre;
    _tipoPedido = implemento.invTipo;
    _seriePedido = implemento.invSerie;
    _idInvProductoPedido = implemento.invId.toString();
    _stockItem = implemento.invStock;
    // print('-----ID:$_idInvProductoPedido');
    // print('-----NOMBRE:$_implementoItem');
    // print('-----TIPO:$_tipoPedido');
    // print('-----SERIE:$_seriePedido');
    // print('-----SERIE:$_seriePedido');
    // print('-----STOCK item:$_stockItem');
    notifyListeners();
  }

  //========================== VALIDO EL STOCK  DEL ITEM SELECCIONADO  =======================//

//  =================  CREO UN DEBOUNCE PARA VALIDAD ELEMNTO SELECCIONADO ==================//

  Timer? _deboucerValidaStockItemPedido;

  bool? _itemDisponible = false;
  bool? get getItemDisponible => _itemDisponible;

  void setItemDisponible(bool? value) {
    _itemDisponible = value;
    // print('-ItemBisponible:$_itemDisponible');
    notifyListeners();
  }

  String? _itemCantidad = '';

  String? get getItemCantidad => _itemCantidad;

  void setItemCantidad(String? value) {
    _itemCantidad = value;
    // print('-CantidadPedido:$_itemCantidad');

    //================================================================================//
    if (_itemCantidad!.isNotEmpty) {
      _deboucerValidaStockItemPedido?.cancel();
      _deboucerValidaStockItemPedido =
          Timer(const Duration(milliseconds: 500), () {
        final stock = int.parse(_stockItem!);
        final stockIngresado = int.parse(_itemCantidad!);

        if (stock >= stockIngresado && stockIngresado > 0) {
          print('SI ESTA DISPONIBLE');

          setItemDisponible(true);
        } else {
          print('NOOOOOOOOO ESTA DISPONIBLE');
          _itemCantidad = '';
          setItemDisponible(false);
        }
        // buscaImplementoPedido(_inputBuscaImplemento);
        // print('GUSCA GUARDIA MULTA :ya');
      });
    }
    // else if (_inputBuscaImplemento!.isEmpty) {
    //   buscaImplementoPedido('');
    // } else {
    //   buscaImplementoPedido('');
    // }

    notifyListeners();
  }

//   String? _inputBuscaImplemento;
//   get getInputBuscaGuardia => _inputBuscaImplemento;
//   void onInputBuscaGuardiaChange(String? text) {
//     _inputBuscaImplemento = text;
//     // print('GUSCA GUARDIA MULTA :$_inputBuscaImplemento');

// //================================================================================//
//     if (_inputBuscaImplemento!.length >= 3) {
//       _deboucerValidaStockItemPedido?.cancel();
//       _deboucerValidaStockItemPedido =
//           Timer(const Duration(milliseconds: 500), () {
//         buscaImplementoPedido(_inputBuscaImplemento);
//         // print('GUSCA GUARDIA MULTA :ya');
//       });
//     } else if (_inputBuscaImplemento!.isEmpty) {
//       buscaImplementoPedido('');
//     } else {
//       buscaImplementoPedido('');
//     }

//     notifyListeners();
//   }
//================================================================================//

//  =================  CREO UN DEBOUNCE BUSCAR CLIENTES ==================//

  Timer? _deboucerSearchBuscaClientePedidos;

  String? _inputBuscaClientePedidos;
  get getInputBuscaClientesPedidos => _inputBuscaClientePedidos;
  void onInputBuscaClienteChangeChange(String? text, String? tipo) {
    _inputBuscaClientePedidos = text;
    // print(' CLIENTES INFORMES :$_inputBuscaClientePedidos');

//================================================================================//

    if (_inputBuscaClientePedidos!.length >= 3) {
      _deboucerSearchBuscaClientePedidos?.cancel();
      _deboucerSearchBuscaClientePedidos =
          Timer(const Duration(milliseconds: 500), () {
        getTodosLosClientesPedido(_inputBuscaClientePedidos);
        //  print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaClientePedidos!.isEmpty) {
      getTodosLosClientesPedido('');
    } else {
      getTodosLosClientesPedido('');
    }

    notifyListeners();
  }
//  =================  CREO UN DEBOUNCE BUSCAR CLIENTES ==================//

  Timer? _deboucerSearchBuscaGuardiasPedido;

  String? _inputBuscaGuardiasPedido;
  get getInputBuscaGuardiasPedido => _inputBuscaGuardiasPedido;
  void onInputBuscaGuardiasPedidoChange(String? text) {
    _inputBuscaGuardiasPedido = text;
    // print(' CLIENTES INFORMES :$_inputBuscaGuardiasPedido');

    if (_inputBuscaGuardiasPedido!.length >= 3) {
      _deboucerSearchBuscaGuardiasPedido?.cancel();
      _deboucerSearchBuscaGuardiasPedido =
          Timer(const Duration(milliseconds: 500), () {
        getTodosLosGuardiasPedido(_inputBuscaGuardiasPedido);
        //  print('GUSCA GUARDIA MULTA :ya');
      });
    } else if (_inputBuscaGuardiasPedido!.isEmpty) {
      getTodosLosGuardiasPedido('');
    } else {
      getTodosLosGuardiasPedido('');
    }

    notifyListeners();
  }

//================================== OBTENEMOS TODOS LOS CLIENTES PEDIDOS ==============================//
  List<Cliente> _listaTodosLosClientesPedidos = [];
  List<Cliente> get getListaTodosLosClientesPedidos =>
      _listaTodosLosClientesPedidos;

  void setListaTodosLosClientesPedidos(List<Cliente> data) {
    _listaTodosLosClientesPedidos = data;

    notifyListeners();
  }

  bool? _errorClientesPedidos; // sera nulo la primera vez
  bool? get getErrorClientesPedidos => _errorClientesPedidos;

  Future<AllClientePedido?> getTodosLosClientesPedido(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllClientesPedidos(
      // cantidad: 100,
      // page: 0,
      search: search,
      // input: 'cliId',
      // orden: false,
      // datos: '',
      // rucempresa: '${dataUser!.rucempresa}',
      tipo: 'CLIENTES',
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorClientesPedidos = true;
      setListaTodosLosClientesPedidos(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorClientesPedidos = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//================================== OBTENEMOS TODOS LOS GUARDIAS ==============================//
  List<Guardia> _listaTodosLosGuardiasPedido = [];
  List<Guardia> get getListaTodosLosGuardiasPedido =>
      _listaTodosLosGuardiasPedido;

  void setListaTodosLosGuardiasPedido(List<Guardia> data) {
    _listaTodosLosGuardiasPedido = data;

    notifyListeners();
  }

  bool? _errorGuardiasPedido; // sera nulo la primera vez
  bool? get getErrorGuardiasPedido => _errorGuardiasPedido;

  Future<AllGuardiasPedido?> getTodosLosGuardiasPedido(String? search) async {
    final dataUser = await Auth.instance.getSession();
// print('usuario : ${dataUser!.rucempresa}');
    final response = await _api.getAllGuardiasPedido(
      search: search,
      docnumero: _docCliente,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorGuardiasPedido = true;
      setListaTodosLosGuardiasPedido(response.data);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorGuardiasPedido = false;
      notifyListeners();
      return null;
    }
    return null;
  }

//===============OBTENGO AL CLIENTE SELECCIONADO =====================//
  Cliente? _clientePedido;
  Cliente? get getClienteInfoPedido => _clientePedido;
  String? _docCliente;
  String _nomCliente = '';
  String? get getDocCliente => _docCliente;
  String? get getNombreCliente => _nomCliente;

  void getClientePedido(Cliente? cliente) {
    _listaGuardiaVarios.clear();
    _clientePedido = cliente;
    _docCliente = cliente!.cliDocNumero;
    _nomCliente = cliente.cliNombreComercial!;
    // print('_nomCliente: $_nomCliente');
    // print('_docCliente: $_docCliente');
    notifyListeners();
  }

  Guardia? _guardia;
  String? _idGuardia = '';
  String? _docGuardia;
  String? _perfilGuardia = '';
  String _nomGuardia = '';
  String? get getDocGuardia => _docGuardia;
  String? get getNombreGuardia => _nomGuardia;

  void getGuardiaPedido(Guardia? guardia) {
    _guardia = guardia;
    _docGuardia = '${guardia!.perId}';
    _nomGuardia = '${guardia.perApellidos} ${guardia.perNombres} ';
    _docGuardia = '${guardia.perDocNumero}';
    _perfilGuardia = '${guardia.perPerfil}';
    // print('_docCliente: $_docGuardia');
    // print('_nomCliente: $_nomGuardia');
    notifyListeners();
  }

  String? _inputObservacion;
  String? _inputDetalle;
  String? _inputDocumento;
  String? _inputFechaEvio;
  String? get getInputObservacion => _inputObservacion;
  void onObservacionChange(String? text) {
    _inputObservacion = text;
    notifyListeners();
  }

  //================================== CREA NUEVA CONSIGNA  ==============================//
  Future crearPedido(
    BuildContext context,
  ) async {
    final serviceSocket = SocketService();

    final infoUser = await Auth.instance.getSession();
    // print(
    //     '==========================DATOS DEL TELEFONO ===============================');
    // print('rucEmpresa ${infoUser!.rucempresa}');
    // print('rucempresa ${infoUser.rucempresa}');
    // print('user ${infoUser.usuario}');
    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadNuevoPedido = {
      "tabla": "pedido",
      "rucempresa": infoUser!.rucempresa,
      "rol": infoUser.rol, // LOGIN
      "disTipo": "PEDIDO", // defecto
      "disIdCliente": _clientePedido!.cliId, // Propiedad cliId
      "disDocuCliente": _clientePedido!.cliDocNumero, // propiedad cliDocNumero
      "disNombreCliente":
          _clientePedido!.cliRazonSocial, // propiedad cliRazonSocial
      "disPersonas": _listaGuardiaVarios,
      "disEntrega": _labelEntrega, // select
      "disObservacion": _inputObservacion, // textarea
      "disEstado": "PENDIENTE", // defecto
      "disFechaEnvio": "", // interno
      "disDetalle": "", // interno
      "disDocumento": "", // vacio
      "disFechaRecibido": "", // vacio
      "disPedidos": _nuevoPedido, // listado
      "disUser": infoUser.usuario, // LOGIN
      "disEmpresa": infoUser.rucempresa // LOGIN
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVO PEDIDO ===============================');
    // print(_pyloadNuevoPedido);

    serviceSocket.socket!.emit('client:guardarData', _pyloadNuevoPedido);

    getTodosLosPedidosGuardias('');
  }

  //================================== ELIMINAR  MULTA  ==============================//
  Future eliminaPedido(BuildContext context, int? idPedido) async {
    // final serviceSocket = SocketService();

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    final infoUser = await Auth.instance.getSession();

    // print(
    //     '==========================JSON PARA CREAR NUEVA COMPRA ===============================');
    final _pyloadEliminaPedido = {
      {
        "tabla": "pedido", // defecto
        "rucempresa": infoUser!.rucempresa, // login
        "disId": idPedido // id registro
      }
    };

    serviceSocket.socket!.emit('client:eliminarData', _pyloadEliminaPedido);
    getTodosLosPedidosGuardias('');

    // serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
    //   if (data['tabla'] == 'pedido') {
    //     NotificatiosnService.showSnackBarSuccsses(data['msg']);
    //     // serviceSocket.socket?.clearListeners();
    //     notifyListeners();
    //   }
    // });
    // serviceSocket.socket?.on('server:error', (data) {
    //   NotificatiosnService.showSnackBarError(data['msg']);
    //   notifyListeners();
    // });
  }

  //======================================== EDITAR PEDIDO==============================================//

  //LLENAMOS LOS DATOS A LAS VARIABLES //

  String? _idCliente = '';
  // String? _idGuardia = '';
  // String? _perfilGuardia = '';
  int? _idPedido;
  String? _rucempresa;
  String? _estadoPedido;
  String? get getEstadoPedido => _estadoPedido;

  List<dynamic>? _disPedidosAntiguo = [];

  void infoPedidoEdicion(dynamic pedido) {
    _nuevoPedido.clear();
    _disPedidosAntiguo!.clear();
    _listaGuardiaVarios.clear();
    _idPedido = pedido['disId'];
    _idCliente = '${pedido['disIdCliente']}';
    _docCliente = '${pedido['disDocuCliente']}';
    _nomCliente = '${pedido['disNombreCliente']}';
    _rucempresa = '${pedido['disEmpresa']}';
    // _inputObservacion = '${pedido['disEmpresa']}';
    _inputFechaEvio = '${pedido['disFechaEnvio']}';
    _inputDetalle = '${pedido['disDetalle']}';
    _inputDocumento = '${pedido['disDocumento']}';
    _estadoPedido = '${pedido['disEstado']}';
    _labelEntrega = '${pedido['disEntrega']}';
    // print('object: $_estadoPedido');
    // print('_inputFechaEvio: $_inputFechaEvio');
    // print('_labelEntrega: $_labelEntrega');

    pedido['disPersonas'].forEach(((e) {
      _listaGuardiaVarios.add({
        "docnumero": e['docnumero'],
        "nombres": e['nombres'],
        "asignado": e['asignado'],
        "id": e['id'],
        "foto": e['foto'],
      });
    }));

    // if (pedido['disEntrega'] == 'DOTACION') {
    //   _labelEntrega = 'DOTACION';
    //   _labelValorEntrega = 1;
    //   notifyListeners();
    // } else {
    //   _labelEntrega = 'DESCUENTO';
    //   _labelValorEntrega = 2;
    //   notifyListeners();
    // }
    if (_labelEntrega == 'DOTACION') {
      _labelEntrega = 'DOTACION';
      _labelValorEntrega = 1;
      // print('_labelEntrega: $_labelEntrega');
      // print('_labelValorEntrega: $_labelValorEntrega');
      notifyListeners();
    } else if (_labelEntrega == 'DESCUENTO') {
      _labelEntrega = 'DESCUENTO';
      _labelValorEntrega = 2;
      // print('_labelEntrega: $_labelEntrega');
      // print('_labelValorEntrega: $_labelValorEntrega');
      notifyListeners();
    }
    // print('_labelEntrega: $_labelEntrega');
    // print('_labelValorEntrega: $_labelValorEntrega');
    _inputObservacion = '${pedido['disObservacion']}';
// int idItem = 0;
    for (var item in pedido['disPedidos']) {
      _nuevoPedido.add(
        CreaNuevoItemPedido(
// 'id': id,
//       'nombre': nombre,
//       'cantidad': cantidad,
//       'tipo': tipo,
//       'serie': serie,
//       "estado":pedido,
//       "cantidadDevolucion": cantidadDevolucion

          item['id'],
          int.parse(item['cantidadDevolucion']),
          item['nombre'],
          item['cantidad'],
          item['tipo'],
          item['serie'],
          item['estado'],
        ),
      );
   
   
   
   
   
     idItem = idItem + 1;
    }

    for (var item in pedido['disPedidos']) {
      _disPedidosAntiguo?.add(item);
    }

    notifyListeners();
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  Future editarPedido(
    BuildContext context,
  ) async {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    final infoUser = await Auth.instance.getSession();

    final _pyloadEditaPedido = {
      "tabla": "pedido",
      "disId": _idPedido,
      "rucempresa": _rucempresa,
      "rol": infoUser!.rol, // LOGIN
      "disTipo": "PEDIDO", // defecto
      "disIdCliente": _idCliente, // propiedad cliDocNumero
      "disDocuCliente": _docCliente,
      "disNombreCliente": _nomCliente, // propiedad cliRazonSocial
      "disPersonas": _listaGuardiaVarios,
      "disPedidosAntiguo": _disPedidosAntiguo, // PEDIDOS ANTIGUOS
      "disEntrega": _labelEntrega, // select
      "disObservacion": _inputObservacion, // textarea
      "disEstado":
          _labelNombreEstado == '' ? "ENVIADO" : _labelNombreEstado, // defecto
      "disFechaEnvio": _inputFechaEvio, // interno
      "disDetalle": _inputDetalle, // interno
      "disDocumento": _inputDocumento, // vacio
      // "disFechaRecibido": _fechaActual, // vacio
      "disFechaRecibido": _fechaActualParse, // vacio
      // "disFechaRecibido": '', // vacio
      // "disDocumento": '', // vacio
      // // "disDetalle": '', // interno
      // "disFechaEnvio": '', // interno
      "disPedidos": _nuevoPedido, // listado
      "disUser": infoUser.usuario, // LOGIN
      "disEmpresa": infoUser.rucempresa // LOGIN
    };
    serviceSocket.socket!.emit('client:actualizarData', _pyloadEditaPedido);
    // print(
    //         '==========================JSON PARA CREAR NUEVO PEDIDO ===============================');
    //     print('PAYLOAD EDICION DE PEDIDO===> $_pyloadEditaPedido');

    getTodosLosPedidosGuardias('');

    // // serviceSocket.socket!.emit('client:guardarData', _pyloadNuevaMulta);
    // serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
    //   if (data['tabla'] == 'pedido') {
    //     // print(
    //     //     '==========================JSON PARA CREAR NUEVO PEDIDO ===============================');
    //     // print('RESPUESTA DEL SOCKET===> $data');

    //     NotificatiosnService.showSnackBarSuccsses(data['msg']);

    //     notifyListeners();
    //   }
    // });
    // serviceSocket.socket?.on('server:error', (data) {
    //   NotificatiosnService.showSnackBarError(data['msg']);
    //   notifyListeners();
    // });
  }

//========================================//
  List _listaInfoGuardiaPedidos = [];

  List get getListaInfoGuardiaPedidos => _listaInfoGuardiaPedidos;

  void setInfoBusquedaInfoGuardia(List data) {
    _listaInfoGuardiaPedidos = data;

    notifyListeners();
  }

  bool? _errorInfoGuardiaPedidos; // sera nulo la primera vez
  bool? get getErrorInfoGuardiaPedido => _errorInfoGuardiaPedidos;
  set setErrorInfoGuardiaPedido(bool? value) {
    _errorInfoGuardiaPedidos = value;
    notifyListeners();
  }

  Future buscaInfoGuardiasPedidos(String? _search) async {
    final dataUser = await Auth.instance.getSession();

    // final response = await _api.getAllGuardias(
    final response = await _api.getAllGuardiasPorCliente(
      search: _search,
      // estado: 'GUARDIAS',
      docnumero: _docCliente,
      token: '${dataUser!.token}',
    );
    if (response != null) {
      _errorInfoGuardiaPedidos = true;

      // print('${response.data[0].infAsunto} ${response.data[0].infLugar}');
      //  _listaInfoGuardiaPedidos=response.data;
      setInfoBusquedaInfoGuardia(response['data']);

      notifyListeners();
      return response;
    }
    if (response == null) {
      _errorInfoGuardiaPedidos = false;
      notifyListeners();
      return null;
    }
  }

// ================== ELIMINA GUARDIA AGREGADO =====================//
  void eliminaGuardiaPedido(int id) {
    // List<CreaNuevaFotoNovedad?> temp = images;

    // print(id);
    // _listaGuardiasInforme.removeWhere((element) => element.id == id);
    _listaGuardiaVarios.removeWhere((e) => (e['id'] == id));

    _listaGuardiaVarios.forEach(((element) {
      // print('${element['nombres']}');
    }));

    notifyListeners();
  }
//========================================================= SELECCIONA  ==============================//

  List _listaGuardiaVarios = [];
  List get getListaGuardiasVarios => _listaGuardiaVarios;
  void setGuardiaVarios(dynamic guardia) {
    // for (var e in _listaGuardiaVarios) {
    //   if (e.perId == guardia.perId) {
    _listaGuardiaVarios.removeWhere((e) => (e['id'] == guardia['perId']));

    {
      _listaGuardiaVarios.add({
        "docnumero": guardia['perDocNumero'],
        "nombres": '${guardia['perApellidos']} ${guardia['perNombres']} ',
        "asignado": true,
        "id": guardia['perId'],
        "foto": guardia['perFoto'],
      });
      notifyListeners();
    }
  }

  //======================================== REALIZA DEVOLUCIONES ==================================================//
  dynamic _pedidoDevolucion = '';
  dynamic get getPedidoDevolucion => _pedidoDevolucion;
  List _listaItemsProductos = [];
  List get getListaItemsProductos => _listaItemsProductos;

  void setListaItemsProductos(List items) {
    // for (var e in items) {
    //     if(e['estado']=='PEDIDO'){
    //     print('ESTADO: ${e['estado']}');
    //     }
    // }

    _listaItemsProductos.addAll(items);
    print('PRODUCTOS: ${_listaItemsProductos}');
    notifyListeners();
  }

  List _listaItemsDevolucionProductos = [];
  List get getListaItemsDevolucionProductos => _listaItemsDevolucionProductos;

  void setListaItemsDevolucionProductos(List items) {
    _listaItemsDevolucionProductos.addAll(items);
    // print('PRODUCTOS: ${_listaItemsProductos}');
    notifyListeners();
  }

  void getPedidoParaDevoluciones(dynamic pedido) {
    List<dynamic> _listatempPedidos = [];
    _pedidoDevolucion = pedido;
    // _listatempPedidos = pedido['disPedidos'];
    // _listatempPedidos.removeWhere((e) => e['estado'] == 'DEVOLUCION');
    // setListaItemsProductos(_listatempPedidos);

    setListaItemsProductos(pedido['disPedidos']);
  }

//====================== AGREGAMOS ITEM PARA LA DDEVOLUCION ======================//
//========================== DROPDOWN  =======================//
  // Implemento? implemento;

  int? _idItem;
  String? _nombreItem = '';
  String? _cantidadItem = '';
  String? _tipoItem = '';
  String? _serieItem = '';
  String? _idProductoItem = '';
  int? _stock;
  int? _stockIngresado;
  String? _cantidadItemDevolucion = '';

  String? get getItemCantidadDevolucion => _cantidadItemDevolucion;
  Timer? _deboucerValidaStockItemDevolucionPedido;

  bool? _itemDevolucionDisponible = false;
  bool? get getItemDevolucionDisponible => _itemDevolucionDisponible;

  void setItemDevolucionDisponible(bool? value) {
    _itemDevolucionDisponible = value;
    // print('-ItemBisponible:$_itemDevolucionDisponible');
    notifyListeners();
  }

// ======= OBTENEMOS EL ITEM SELECCIONADO =============//


int? _cantidadRestada ;
int? _itemTevolucion ;
int? get getCantidadRestada=>_cantidadRestada;
void setCantidadRestada(int? valor){
_cantidadRestada=valor;
  // print('-CANTIDAD RESTADA :$_cantidadRestada');
// notifyListeners();
}
  void setItemscantidadDevolucion(String cantidad,String devolucion) {
    _cantidadItemDevolucion=devolucion;
    // _itemDevolucionDisponible = true;
    _itemTevolucion=int.parse(devolucion.trim());
    final inputText = int.parse(cantidad.trim());
      // print('-CANTIDAD :$inputText --- DEVOLUCION: $itemTevolucion');

     setCantidadRestada(inputText-_itemTevolucion!);
      // print('-CANTIDAD RESTADA :$_cantidadRestada');


    if (inputText != 0) {
      _stockIngresado = inputText;
      // print('-CANTIDAD INICIAL:$_stockIngresado');
      _itemDevolucionDisponible = true;
    } else {
      _itemDevolucionDisponible = false;
    }

    // notifyListeners();
  }

  void resetItemDevolucion() {
    // _cantidadItemDevolucion = '';
    _itemDevolucionDisponible = false;
  }

  //========================== OBTENEMOS LA INFORMACION DEL ITEM SELECCIONADO  =======================//
  void agregarItemDevolucionPedido(dynamic _itemDevolucion) {
    _idItem = _itemDevolucion['id'];
    _nombreItem = _itemDevolucion['nombre'];
    _tipoItem = _itemDevolucion['tipo'];
    _cantidadItem = _itemDevolucion['cantidad'];
    _serieItem = _itemDevolucion['serie'];
    _idProductoItem = _itemDevolucion['idProduct'];
    _stock = int.parse(_itemDevolucion['cantidad']);


    notifyListeners();
  }

  final List<dynamic> _nuevoItemDevolucionPedido = [];
  List<dynamic> get getNuevoItemDevolucionPedido => _nuevoItemDevolucionPedido;

  // void setItemDevolucionPedido(dynamic pedido) {
  //   // _nuevoItemDevolucionPedido.removeWhere((e) => (e['id']] == pedido['id']));
  //   _nuevoItemDevolucionPedido.add(pedido);

  //   // print('ESTE ES EL ITEM AGREGADO: $_nuevoItemDevolucionPedido');

  //   notifyListeners();
  // }

  void agregaNuevoItemDevolucionPedido() {
    _nuevoItemDevolucionPedido.removeWhere((e) => (e['id']) == _idItem!);

    _nuevoItemDevolucionPedido.add(
      
        {
            "id":  _idItem!,
            "nombre": '$_nombreItem',
            "cantidad": '$_cantidadItemDevolucion',
            "tipo":'$_tipoItem',
            "serie": '$_serieItem',
         }
   
        );
//  print('LISTA DE DEVOLUCIONES: $_nuevoItemDevolucionPedido');
    notifyListeners();
  }

//============ELIMINA ELEMENTO DE LA LISTA DE RTENCIONES=====================//

  void eliminaDevolucionPedidoAgregado(int rowSelect) {
    // print('IDrowddddSelect:$rowSelect');
    _nuevoItemDevolucionPedido.removeWhere((e) => e['id'] == rowSelect);
//  sumatoria() ;
    notifyListeners();
  }

   void setItemCantidadDevolucion(String? value) {
    _cantidadItemDevolucion = value;
    // print('-Cantidad DEDEDED:${value}');

    if (value!.isNotEmpty) {
      _deboucerValidaStockItemDevolucionPedido?.cancel();
      _deboucerValidaStockItemDevolucionPedido =
          Timer(const Duration(milliseconds: 500), () {
 
    // print('-Cantidad DEDEDED:$value');

        _stockIngresado = int.parse(_cantidadItemDevolucion!);
        // // _stockIngresado = _cantidadRestada;

        if (_cantidadRestada!>=_stockIngresado! &&_stockIngresado!>0) {
          // if(_stockIngresado!>=0){

          print('SI ESTA DISPONIBLE');
          setItemDevolucionDisponible(true);
          // }


        } else {
          print('NOOOOOOOOO ESTA DISPONIBLE');
          setItemDevolucionDisponible(false);
        }
      });
    } else if (_cantidadItemDevolucion == '') {
      // setItemCantidadDevolucion('');
      setItemDevolucionDisponible(false);
    }

    notifyListeners();
  }

//================================== CREA NUEVA CONSIGNA  ==============================//
  Future crearDevolucion(
    BuildContext context,
  ) async {
    final serviceSocket = SocketService();

    final infoUser = await Auth.instance.getSession();

    final _pyloadDevolucionPedido = {
      "tabla": "devolucion",
      "rucempresa": infoUser!.rucempresa,
      "rol": infoUser.rol, // LOGIN
      "disTipo": "DEVOLUCION",
      "disIdPedido": "${_pedidoDevolucion['disId']}", // defecto
      "disIdCliente": "${_pedidoDevolucion['disIdCliente']}", // Propiedad cliId
      "disDocuCliente":
          "${_pedidoDevolucion['disDocuCliente']}", // propiedad cliDocNumero
      "disNombreCliente":
          "${_pedidoDevolucion['disNombreCliente']}", // propiedad cliRazonSocial
      "disPersonas": _pedidoDevolucion['disPersonas'],
      "disEntrega": "${_pedidoDevolucion['disEntrega']}", // select
      "disObservacion": "${_pedidoDevolucion['disObservacion']}", // textarea
      "disEstado": "PENDIENTE", // defecto
      "disFechaEnvio": "", // interno
      "disDetalle": "", // interno
      "disDevolucion": _nuevoItemDevolucionPedido,
      "disFechaRecibido": "", // vacio
      "disPedidos": _pedidoDevolucion['disPedidos'], // listado
      "disUser": infoUser.usuario, // LOGIN
      "disEmpresa": infoUser.rucempresa // LOGIN
    };
    print(
        '==========================JSON PARA CREAR NUEVO PEDIDO ===============================');
    print(_pyloadDevolucionPedido);

    serviceSocket.socket!.emit('client:guardarData', _pyloadDevolucionPedido);

    // getTodosLosPedidosGuardias('');
    getTodosLosPedidosActivos('');
  }
  //=============================================================================================================//



//========================== DROPDOWN PERIODO  CLIENTE =======================//
bool? _estadoDevolucion=false;
bool? get getEstadoDevolucion=>_estadoDevolucion;

void setEstadoDevolucion(bool estado){
_estadoDevolucion=estado;
notifyListeners();
}

  String? _labelNombreEstadoDevolucionPedido;

  String? get labelNombreEstadoDevolucionPedido => _labelNombreEstadoDevolucionPedido;

  void setLabelNombreEstadoDevolucionPedido(String value){
        _labelNombreEstadoDevolucionPedido = value;
        setEstadoDevolucion(true);
//     if(value.isNotEmpty){
    // _labelNombreEstadoDevolucionPedido = value;
    // print('--estado DEVOLUCION:$labelNombreEstadoDevolucionPedido');
//  notifyListeners();
//     }
 notifyListeners();
  }
   

//========================== OBTENEMOS LA INFORMACION DE LA DDEVOLUCION SELECCIONADA PARA EDITAR =======================//
// ESTADOS DE LA DEVOLUCION
 List<String> data = ['ANULADO'];

List<String> get getDataEstadoDevolucion=>data;

dynamic _dataDevolucion;
dynamic get getDataDevolucion=>_dataDevolucion;


List<dynamic> _listaPedidosDevolucion=[];
List<dynamic> _listaDevolucionDePedido=[];

 void getInfoDevolucionPedido( dynamic infoDevolucion){
  _listaPedidosDevolucion=[];
_listaDevolucionDePedido=[];
  _dataDevolucion=infoDevolucion;
  // print('LA DEVOLUCION ES : ${infoDevolucion['disId']}');
  // print('LA DEVOLUCION ES : $infoDevolucion');

for (var item in _dataDevolucion['disPedidos']) {
  _listaPedidosDevolucion.add(
      {
         "id":item['id'],
         "nombre":item['nombre'],
         "cantidad":item['cantidad'],
         "tipo":item['tipo'],
         "serie":item['serie'],
       
      }
  );
  
}







 }


//========================== REALIZAMOS LA DEVOLUCION DEL PEDIDO =======================//
 Future editarDevolucionPedido(
    BuildContext context,
  ) async {
    final serviceSocket = SocketService();

    final infoUser = await Auth.instance.getSession();

    final _pyloadEditarDevolucionPedido = {
      "tabla": "devolucion",
      "rucempresa": infoUser!.rucempresa,
      "rol": infoUser.rol, // LOGIN
      "disTipo": "DEVOLUCION",
      "disId":_dataDevolucion['disId'],
      "disIdPedido": _dataDevolucion['disId'], // defecto
      "disIdCliente": _dataDevolucion['disIdCliente'], // Propiedad cliId
      "disDocuCliente":_dataDevolucion['disDocuCliente'], // propiedad cliDocNumero
      "disNombreCliente": _dataDevolucion['disNombreCliente'], // propiedad cliRazonSocial
      "disPersonas": _dataDevolucion['disPersonas'],
      "disEntrega": _dataDevolucion['disEntrega'], // select
      "disObservacion": _dataDevolucion['disObservacion'], // textarea
      "disEstado":_labelNombreEstadoDevolucionPedido, // defecto
      "disFechaEnvio": _dataDevolucion['disFechaEnvio'], // interno
      "disDetalle": _dataDevolucion['disDetalle'], // interno
      "disDevolucion": '',
      "disFechaRecibido": _dataDevolucion['disFechaRecibido'], // vacio
      "disPedidos":_listaPedidosDevolucion, // listado
      "disUser": infoUser.usuario, // LOGIN
      "disEmpresa": infoUser.rucempresa // LOGIN
    };
    // print(
    //     '==========================JSON PARA CREAR NUEVO PEDIDO ===============================');
    // print(_pyloadEditarDevolucionPedido);

     serviceSocket.socket!.emit('client:actualizarData', _pyloadEditarDevolucionPedido);

    getTodasLasDevoluciones('');
  }
























}
