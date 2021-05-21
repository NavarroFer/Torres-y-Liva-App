import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/models/rubro_model.dart';
import 'package:geolocator/geolocator.dart';

class CatalogoProductosPage extends StatefulWidget {
  static final String route = 'catalgo';

  @override
  _CatalogoProductosPageState createState() => _CatalogoProductosPageState();
}

class _CatalogoProductosPageState extends State<CatalogoProductosPage> {
  List listaRubros = List.filled(0, null, growable: true);

  @override
  void initState() {
    listaRubros.addAll([
      Rubro(id: 1, nombre: "Bazar", idRubroPadre: -1),
      Rubro(id: 2, nombre: "Camping y playa", idRubroPadre: -1),
      Rubro(id: 3, nombre: "Decoracion - regaleria", idRubroPadre: -1),
      Rubro(id: 4, nombre: "Electricidad - iluminacion", idRubroPadre: -1),
      Rubro(id: 3, nombre: "Decoracion - regaleria", idRubroPadre: -1),
      Rubro(id: 4, nombre: "Electricidad - iluminacion", idRubroPadre: -1),
      Rubro(id: 3, nombre: "Decoracion - regaleria", idRubroPadre: -1),
      Rubro(id: 4, nombre: "Electricidad - iluminacion", idRubroPadre: -1),
      Rubro(id: 3, nombre: "Decoracion - regaleria", idRubroPadre: -1),
      Rubro(id: 4, nombre: "Electricidad - iluminacion", idRubroPadre: -1),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.015,
        ),
        _rowButtons(context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Text(
          'RUBROS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: MediaQuery.of(context).size.height * 0.002,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        _gridCatalogo(context),
      ],
    );
  }

  Widget _gridCatalogo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Widget> listaProdGrilla = List<Widget>.filled(0, null, growable: true);

    listaRubros.forEach((rubro) {
      listaProdGrilla.add(_cardRubro(context, rubro));
    });
    return Container(
        height: size.height * 0.65,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: listaProdGrilla,
            )
          ],
        ));
  }

  Widget _rowButtons(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: size.width * 0.3,
          height: size.height * 0.06,
          child: OutlinedButton(
              onPressed: _ultimasEntradasPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              child: AutoSizeText(
                'Últimas Entradas',
                maxFontSize: (size.height * 0.02).roundToDouble(),
                minFontSize: (size.height * 0.015).roundToDouble(),
                maxLines: 1,
              )),
        ),
        Container(
          width: size.width * 0.3,
          height: size.height * 0.06,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              onPressed: _ultimasFotosPressed,
              child: AutoSizeText(
                'Últimas Fotos',
                maxLines: 1,
                // maxFontSize: (size.height * 0.017).roundToDouble(),
                // minFontSize: (size.height * 0.001).roundToDouble(),
              )),
        ),
        Container(
          width: size.width * 0.3,
          height: size.height * 0.06,
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              onPressed: _importacionPressed,
              child: AutoSizeText(
                'Importación',
                maxLines: 1,
                // maxFontSize: (size.height * 0.017).roundToDouble(),
                // minFontSize: (size.height * 0.001).roundToDouble(),
              )),
        ),
      ],
    );
  }

  Widget _cardRubro(BuildContext context, Rubro rubro) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.45,
      height: size.height * 0.25,
      child: InkWell(
        splashColor: Colors.red,
        highlightColor: Colors.red.withOpacity(0.5),
        onTap: () {
          print(rubro.nombre);
        },
        onLongPress: () {},
        child: Card(
          margin: EdgeInsets.all(size.width * 0.02),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.cameraOff,
                size: size.height * 0.1,
              ),
              ListTile(
                title: Text(
                  rubro.nombre.toUpperCase(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ultimasFotosPressed() {}

  void _ultimasEntradasPressed() {}

  void _importacionPressed() {}
}
