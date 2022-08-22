// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/ausencias_controller.dart';
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

class BuscarGuardias extends StatefulWidget {
  // final String? modulo;

  const BuscarGuardias({Key? key}) : super(key: key);

  @override
  State<BuscarGuardias> createState() => _BuscarGuardiasState();
}

class _BuscarGuardiasState extends State<BuscarGuardias> {
  TextEditingController textSearchGuardias = TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    textSearchGuardias.text = '';
// final loadData= MultasGuardiasContrtoller();
// await loadData.buscaGuardiaMultas('a');
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final informeController = Provider.of<InformeController>(context);
    final modulo = ModalRoute.of(context)!.settings.arguments;

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        appBar: AppBar(
          // backgroundColor: const Color(0XFF343A40), // primaryColor,
          title: Text(
            'Buscar Personal',
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
                controller: textSearchGuardias,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'búsqueda Personal',
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
                  informeController.onInputBuscaGuardiaChange(text);
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
                      child: Consumer<AvisoSalidaController>(
                        builder: (_, provider, __) {
                          if (provider.getErrorInfoGuardia == null) {
                            return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            height: size.iScreen(2.0),
                          ),
                          const Text('Cargando lista de Guardias.... '),
                        ],
                      ),
                    );
                          } else if (provider.getErrorInfoGuardia == false) {
                            return const NoData(
                              label: 'No existen datos para mostar',
                            );
                          } else if (provider.getListaInfoGuardia.isEmpty) {
                            return const NoData(
                              label: 'No existen datos para mostar',
                            );
                            // Text("sin datos");
                          }
    
                          return ListView.builder(
                            itemCount: provider.getListaInfoGuardia.length,
                            itemBuilder: (BuildContext context, int index) {
                              final guardia = provider.getListaInfoGuardia[index];
                              return Card(
                                child: ListTile(
                                  visualDensity: VisualDensity.compact,
                                  title: Text(
                                    '${guardia['perNombres']} ${guardia['perApellidos']}',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        // color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  subtitle: Text(
                                    '${guardia['perDocNumero']}',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.7),
                                        // color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onTap: () {
                                    if (modulo == 'cambioPuesto') {
                                      final controllerCambioPuesto =
                                          Provider.of<CambioDePuestoController>(
                                              context,
                                              listen: false);
                                      controllerCambioPuesto
                                          .getInfoGuardia(guardia);
                                      Navigator.pop(context);
                                    } else if (modulo == 'avisoSalida') {
                                      provider.getInfomacionGuardia(
                                          guardia['perId'],
                                          guardia['perDocNumero'],
                                          guardia['perNombres'],
                                          guardia['perApellidos']);
                                      Navigator.pop(context);
                                    } else if (modulo == 'ausencia') {
                                      Provider.of<AusenciasController>(context,
                                          listen: false).getInfomacionGuardia(guardia);
                                      Navigator.pop(context);
                                    }
                                    else if (modulo == 'turnoExtra') {
                                      Provider.of<TurnoExtraController>(context,
                                          listen: false).getInfoGuardia(guardia);
                                      Navigator.pop(context);
                                    }
                                    else if (modulo == 'crearMulta') {
    
                                        print(' SIIIII: $modulo');
    
                                      Provider.of<MultasGuardiasContrtoller>(context,
                                          listen: false).getInfomacionGuardia( guardia['perId'],
                                          guardia['perDocNumero'],
                                          guardia['perNombres'],
                                          guardia['perApellidos'],
                                          guardia['perLugarTrabajo'],
                                          guardia['perPuestoServicio']);
                                      Navigator.pop(context);
                                       Navigator.pushNamed(context, 'crearMultasGuardias');
    
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
      ),
    );
  }
}
