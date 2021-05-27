import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/pages/cotizacion_page.dart';
import 'package:torres_y_liva/src/pages/pedido_page.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:widget_animator/widget_animator.dart';

class HomePage extends StatelessWidget {
  static final String route = 'home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _appName(context),
          _logo(context),
          _barra(context),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                _botonPedidos(context),
                _botonCotizaciones(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonPedidos(BuildContext context) {
    return _botonMenu(context, "Pedidos", _onPressBotonPedidos);
  }

  Widget _botonCotizaciones(BuildContext context) {
    return _botonMenu(context, "Cotizaciones", _onPressBotonCotizaciones);
  }

  _onPressBotonCotizaciones(BuildContext context) {
    Navigator.of(context)
        .pushNamed(CotizacionPage.route, arguments: 'cotizacion');
  }

  _onPressBotonPedidos(BuildContext context) {
    Navigator.of(context).pushNamed(PedidoPage.route, arguments: 'pedido');
  }

  _appName(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      left: MediaQuery.of(context).size.width * 0.05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Torres", style: Theme.of(context).textTheme.headline2),
          Text(
            "y\nLiva",
            style: Theme.of(context).textTheme.headline2,
          )
        ],
      ),
    );
  }

  _logo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
        right: size.width * 0.03,
        top: size.height * 0.11,
        child: Image.asset(
          "assets/img/ic_launcher_round.png",
          height: size.height * 0.23,
        ));
  }

  Widget _botonMenu(BuildContext context, String s,
      void Function(BuildContext context) onPressBoton) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: SizedBox(
        width: size.width * 0.7,
        height: size.height * 0.06,
        child: RaisedButton(
          shape: StadiumBorder(),
          onPressed: () => {onPressBoton(context)},
          child: WidgetAnimator(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 300),
            child: Text(
              s,
              style: TextStyle(
                  fontSize: size.height * 0.03,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
          color: Colors.red,
        ),
      ),
    );
  }

  _barra(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * 0.5,
      child: Container(
        color: Colors.grey[400],
        height: size.height * 0.5,
        width: size.width,
      ),
    );
  }
}
