import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/rubro_model.dart';
import 'package:torres_y_liva/src/pages/buscador_producto_page.dart';

class CatalogoProductosPage extends StatefulWidget {
  static final String route = 'catalgo';

  final Function() notifyParent;
  final String modo;
  static List itemsSelected = List.empty(growable: true);
  static bool seleccionando = false;

  CatalogoProductosPage({this.modo, this.notifyParent});

  @override
  _CatalogoProductosPageState createState() => _CatalogoProductosPageState();
}

class _CatalogoProductosPageState extends State<CatalogoProductosPage> {
  List listaCategorias = List.empty(growable: true);

  // ignore: non_constant_identifier_names
  final int PRIMER_NIVEL_CATEGORIA = 0;
  // ignore: non_constant_identifier_names
  final String TITLE_CATALOGO = 'RUBROS';

  int nivelActual = 0;

  @override
  void initState() {
    listaCategorias.addAll(Categorias.categorias
        .where((categoria) => categoria.nivel == PRIMER_NIVEL_CATEGORIA)
        .toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: size.height * 0.015,
            ),
            _rowButtons(context),
            SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              TITLE_CATALOGO,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: size.height * 0.002,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            _gridCatalogo(context),
          ],
        ),
        Positioned(
          bottom: size.height * 0.03,
          right: size.width * 0.03,
          child: CatalogoProductosPage.seleccionando
              ? FloatingActionButton(
                  onPressed: () {
                    CatalogoProductosPage.itemsSelected.clear();
                    CatalogoProductosPage.seleccionando = false;
                    listaCategorias.forEach((rubro) {
                      rubro.checked = false;
                    });
                    widget.notifyParent();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    size: size.height * 0.05,
                  ),
                  elevation: 10,
                )
              : Container(),
        )
      ],
    );
  }

  Widget _gridCatalogo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Widget> listaProdGrilla = List<Widget>.filled(0, null, growable: true);

    listaCategorias.forEach((categoria) {
      listaProdGrilla.add(_cardCategoria(context, categoria));
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

  Widget _cardCategoria(BuildContext context, Categoria categoria) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width * 0.45,
          height: size.height * 0.25,
          child: InkWell(
            splashColor: Colors.red,
            highlightColor: Colors.red.withOpacity(0.5),
            onTap: () {
              //TODO cambiar lista que se muestra (rubros o items)
              if (CatalogoProductosPage.seleccionando) {
                if (categoria.checked) {
                  categoria.checked = false;
                  CatalogoProductosPage.itemsSelected.remove(categoria);
                } else {
                  categoria.checked = true;
                  CatalogoProductosPage.itemsSelected.add(categoria);
                }

                widget.notifyParent();

                setState(() {});
              } else { //navegando
                final idCategoria = categoria.categoriaID;
                print(widget.modo);
                if (nivelActual == 2) {
                  Navigator.of(context).pushNamed(BuscadorProductoPage.route,
                      arguments: [
                        categoria.descripcion,
                        idCategoria,
                        widget.modo
                      ]);
                  //push buscador productos con el idCategoria
                } else {
                  nivelActual++;
                  listaCategorias.clear();

                  Categorias.categorias.forEach((element) {
                    if (element.nivel == nivelActual &&
                        element.lineaItemParent.toString() == idCategoria)
                      listaCategorias.add(element);
                  });
                  // listaCategorias.addAll(Categorias.categorias.where((cat) {
                  //   print(cat);
                  //   return cat.nivel == nivelActual &&
                  //       cat.lineaItemParent.toString() == idCategoria;
                  // }).toList());

                  nivelActual = nivelActual;

                  setState(() {});
                }
              }
            },
            onLongPress: () {
              if (CatalogoProductosPage.seleccionando == false)
                CatalogoProductosPage.seleccionando = true;

              if (!categoria.checked) {
                categoria.checked = true;
                CatalogoProductosPage.itemsSelected.add(categoria);
              }

              widget.notifyParent();
              setState(() {});
            },
            child: Card(
              margin: EdgeInsets.all(size.width * 0.02),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
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
                      categoria?.descripcion?.toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        widget.modo == 'cotizacion' && CatalogoProductosPage.seleccionando
            ? _checkBox(context, categoria)
            : SizedBox(
                height: 0.001,
              ),
      ],
    );
  }

  void _ultimasFotosPressed() {}

  void _ultimasEntradasPressed() {}

  void _importacionPressed() {}

  _checkBox(BuildContext context, Categoria rubro) {
    return Checkbox(value: rubro.checked, onChanged: (value) {});
  }
}
