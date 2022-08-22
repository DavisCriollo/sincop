//****************************************************/

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
import 'package:sincop_app/src/controllers/login_controller.dart';
import 'package:sincop_app/src/pages/home.dart';
import 'package:sincop_app/src/pages/home_page.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:sincop_app/src/utils/theme.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  // final logData = LoginController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ChangeNotifierProvider(
            create: (_) => LoginController(),
            builder: (context, __) {
              final controller = Provider.of<LoginController>(context);

              return Container(
                // color:Colors.green,
                width: size.iScreen(100.0),
                height: size.iScreen(100.0),
                margin: EdgeInsets.only(
                    bottom: size.iScreen(0.0), top: size.iScreen(0.0)),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // color:Colors.red,
                        margin: EdgeInsets.only(
                            bottom: size.iScreen(4.0), top: size.iScreen(4.0)),
                        width: size.wScreen(40.0),
                        // child: Image.asset('assets/imgs/logoNeitor.png'),
                        child: Image.asset('assets/imgs/Guardias.png'),
                      ),

                      Form(
                        key: controller.loginFormKey,
                        child: Container(
                          // color:Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.iScreen(5.0)),
                          margin: EdgeInsets.only(bottom: size.iScreen(1.0)),
                          width: size.wScreen(100.0),
                          // height: size.iScreen(25.0),
                          child: Column(
                            children: [
                              //*****************************************/
                              SizedBox(
                                width: size.wScreen(100.0),
                                // color: Colors.blue,
                                child: Text('Empresa',
                                    style: GoogleFonts.lexendDeca(
                                        // fontSize: size.iScreen(2.0),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey)),
                              ),
                              TextFormField(
                                readOnly: true,
                                initialValue: "PAZVISEG",
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.business_outlined)),
                                textAlign: TextAlign.start,
                                style: const TextStyle(

                                    // fontSize: size.iScreen(3.5),
                                    // fontWeight: FontWeight.bold,
                                    // letterSpacing: 2.0,
                                    ),
                                onChanged: (text) {
                                  controller.onChangeEmpresa("Neitor");
                                  // codigo = text;
                                },
                                validator: (text) {
                                  // if (text.trim().length > 0) {
                                  //   return null;
                                  // } else {
                                  //   return 'Código Invalido';
                                  // }
                                },
                                onSaved: (value) {
                                  // codigo = value;
                                },
                              ),

                              //***********************************************/
                              SizedBox(
                                height: size.iScreen(2.0),
                              ),

                              //*****************************************/
                              SizedBox(
                                width: size.wScreen(100.0),
                                // color: Colors.blue,
                                child: Text('Usuario',
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

                                decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.person_outline_outlined),
                                ),
                                textAlign: TextAlign.start,
                                style: const TextStyle(

                                    // fontSize: size.iScreen(3.5),
                                    // fontWeight: FontWeight.bold,
                                    // letterSpacing: 2.0,
                                    ),
                                onChanged: (text) {
                                  controller.onChangeUser(text);
                                },
                                validator: (text) {
                                  if (text!.trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Usuario Inválido';
                                  }
                                },
                                onSaved: (value) {
                                  // codigo = value;
                                  controller.onChangeUser(value!);
                                },
                              ),

                              //***********************************************/
                              SizedBox(
                                height: size.iScreen(2.0),
                              ),
                              //*****************************************/
                              SizedBox(
                                width: size.wScreen(100.0),
                                // color: Colors.blue,
                                child: Text('Clave',
                                    style: GoogleFonts.lexendDeca(
                                      // fontSize: size.iScreen(2.0),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    )),
                              ),
                              TextFormField(
                                // controller: textClave,
                                // initialValue: 'demo**+2022',
                                // initialValue: "data",
                                // initialValue: (textClave.text!=null) ?textClave.text:'',

                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      splashRadius: 5.0,
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: _obscureText
                                          ? const Icon(
                                              Icons.visibility_off_outlined)
                                          : const Icon(
                                              Icons.remove_red_eye_outlined)),
                                  // Icon(Icons.lock)
                                ),
                                obscureText: _obscureText,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    // fontSize: size.iScreen(3.5),
                                    // fontWeight: FontWeight.bold,
                                    // letterSpacing: 2.0,
                                    ),
                                onChanged: (text) {
                                  controller.onChangeClave(text);
                                },
                                validator: (text) {
                                  if (text!.trim().isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'Ingrese su Clave';
                                  }
                                },
                                onSaved: (value) {
                                  // codigo = value;
                                  controller.onChangeClave(value!);
                                },
                              ),
                              //***********************************************/
                            ],
                          ),
                        ),
                      ),
                      //===========================================//
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Container(
                          //   alignment: Alignment.centerRight,
                          //    margin: EdgeInsets.only(
                          //         top: size.iScreen(3.0),
                          //         bottom: size.iScreen(3.0),
                          //         left: size.iScreen(3.0),
                          //         right: size.iScreen(1.0),
                          //         ),
                          //   child: Row(
                          //     children: [
                          //       Consumer<LoginController>(
                          //         builder: (_, provider, __) {
                          //           return Checkbox(

                          //               // checkColor: Colors.green,
                          //               // fillColor: Colors.red,
                          //               focusColor: Colors.white,
                          //               value: provider.getRecuerdaCredenciales,
                          //               // value: true,
                          //               onChanged: (value) {
                          //                 provider.onRecuerdaCredenciales(value!);
                          //                 // print(value);
                          //               }
                          //               );
                          //         },
                          //       ),
                          //       Text(
                          //         'Recordarme',
                          //         style: GoogleFonts.lexendDeca(
                          //             fontSize: size.iScreen(1.7),
                          //             // fontWeight: FontWeight.bold,
                          //             color: Colors.grey),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          Container(
                            // color: Colors.red,
                            margin: EdgeInsets.only(
                              top: size.iScreen(0.0),
                              bottom: size.iScreen(.0),
                              left: size.iScreen(0.0),
                              right: size.iScreen(4.0),
                            ),
                            padding: EdgeInsets.only(
                              top: size.iScreen(0.0),
                              bottom: size.iScreen(0.0),
                              left: size.iScreen(0.0),
                              right: size.iScreen(0.0),
                            ),
                            //
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'password');
                              },
                              child: Text(
                                '¿Olvidé mi Clave?',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(1.7),
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                            ),
                          )

                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pushNamed(context, 'password');
                          //   },
                          //   child: Ink(
                          //     child: Container(
                          //       // alignment: Alignment.centerRight,
                          //       // color: Colors.red,
                          //       margin: EdgeInsets.only(
                          //           top: size.iScreen(2.0),
                          //           bottom: size.iScreen(2.0),
                          //           left: size.iScreen(2.0),
                          //           right: size.iScreen(4.0),
                          //           ),
                          //           padding: EdgeInsets.only(
                          //           top: size.iScreen(0.5),
                          //           bottom: size.iScreen(0.5),
                          //           left: size.iScreen(2.0),
                          //           right: size.iScreen(.0),
                          //           ),
                          //       child: Text(
                          //         '¿Olvidé mi Clave?',
                          //         style: GoogleFonts.lexendDeca(
                          //             fontSize: size.iScreen(1.7),
                          //             fontWeight: FontWeight.bold,
                          //             color: primaryColor),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      //========================================//
                      Container(
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(5.0),
                            vertical: size.iScreen(3.0)),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.iScreen(3.0),
                            vertical: size.iScreen(0.5)),
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            height: size.iScreen(3.5),
                            width: size.iScreen(10.0),
                            child: Text('Ingresar',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                )),
                          ),
                          onTap: () {
                            // Navigator.pushNamed(context, 'clientes');
                            // _submit();
                            _onSubmit(context, controller);
                          },
                        ),
                      ),
                      //===========================================//
                      // Container(
                      //   alignment: Alignment.center,
                      //   margin: EdgeInsets.symmetric(
                      //       vertical: size.iScreen(3.0),
                      //       horizontal: size.iScreen(5)),
                      //   child: Text(
                      //     '2.0',
                      //     style: GoogleFonts.lexendDeca(
                      //         fontSize: size.iScreen(2.2),
                      //         fontWeight: FontWeight.bold,
                      //         color: primaryColor),
                      //   ),
                      // ),
                      //========================================//
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

