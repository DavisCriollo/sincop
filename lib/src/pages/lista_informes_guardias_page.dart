import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/crear_informe_guardias.dart';
import 'package:sincop_app/src/pages/detalle_informe_guardia.dart';
import 'package:sincop_app/src/pages/edita_nforme_guardia.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaInformesGuardiasPage extends StatefulWidget {
  final Session? usuario;
  const ListaInformesGuardiasPage({Key? key, this.usuario}) : super(key: key);

  @override
  State<ListaInformesGuardiasPage> createState() =>
      _ListaInformesGuardiasPageState();
}

class _ListaInformesGuardiasPageState extends State<ListaInformesGuardiasPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final loadInfo = Provider.of<InformeController>(context, listen: false);
    loadInfo.buscaInformeGuardias('');

    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket!.on('server:guardadoExitoso', (data) async {
      if (data['tabla'] == 'informe') {
        loadInfo.buscaInformeGuardias('');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket!.on('server:actualizadoExitoso', (data) async {
      if (data['tabla'] == 'informe') {
        loadInfo.buscaInformeGuardias('');
        NotificatiosnService.showSnackBarSuccsses(data['msg']);
      }
    });
    serviceSocket.socket!.on('server:eliminadoExitoso', (data) async {
      if (data['tabla'] == 'informe') {
        loadInfo.buscaInformeGuardias('');
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
    final informeController =
        Provider.of<InformeController>(context, listen: false);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: const Color(0xFFEEEEEE),
            appBar: AppBar(
              // backgroundColor: primaryColor,
              title: Text(
                // 'Mis Informes ${widget.usuario!.rol!}',
                'Mis Informes',
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
            body: RefreshIndicator(
              onRefresh: onRefresh,
              child: SizedBox(
                  // color: Colors.red,
                  width: size.wScreen(100.0),
                  height: size.hScreen(100.0),
                  child:
                      Consumer<InformeController>(builder: (_, provider, __) {
                    if (provider.getErrorInformesGuardia == null) {
                      return const NoData(
                        label: 'Cargando datos...',
                      );
                    } else if (provider.getErrorInformesGuardia == false) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                      // Text("Error al cargar los datos");
                    } else if (provider.getListaInformesInforme.isEmpty) {
                      return const NoData(
                        label: 'No existen datos para mostar',
                      );
                      // Text("sin datos");
                    }
                    return ListView.builder(
                      itemCount: provider.getListaInformesInforme.length,
                      itemBuilder: (BuildContext context, int index) {
                        final informe = provider.getListaInformesInforme[index];
                        return Slidable(
                          startActionPane: ActionPane(
                            // A motion is a widget used to control how the pane animates.
                            motion: const ScrollMotion(),

                            children: [
                              widget.usuario!.usuario == informe['infUser']
                                  ? SlidableAction(
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      // label: 'Editar',
                                      onPressed: (context) {
                                        // loadData;
                                        provider.resetValuesInformes();
                                        // provider.getDataInformeGuardia(informe);
                                        provider.getDataInformes(informe);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    EditaInformeGuardiaPage(
                                                        usuario:
                                                            widget.usuario!,
                                                        informe:
                                                            provider.getListaInformesInforme[
                                                                    index]
                                                                ['infGuardias'],
                                                        fecha: informe[
                                                            'infFechaSuceso']))));
                                      },
                                    )
                                  : SizedBox(),
                              SlidableAction(
                                onPressed: (context) async {
                                  // ProgressDialog.show(context);
                                  await provider.eliminaInformeGuardia(
                                      context, informe['infId']);
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          DetalleInformeGuardiaPage(
                                            // informe: informe,
                                            informe: provider
                                                .getListaInformesInforme[index],
                                          ))));
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
                                                    'Asunto: ',
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
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
                                                    // '${informe['infAsunto']}',
                                                    '${informe['infAsunto']}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
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
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(50.0),
                                                  child: Text(
                                                    'Dirigido a: ',
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                  ),
                                                ),
                                                Container(
                                                  width: size.wScreen(75.0),
                                                  // color: Colors.red,
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),

                                                  child: Text(
                                                    '${informe['infNomDirigido']}' ,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
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
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    'Fecha: ',
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),
                                                  // width: size.wScreen(100.0),
                                                  child: Text(
                                                    // informe['infFecReg']
                                                    //     .toString()
                                                    //     .replaceAll(
                                                    //         ".000Z", ""),
                                                    informe['infFecReg']
                                                        .toString()
                                                        .replaceAll("T", " ")
                                                        .replaceAll(
                                                            "000Z", " "),
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
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
                                                  // width: size.wScreen(50.0),
                                                  child: Text(
                                                    'Elaborado por: ',
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: size
                                                                .iScreen(1.5),
                                                            color:
                                                                Colors.black87,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                  ),
                                                ),
                                                Container(
                                                  width: size.wScreen(60.0),
                                                  // color: Colors.red,
                                                  margin: EdgeInsets.only(
                                                      top: size.iScreen(0.5),
                                                      bottom:
                                                          size.iScreen(0.0)),

                                                  child: Expanded(
                                                    child: Text(
                                                      '${informe['infGenerado']}' ,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.lexendDeca(
                                                              fontSize: size
                                                                  .iScreen(1.2),
                                                              color:
                                                                  Colors.black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Column(
                                      //   children: [
                                      //     Text(
                                      //       'Estado',
                                      //       style: GoogleFonts.lexendDeca(
                                      //           fontSize: size.iScreen(1.6),
                                      //           color: Colors.black87,
                                      //           fontWeight: FontWeight.normal),
                                      //     ),
                                      //     CupertinoSwitch(
                                      //       activeColor:
                                      //           const Color(0XFF3da9f4),
                                      //       value: true,
                                      //       // (multas.nomEstado == 'ACTIVA')
                                      //       //     ? true
                                      //       //     : false,
                                      //       onChanged: (value) {
                                      //         // _modalEstadoMulta(
                                      //         //     size,
                                      //         //     multasControler,
                                      //         //     multas,
                                      //         //     'INACTIVA');
                                      //       },
                                      //     ),
                                      //     // Switch(
                                      //     //   value: true,
                                      //     //   onChanged: (val) {},
                                      //     // ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: primaryColor,
              child: const Icon(Icons.add),
              onPressed: () {
                informeController.resetValuesInformes();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => CrearInformeGuardiaPage(
                            usuario: widget.usuario!))));
              },
            )),
      ),
    );
  }

  Future<void> onRefresh() async {
    final informeController =
        Provider.of<InformeController>(context, listen: false);
    informeController.buscaInformeGuardias('');
  }
}
