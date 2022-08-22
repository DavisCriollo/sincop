import 'package:flutter/material.dart';

import 'package:sincop_app/src/utils/responsive.dart';

class ListaNotifications extends StatefulWidget {
  final String? payload;
  const ListaNotifications({Key? key, this.payload}) : super(key: key);

  @override
  State<ListaNotifications> createState() => _ListaNotificationsState();
}

class _ListaNotificationsState extends State<ListaNotifications> {
  @override
  Widget build(BuildContext context) {
print('++++++++++++ ${widget.payload}  ===========');



    final Responsive size = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('LISTA DE NOTIFICATIONS')),
      body: Container(
        // color: Colors.red,
        width: size.wScreen(100),
        height: size.hScreen(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text('TITLE: '),
           Text('BODY: '),
           Text('${widget.payload}'),
          ],
        ),
      ),
    );
  }
}