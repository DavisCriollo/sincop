import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sincop_app/src/controllers/valida_turno.dart';
import 'package:sincop_app/src/routes/routes.dart';
import 'package:sincop_app/src/service/notification_push.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/service/socket_service.dart';
import 'package:sincop_app/src/controllers/activities_controller.dart';
import 'package:sincop_app/src/controllers/ausencias_controller.dart';
import 'package:sincop_app/src/controllers/aviso_salida_controller.dart';
import 'package:sincop_app/src/controllers/cambio_puesto_controller.dart';
import 'package:sincop_app/src/controllers/comunicados_clientes_controller.dart';
import 'package:sincop_app/src/controllers/consignas_clientes_controller.dart';
import 'package:sincop_app/src/controllers/estado_cuenta_controller.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
import 'package:sincop_app/src/controllers/informes_controller.dart';
import 'package:sincop_app/src/controllers/logistica_controller.dart';
import 'package:sincop_app/src/controllers/multas_controller.dart';

import 'package:sincop_app/src/controllers/novedades_controller.dart';

import 'package:sincop_app/src/controllers/turno_extra_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sincop_app/src/utils/theme.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await PushNotificationService.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
final homeController=HomeController();



    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PushNotificationService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => ActividadesController()),
        ChangeNotifierProvider(create: (_) => ComunicadosController()),
        ChangeNotifierProvider(create: (_) => ConsignasClientesController()),
        ChangeNotifierProvider(create: (_) => EstadoCuentaController()),
        ChangeNotifierProvider(create: (_) => MultasGuardiasContrtoller()),
        ChangeNotifierProvider(create: (_) => InformeController()),
        ChangeNotifierProvider(create: (_) => LogisticaController()),
        ChangeNotifierProvider(create: (_) => AvisoSalidaController()),
        ChangeNotifierProvider(create: (_) => CambioDePuestoController()),
        ChangeNotifierProvider(create: (_) => AusenciasController()),
        ChangeNotifierProvider(create: (_) => TurnoExtraController()),
        ChangeNotifierProvider(create: (_) => ActivitiesController()),
        // ChangeNotifierProvider(create: (_) => ValidaTurnoController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //  CONFIGURACION PARA EL DATEPICKER
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'), // English, no country code
          Locale('es', 'ES'), // Hebrew, no country code
        ],
        theme: ThemeData(
          brightness: Brightness.light,
          // primarySwatch: Color(00),
          primaryColor: primaryColor,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'splash',
     
      

        // initialRoute: 'compras',
        routes: appRoutes,
        navigatorKey: homeController.navigatorKey,
        scaffoldMessengerKey: NotificatiosnService.messengerKey,
      ),
    );
  }
}
