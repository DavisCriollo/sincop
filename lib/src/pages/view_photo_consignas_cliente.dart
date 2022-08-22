import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sincop_app/src/models/crea_foto_consigna_cliente.dart';
import 'package:sincop_app/src/models/crea_fotos_detalle_novedad.dart';
import 'package:sincop_app/src/models/crear_foto_comunicado_guardia.dart';
import 'package:sincop_app/src/utils/responsive.dart';


class PreviewScreenConsignas extends StatelessWidget {
  final CreaNuevaFotoConsignaCliente? image;

  const PreviewScreenConsignas({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color(0XFF343A40), // primaryColor,
        title: const Text('Photo'),
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
      body: InteractiveViewer(
        child: Hero(
          tag: image!.id,
          child: SizedBox(
            width: size.wScreen(100.0),
            height: size.hScreen(100.0),
            child: Image.file(
              File(image!.path),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}