// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class BuscarClientesVarios extends StatefulWidget {
  const BuscarClientesVarios({Key? key}) : super(key: key);

  @override
  State<BuscarClientesVarios> createState() => _BuscarClientesVariosState();
}

class _BuscarClientesVariosState extends State<BuscarClientesVarios> {
  TextEditingController textSearchGuardiaMulta = TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    textSearchGuardiaMulta.text = '';
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
        body:
         Container(
          margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.5)),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.iScreen(1.5),
              ),
              //*****************************************/
              
              TextFormField(
                controller: textSearchGuardiaMulta,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'b??squeda Personal',
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
                    return 'Ingrese dato para b??squeda';
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
              Wrap(
                children: informeController.getListaGuardiaInforme
                    .map(
                      (e) => GestureDetector(
                        onTap: () => informeController.eliminaGuardiaInforme(e['id']) ,
                        child: Container(
                          margin: EdgeInsets.all(size.iScreen(0.6)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              padding: EdgeInsets.all(size.iScreen(0.2)),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                              ),
                              width: size.iScreen(13.0),
                              child: Text(
                                '${e['nombres']}.',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.4),
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
    //       
    
              Expanded(
                  child: SizedBox(
                      // color: Colors.red,
                      width: size.iScreen(100),
                      child: Consumer<MultasGuardiasContrtoller>(
                        builder: (_, provider, __) {
                          if (provider.getErrorInfoCliente == null) {
                            return const NoData(
                              label: 'Ingrese dato para b??squeda',
                            );
                          } else if (provider.getErrorInfoCliente ==
                              false) {
                             return const NoData(
                              label: 'No existen datos para mostar',
                            );
                          } else if (provider
                              .getListaInfoCliente.isEmpty) {
                            return const NoData(
                              label: 'No existen datos para mostar',
                            );
                            // Text("sin datos");
                          }
    
                          return ListView.builder(
                            itemCount: provider.getListaInfoCliente.length,
                            itemBuilder: (BuildContext context, int index) {
                              final cliente =
                                  provider.getListaInfoCliente[index];
                              return Card(
                                child: ListTile(
                                  visualDensity: VisualDensity.compact,
                                  title: Text(
                                    '${cliente['cliRazonSocial']}',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        // color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  subtitle: Text(
                                    '${cliente['cliDocNumero']}',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.7),
                                        // color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onTap: () {
                                    // provider.setGuardiaInforme(guardia);
                                    provider.setListaCorreosClienteMultas(cliente['cliId'],cliente['cliDocNumero'],cliente['cliRazonSocial'],cliente['perEmail']);
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
