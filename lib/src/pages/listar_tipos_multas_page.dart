import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
// import 'package:sincop_app/src/controllers/tipo_multas_controller.dart';
import 'package:sincop_app/src/pages/buscar_personal_multas_page.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class TipoMultasPage extends StatefulWidget {
  const TipoMultasPage({Key? key}) : super(key: key);
  @override
  State<TipoMultasPage> createState() => _TipoMultasPageState();
}

class _TipoMultasPageState extends State<TipoMultasPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    // await MultasGuardiasContrtoller().buscaGuardiaMultas();
  }

  int val = -1;
  //  var data;
  // List<MyItems>? _itemsPanel = [
  //   MyItems('1%', [
  //     'Abandono de puesto',
  //     'Estado Etílico o aliento a licor fff ffff fff',
  //     'Falta de Respeto',
  //     'Dormido en pueesto de trabajo',
  //     'falta Injustificada',
  //     'Otros'
  //   ]),
  //   MyItems('5%', ['body A', 'body B', 'body C', 'body D']),
  //   MyItems('10%', [
  //     'body A',
  //     'body B',
  //     'body C',
  //     'body D',
  //     'body B',
  //     'body C',
  //     'body D',
  //     'body D',
  //     'body B',
  //     'body C',
  //     'body D',
  //     'body D',
  //     'body B',
  //     'body C',
  //     'body D',
  //   ]),
  //   MyItems('15%', ['body A', 'body B', 'body C', 'body D']),
  //   MyItems('20%', ['body A', 'body B', 'body C', 'body D']),
  //   MyItems('25%', ['body A', 'body B', 'body C', 'body D']),
  //   MyItems('30%', ['body A', 'body B', 'body C', 'body D']),
  //   MyItems('35%', ['body A', 'body B', 'body C', 'body D']),
  //   MyItems('40%', ['body A', 'body B', 'body C', 'body D']),
  //   MyItems('50%', ['body A', 'body B', 'body C', 'body D'])
  // ];

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final tipoMultasController =
        Provider.of<MultasGuardiasContrtoller>(context);

