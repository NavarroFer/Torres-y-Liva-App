import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
import 'package:torres_y_liva/src/models/rubro_model.dart';
import 'package:torres_y_liva/src/pages/buscador_producto_page.dart';

class CatalogoProductosPage extends StatefulWidget {
  static final String route = 'catalgo';

  final Function() notifyParent;
  final String modo;
  static List itemsSelected = List.empty(growable: true);
  static bool seleccionando = false;
  static int cantidadItems = 0;

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

  List<Categoria> _pathCategorias = List.empty(growable: true);

  @override
  void initState() {
    listaCategorias.addAll(Categorias.categorias
        .where((categoria) => categoria.nivel == PRIMER_NIVEL_CATEGORIA)
        .toList());
    super.initState();
  }

  @override
  void dispose() {
    CatalogoProductosPage.itemsSelected.clear();
    CatalogoProductosPage.seleccionando = false;
    CatalogoProductosPage.cantidadItems = 0;
    listaCategorias.forEach((rubro) {
      rubro.checked = false;
    });
    super.dispose();
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
            this.nivelActual == 0 ? Container() : _buttonsNavigation(context),
            Text(
              TITLE_CATALOGO,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: size.height * 0.002,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            this.nivelActual == 0 ? Container() : _pathNavigation(context),
            _gridCatalogo(context),
          ],
        ),
        Positioned(
          bottom: size.height * 0.03,
          right: size.width * 0.03,
          child: CatalogoProductosPage.seleccionando
              ? Stack(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        CatalogoProductosPage.itemsSelected.clear();
                        CatalogoProductosPage.seleccionando = false;
                        CatalogoProductosPage.cantidadItems = 0;
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
                    ),
                    _numeroCantidadItems(context),
                  ],
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
        height: this.nivelActual == 0
            ? size.height * 0.58
            : widget.modo == 'pedido'
                ? size.height * 0.4
                : size.height * 0.45,
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
              //TODO reemplazar por una query a la DB local
              final cantItems = _getCantidadItemsCategoria(
                  categoria.categoriaID, categoria.nivel);
              if (CatalogoProductosPage.seleccionando) {
                if (categoria.checked) {
                  categoria.checked = false;
                  CatalogoProductosPage.itemsSelected.remove(categoria);
                  CatalogoProductosPage.cantidadItems -= cantItems;
                } else {
                  categoria.checked = true;
                  CatalogoProductosPage.itemsSelected.add(categoria);
                  CatalogoProductosPage.cantidadItems += cantItems;
                }

                widget.notifyParent();

                setState(() {});
              } else {
                //navegando
                if (!this._pathCategorias.contains(categoria)) {
                  this._pathCategorias.add(categoria);
                }
                final idCategoria = categoria.categoriaID;
                if (nivelActual == 2) {
                  Navigator.of(context).pushNamed(BuscadorProductoPage.route,
                      arguments: [
                        categoria.descripcion,
                        idCategoria,
                        widget.modo,
                        nivelActual
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

                  setState(() {});
                }
              }
            },
            onLongPress: () {
              if (widget.modo == 'cotizacion') {
                if (CatalogoProductosPage.seleccionando == false)
                  CatalogoProductosPage.seleccionando = true;

                //TODO reemplazar por una query a la DB local
                final cantItems = _getCantidadItemsCategoria(
                    categoria.categoriaID, categoria.nivel);

                if (!categoria.checked) {
                  categoria.checked = true;
                  CatalogoProductosPage.itemsSelected.add(categoria);
                  CatalogoProductosPage.cantidadItems += cantItems;
                }

                widget.notifyParent();
                setState(() {});
              }
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
                    title: AutoSizeText(
                      categoria?.descripcion?.toUpperCase(),
                      maxLines: 2,
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

  Widget _checkBox(BuildContext context, Categoria rubro) {
    return Checkbox(value: rubro.checked, onChanged: (value) {});
  }

  Widget _numeroCantidadItems(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return new Positioned(
      right: 0,
      top: 0,
      child: new Container(
        padding: EdgeInsets.all(1),
        decoration: new BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        constraints: BoxConstraints(
            minWidth: size.width * 0.05, minHeight: size.height * 0.02),
        child: new Text(
          '${CatalogoProductosPage.cantidadItems}',
          style: new TextStyle(
            color: Colors.white,
            fontSize: size.height * 0.02,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  int _getCantidadItemsCategoria(String categoriaID, int nivel) {
    //TODO cambiar por una busqueda en la db local

    int cant = 0;
    if (nivel < 2) {
      Categorias.categorias.forEach((categoria) {
        if (categoria.nivel == nivel + 1 &&
            categoria.lineaItemParent.toString() == categoriaID)
          cant += _getCantidadItemsCategoria(categoria.categoriaID, nivel + 1);
      });
    } else {
      //nivel 3 = productos
      Productos.productos.forEach((producto) {
        if (producto.categoriaID == categoriaID) cant++;
      });
    }

    return cant;
  }

  Widget _buttonsNavigation(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final botones = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: size.width * 0.05,
        ),
        _buttonBackNavigation(context),
        SizedBox(
          width: size.width * 0.01,
        ),
        _buttonHome(context),
        Expanded(child: SizedBox()),
        _buttonCatalogo(context),
        SizedBox(
          width: size.width * 0.05,
        ),
      ],
    );
    return Column(
      children: [
        botones,
        SizedBox(
          height: size.height * 0.03,
        ),
      ],
    );
  }

  _buttonBackNavigation(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        nivelActual--;

        listaCategorias.clear();
        this._pathCategorias.removeLast();

        Categorias.categorias.forEach((element) {
          if (element.nivel == nivelActual) listaCategorias.add(element);
        });
        setState(() {});
      },
      child: Icon(Icons.arrow_back),
    );
  }

  _buttonHome(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          nivelActual = PRIMER_NIVEL_CATEGORIA;
          listaCategorias.clear();
          _pathCategorias.clear();
          Categorias.categorias.forEach((element) {
            if (element.nivel == nivelActual) listaCategorias.add(element);
          });
          setState(() {});
        },
        child: Icon(Icons.home));
  }

  _buttonCatalogo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final categoria = _pathCategorias[_pathCategorias.length - 1];

    return ElevatedButton(
      onPressed: () {
        //TODO que al apretar, funcione
        Navigator.of(context).pushNamed(BuscadorProductoPage.route, arguments: [
          categoria?.descripcion?.trim(),
          categoria?.categoriaID,
          widget.modo,
          nivelActual - 1
        ]);
      },
      child: Text('Ver Catálogo'),
    );
  }

  Widget _pathNavigation(BuildContext context) {
    final size = MediaQuery.of(context).size;

    String pathString = '';
    _pathCategorias.forEach((element) {
      pathString += " > ${element?.descripcion?.trim()}";
    });

    final path = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * 0.05,
        ),
        Text(
          pathString,
          textAlign: TextAlign.start,
          textScaleFactor: size.height * 0.0015,
        ),
      ],
    );
    return Column(
      children: [
        path,
        SizedBox(
          height: size.height * 0.03,
        ),
      ],
    );
  }
}
