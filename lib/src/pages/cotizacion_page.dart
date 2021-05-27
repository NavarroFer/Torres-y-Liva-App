import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';

class CotizacionPage extends StatefulWidget {
  static final String route = 'cotizacion';
  CotizacionPage({Key key}) : super(key: key);

  @override
  _CotizacionPageState createState() => _CotizacionPageState();
}

class _CotizacionPageState extends State<CotizacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CatalogoProductosPage.seleccionando
            ? Text('Seleciconando')
            : Text('Cotizacion'),
      ),
      body: CatalogoProductosPage(modo: 'cotizacion'),
    );
  }
}
