
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:permission_handler/permission_handler.dart';



class AccesoGPSPage extends StatefulWidget {
  const AccesoGPSPage({Key? key}) : super(key: key);

  @override
  _AccesoGPSPageState createState() => _AccesoGPSPageState();
}

class _AccesoGPSPageState extends State<AccesoGPSPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Permission.location.isGranted) {
        // Navigator.pushReplacementNamed(context, 'home');
        Navigator.pushReplacementNamed(context, 'login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Es necesario activar el GPS para usar la aplicación',
                style: GoogleFonts.lexendDeca(
                    fontSize: size.iScreen(1.7),
                    color: Colors.black54,
                    fontWeight: FontWeight.w600)),
                    SizedBox(height: size.iScreen(2.0),),
            MaterialButton(
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              child: Text(
                'Solicitar Acceso',
                style: GoogleFonts.lexendDeca(
                    fontSize: size.iScreen(1.7),
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
              onPressed: () async {
                // Extraemos el estatus del Permiso del GPS
// openAppSettings();

                final status = await Permission.location.request();
                accesoGPS(status);
              },
            ),
          ],
        ),
      ),
    );
  }


  void accesoGPS(PermissionStatus status) {
    print(status);
    switch (status) {
      case PermissionStatus.granted:
        // Navigator.pushReplacementNamed(context, 'home');
        Navigator.pushReplacementNamed(context, 'login');
        break;
     
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
        openAppSettings();
    }
  }
}
