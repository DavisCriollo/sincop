import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sincop_app/src/utils/responsive.dart';
import 'package:sincop_app/src/utils/theme.dart';
import 'package:sincop_app/src/urls/urls.dart' as urls;

class AlertaPage extends StatefulWidget {
  final dynamic notificacion;
  const AlertaPage({Key? key, this.notificacion}) : super(key: key);

  @override
  State<AlertaPage> createState() => _AlertaPageState();
}

class _AlertaPageState extends State<AlertaPage> {
  @override
  void initState() {
    initil();
    super.initState();
  }

  void initil() async {
    AudioCache player = AudioCache();

    player = AudioCache();

    await player.play('evacuacion_alarma.mp3');
  }

  @override
  Widget build(BuildContext context) {
    List telefonos = widget.notificacion['notInformacion']['perTelefono'];
    List infoClientePuesto =
        widget.notificacion['notInformacion']['perPuestoServicio'];

// for (var e in widget.notificacion['notInformacion']['perTelefono']) {
//   telefonos.addAll(e);
    // print('$telefonos');

// }

    final Responsive size = Responsive.of(context);
    // final logisticaController = Provider.of<LogisticaController>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        // backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: Text(
          'ALERTA',
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
              ],
            ),
          ),
        ),
        //  actions: [
        //   //  IconButton(onPressed: (){}, icon: icon)
        //  ],
      ),
      body: Container(
        //  color: Colors.blue.shade100,
        width: size.wScreen(100),
        height: size.hScreen(100),
        margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.5)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvatarGlow(
                endRadius: 80,
                glowColor: Colors.red,
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  'assets/imgs/alarma.png',
                  color: primaryColor,
                  width: size.iScreen(18.0),
                  height: size.iScreen(20.0),
                ),
              ),
              Column(
                children: [
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                  //*****************************************/
                  Container(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text('SOS',
                        style: GoogleFonts.lexendDeca(
                            fontSize: size.iScreen(3.5),
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.0),
                  ),
                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text(
                        'Se ha generado una alerta por parte del siguiente usuario:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendDeca(
                          fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(2.5),
                  ),
                  //*****************************************/
                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Nombre:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),

                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('${widget.notificacion['notNombrePersona']}',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        )),
                  ),

                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //*****************************************/

                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Teléfono:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),

                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Wrap(
                        children: telefonos
                            .map(
                              (e) => InkWell(
                                focusColor: Colors.red,
                                onLongPress: () {
                                  _callNumber('$e');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('$e',
                                        style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.bold,
                                          // color: Colors.grey
                                        )),
                                    //***********************************************/
                                    SizedBox(
                                      width: size.iScreen(3.0),
                                    ),
                                    //*****************************************/
                                    Icon(
                                      Icons.phone_forwarded_outlined,
                                      size: size.iScreen(3.0),
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            )
                            .toList()),
                  ),
                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //*****************************************/

                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    child: Text('Ciudad:',
                        style: GoogleFonts.lexendDeca(
                            // fontSize: size.iScreen(2.0),
                            fontWeight: FontWeight.normal,
                            color: Colors.grey)),
                  ),

                  SizedBox(
                    width: size.wScreen(100.0),

                    // color: Colors.blue,
                    // child: Text('Santo Domingo de los Tsáchilas',
                    child: Text(
                        '${widget.notificacion['notInformacion']['perCiudad']}',
                        style: GoogleFonts.lexendDeca(
                          // fontSize: size.iScreen(2.0),
                          fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        )),
                  ),
                  //***********************************************/
                  SizedBox(
                      width: size.wScreen(100.0),

                      // color: Colors.blue,
                      // child: Text('SANI GROUP S.C.',
                      child: Wrap(
                          children: infoClientePuesto
                              .map(
                                (e) => Column(
                                  children: [
                                    //***********************************************/
                                    SizedBox(
                                      height: size.iScreen(0.5),
                                    ),
                                    //*****************************************/

                                    SizedBox(
                                      width: size.wScreen(100.0),

                                      // color: Colors.blue,
                                      child: Text('Cliente:',
                                          style: GoogleFonts.lexendDeca(
                                              // fontSize: size.iScreen(2.0),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey)),
                                    ),
                                    Text('${e['razonsocial']}',
                                        style: GoogleFonts.lexendDeca(
                                          // fontSize: size.iScreen(2.0),
                                          fontWeight: FontWeight.bold,
                                          // color: Colors.grey
                                        )),
                                    //***********************************************/
                                    SizedBox(
                                      height: size.iScreen(0.5),
                                    ),
                                    //*****************************************/

                                    SizedBox(
                                      width: size.wScreen(100.0),

                                      // color: Colors.blue,
                                      child: Text('Ubicación:',
                                          style: GoogleFonts.lexendDeca(
                                              // fontSize: size.iScreen(2.0),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey)),
                                    ),

                                    SizedBox(
                                      width: size.wScreen(100.0),

                                      // color: Colors.blue,
                                      // child: Text('Santo Domingo de los Tsáchilas',
                                      child: Text(
                                          '${e['ubicacion']}',
                                          style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.grey
                                          )),
                                    ),
                                    //***********************************************/

                                    //*****************************************/

                                    SizedBox(
                                      width: size.wScreen(100.0),

                                      // color: Colors.blue,
                                      child: Text('Puesto:',
                                          style: GoogleFonts.lexendDeca(
                                              // fontSize: size.iScreen(2.0),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey)),
                                    ),

                                    SizedBox(
                                      width: size.wScreen(100.0),

                                      // color: Colors.blue,
                                      child: Text('${e['puesto']}',
                                          style: GoogleFonts.lexendDeca(
                                            // fontSize: size.iScreen(2.0),
                                            fontWeight: FontWeight.bold,
                                            // color: Colors.grey
                                          )),
                                    ),
                                    //***********************************************/

                                    SizedBox(
                                      height: size.iScreen(0.5),
                                    ),
                                    //*****************************************/
                                  ],
                                ),
                              )
                              .toList())

                      // Text('${widget.notificacion['notInformacion']['perPuestoServicio']['razonsocial']}',
                      //     style: GoogleFonts.lexendDeca(
                      //       // fontSize: size.iScreen(2.0),
                      //       fontWeight: FontWeight.bold,
                      //       // color: Colors.grey
                      //     )),
                      ),
                  //***********************************************/

                  //***********************************************/
                  SizedBox(
                    height: size.iScreen(0.5),
                  ),
                  //*****************************************/
                  //========================================//
                  Container(
                    decoration: BoxDecoration(
                        color: tercearyColor,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Acudir',
                                style: GoogleFonts.lexendDeca(
                                  fontSize: size.iScreen(1.8),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                )),
                            Icon(
                              Icons.room_outlined,
                              size: size.iScreen(2.8),
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        bottomSheetMaps(
                          context,
                          size,
                          'Navegar',
                          double.parse(widget.notificacion['notInformacion']
                              ['coordenadas']['latitud']),
                          double.parse(widget.notificacion['notInformacion']
                              ['coordenadas']['longitud']),
                          'Seleccione Aplicación',
                        );
                      },
                    ),
                  ),
                  //==========================================//
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void bottomSheetMaps(
    BuildContext context,
    Responsive size,
    String title,
    double lat,
    double lng,
    String message,
  ) {
    // final List<String> latlong = cliente.coordenadas.split(",");

    // print('${cliente.coordenadas}');
    // print('${latlong[0]}');
    // print('${latlong[1]}');
    // lat = double.parse(latlong[0]);
    // lng = double.parse(latlong[1]);
    // print('$lat');
    // print('$lng');

    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              // title: Text(title, style: GoogleFonts.roboto(
              //               fontSize: size.dp(1.8),
              //               fontWeight: FontWeight.w500,
              //               // color: Colors.white,
              //             )),
              message: Text(message,
                  style: GoogleFonts.roboto(
                    fontSize: size.iScreen(1.8),
                    fontWeight: FontWeight.w500,
                    // color: Colors.white,
                  )),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    urls.launchWaze(lat, lng);
                    // urls.launchWaze(-0.242585, -79.197022);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: size.wScreen(10.0),
                          child: Image.asset('assets/imgs/waze-icon.jpeg'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size.iScreen(1.0)),
                        child: Text('Mapa Waze',
                            style: GoogleFonts.roboto(
                              fontSize: size.iScreen(2.0),
                              fontWeight: FontWeight.w500,
                              // color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    urls.launchGoogleMaps(lat, lng);
                    // urls.launchGoogleMaps(-0.242585, -79.197022);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: size.wScreen(10.0),
                          child: Image.asset('assets/imgs/google-icon.png'),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: size.iScreen(1.0)),
                          child: Text('Mapa Google',
                              style: GoogleFonts.roboto(
                                fontSize: size.iScreen(2.0),
                                fontWeight: FontWeight.w500,
                                // color: Colors.white,
                              ))),
                    ],
                  ),
                ),
              ],
              // cancelButton: CupertinoActionSheetAction(
              //   onPressed: () => Navigator.of(context).pop(),
              //   child: Text('Close'),
              // ),
            ));
  }
}

_callNumber(String numero) async {
  await FlutterPhoneDirectCaller.callNumber(numero);
}
