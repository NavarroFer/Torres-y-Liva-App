import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/datos_pedido_page.dart';
import 'package:torres_y_liva/src/pages/home_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/pages/nuevo_pedido_page.dart';
import 'package:torres_y_liva/src/pages/utils/calculator_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Torres y Liva',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        NuevoPedidoPage.route: (context) => NuevoPedidoPage(),
        CalculatorPage.route: (context) => CalculatorPage(),
        DatosPedidoPage.route: (context) => DatosPedidoPage(),
        ItemsPedidoPage.route: (context) => ItemsPedidoPage(),
        CatalogoProductosPage.route: (context) => CatalogoProductosPage(),
      },
    );
  }
}
