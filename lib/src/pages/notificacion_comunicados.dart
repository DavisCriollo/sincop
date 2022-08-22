import 'package:flutter/material.dart';

class ListaComunicadosPush extends StatefulWidget {

  final informacion;
  const ListaComunicadosPush({Key? key, this.informacion}) : super(key: key);

  @override
  State<ListaComunicadosPush> createState() => _ListaComunicadosPushState();
}

class _ListaComunicadosPushState extends State<ListaComunicadosPush> {
  @override
  Widget build(BuildContext context) {
    return 
  Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        // backgroundColor: primaryColor,
        title: const Text('Mis Consignas'),
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
      ),
      body:  Center(child:Text('${widget.informacion}')),
      );
  
  
  
 
  }
}