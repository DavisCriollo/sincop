import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class BuscarImplementoPedidoGuardiaPage extends StatefulWidget {
  const BuscarImplementoPedidoGuardiaPage({Key? key}) : super(key: key);

  @override
  State<BuscarImplementoPedidoGuardiaPage> createState() =>
      _BuscarImplementoPedidoGuardiaPageState();
}

class _BuscarImplementoPedidoGuardiaPageState
    extends State<BuscarImplementoPedidoGuardiaPage> {
  TextEditingController textSearchImplemento = TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    textSearchImplemento.text = '';
// final loadData= MultasGuardiasContrtoller();
// await loadData.buscaGuardiaMultas('a');
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final logisticaController = Provider.of<LogisticaController>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xffF2F2F2),
          appBar: AppBar(
            // backgroundColor: primaryColor,
            title: Text(
              'Implementos',
              style: GoogleFonts.lexendDeca(
                  fontSize: size.iScreen(2.45),
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
                  controller: textSearchImplemento,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Búscar...',
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
                    logisticaController.onInputBuscaGuardiaChange(text);
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
                        child: Consumer<LogisticaController>(
                          builder: (_, provider, __) {
                            if (provider.getErrorImplementoPedido == null) {
                              return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            height: size.iScreen(2.0),
                          ),
                          const Text('Cargando Implementos.... '),
                        ],
                      ),
                    );
                            } else if (provider.getErrorImplementoPedido ==
                                false) {
                              return const NoData(
                                label: 'No existen datos para mostar',
                              );
                            } else if (provider
                                .getListaImplementoPedido.isEmpty) {
                              return const NoData(
                                label: 'No existen datos para mostar',
                              );
                              // Text("sin datos");
                            }

                            return ListView.builder(
                              itemCount:
                                  provider.getListaImplementoPedido.length,
                              itemBuilder: (BuildContext context, int index) {
                                final implemento =
                                    provider.getListaImplementoPedido[index];
                                return GestureDetector(
                                  onTap: () {
                                    provider.getImplemento(
                                        implemento);

                                    Navigator.pop(context);
                                    // Navigator.pushNamed(context, 'detalleInformeGuardia');
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: ((context) =>
                                    //             DetalleInformeGuardiaPage(
                                    //                 informe: informe))));
                                  },
                                  child: ClipRRect(
                                    // borderRadius: BorderRadius.circular(8),
                                    child: Card(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: size.iScreen(0.5)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.iScreen(1.0),
                                            vertical: size.iScreen(0.5)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // boxShadow: const <BoxShadow>[
                                          //   BoxShadow(
                                          //       color: Colors.black54,
                                          //       blurRadius: 1.0,
                                          //       offset: Offset(0.0, 1.0))
                                          // ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      // color: Colors.red,
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              size.iScreen(0.5),
                                                          bottom: size
                                                              .iScreen(0.0)),
                                                      // width: size.wScreen(60.0),
                                                      child: Text(
                                                        '${implemento.invNombre}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              size.iScreen(0.5),
                                                          bottom: size
                                                              .iScreen(0.0)),
                                                      // width: size.wScreen(100.0),
                                                      child: Text(
                                                        'Color: ',
                                                        style:
                                                            GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ),
                                                    Container(
                                                      // color: Colors.red,
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              size.iScreen(0.5),
                                                          bottom: size
                                                              .iScreen(0.0)),
                                                      // width: size.wScreen(60.0),
                                                      child: Text(
                                                        '${implemento.invColor}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.lexendDeca(
                                                                fontSize: size
                                                                    .iScreen(
                                                                        1.5),
                                                                color: Colors
                                                                    .black87,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    'Stock ',
                                                    style: GoogleFonts.lexendDeca(
                                                        fontSize:
                                                            size.iScreen(1.5),
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Container(
                                                  // color: Colors.red,
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(60.0),
                                                  child: Text(
                                                    '${implemento.invStock}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.lexendDeca(
                                                        fontSize:
                                                            size.iScreen(1.5),
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                                // Card(
                                //   child: ListTile(
                                //     visualDensity: VisualDensity.compact,
                                //     title: Text(
                                //       '${implemento.invNombre}',
                                //       style: GoogleFonts.lexendDeca(
                                //           fontSize: size.iScreen(1.8),
                                //           // color: Colors.black54,
                                //           fontWeight: FontWeight.normal),
                                //     ),
                                //     subtitle: Text(
                                //       '${implemento.invColor}',
                                //       style: GoogleFonts.lexendDeca(
                                //           fontSize: size.iScreen(1.7),
                                //           // color: Colors.black54,
                                //           fontWeight: FontWeight.normal),
                                //     ),
                                //     onTap: () {
                                //       // provider.setimplementoInforme(guardia);
                                //     },
                                //   ),
                                // );
                              },
                            );
                          },
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
