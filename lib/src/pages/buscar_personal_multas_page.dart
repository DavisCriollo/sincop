
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class BuscarPersonalMultas extends StatefulWidget {
  const BuscarPersonalMultas({Key? key}) : super(key: key);

  @override
  State<BuscarPersonalMultas> createState() => _BuscarPersonalMultasState();
}

class _BuscarPersonalMultasState extends State<BuscarPersonalMultas> {
    TextEditingController textSearchGuardiaMulta= TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    textSearchGuardiaMulta.text='';
// final loadData= MultasGuardiasContrtoller();
// await loadData.buscaGuardiaMultas('a');
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final multasController = Provider.of<MultasGuardiasContrtoller>(context);
    return Scaffold(
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
              controller: textSearchGuardiaMulta,
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
                multasController.onInputBuscaGuardiaChange(text);
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
              child:
              Consumer<MultasGuardiasContrtoller>(builder: (_, provider, __) {
               
                 if (provider.getErrorInfoMultaGuardia== null) {
                return const NoData(
                  label: 'Ingrese dato para búsqueda',
                );
              }
               else if (provider.getErrorInfoMultaGuardia == false) {
                return const NoData(label: 'No existen datos para mostar',
                );
               
              } 
              else if (provider.getListaInfoMultaGuardia.isEmpty) {
                return const NoData(
                  label: 'No existen datos para mostar',
                );
                // Text("sin datos");
              }
                
                
                
                
                
               return 
                ListView.builder(
                itemCount: provider.getListaInfoMultaGuardia.length,
                itemBuilder: (BuildContext context, int index) {
                  final guardia =
                      provider.getListaInfoMultaGuardia[index];
                  return Card(
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        '${guardia.perNombres} ${guardia.perApellidos}',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.8),
                            // color: Colors.black54,
                            fontWeight: FontWeight.normal),
                      ),
                      subtitle: Text(
                        '${guardia.perDocNumero}',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.7),
                            // color: Colors.black54,
                            fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        // _submit(provider);
                        provider.setIdPersonaMulta=guardia.perId;
                        provider.setCedPersonaMulta =guardia.perDocNumero;
                        provider.setNomPersonaMulta ='${guardia.perNombres} ${guardia.perApellidos}';
                        provider.resetValuesMulta();
                         Navigator.pushNamed(context, 'crearMultasGuardias');
                          
                      },
                    ),
                  );
                
                },
              );
             
              },)
              
            ))
          ],
        ),
      ),
   
   
   
   
    );
  }

  void _submit(MultasGuardiasContrtoller controllerMultas) async {
    final conexion = await Connectivity().checkConnectivity();
    if (conexion == ConnectivityResult.none) {
      NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
    } else if (conexion == ConnectivityResult.wifi ||
        conexion == ConnectivityResult.mobile) {
      ProgressDialog.show(context);
      // await controllerMultas.buscaGuardiaMultas('');
      ProgressDialog.dissmiss(context);
      final response = controllerMultas.getErrorInfoMultaGuardia;
      if (response == true) {
        Navigator.pushNamed(context, 'crearMultasGuardias');
      } else {
        NotificatiosnService.showSnackBarDanger('No existe registrto');
      }
    }
  }
}
