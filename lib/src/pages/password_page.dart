import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/controllers/password_controller.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';



import 'package:provider/provider.dart';

class PasswordPage extends StatelessWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return ChangeNotifierProvider<PasswordController>(
      create: (_) => PasswordController(),
      builder: (_, __) {
        final controller = _.read<PasswordController>();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            // backgroundColor: const Color(0XFF343A40), 
            title: const Text(
              'Recuperar Contraseña',
              style: TextStyle(color: Colors.white),
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
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              // color: Colors.red,

              width: size.wScreen(100),
              height: size.hScreen(100),
              margin: EdgeInsets.only(
                          bottom: size.iScreen(2),
                          left: size.iScreen(4.0),
                          right: size.iScreen(4.0)),
              child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                child: Form(
                  key: controller.formKeyPassword,
                  child: Column(
                    children: [
                      SizedBox(height: size.iScreen(2.0),),
                      const LogoImage(),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: size.iScreen(2),
                            left: size.iScreen(2),
                            right: size.iScreen(2)),
                        child: Text(
                          '¿ Olvidaste tu Contraseña ?',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(2.0),
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: size.iScreen(1.0),
                            horizontal: size.iScreen(0.0)),
                        child: Text(
                          'Escribe tu usuario y código de empresa para recuperarla.',
                          style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(1.9),
                            fontWeight: FontWeight.w400,
                            // color: quinaryColor
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: size.wScreen(70.0),
                      //   child: Form(
                      //     key: controller.formKey,
                      //     child: TextFormField(
                      //       keyboardType: TextInputType.emailAddress,
                      //       decoration: const InputDecoration(
                      //           hintText: 'correo@correo.com'),
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: size.iScreen(1.7),
                      //         // letterSpacing: 2.0,
                      //       ),
                      //       onChanged: (text) {
                      //         controller.onCorreoChange(text);
                      //       },
                      //       validator: (value) {
                      //         if (!EmailValidator.validate(value ?? "")) {
                      //           return 'Correo inválido';
                      //         }
                      //       },
                      //     ),
                      //   ),
                      // ),
                //=============================================================================================================//
                 //***********************************************/
                              SizedBox(
                                height: size.iScreen(2.0),
                              ),
                              //*****************************************/
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
                                    // initialValue: controller.getUsuario,
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
                                      //  controller.onChangeUser(value!);
                                    },
                                  ),
                
                              //***********************************************/
                              SizedBox(
                                height: size.iScreen(2.0),
                              ),
                              //*****************************************/
                                 SizedBox(
                                height: size.iScreen(2.0),
                              ),
                              //*****************************************/
                              //*****************************************/
                              SizedBox(
                                width: size.wScreen(100.0),
                                // color: Colors.blue,
                                child: Text('Empresa',
                                    style: GoogleFonts.lexendDeca(
                                      // fontSize: size.iScreen(2.0),
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    )),
                              ),
                              TextFormField(
                                    // controller: textUsuario,
                                    // initialValue: controller.getUsuario,
                                    // initialValue: (textUsuario.text==true)? textUsuario.text:'',
                                       
                                    decoration: const InputDecoration(
                                      suffixIcon:
                                          Icon(Icons.apartment_outlined),
                                    ),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                
                                        // fontSize: size.iScreen(3.5),
                                        // fontWeight: FontWeight.bold,
                                        // letterSpacing: 2.0,
                                        ),
                                    onChanged: (text) {
                                      controller.onChangeEmpresa(text);
                                    },
                                    validator: (text) {
                                      if (text!.trim().isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'Código de empresa Inválido';
                                      }
                                    },
                                    onSaved: (value) {
                                      // codigo = value;
                                      //  controller.onChangeEmpresa(value!);
                                    },
                                  ),
                             //***********************************************/
                //=============================================================================================================//
                     Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.symmetric(
                          horizontal: size.iScreen(5.0),
                          vertical: size.iScreen(3.0)),
                      padding: EdgeInsets.symmetric(
                        horizontal: size.iScreen(3.0),
                        vertical: size.iScreen(0.5)
                      ),
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: size.iScreen(3.5),
                          width: size.iScreen(10.0),
                          child: Text('Enviar',
                              style: GoogleFonts.lexendDeca(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              )),
                        ),
                        onTap: () => onSubmit(context, controller),
                        // onTap: null,
                        
                      ),
                    ),
                  
                      // GestureDetector(
                      //   onTap: () => onSubmit(context, controller),
                      //   child:
                      //    Container(
                      //     margin:
                      //         EdgeInsets.symmetric(vertical: size.iScreen(2.0)),
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: size.iScreen(1.0),
                      //         horizontal: size.iScreen(5.0)),
                      //     decoration: BoxDecoration(
                      //         color: primaryColor,
                      //         borderRadius: BorderRadius.circular(5.0)),
                      //     child: Text(
                      //       'Enviar',
                      //       style: GoogleFonts.lexendDeca(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white),
                      //     ),
                      //   ),
                      
                      
                      
                      
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onSubmit(BuildContext context, PasswordController controller) async {
    final isValid = controller.validateForm();
    if (!isValid) return;
    if (isValid) {

      //  final response = await controller.passwordRecovery();
      // ProgressDialog.dissmiss(context);
      // if (response != null) {
      //    print('SIIIIIIIII');
      //   // Navigator.pushNamedAndRemoveUntil(
      //   //     context, "home", (Route<dynamic> route) => false);
      // }
      ProgressDialog.show(context);
      //     //TODO: CUARDAD LA INFORMACION EN LA BASE
        final response = await controller.passwordRecovery();
      //     // await controller.getCurrentPosition();
      // controller.passwordRecovery();
      ProgressDialog.dissmiss(context);
       if (response != null) {
          // print('SIIIIIIIII');
          NotificatiosnService.showSnackBarSuccsses("${response["msg"]}");
        // Navigator.pushNamedAndRemoveUntil(context, "home", (Route<dynamic> route) => false);
      } 

    }
  }
}

class LogoImage extends StatelessWidget {
  const LogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: size.iScreen(5.0)),
      width: size.wScreen(30),
      child: Image.asset('assets/imgs/logoNeitor.png'),
    );
  }
}
