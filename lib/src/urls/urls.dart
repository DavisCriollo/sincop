import 'package:url_launcher/url_launcher.dart';





abrirPDFPedidos(int idPedido,String rucEmpresa) async {
  final url = 'https://backsigeop.neitor.com/api/reportes/pedido?disId=$idPedido&rucempresa=$rucEmpresa';
  if (await canLaunch(url)) {
    print(url);
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}

abrirPaginaNeitor() async {
  const url = 'https://neitor.com/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}
abrirPagina2Jl() async {
  const url = 'http://2jl.ec';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}
abrirPaginaPazViSeg() async {
  const url = 'https://sigeop.neitor.com/l';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}

//URLS ATLANTIC

abrirPaginaAtlantic() async
{
  const url = 'https://www.atlantic.edu.ec/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}

abrirEnFacebookAtlantic() async
{
  const url = 'https://www.facebook.com/atlanticsuperior/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}
abrirEnInstagramAtlantic() async
{
  const url = 'https://www.instagram.com/atlantic_ist/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}

abrirEnTwitterAtlantic() async
{
  const url = 'https://twitter.com/ITS_ATLANTIC_';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se puede abrir: $url';
  }
}

void launchWaze(double lat, double lng) async {
  var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
  var fallbackUrl =
      'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
  try {
    bool launched =
        await launch(url, forceSafariVC: false, forceWebView: false);
    if (!launched) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  } catch (e) {
    await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
  }
}

void launchGoogleMaps(double lat, double lng) async {
  var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
  var fallbackUrl =
      'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
  try {
    bool launched =
        await launch(url, forceSafariVC: false, forceWebView: false);
    if (!launched) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  } catch (e) {
    await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
  }
}