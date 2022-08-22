import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/controllers/novedades_controller.dart';
import 'package:sincop_app/src/models/lista_allNovedades_guardia.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/detalle_multa_guardia.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/widgets/error_data.dart';
import 'package:sincop_app/src/widgets/no_data.dart';
import 'package:provider/provider.dart';

class ListaMultasGuardias extends StatefulWidget {
 final Session? user;
   const ListaMultasGuardias({Key? key,  this.user}) : super(key: key);

  @override
  State<ListaMultasGuardias> createState() => _ListaMultasGuardiasState();
}

class _ListaMultasGuardiasState extends State<ListaMultasGuardias> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Responsive size = Responsive.of(context);

    final multasControler = Provider.of<MultasGuardiasContrtoller>(context);
    //  final Session usuario = ModalRoute.of(context)!.settings.arguments;
    // final usuario=multasControler.infoUser!.usuario;
    // print('USUARIO LOGUEADO: $usuario');

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: const Color(0XFF343A40), // primaryColor,
            title:  const Text('Lista de Multas'),
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
            child: Consumer<MultasGuardiasContrtoller>(
              builder: (_, providers, __) {
                if (providers.getErrorMultas == null) {
                  return Center(
                                    // child: CircularProgressIndicator(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Cargando Datos...',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.5),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //***********************************************/
                                        SizedBox(
                                          height: size.iScreen(1.0),
                                        ),
                                        //*****************************************/
                                        const CircularProgressIndicator(),
                                      ],
                                    ),
                                  );
                } else if (providers.getListaTodasLasMultasGuardias.isEmpty) {
                  return const NoData(
                    label: 'No existen multas para mostar',
                  );
                } else if (providers.getListaTodasLasMultasGuardias.isEmpty) {
                  return const NoData(
                    label: 'No existen datos para mostar',
                  );
                  // Text("sin datos");
                }

                return ListView.builder(
                    itemCount:
                        multasControler.getListaTodasLasMultasGuardias.length,
                    itemBuilder: (BuildContext context, int index) {




                      final multas =
                          multasControler.getListaTodasLasMultasGuardias[index];
// print('XXXXX: ${widget.user!.usuario}');
                      return 
                      Slidable(
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),

                          // // A pane can dismiss the Slidable.
                          // dismissible: DismissiblePane(onDismissed: () {}),

                          // All actions are defined in the children parameter.
                          children: [
                              multas.nomEstado=='ACTIVA' && widget.user!.usuario ==multas.nomDocuPer?SlidableAction(
                              onPressed: (context)  {
                               multasControler.getInfomacionMulta(multas);
                             Navigator.pushNamed(context, 'crearApelacionPage');
                              },
                              backgroundColor:tercearyColor, //Colors.red.shade700,
                              foregroundColor: Colors.white,
                              icon: Icons.speaker_notes_outlined,
                              // label: 'Apelar',
                            ):Container(),
                            SlidableAction(
                              onPressed: (context) async {
                                ProgressDialog.show(context);
                                await multasControler.eliminaMultaGuardia(
                                    context, multas);
                                ProgressDialog.dissmiss(context);
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
                            // Navigator.pushNamed(context, 'detalleMultaGuardia');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        DetalleMultaGuardiaPage(
                                            infoMultaGuardia: multas))));
                          },
                          child: ClipRRect(
                            // borderRadius: BorderRadius.circular(8),
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.only(top: size.iScreen(0.5)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.iScreen(1.0),
                                    vertical: size.iScreen(0.5)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 1.0,
                                        offset: Offset(0.0, 1.0))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                             Container(
                                            // color: Colors.red,
                                            margin: EdgeInsets.only(
                                                top: size.iScreen(0.5),
                                                bottom: size.iScreen(0.0)),
                                            width: size.wScreen(100.0),
                                            child: Text(
                                              '${multas.nomNombrePer}',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: size.iScreen(1.8),
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: size.iScreen(0.5),
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Tipo: ',
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
                                                    bottom: size.iScreen(0.0)),
                                                width: size.wScreen(60.0),
                                                child: Text(
                                                  '${multas.nomDetalle}',
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
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Multa: ',
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
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  '${multas.nomPorcentaje} %',
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
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Ciudad: ',
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
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  '${multas.nomCiudad}',
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
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  'Fecha de registro: ',
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
                                                    bottom: size.iScreen(0.0)),
                                                // width: size.wScreen(100.0),
                                                child: Text(
                                                  multas.nomFecReg
                                                      .toString()
                                                      .replaceAll(".000Z", ""),
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
                                    Column(
                                      children: [
                                        Text(
                                          'Estado',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.6),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Text(
                                          '${multas.nomEstado}',
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: size.iScreen(1.6),
                                              color: tercearyColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                      
                      
                      
                      //   },
                      // );
                    });
              },
            ),
          ),
         ),
    );
  }

//====== MUESTRA MODAL DE TIPO DE DOCUMENTO =======//
  void _modalEstadoMulta(
      Responsive size,
      MultasGuardiasContrtoller multasControler,
      Result? multa,
      String? estado) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.wScreen(5.0), vertical: size.wScreen(3.0)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Aviso',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
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
                  Text('Seguro de cambiar el estado de esta multa ?',
                      style: GoogleFonts.lexendDeca(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.normal,
                        // color: Colors.white,
                      )),
                  //*****************************************/
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),

                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),
                    // color: Colors.blue,
                    child: Text('Ingrese motivo de anulación:',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        )),
                  ),
                  TextFormField(
                    // controller: textUsuario,
                    // initialValue: 'demo',
                    // initialValue: (textUsuario.text==true)? textUsuario.text:'',
                    maxLines: 2,
                    decoration: const InputDecoration(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(

                        // fontSize: size.iScreen(3.5),
                        // fontWeight: FontWeight.bold,
                        // letterSpacing: 2.0,
                        ),
                    onChanged: (text) {
                      multasControler.onInputAnulacionDeMultaChange(text);
                    },
                    validator: (text) {
                      if (text!.trim().isNotEmpty) {
                        return null;
                      } else {
                        return 'Ingrese motivo de desacitvación';
                      }
                    },
                    onSaved: (value) {
                      // codigo = value;
                      // tipoMultaController.onInputFDetalleNovedadChange(value);
                    },
                  ),
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: size.iScreen(1.0), bottom: size.iScreen(2.0)),
                    height: size.iScreen(3.5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF0A4280),
                        ),
                      ),
                      onPressed: () async {
                        ProgressDialog.show(context);
                        await multasControler.actualizaEstadoMulta(
                            context, multa!);

                        ProgressDialog.dissmiss(context);
                        Navigator.pop(context);
                      },
                      child: Text('Si',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(1.8),
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
