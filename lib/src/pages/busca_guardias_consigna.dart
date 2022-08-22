// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/consignas_clientes_controller.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class BuscarGuardiasConsignas extends StatefulWidget {
  const BuscarGuardiasConsignas({Key? key}) : super(key: key);

  @override
  State<BuscarGuardiasConsignas> createState() => _BuscarGuardiasConsignasState();
}

class _BuscarGuardiasConsignasState extends State<BuscarGuardiasConsignas> {
  TextEditingController textSearchGuardiaConsignas = TextEditingController();
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    textSearchGuardiaConsignas.text = '';
// final loadInfo = Provider.of<ConsignasClientesController>(context, listen: false);
//     loadInfo.buscaGuardiasConsigna('');

  }




  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final consignasController = Provider.of<ConsignasClientesController>(context);
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
              controller: textSearchGuardiaConsignas,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'búsqueda Guardias',
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
                consignasController.onInputBuscaGuardiaChange(text);
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
              Wrap(
              children: consignasController.getListaGuardiasConsigna
                  .map(
                    (e) => GestureDetector(
                      onTap: () => consignasController.eliminaGuardiaConsigna(e['id']) ,
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
                    child: Consumer<ConsignasClientesController>(
                      builder: (_, provider, __) {
                        if (provider.getErrorLoadPersonal == null) {
                          return const NoData(
                            label: 'Ingrese dato para búsqueda',
                          );
                        } else if (provider.getErrorLoadPersonal ==
                            false) {
                         return const NoData(
                            label: 'No existen datos para mostar',
                          );
                        } else if (provider
                            .getListaInfoGuardiaConsigna.isEmpty) {
                          return const NoData(
                            label: 'No existen datos para mostar',
                          );
                          // Text("sin datos");
                        }

                        return ListView.builder(
                          itemCount: provider.getListaInfoGuardiaConsigna.length,
                          itemBuilder: (BuildContext context, int index) {
                            final guardia =
                                provider.getListaInfoGuardiaConsigna[index];
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
                                  provider.setGuardiaConsigna(guardia);
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
    );
  }
}
