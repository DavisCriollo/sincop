import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/pages/crea_aviso_salida_guardia.dart';
import 'package:sincop_app/src/pages/crear_informe_guardias.dart';
import 'package:sincop_app/src/pages/detalle_informe_guardia.dart';
import 'package:sincop_app/src/pages/edita_aviso_salida.dart';
import 'package:sincop_app/src/pages/edita_nforme_guardia.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaAvisoSalidaGuardiasPage extends StatefulWidget {
  const ListaAvisoSalidaGuardiasPage({Key? key}) : super(key: key);

  @override
  State<ListaAvisoSalidaGuardiasPage> createState() =>
      _ListaAvisoSalidaGuardiasPageState();
}

class _ListaAvisoSalidaGuardiasPageState extends State<ListaAvisoSalidaGuardiasPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final loadInfo = Provider.of<AvisoSalidaController>(context, listen: false);
    loadInfo.buscaAvisosSalida('');

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'avisosalida') {
        loadInfo.buscaAvisosSalida('');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
 serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'avisosalida') {
        loadInfo.buscaAvisosSalida('');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
 serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
      if (data['tabla'] == 'avisosalida') {
        loadInfo.buscaAvisosSalida('');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket?.on('server:error', (data) {
      NotificatiosnService.showSnackBarError(data['msg']);
    });
   
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: const Color(0xFFEEEEEE),
            appBar: AppBar(
              // backgroundColor: primaryColor,
              title: Text(
                'Avisos de Salida',
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
            body: 
            RefreshIndicator(
              onRefresh: onRefresh,
              child: SizedBox(
                  // color: Colors.red,
                  width: size.wScreen(100.0),
                  height: size.hScreen(100.0),
                  child:
                      Consumer<AvisoSalidaController>(builder: (_, provider, __) {
                    if (provider.getErrorInformesGuardia == null) {
                      return const NoData(
                         label: 'Cargando datos...',
                      );
                    } else if (provider.getErrorInformesGuardia == false) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                      // Text("Error al cargar los datos");
                    } else if (provider.getListaAvisosSalida.isEmpty) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                      // Text("sin datos");
                    }
                    return
                     ListView.builder(
                      itemCount: provider.getListaAvisosSalida.length,
                      itemBuilder: (BuildContext context, int index) {
                        final aviso = provider.getListaAvisosSalida[index];
                        return 
                        Slidable(
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
                                  // provider.resetValuesInformes();
                                  provider.getDataAvisoSalida(aviso);

                                 Navigator.push(
                                     context, 
                                     MaterialPageRoute(
                                         builder: ((context) =>
                                              EditaAvisoSalida(
                                              //  informe:informe,
                                                 fecha: aviso['nomFecha']
                                                    
                                                     ))));
                                },
                              ),
                              SlidableAction(
                                onPressed: (context) async {
                                  // ProgressDialog.show(context);
                                  await provider.eliminaAvisoSalida(
                                        aviso['nomId']);
                                  // ProgressDialog.dissmiss(context);
                                },
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_forever_outlined,
                                // label: 'Eliminar',
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, 'detalleInformeGuardia');
                              //Navigator.push(
                                //  context,
                                 // MaterialPageRoute(
                                    //  builder: ((context) =>
                                    //      DetalleInformeGuardiaPage(
                                       //       informe: informe))));
                            },
                            child: ClipRRect(
                              // borderRadius: BorderRadius.circular(8),
                              child: Card(
                                child: Container(
                                  margin:
                                      EdgeInsets.only(top: size.iScreen(0.5)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.iScreen(1.0),
                                      vertical: size.iScreen(0.5)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    // boxShadow: const <BoxShadow>[
                                    //   BoxShadow(
                                    //       color: Colors.black54,
                                    //       blurRadius: 1.0,
                                    //       offset: Offset(0.0, 1.0))
                                    // ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    'Aviso: ',
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
                                                  width: size.wScreen(60.0),
                                                  child: Text(
                                                    '${aviso['nomTipo']}',
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
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    'Guardia: ',
                                                    style: GoogleFonts.lexendDeca(
                                                        fontSize:
                                                            size.iScreen(1.5),
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Container(
                                                  width: size.iScreen(23.0),
                                                  // color: Colors.red,
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),

                                                  child: Text(
                                                    ' ${aviso['nomNomPersona']}',
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
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    'Fecha de salida: ',
                                                    style: GoogleFonts.lexendDeca(
                                                        fontSize:
                                                            size.iScreen(1.5),
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    aviso['nomFecha']
                                                        .toString()
                                                        .replaceAll(
                                                            "T", " "),
                                                    style: GoogleFonts.lexendDeca(
                                                        fontSize:
                                                            size.iScreen(1.5),
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.red,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'ESTADO',
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.3),
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            Text(
                                              '${aviso['nomEstado']}',
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.4),
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // CupertinoSwitch(
                                            //   value: true,
                                            //   // (multas.nomEstado == 'ACTIVA')
                                            //   //     ? true
                                            //   //     : false,
                                            //   onChanged: (value) {
                                            //     // _modalEstadoMulta(
                                            //     //     size,
                                            //     //     multasControler,
                                            //     //     multas,
                                            //     //     'INACTIVA');
                                            //   },
                                            // ),
                                            // Switch(
                                            //   value: true,
                                            //   onChanged: (val) {},
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                     
                     
                     
                      },
                    );
                  
                  
                  
                  
                  }
                  
                  )
                  ),
            
            
            
            
            ),
           
           
           
           
           
           
            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryColor,
              child: const Icon(Icons.add),
              onPressed: () {
                final avisoSalida =
        Provider.of<AvisoSalidaController>(context, listen: false);
                avisoSalida.resetValuesAvisoSalida();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            const CreaAvisoSalida())));
              },
            )),
      ),
    );
  }

  Future<void> onRefresh() async {
    final informeController =
        Provider.of<InformeController>(context, listen: false);
    // informeController.buscaInformeGuardias('');
  }
}
