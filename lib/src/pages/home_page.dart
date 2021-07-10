import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:torres_y_liva/src/pages/cotizacion_page.dart';
import 'package:torres_y_liva/src/pages/pedido_page.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/utils/image_helper.dart';
import 'package:widget_animator/widget_animator.dart';

class HomePage extends StatefulWidget {
  static final String route = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Image img;

  bool _execGetImage = false;

  @override
  void initState() {
    super.initState();
  }

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
            child: FutureBuilder(
              future: _getImages(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                final size = MediaQuery.of(context).size;
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.4),
                      _botonPedidos(context),
                      _botonReportePrecios(context),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(height: size.height * 0.6),
                      SizedBox(
                        child: CircularProgressIndicator(),
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      AutoSizeText('Obteniendo informacion de imagenes',
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          minFontSize: (size.width * 0.065).roundToDouble(),
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonPedidos(BuildContext context) {
    return _botonMenu(context, "Pedidos", _onPressBotonPedidos);
  }

  Widget _botonReportePrecios(BuildContext context) {
    return _botonMenu(context, "Fotocotizaciones", _onPressBotonReportePrecios);
  }

  _onPressBotonReportePrecios(BuildContext context) {
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
    final perc = cantFotosDescargadas / imagenesADescargar;
    return Positioned(
      right: size.width * 0.03,
      top: imagenesADescargar > 0 ? size.height * 0.06 : size.height * 0.11,
      child: imagenesADescargar > 0
          ? Column(
              children: [
                Image.asset(
                  "assets/img/ic_launcher_round.png",
                  height: size.height * 0.23,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                new CircularPercentIndicator(
                  radius: size.width * 0.3,
                  lineWidth: 10.0,
                  animateFromLastPercent: true,
                  animation: true,
                  footer: Text(
                    perc > 0.99
                        ? 'Imágenes descargadas'
                        : 'Descargando imagenes',
                    textScaleFactor: size.width * 0.0035,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  percent: perc,
                  center: Text(
                    (100 * perc).toStringAsFixed(2) + '%',
                    textScaleFactor: size.width * 0.0045,
                  ),
                  progressColor: _colorByPercent(perc),
                ),
              ],
            )
          : Image.asset(
              "assets/img/ic_launcher_round.png",
              height: size.height * 0.23,
            ),
    );
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

  Future<bool> _getImages(BuildContext context) async {
    if (_execGetImage == false) {
      _execGetImage = true;
      return await getImages(() {
        setState(() {});
      }, context);
    } else
      return true;
  }

  _colorByPercent(double d) {
    if (d < 0.1)
      return Colors.red;
    else if (d < 0.2)
      return Colors.orange;
    else if (d < 0.4)
      return Colors.blue;
    else if (d < 0.6)
      return Colors.purple;
    else if (d < 0.8)
      return Colors.cyan;
    else
      return Colors.green;
  }
}
