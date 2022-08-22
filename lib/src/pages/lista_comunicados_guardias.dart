import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/comunicados_clientes_controller.dart';
import 'package:sincop_app/src/models/lista_allComunicados_clientes.dart';
import 'package:sincop_app/src/pages/comunicado_leido_cliente_page.dart';
import 'package:sincop_app/src/pages/comunicado_leido_guardia_page.dart';
import 'package:sincop_app/src/pages/creaEdita_comunicado_cliente_page.dart';
import 'package:sincop_app/src/utils/dialogs.dart';

import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaComunicadosGuardiasPage extends StatefulWidget {
  const ListaComunicadosGuardiasPage({Key? key}) : super(key: key);

  @override
  State<ListaComunicadosGuardiasPage> createState() =>
      _ListaComunicadosGuardiasPageState();
}

class _ListaComunicadosGuardiasPageState
    extends State<ListaComunicadosGuardiasPage> {
  final TextEditingController _textSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);
    final comunicadoControler = Provider.of<ComunicadosController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        // backgroundColor: primaryColor,
        title: Consumer<ComunicadosController>(
          builder: (_, provider, __) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size.iScreen(0.1)),
                    child: (provider.btnSearch)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // margin: EdgeInsets.symmetric(
                                    //     horizontal: size.iScreen(0.0)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.iScreen(1.5)),
                                    color: Colors.white,
                                    height: size.iScreen(4.0),
                                    child: TextField(
                                      controller: _textSearchController,
                                      autofocus: true,
                                      onChanged: (text) {
                                        comunicadoControler.onSearchText(text);
                                        // setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        // icon: Icon(Icons.search),
                                        border: InputBorder.none,
                                        hintText: 'Buscar Comunicado',
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          // Border.all(
                                          //     color: Colors.white)
                                          Border(
                                        left: BorderSide(
                                            width: 0.0, color: Colors.grey),
                                      ),
                                    ),
                                    height: size.iScreen(4.0),
                                    width: size.iScreen(3.0),
                                    child: const Icon(Icons.search,
                                        color: primaryColor),
                                  ),
                                  onTap: () {
                                    // print('BUSCAR');
                                    // _textSearchController.text = '';
                                  },
                                )
                              ],
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            width: size.wScreen(90.0),
                            child: Text(
                              'Mis Comunicados',
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.45),
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                  ),
                ),
                IconButton(
                    splashRadius: 2.0,
                    icon: (!provider.btnSearch)
                        ? Icon(
                            Icons.search,
                            size: size.iScreen(3.5),
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.clear,
                            size: size.iScreen(3.5),
                            color: Colors.white,
                          ),
                    onPressed: () {
                      provider.setBtnSearch(!provider.btnSearch);
                      _textSearchController.text = "";
                      provider.getTodosLosComunicadosClientes('');
                    }),
              ],
            );
          },
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
        margin: EdgeInsets.symmetric(
          horizontal: size.iScreen(1.0),
        ),

        // color: Colors.red,
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),

        child:
            // ComunicadosClienteController<ComunicadosClienteController>(bu);
            Consumer<ComunicadosController>(
          builder: (_, provider, __) {
            if (provider.getError == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (provider.getError == false) {
               return const ErrorData();
              // Text("Error al cargar los datos");
            } else if (provider.getListaTodosLosComunicadosCliente.isEmpty) {
              return const NoData(
                label: 'No existen datos para mostar',
              );
              // Text("sin datos");
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: provider.getListaTodosLosComunicadosCliente.length,
              // itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                final comunicado =
                    provider.getListaTodosLosComunicadosCliente[index];
                return GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ComunicadoLeidoGuardiaPage(
                                infoComunicadoCliente: comunicado))));
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
                                  '${comunicado.comAsunto}',
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
                                  '${comunicado.comDetalle}',
                                  overflow: TextOverflow.ellipsis,
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
                                width: size.wScreen(100.0),
                                child: Text(
                                  comunicado.comFecReg
                                      .toString()
                                      .replaceAll(".000Z", ""),
                                  // '${comunicado.comFecReg.replaceAll("T", "-").replaceAll(".000Z", "")}',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: size.iScreen(1.5),
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


// perfil supervisor

//menu para: cliente -  
//compartir , contacenos, acerca de,  menu lateral 


 //guardia

//compartir , contacenos, acerca de,  menu lateral 
//  iniciar turno,
  //informe, bitacora,actividades, consignas, emergencias o alerta

  