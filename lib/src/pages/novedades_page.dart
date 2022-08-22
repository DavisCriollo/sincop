import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/ausencias_controller.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
import 'package:sincop_app/src/controllers/cambio_puesto_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/controllers/novedades_controller.dart';
import 'package:sincop_app/src/controllers/turno_extra_controller.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/lista_multas_guardias_page.dart';
import 'package:sincop_app/src/pages/lista_multas_supervisor_page.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/widgets/item_menu_novedades.dart';
import 'package:provider/provider.dart';

class NovedadesPage extends StatefulWidget {
  final List<String?>? tipo;
  final Session? user;
  const NovedadesPage({Key? key, this.tipo, this.user}) : super(key: key);

  @override
  State<NovedadesPage> createState() => _NovedadesPageState();
}

class _NovedadesPageState extends State<NovedadesPage> {
  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);

    // print('====**> ${widget.tipo}- ${widget.user!.nombre}');
    final controllerActividades = Provider.of<ActividadesController>(context);
    final controllerMultas = Provider.of<MultasGuardiasContrtoller>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: Text(
          'Novedades',
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
      ),
      body: Container(
          // color: Colors.red,
          width: size.wScreen(100.0),
          // height: size.hScreen(100.0),
          padding: EdgeInsets.only(
            top: size.iScreen(0.0),
            left: size.iScreen(3.0),
            right: size.iScreen(3.0),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                // color: Colors.red,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: size.iScreen(1.0),
                  runSpacing: size.iScreen(2.0),
                  children: [
                    ItemsMenuNovedades(
                      onTap: () {
                        if (widget.tipo!.contains('SUPERVISOR')) {
                          // Navigator.pushNamed(context, 'listaMultasSupervisor');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ListaMultasSupervisor(user: widget.user)));
                        } else {
// controllerMultas.getTodasLasMultasGuardia('');
//                         Navigator.pushNamed(context, 'listaMultasGuardias');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ListaMultasGuardias(user: widget.user)));
                        }
                      },
                      label: 'Multas',
                      icon: Icons.list_alt_outlined,
                      // icon: 'administrative-fine.png',
                      color: Colors.orange,
                    ),
                    (widget.tipo!.contains('SUPERVISOR'))
                        ? ItemsMenuNovedades(
                            onTap: () {
                              Provider.of<AvisoSalidaController>(context,
                                      listen: false)
                                  .buscaAvisosSalida('');

                              // _modalOpcionMulta(size, controllerActividades);
                              Navigator.pushNamed(
                                  context, 'listaAvisoSalidaGuardia');
                            },
                            label: 'Aviso de salida',
                            icon: Icons.connect_without_contact_outlined,
                            color: Colors.green,
                          )
                        : const SizedBox(),
                    (
                      // widget.tipo!.contains('GUARDIA') ||
                            widget.tipo!.contains('SUPERVISOR'))
                        ? ItemsMenuNovedades(
                            onTap: () {
                              // _modalOpcionMulta(size, controllerActividades);
                              Provider.of<CambioDePuestoController>(context,
                                      listen: false)
                                  .buscaCambioPuesto('');
                              Navigator.pushNamed(
                                  context, 'listaCambioDePuesto');
                            },
                            label: 'Cambio de puesto',
                            icon: Icons.transfer_within_a_station_outlined,
                            color: Colors.deepPurple,
                          )
                        : const SizedBox(),
                    (widget.tipo!.contains('SUPERVISOR'))
                        ? ItemsMenuNovedades(
                            onTap: () {
                              // _modalOpcionMulta(size, controllerActividades);
                              Provider.of<TurnoExtraController>(context,
                                      listen: false)
                                  .buscaTurnoExtra('');
                              Navigator.pushNamed(context, 'listaTurnoExtra');
                            },
                            label: 'Turno Extra',
                            icon: Icons.card_membership_outlined,
                            color: Colors.green,
                          )
                        : const SizedBox(),
                    ItemsMenuNovedades(
                      onTap: () {
                        Provider.of<AusenciasController>(context, listen: false)
                            .buscaAusencias('');
                        Navigator.pushNamed(context, 'listaAusencias');
                      },
                      label: 'Ausencias',
                      icon: Icons.event_busy_outlined,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalOpcionMulta(
      Responsive size, ActividadesController actividadesController) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('OPCIONES',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
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
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.iScreen(3.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading:
                            const Icon(Icons.qr_code_2, color: Colors.black),
                        title: Text(
                          "Código QR",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () async {
                          actividadesController.setOpcionMulta(1);
                          // Navigator.pop(context);
                          String barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                                  '#34CAF0', 'Cancelar', false, ScanMode.QR);

                          // print('RESPUESTA DEL ESCANNER ==========> : $barcodeScanRes ');
                          actividadesController.setInfoQR(barcodeScanRes);

                          // Navigator.pushNamed(context, 'validaAccesoMultas');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading: const Icon(Icons.badge_outlined,
                            color: Colors.black),
                        title: Text(
                          "Código Personal",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          actividadesController.setOpcionMulta(2);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'validaAccesoMultas');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading:
                            const Icon(Icons.list_alt, color: Colors.black),
                        title: Text(
                          "Nómina de Personal",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          actividadesController.setOpcionMulta(3);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'validaAccesoMultas');
                        },
                      ),
                      SizedBox(
                        height: size.iScreen(2.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  //===================================================//

}
