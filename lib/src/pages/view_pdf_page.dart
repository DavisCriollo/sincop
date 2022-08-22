

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sincop_app/src/utils/responsive.dart';
// import 'package:sincop_app/src/utils/theme.dart';


// class ViewPDFPage extends StatefulWidget {
//   final dynamic pedido;
//    const ViewPDFPage({Key? key, required this.pedido}) : super(key: key);

//   @override
//   State<ViewPDFPage> createState() => _ViewPDFPageState();
// }

// class _ViewPDFPageState extends State<ViewPDFPage> {
  
//   @override
//   Widget build(BuildContext context) {
//         Responsive size = Responsive.of(context);
//     return Scaffold(
//        backgroundColor: const Color(0xFFEEEEEE),
       
//         appBar: AppBar(
//           // backgroundColor: primaryColor,
//           title: Text(
//             'Reporte PDF',
//             style: GoogleFonts.lexendDeca(
//                 fontSize: size.iScreen(2.45),
//                 color: Colors.white,
//                 fontWeight: FontWeight.normal),
//           ),
//            flexibleSpace: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomCenter,
//                   colors: <Color>[
//                     Color(0XFF153E76),
//                     Color(0XFF0076A7),
                   
                   
                   
//                     // Color(0XFF005B97),
//                     // Color(0XFF0075BE),
//                     // Color(0XFF1E9CD7),
//                     // Color(0XFF3DA9F4),
//                   ],
//                 ),
//               ),
//             ),
//         ),
//       body:  Container(
//           width: size.wScreen(100.0),
//             height: size.hScreen(100),
//             // color:Colors.red,
//         child: const WebView(
//         //  initialUrl: "https://backsigeop.neitor.com/api/reportes/pedido?disId=${widget.pedido['disId']}&rucempresa=${widget.pedido['disEmpresa']}",
//         //  initialUrl: "https://backsigeop.neitor.com/api/reportes/carnet?perId=1042&rucempresa=PAZVISEG",
//          initialUrl: "https://flutter.dev/?gclid=EAIaIQobChMIsqeSpbDz9gIV4oFbCh0EhwTZEAAYASAAEgKPXvD_BwE&gclsrc=aw.ds",
//     //  javascriptMode:JavascriptMode.unrestricted,
//      ),
//       ),
//     );
//   }
// }