// print('AQUI ; ${tipoMultasController.getListaTodosLosTiposDeMultas.length}');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        appBar: AppBar(
          // backgroundColor: const Color(0XFF343A40), // primaryColor,
          title: Text(
            'Tipos de Multas',
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
          // color: Colors.red,
          width: size.wScreen(100.0),
          height: size.hScreen(100.0),
          padding: EdgeInsets.only(
            top: size.iScreen(0.0),
            left: size.iScreen(1.0),
            right: size.iScreen(1.0),
          ),
          child: Consumer<MultasGuardiasContrtoller>(
            builder: (_, providers, __) {
              if (providers.getErrorTiposMultas == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (providers.getErrorTiposMultas == false) {
                return const NoData(
                  label: 'No existen datos para mostar',
                );
              } else if (providers.getListaTodosLosTiposDeMultas.isEmpty) {
                return const NoData(
                  label: 'No existen datos para mostar',
                );
                // Text("sin datos");
              }

              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: providers.getListaTodosLosTiposDeMultas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tipoMulta =
                        providers.getListaTodosLosTiposDeMultas[index];
                    return ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      title: Text(
                        // '${tipoMulta.novTipo}  ${tipoMulta.novPorcentaje} %     $index',
                        '${tipoMulta.novTipo}  ${tipoMulta.novPorcentaje} % ',
                        style: TextStyle(
                            fontSize: size.iScreen(1.9),
                            fontWeight: FontWeight.w500),
                      ),
                      children: <Widget>[
                        SizedBox(
                          height: size.iScreen(providers
                                  .getListaTodosLosTiposDeMultas.length
                                  .toDouble() *
                              13.0),
                          child: ListView.builder(
                            itemCount: tipoMulta.novlista!.length,
                            itemBuilder: (BuildContext context, int i) {
                              final nombreTipo = tipoMulta.novlista![i];
                              return RadioListTile(
                                //  activeColor:Colors.red,
                                //  tileColor:Colors.red,

                                title: Text(
                                  // ' ${nombreTipo.nombre} - $index - ${tipoMulta.novlista!.indexOf(tipoMulta.novlista![i],i)} ',
                                  ' ${nombreTipo.nombre} ',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.9),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                value:
                                    '$index${tipoMulta.novlista!.indexOf(tipoMulta.novlista![i], i)}',
                                //  value: '${_itemsPanel!.indexOf(e)}$i',
                                groupValue:
                                    tipoMultasController.getItemTipoMulta,
                                onChanged: (value) {
                                  var data =
                                      '$index${tipoMulta.novlista!.indexOf(tipoMulta.novlista![i], i)}';
                                  val = int.parse(data);
                                  tipoMultasController.setItenTipoMulta(
                                      value,
                                      tipoMulta.novId,
                                      tipoMulta.novOrigen,
                                      tipoMulta.novTipo,
                                      tipoMulta.novPorcentaje,
                                      tipoMulta.novlista![i].nombre.toString());
                                  // print(data);
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: size.iScreen(1.0),
                              bottom: size.iScreen(2.0)),
                          height: size.iScreen(3.5),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                // const Color(0xFF0A4280),
                                primaryColor,
                              ),
                            ),
                            onPressed: () {
                              tipoMultasController.setCoords = '';
                              if (tipoMultasController
                                  .getTextoTipoMulta.isNotEmpty) {
                                _modalRegistraMulta(size, tipoMultasController);
                                //  Navigator.pushNamed(context, 'crearMultasGuardias');
                                // tipoMultasController.resetValuesMulta();
                                // tipoMultasController.buscaGuardiaMultas('');

                              } else {
                                NotificatiosnService.showSnackBarDanger(
                                    'Debe seleccionar una multa');
                              }
                            },
                            child: Text('Asignar',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.8),
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ),
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

//======================== VAALIDA SCANQR =======================//
  void _validaScanQRMulta(
      Responsive size, MultasGuardiasContrtoller tipoMultasController) async {
    try {
      await tipoMultasController.setInfoQRMultaGuardia(
          await FlutterBarcodeScanner.scanBarcode(
              '#34CAF0', '', false, ScanMode.QR));
      if (!mounted) return;
      ProgressDialog.show(context);

      ProgressDialog.dissmiss(context);
      final response = tipoMultasController.getErrorInfoMultaGuardia;
      if (response == true) {
        // tipoMultasController.buscaGuardiaMultas();
        Navigator.pushNamed(context, 'crearMultasGuardias');
      } else {
        NotificatiosnService.showSnackBarDanger('No existe registrto');
      }
    } on PlatformException {
      NotificatiosnService.showSnackBarError('No se pudo escanear ');
    }
  }

  //====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalRegistraMulta(
      Responsive size, MultasGuardiasContrtoller tipoMultasController) {
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
                  Text('SELECCIONAR PERSONA',
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
                          // homeController.setOpcionActividad(1);
                          tipoMultasController.resetValuesMulta();
                          _validaScanQRMulta(size, tipoMultasController);
                          Navigator.pop(context);
                          // _modalTerminosCondiciones(size, homeController);
                        },
                      ),
                      // const Divider(),
                      // ListTile(
                      //   tileColor: Colors.grey[200],
                      //   leading: const Icon(Icons.badge_outlined,
                      //       color: Colors.black),
                      //   title: Text(
                      //     "Código Personal",
                      //     style: GoogleFonts.lexendDeca(
                      //       fontSize: size.iScreen(1.5),
                      //       fontWeight: FontWeight.bold,
                      //       // color: Colors.white,
                      //     ),
                      //   ),
                      //   trailing: const Icon(Icons.chevron_right_outlined),
                      //   onTap: () {
                      //     // print('EEEERRRRR');

                      //     // Navigator.pop(context);
                      //     // Navigator.pushNamed(context, 'validaAccesoMultas');
                      //   },
                      // ),
                      const Divider(),
                      ListTile(
                        tileColor: Colors.grey[200],
                        leading: const Icon(Icons.badge_outlined,
                            color: Colors.black),
                        title: Text(
                          "Nómina de Guardias",
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_outlined),
                        onTap: () {
                          // tipoMultasController.setOpcionActividad(3);
                          //
                          tipoMultasController.resetValuesMulta();
                          Navigator.pop(context);

                          // Navigator.pushNamed(
                          // context, 'buscarPersonalMultaGuardia');
                          // tipoMultasController.buscaGuardiaMultas('');

                          // Navigator.pop(context);

                          Provider.of<AvisoSalidaController>(context,listen: false).buscaInfoGuardias('');
                          Navigator.pushNamed(context, 'buscaGuardias',
                              arguments: 'crearMulta');
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
}

// class MyItems {
//   bool isExpanded = false;
//   final String? header;
//   final List<String>? body;

//   MyItems(this.header, this.body);
// }
