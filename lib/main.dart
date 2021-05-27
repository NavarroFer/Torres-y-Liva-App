import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:torres_y_liva/src/bloc/bloc_provider.dart';
import 'package:torres_y_liva/src/pages/buscador_producto_page.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/cotizacion_page.dart';
import 'package:torres_y_liva/src/pages/datos_pedido_page.dart';
import 'package:torres_y_liva/src/pages/home_page.dart';
import 'package:torres_y_liva/src/pages/pedido_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/pages/login_page.dart';
import 'package:torres_y_liva/src/pages/nuevo_pedido_page.dart';
import 'package:torres_y_liva/src/pages/utils/calculator_page.dart';
import 'package:torres_y_liva/src/pages/utils/geolocator.dart';

void main() async {
  runApp(MyApp());
  Position pos = await determinePosition();
  print(pos);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocProvider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Torres y Liva',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: LoginPage.route,
      routes: {
        PedidoPage.route: (context) => PedidoPage(),
        NuevoPedidoPage.route: (context) => NuevoPedidoPage(),
        CalculatorPage.route: (context) => CalculatorPage(),
        DatosPedidoPage.route: (context) => DatosPedidoPage(null),
        ItemsPedidoPage.route: (context) => ItemsPedidoPage(null),
        CatalogoProductosPage.route: (context) => CatalogoProductosPage(),
        BuscadorProductoPage.route: (context) => BuscadorProductoPage(),
        LoginPage.route: (context) => LoginPage(),
        HomePage.route: (context) => HomePage(),
        CotizacionPage.route: (context) => CotizacionPage(),
      },
    ));
  }
}
