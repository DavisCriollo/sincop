
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';
import 'package:sincop_app/src/controllers/novedades_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:provider/provider.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ValidaAccesoMultas extends StatefulWidget {
  const ValidaAccesoMultas({Key? key}) : super(key: key);

  @override
  State<ValidaAccesoMultas> createState() => _ValidaAccesoMultasState();
}

class _ValidaAccesoMultasState extends State<ValidaAccesoMultas> {
  final TextEditingController _textSearchController = TextEditingController();

@override
  void dispose() {
    _textSearchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final controllerMultas = Provider.of<MultasGuardiasContrtoller>(context);
    // final controllerHome = Provider.of<HomeController>(context);
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: const Color(0xffF2F2F2),
            appBar: AppBar(
              // backgroundColor: const Color(0XFF343A40), // primaryColor,
              title: Text(
                'Valida Acceso',
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
              padding: EdgeInsets.symmetric(horizontal: size.iScreen(5.0)),
              width: size.wScreen(100.0),
              height: size.hScreen(100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: size.iScreen(3.0)), // color: Colors.blue,
                    child: Text('Ingrese su código de verificación.',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            // color: textPrimaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.wScreen(5.0)),
                    child: Form(
                      key: controllerMultas.validaMultasGuardiaFormKey,
                      child: TextFormField(
                        controller: _textSearchController,
                        // keyboardType: TextInputType.number,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'^(\d+)?\.?\d{0,2}'))
                        // ],
                        autofocus: true,
                        textInputAction: TextInputAction.send,
                        // textCapitalization: TextCapitalization.characters,
                        validator: (text) {
                          if (text!.trim().isNotEmpty) {
                            return null;
                          } else {
                            return 'Código Invalido';
                          }
                        },
                        // textInputAction: TextInputAction.none,
                        textAlign: TextAlign.center,

                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        )),
                        style: TextStyle(
                          decoration: null,
                          letterSpacing: 2.0,
                          fontSize: size.iScreen(3.0),
                          fontWeight: FontWeight.normal,
                        ),

                        onChanged: (text) {
                          controllerMultas.onInputBuscaGuardiaChange(text);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.iScreen(2.5)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF0A4280),
                        ),
                      ),
                      onPressed: () {
                        _submit(controllerMultas);
                      },
                      child: Text('Validar',
                          style: GoogleFonts.lexendDeca(
                              fontSize: size.iScreen(2.3),
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ],
              ),
            ))
        // _formCodigoNovedades(size, controllerActividades),

        );
  }

 

  void _submit(MultasGuardiasContrtoller controllerMultas) async {
    final isValid = controllerMultas.validateFormValidaMulta();
    if (!isValid) return;
    if (isValid) {
      final conexion = await Connectivity().checkConnectivity();
      if (conexion == ConnectivityResult.none) {
        NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
      } else if (conexion == ConnectivityResult.wifi ||
          conexion == ConnectivityResult.mobile) {
             ProgressDialog.show(context);
          await controllerMultas.buscaGuardiaMultas('');
        ProgressDialog.dissmiss(context);
        final response = controllerMultas.getErrorInfoMultaGuardia;
        if (response==true) {
          //  print('SIIIIIIIII');
          // _textSearchController.text='';
        Navigator.pushNamed(context, 'crearMultasGuardias');
        }
        else{
          NotificatiosnService.showSnackBarDanger('No existe registrto');
        }

      }
    }
  }
}
