// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
import 'package:sincop_app/src/controllers/cambio_puesto_controller.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/controllers/turno_extra_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class BuscarClientes extends StatefulWidget {
  // final String? modulo;

  const BuscarClientes({Key? key}) : super(key: key);

  @override
  State<BuscarClientes> createState() => _BuscarClientesState();
}

class _BuscarClientesState extends State<BuscarClientes> {
  TextEditingController textSearchClientes = TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    textSearchClientes.text = '';
// final loadData= MultasGuardiasContrtoller();
// await loadData.buscaGuardiaMultas('a');
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final informeController = Provider.of<CambioDePuestoController>(context);
    final modulo = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        // backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: Text(
          'Buscar Clientes',
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.5)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.iScreen(1.5),
            ),
            //*****************************************/

            TextFormField(
              controller: textSearchClientes,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'búsqueda Cliente',
                suffixIcon: GestureDetector(
                  onTap: () async {
                    // _searchGuardia(tipoMultaController);
                  },
                  child: const Icon(
                    Icons.search,
                    color: Color(0XFF343A40),
                  ),
                ),
              ),
              textAlign: TextAlign.start,
              style: const TextStyle(

                  // fontSize: size.iScreen(3.5),
                  // fontWeight: FontWeight.bold,
                  // letterSpacing: 2.0,
                  ),
              onChanged: (text) {
                // tipoMultaController.onInputBuscaGuardiaChange(text);
                informeController.onInputBuscaClienteChange(text);
              },
              validator: (text) {
                if (text!.trim().isNotEmpty) {
                  return null;
                } else {
                  return 'Ingrese dato para búsqueda';
                }
              },
              onSaved: (value) {
                // codigo = value;
                // tipoMultaController.onInputFDetalleNovedadChange(value);
              },
            ),
            //*****************************************/
            SizedBox(
              height: size.iScreen(1.0),
            ),
            Expanded(
                child: SizedBox(
                    // color: Colors.red,
                    width: size.iScreen(100),
                    child: Consumer<CambioDePuestoController>(
                      builder: (_, provider, __) {
                        if (provider.getErrorClientes == null) {
                          return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            height: size.iScreen(2.0),
                          ),
                          const Text('Cargando lista de Clientes.... '),
                        ],
                      ),
                    );
                        } else if (provider.getErrorClientes == false) {
                          return const NoData(
                            label: 'No existen datos para mostar',
                          );
                        } else if (provider.getListaTodosLosClientes.isEmpty) {
                          return const NoData(
                            label: 'No existen datos para mostar',
                          );
                          // Text("sin datos");
                        }

                        return ListView.builder(
                          itemCount: provider.getListaTodosLosClientes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final cliente = provider.getListaTodosLosClientes[index];
                            return Card(
                              child: ListTile(
                                visualDensity: VisualDensity.compact,
                                title: Text(
                                  '${cliente.cliRazonSocial}',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.8),
                                      // color: Colors.black54,
                                      fontWeight: FontWeight.normal),
                                ),
                                subtitle: Text(
                                  '${cliente.cliDocNumero}',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.7),
                                      // color: Colors.black54,
                                      fontWeight: FontWeight.normal),
                                ),
                                onTap: () {
                                  if (modulo == 'cambioPuesto') {
                                   
                                        Provider.of<CambioDePuestoController>(
                                            context,
                                            listen: false).getInfoCliente(cliente);
                                    Navigator.pop(context);
                                   
                                  } 
                                  else if (modulo == 'turnoExtra') {
                                    // getInfoCliente(cliente.cliId,cliente.cliDocNumero,cliente.cliNombreComercial,cliente.cliDatosOperativos!);
                                    Provider.of<TurnoExtraController>(
                                            context,
                                            listen: false).getInfoCliente(cliente);
                                   
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
