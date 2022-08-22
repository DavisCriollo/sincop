import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
import 'package:sincop_app/src/controllers/login_controller.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/pages/home.dart';
import 'package:sincop_app/src/pages/login_page.dart';
import 'package:sincop_app/src/utils/responsive.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controllerLogin = LoginController();
  final controllerHome = HomeController();

  @override
  void initState() {
    super.initState();
// VERIFICO SI EL CONTEXTO  ESTA INICIALIZADO//
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _chechLogin();
    });
  }

  _chechLogin() async {
    final Session? session = await Auth.instance.getSession();
    final String? validaTurno = await Auth.instance.getTurnoSession();

    if (session != null) {
      final controllerHome = HomeController();
      controllerHome.setValidaBtnTurno((validaTurno != null) ? true : false);
       final status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        // print('============== SI TIENE PERMISOS');
        await controllerHome.getCurrentPosition();
        if (controllerHome.getCoords != '') {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => HomeMenu(
          //         validaTurno: validaTurno,
          //         tipo: session.rol,
          //         user: session,
          //         ubicacionGPS: controllerHome.getCoords),
          //   ),
          // );

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomeMenu(
                      validaTurno: validaTurno,
                      tipo: session.rol,
                      user: session,
                      ubicacionGPS: controllerHome.getCoords)),
              (Route<dynamic> route) => false);
              ModalRoute.withName('/');
        }
      } else {
        // print('============== NOOOO TIENE PERMISOS');
        Navigator.pushNamed(context, 'gps');
      }
    } else {

      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const LoginPage(
                      )),
              (Route<dynamic> route) => false);
              // ModalRoute.withName('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return Scaffold(
      body: SizedBox(
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(
                height: size.iScreen(2.0),
              ),
              const Text('Procesando.... '),
            ],
          ),
        ),
      ),
    );
  }
}