//*******************************************************//

  void _onSubmit(BuildContext context, LoginController controller) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {
      final conexion = await Connectivity().checkConnectivity();
      if (conexion == ConnectivityResult.none) {
        NotificatiosnService.showSnackBarError('SIN CONEXION A INTERNET');
      } else if (conexion == ConnectivityResult.wifi ||
          conexion == ConnectivityResult.mobile) {
        final controllerHome = HomeController();
        final status = await Permission.location.request();
        if (status == PermissionStatus.granted) {
          // print('============== SI TIENE PERMISOS');
          await controllerHome.getCurrentPosition();
          if (controllerHome.getCoords != '') {
            ProgressDialog.show(context);
            final response = await controller.loginApp(context);
            ProgressDialog.dissmiss(context);
            if (response != null) {
              Navigator.pushReplacement(
                context,
               
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomeMenu(
                        tipo: controller.infoUser!.rol,
                        user: controller.infoUser,
                        ubicacionGPS: controllerHome.getCoords)),
              );
            }
          }
        } else {
          // print('============== NOOOO TIENE PERMISOS');
          Navigator.pushNamed(context, 'gps');
        }
      }
    }
  }

  Future<bool?> checkGPSStatus() async {
    final isEnable = await Geolocator.Geolocator.isLocationServiceEnabled();
    Geolocator.Geolocator.getServiceStatusStream().listen((event) {
      final isEnable = (event.index == 1) ? true : false;
    });
    return isEnable;
  }

//======================== VAALIDA SCANQR =======================//
  void _validaGPS() async {
    final controllerHome = HomeController();
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      ProgressDialog.show(context);
      await controllerHome.getCurrentPosition();

      ProgressDialog.dissmiss(context);

      Navigator.pushNamedAndRemoveUntil(
          context, "splash", (Route<dynamic> route) => false);
    }
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.restricted ||
        status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.limited) {
      openAppSettings();
    }
    // ProgressDialog.show(context);
  }
}
