import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torres_y_liva/src/bloc/bloc_provider.dart';
import 'package:torres_y_liva/src/pages/buscador_producto_page.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/cotizacion_page.dart';
import 'package:torres_y_liva/src/pages/datos_pedido_page.dart';
import 'package:torres_y_liva/src/pages/home_page.dart';
import 'package:torres_y_liva/src/pages/pedido_enviado_detail_page.dart';
import 'package:torres_y_liva/src/pages/pedido_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/pages/login_page.dart';
import 'package:torres_y_liva/src/pages/nuevo_pedido_page.dart';
import 'package:torres_y_liva/src/pages/utils/calculator_page.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/utils/shared_pref_helper.dart';

void main() async {
  runApp(MyApp());
  await cargarDatos();
  if (fechaAltaMovil == 0) {
    await guardarFechaAltaMovil();
    fechaAltaMovil = DateTime.now().millisecondsSinceEpoch;
  }
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
        DatosPedidoPage.route: (context) => DatosPedidoPage(),
        ItemsPedidoPage.route: (context) => ItemsPedidoPage(),
        CatalogoProductosPage.route: (context) => CatalogoProductosPage(),
        BuscadorProductoPage.route: (context) => BuscadorProductoPage(),
        LoginPage.route: (context) => LoginPage(),
        HomePage.route: (context) => HomePage(),
        CotizacionPage.route: (context) => CotizacionPage(),
        PedidoEnviadoDetailPage.route: (context) => PedidoEnviadoDetailPage(),
      },
    ));
  }
}
