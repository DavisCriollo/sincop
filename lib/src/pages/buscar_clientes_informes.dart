import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class BuscarClientesInformes extends StatefulWidget {
  const BuscarClientesInformes({Key? key}) : super(key: key);

  @override
  State<BuscarClientesInformes> createState() => _BuscarClientesInformesState();
}

class _BuscarClientesInformesState extends State<BuscarClientesInformes> {
  TextEditingController textSearchClienteInformes = TextEditingController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final loadData = MultasGuardiasContrtoller();
    // loadData.setListaClienteMultasClear;
    textSearchClienteInformes.text = '';
  }

  @override
  void dispose() {
    textSearchClienteInformes.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final informesController = Provider.of<InformeController>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        // backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: Text(
          'Buscar Cliente',
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
            // SizedBox(
            //   width: size.wScreen(100.0),
            //   // color: Colors.blue,
            //   child: Text('Ingrese criterio de búsqueda',
            //       style: GoogleFonts.lexendDeca(
            //         // fontSize: size.iScreen(2.0),
            //         fontWeight: FontWeight.normal,
            //         color: Colors.grey,
            //       )),
            // ),
            TextFormField(
              controller: textSearchClienteInformes,
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
                informesController.onInputBuscaClienteInformesChange(text);
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
                    child: Consumer<InformeController>(
                      builder: (_, provider, __) {
                        if (provider.getErrorClientesInformes == null) {
                          return const NoData(
                            label: 'Ingrese dato para búsqueda',
                          );
                        }
                        //  else if (provider.getErrorInfoMultaGuardia == false) {
                        //   return const NoData(s
                        //     label: 'Error al cargar la información',
                        //   );
                        // Text("Error al cargar los datos");
                        // }
                        else if (provider
                            .getListaTodosLosClientesInfomes.isEmpty) {
                          return const NoData(
                            label: 'No existen datos para mostar',
                          );
                          // Text("sin datos");
                        }

                        return ListView.builder(
                          itemCount:
                              provider.getListaTodosLosClientesInfomes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final cliente =
                                provider.getListaTodosLosClientesInfomes[index];
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
                                  '${cliente.cliCelular} - ${cliente.cliTelefono}',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.7),
                                      // color: Colors.black54,
                                      fontWeight: FontWeight.normal),
                                ),
                                onTap: () {
                                  provider.setDirigidoAClienteChange(cliente);
              Navigator.pop(context);
                                  // provider.setListaCorreosClienteMultas(
                                  //     cliente.cliId,
                                  //     cliente.cliDocNumero,
                                  //     cliente.cliNombreComercial,
                                  //     cliente.perEmail);
                                },
                              ),
                            );
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(5),
                            //   ),
                            //   margin: EdgeInsets.only(
                            //     top: size.iScreen(0.2),
                            //     bottom: size.iScreen(0.2),
                            //   ),
                            //   padding: EdgeInsets.only(
                            //       top: size.iScreen(0.0),
                            //       left: size.iScreen(0.5),
                            //       right: size.iScreen(0.5),
                            //       bottom: size.iScreen(0.0)),
                            //   // width: size.wScreen(100.0),
                            //   child: Row(
                            //     children: [
                            //       Checkbox(
                            //           visualDensity: VisualDensity.compact,
                            //           value: true,
                            //           //  consignaController
                            //           //         .getlistaEstadoPersonalDesignadoCliente[
                            //           //     index],
                            //           onChanged: (value) {
                            //             // consignaController
                            //             //     .setSelectItemChecbox(
                            //             //         consignaController
                            //             //                 .getlistaEstadoPersonalDesignadoCliente[
                            //             //             index] = value,
                            //             //         persona);
                            //             // consignaController.setItemtCheckboxGuardia(persona);

                            //             // consignaController
                            //             //   .getlistaEstadoPersonalDesignadoCliente[index]=!value;
                            //             print('estado del check : $value');
                            //           }),
                            //       Expanded(
                            //         child: Text(
                            //           '{persona.perNombres} {persona.perApellidos}',
                            //           style: GoogleFonts.lexendDeca(
                            //               fontSize: size.iScreen(1.8),
                            //               color: Colors.black54,
                            //               fontWeight: FontWeight.normal),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // );
                          },
                        );
                      },
                    )

                    // ListView(
                    //   children: [
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         color: Colors.grey.shade200,
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       margin: EdgeInsets.only(
                    //         top: size.iScreen(0.5),
                    //         bottom: size.iScreen(0.5),
                    //       ),
                    //       padding: EdgeInsets.only(
                    //           top: size.iScreen(0.0),
                    //           left: size.iScreen(0.5),
                    //           right: size.iScreen(0.5),
                    //           bottom: size.iScreen(0.0)),
                    //       // width: size.wScreen(100.0),
                    //       child: Row(
                    //         children: [
                    //           Checkbox(
                    //               visualDensity: VisualDensity.compact,
                    //               value: true,
                    //               //  consignaController
                    //               //         .getlistaEstadoPersonalDesignadoCliente[
                    //               //     index],
                    //               onChanged: (value) {
                    //                 // consignaController
                    //                 //     .setSelectItemChecbox(
                    //                 //         consignaController
                    //                 //                 .getlistaEstadoPersonalDesignadoCliente[
                    //                 //             index] = value,
                    //                 //         persona);
                    //                 // consignaController.setItemtCheckboxGuardia(persona);

                    //                 // consignaController
                    //                 //   .getlistaEstadoPersonalDesignadoCliente[index]=!value;
                    //                 print('estado del check : $value');
                    //               }),
                    //           Expanded(
                    //             child: Text(
                    //               '{persona.perNombres} {persona.perApellidos}',
                    //               style: GoogleFonts.lexendDeca(
                    //                   fontSize: size.iScreen(1.8),
                    //                   color: Colors.black54,
                    //                   fontWeight: FontWeight.normal),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     )

                    //   ],
                    // ),
                    ))
          ],
        ),
      ),
    );
  }
}
