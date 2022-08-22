import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
import 'package:sincop_app/src/controllers/login_controller.dart';
import 'package:sincop_app/src/models/session_response.dart';
import 'package:sincop_app/src/service/notifications_service.dart';
import 'package:sincop_app/src/utils/dialogs.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';

import '../models/auth_response.dart';

class CustomDrawer extends StatelessWidget {
  List<String?>? tipo;
  Session? users;
  CustomDrawer({Key? key, required this.tipo, required this.users})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final homeController = Provider.of<HomeController>(context);

    // final user = Provider.of<LoginController>(context).infoUser;
    // final user =homeController.infoUser;

    return ChangeNotifierProvider<LoginController>(
      create: (_) => LoginController(),
      builder: (context, _) {
        return Drawer(
          child: Column(
            children: [
              //========================//
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: size.iScreen(1.0), vertical: size.iScreen(0)),
                color: const Color(0XFF3C3C3B),
                width: size.wScreen(100),
                height: size.hScreen(20.0),
                child: DrawerHeader(
                  child: Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(
                    // horizontal: size.iScreen(2), vertical: size.iScreen(0)),
                    color: const Color(0XFF3C3C3B),
                    width: size.wScreen(100),
                    height: size.hScreen(20.0),
                    child: Consumer<LoginController>(
                      builder: (_, value, __) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.wScreen(100),
                              child: Text(
                                // 'Hernan Leonardo Rodriguez Mendoza',
                                'Bienvenido ',
                                style: GoogleFonts.lexendDeca(
                                    fontSize: size.iScreen(3.0),
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            SizedBox(
                              height: size.iScreen(2.0),
                            ),
                            Text(
                              //  '${dateUser!.nombre}'.toString()!,
                              users!.nombre!,
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.5),
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: size.iScreen(0.5),
                            ),
                            Text(
                              //  '${dateUser!.nombre}'.toString(),
                              // 'correo@correo.com',
                              users!.usuario!,
                              style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.7),
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              //==========================================================================================//

              Expanded(
                child: ListView(
                  children: [
                    ItemDrower(
                      size: size,
                      label: 'Reportes',
                      icon: Icons.poll_outlined,
                      onTap: () {},
                    ),
                    ItemDrower(
                      size: size,
                      label: 'Compartir',
                      icon: Icons.share,
                      onTap: () {},
                    ),
                    ItemDrower(
                      size: size,
                      label: 'Contáctenos',
                      icon: Icons.headset_mic_outlined,
                      onTap: () {},
                    ),
                    ItemDrower(
                      size: size,
                      label: 'Quienes Somos',
                      icon: Icons.help_outline,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              ItemDrower(
                arrow: false,
                size: size,
                label: 'Salir',
                icon: Icons.login_sharp,
                onTap: () async {
                  //==================================================//
                  ProgressDialog.show(context);

                  final response = await homeController.sentTokenDelete();
                  ProgressDialog.dissmiss(context);

                  Auth.instance.deleteSesion(context);
                  Auth.instance.deleteIdRegistro();
                  Auth.instance.deleteTurnoSesion();

                  // if (response != null) {
                  //   Auth.instance.deleteSesion(context);
                  //   Auth.instance.deleteTurnoSesion();
                  // } else {
                  //   NotificatiosnService.showSnackBarError(
                  //       'No se pudo cerrar sesión ');

                  // }

                  //==================================================//
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ItemDrower extends StatelessWidget {
  final bool arrow;
  final Responsive size;
  final String label;
  final VoidCallback onTap;
  final IconData icon;

  const ItemDrower({
    Key? key,
    required this.size,
    required this.label,
    required this.onTap,
    required this.icon,
    this.arrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                //color: Colors.red,
                border: Border(
              top: BorderSide(
                color: primaryColor,
                width: 0.1,
              ),
            )),
            padding: EdgeInsets.all(
              size.iScreen(1.0),
            ),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: size.iScreen(0.1), right: size.iScreen(1.5)),
                    child: Icon(
                      icon,
                      size: size.iScreen(3.5),
                      color: primaryColor,
                    )),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        // color: Colors.red,
                        ),
                    padding: EdgeInsets.only(
                        top: size.iScreen(1.0), bottom: size.iScreen(1.0)),
                    // width: size.wScreen(100),
                    child: Text(
                      label,
                      style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          // color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_outlined),
              ],
            ),
          ),
          //   ListTile(
          //     dense:true,
          //     title: Text(
          //       label,
          //       style: GoogleFonts.lexendDeca(
          //           fontSize: size.iScreen(2.0),
          //           // color: Colors.white,
          //           fontWeight: FontWeight.normal),
          //     ),
          //     leading: Icon(icon),
          //     trailing: (arrow)?const Icon(Icons.chevron_right_outlined):null,
          //     onTap: onTap,
          //   ),
          //   Divider(
          //     thickness: size.iScreen(0.1),
          //   ),
        ],
      ),
      onTap: onTap,
    );
  }
}
