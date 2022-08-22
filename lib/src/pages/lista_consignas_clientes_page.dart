import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sincop_app/src/controllers/consignas_clientes_controller.dart';
import 'package:sincop_app/src/pages/consigna_leida_cliente_page.dart';
import 'package:sincop_app/src/pages/edita_consigna_cliente_page.dart';
import 'package:sincop_app/src/pages/crea_consigna_cliente_page.dart';
import 'package:sincop_app/src/utils/dialogs.dart';

import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaConsignasClientesPage extends StatefulWidget {
  const ListaConsignasClientesPage({Key? key}) : super(key: key);

  @override
  State<ListaConsignasClientesPage> createState() =>
      _ListaConsignasClientesPageState();
}

class _ListaConsignasClientesPageState
    extends State<ListaConsignasClientesPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final loadInfo =
        Provider.of<ConsignasClientesController>(context, listen: false);
    loadInfo.buscaGuardiasConsigna('');
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final consignasControler =
        Provider.of<ConsignasClientesController>(context);
    return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          // backgroundColor: primaryColor,
          title: const Text('Mis Consignas '),
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
          margin: EdgeInsets.symmetric(
            horizontal: size.iScreen(1.0),
          ),

          // color: Colors.red,
          width: size.wScreen(100.0),
          height: size.hScreen(100.0),

          child: Consumer<ConsignasClientesController>(
            builder: (_, providers, __) {
              if (providers.getErrorAllConsignas == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (providers.getErrorAllConsignas == false) {
                return const ErrorData();
                // Text("Error al cargar los datos");
              } else if (providers.getListaTodasLasConsignasCliente.isEmpty) {
                return const NoData(
                  label: 'No existen datos para mostar',
                );
                // Text("sin datos");
              }

              return ListView.builder(
                itemCount: providers.getListaTodasLasConsignasCliente.length,
                itemBuilder: (BuildContext context, int index) {
                  final consigna =
                      providers.getListaTodasLasConsignasCliente[index];
                  return Slidable(
                    key: ValueKey(index),
                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      children: [
                        SlidableAction(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          // label: 'Editar',
                          onPressed: (context) {
                            // loadData;
                            providers.setDiaSemanasTepmporal(
                                consigna.conDiasRepetir);
                            providers.getInfoEdit(consigna);
                               
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        EditarConsignaClientePage(
                                          infoConsignaCliente: consigna,
                                          accion: 'Editar',
                                        )))).then((value) {
                              setState(() {
                                providers.setDiaSemanas(
                                    providers.getDiaSemanasTepmporal);
                              });
                            });
                          },
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            ProgressDialog.show(context);
                            await consignasControler.eliminaConsignaCliente(
                                context, consigna);
                            ProgressDialog.dissmiss(context);
                          },
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          icon: Icons.delete_forever_outlined,
                          // label: 'Eliminar',
                        ),
                        // SlidableAction(
                        //   onPressed: (context) {
                        //     Navigator.pushNamed(context, 'consignacionLeidaCliente');
                        //   },
                        //   backgroundColor: Colors.green,
                        //   foregroundColor: Colors.white,
                        //   icon: Icons.remove_red_eye_outlined,
                        //   // label: 'Eliminar',
                        // ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ConsignaLeidaClientePage(
                                    infoConsignaCliente: consigna))));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: size.iScreen(0.5)),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.iScreen(1.5),
                            vertical: size.iScreen(0.5)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: size.iScreen(0.5),
                                        bottom: size.iScreen(0.0)),
                                    width: size.wScreen(100.0),
                                    child: Text(
                                      '${consigna.conAsunto} - ${index}',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.6),
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: size.iScreen(0.5),
                                        bottom: size.iScreen(0.0)),
                                    width: size.wScreen(100.0),
                                    child: Text(
                                      '${consigna.conDetalle}',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.5),
                                          color: Colors.black87,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: size.iScreen(0.5),
                                            bottom: size.iScreen(0.0)),
                                        // width: size.wScreen(100.0),
                                        child: Text(
                                          'Prioridad: ',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.5),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: size.iScreen(0.5),
                                            bottom: size.iScreen(0.0)),
                                        // width: size.wScreen(100.0),
                                        child: Text(
                                          '${consigna.conPrioridad}',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.5),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: size.iScreen(0.5),
                                            bottom: size.iScreen(0.0)),
                                        // width: size.wScreen(100.0),
                                        child: Text(
                                          'Frecuencia: ',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.5),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: size.iScreen(0.5),
                                            bottom: size.iScreen(0.0)),
                                        // width: size.wScreen(100.0),
                                        child: Text(
                                          '${consigna.conFrecuencia}',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.5),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: size.iScreen(0.5),
                                        bottom: size.iScreen(0.0)),
                                    width: size.wScreen(100.0),
                                    child: Text(
                                      consigna.conFecReg
                                          .toString()
                                          .replaceAll(".000Z", ""),
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: size.iScreen(1.5),
                                          color: Colors.black87,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Estado',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.6),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal),
                                ),
                                CupertinoSwitch(
                                  // key: Key('$index'),
                                  value: (consigna.conEstado == 'ACTIVA')
                                      ? true
                                      : false,
                                  onChanged: (value) {
                                    // consignasControler.setEstadoComunicado(
                                    //     value, index);
// Dialogs.alertConfirm(context, size: 20.0, title: 'Estado', description: "Seguro de cambiar estado de la comunicación?");

                                    _modalEstadoConsigna(
                                        size, consignasControler);
                                  },
                                ),
                                //***********************************************/
                                SizedBox(
                                  height: size.iScreen(0.5),
                                ),

                                //*****************************************/
                                Text(
                                  'Realizado',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.6),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  '${consigna.conProgreso}',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.5),
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            consignasControler.resetValues();
            // consignasControler.buscaGuardiasConsigna('');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ConsignaClientePage()));
            // Navigator.pushNamed(context, 'consignaCliente');
          },
        ));
  }

//====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalEstadoConsigna(
      Responsive size, ConsignasClientesController consignasControler) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Aviso',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          )),
                      IconButton(
                          splashRadius: size.iScreen(3.0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: size.iScreen(3.5),
                          )),
                    ],
                  ),
                  Text('Seguro de cambiar el estado de la consigna?',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        // color: Colors.white,
                      )),
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: size.iScreen(1.0), bottom: size.iScreen(2.0)),
                    height: size.iScreen(3.5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF0A4280),
                        ),
                      ),
                      onPressed: () {
                        // controllerActividades.setCoords = '';
                        // Navigator.pushNamed(
                        //     context, 'detalleDeNovedad');
                      },
                      child: Text('Si',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
