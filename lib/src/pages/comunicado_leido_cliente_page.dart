
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/comunicados_clientes_controller.dart';
import 'package:sincop_app/src/models/lista_allComunicados_clientes.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ComunicadoLeidoClientePage extends StatelessWidget {
 final  Result? infoComunicadoCliente;

  const ComunicadoLeidoClientePage({Key? key, this.infoComunicadoCliente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);

    final comunicadoController =
        Provider.of<ComunicadosController>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text('Detalle de Comunicado'),
          ),
          body: Container(
            // color: Colors.red,
            margin: EdgeInsets.only(top: size.iScreen(3.0)),
            padding: EdgeInsets.symmetric(horizontal: size.iScreen(2.0)),
            width: size.wScreen(100.0),
            height: size.hScreen(100),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Row(
                      children: [
                        Text('Asunto:',
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                        Spacer(),
                        Text(
                            infoComunicadoCliente!.comFecReg
                                .toString()
                                .replaceAll(".000Z", ""),
                            style: GoogleFonts.lexendDeca(
                                // fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      // 'item Novedad: ${controllerActividades.getItemMulta}',
                      '"${infoComunicadoCliente!.comAsunto}"',
                      textAlign: TextAlign.center,
                      //
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.3),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),

                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Detalle:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    child: Text(
                      '${infoComunicadoCliente!.comDetalle}',
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(1.8),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Fecha:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),
                   //***********************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                   //***********************************************/

                 Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Desde: ',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' 2022-03-15',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                // color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                           
                         
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Hasta :',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.7),
                                color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' 2022-07-19',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(1.8),
                                // color: Colors.black45,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                           
                         
                          ],
                        ),
                      ],
                    ),
                  //*****************************************/
                   
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                   //***********************************************/
                  Container(
                    margin: EdgeInsets.only(bottom: size.iScreen(2.0)),
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Leido por:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),

                  SizedBox(
                    width: size.wScreen(100.0),
                    height: size.wScreen(10.0 *
                        5.8), //Calcular el tamanio depende al numero de elementos de la lista
                    child: 
                
                    Consumer<ComunicadosController>(builder: (_, dataProvider, __){
            if (dataProvider.getError == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataProvider.getError == false) {
                return const NoData(
                  label: 'Error al cargar la información',
                );
                // Text("Error al cargar los datos");
              } else if (dataProvider.getListaTodosLosComunicadosCliente.isEmpty) {
                return const NoData(
                  label: 'No existen datos para mostar',
                );
                // Text("sin datos");
              }


                      return    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: infoComunicadoCliente!.comLeidos!.length,
                      itemBuilder: (BuildContext context, int index) {
                        
                        return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            margin: EdgeInsets.only(bottom: size.iScreen(0.5)),
                            padding: EdgeInsets.only(
                                top: size.iScreen(0.9),
                                left: size.iScreen(0.5),
                                right: size.iScreen(0.5),
                                bottom: size.iScreen(0.9)),
                            // width: size.wScreen(100.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${infoComunicadoCliente!.comLeidos![index]['nombres']}',
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: size.iScreen(1.8),
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                // const Icon(Icons.chevron_right_outlined),
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ],
                            ));
                      },
                    );
                 
                 
                    } 
                    
                    
                    ),
                    
                    
                    
                 
                  )

                  //***********************************************/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
