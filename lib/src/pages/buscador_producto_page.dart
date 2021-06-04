import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/widgets/dialog_box_widget.dart';

import '../models/producto_model.dart';
import '../widgets/base_widgets.dart';
import 'utils/calculator_page.dart';

class BuscadorProductoPage extends StatefulWidget {
  static final String route = 'buscadorProd';

  @override
  _BuscadorProductoPageState createState() => _BuscadorProductoPageState();
}

class _BuscadorProductoPageState extends State<BuscadorProductoPage> {
  String titulo = '';
  List<Producto> listaBusqueda = List<Producto>.filled(0, null, growable: true);

  int _vista = 1;

  bool _buscando = false;

  List<Widget> acciones = [];

  TextEditingController _buscadorController = TextEditingController();

  String _searchQuery;

  List<ItemPedido> itemsParaPedido = List<ItemPedido>.empty(growable: true);

  List<Object> arguments;

  String idCategoria;

  int nivelCat = -1;

  bool primerFiltro = true;

  String pageFrom = '';

  List<String> listaCat = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    primerFiltro = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    titulo = arguments[0];
    idCategoria = arguments[1];
    pageFrom = arguments[2];
    nivelCat = arguments[3];

    if (primerFiltro) _filterListaBusqueda();

    // _startSearch(context);

    return Scaffold(
      appBar: AppBar(
        leading: _buscando
            ? _buttonArrowWhileSearch(context)
            : _buttonArrowBack(context),
        title: _titleAppBar(context),
        actions: CatalogoProductosPage.seleccionando
            ? acciones = _accionesSeleccionando(context)
            : _acciones(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: _body(context),
      ),
    );
  }

  Widget _editarBusqueda(BuildContext context) {
    return action(context,
        icon: Icons.search, onPressed: _editarBusquedaPressed);
  }

  Widget _opciones(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02),
      child: PopupMenuButton(
        child: Icon(MdiIcons.dotsVertical),
        onSelected: (value) {
          switch (value) {
            case 0:
              _listaPressed();
              break;
            case 1:
              _catalogoPressed();
              break;
            case 2:
              _calculadoraPressed(context);
              break;
            default:
          }
        },
        tooltip: 'Lista de opciones',
        itemBuilder: (_) => <PopupMenuItem<int>>[
          new PopupMenuItem<int>(child: Text('Lista'), value: 0),
          new PopupMenuItem<int>(child: Text('Catalogo'), value: 1),
          new PopupMenuItem<int>(child: Text('Calculadora'), value: 2),
        ],
      ),
    );
  }

  Widget _vistaGrid(BuildContext context) {
    return action(context,
        icon: MdiIcons.viewGrid, onPressed: _vistaGridPressed);
  }

  void _editarBusquedaPressed(BuildContext context) {
    _startSearch(context);
    // updateSearchQuery(_searchQuery);
  }

  void _vistaGridPressed(BuildContext context) {
    setState(() {
      _vista = 0;
    });
  }

  Widget _body(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (listaBusqueda.length > 0) {
      switch (_vista) {
        case 0: //Grid
          return _gridProductos(context);
          break;
        case 1: //Lista
          return _listaProductos(context);
          break;
        default:
          return Container();
      }
    } else {
      return Center(
        child: AutoSizeText(
          'No hay productos para mostrar.',
          textScaleFactor: size.height * 0.002,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _gridProductos(BuildContext context) {
    List<Widget> listaProdGrilla = List<Widget>.filled(0, null, growable: true);

    return ListView.builder(
      itemCount: listaBusqueda.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          index < listaBusqueda.length && index > 0 && index % 2 == 1
              ? _cardProducto(context, listaBusqueda[index - 1])
              : Container(),
          index < listaBusqueda.length && index > 0 && index % 2 == 1
              ? _cardProducto(context, listaBusqueda[index])
              : Container()
        ]);
      },
    );
  }

  Widget _listaProductos(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Widget> listaProdGrilla = List<Widget>.filled(0, null, growable: true);

    return ListView.builder(
      itemCount: listaBusqueda.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(listaBusqueda[index].descripcion),
          leading: Icon(
            MdiIcons.cameraOff,
            size: size.height * 0.04,
          ),
          trailing:
              Text("\$ ${listaBusqueda[index].precio.toStringAsFixed(2)}"),
          onTap: pageFrom == 'pedido'
              ? () {
                  _itemPressed(context, listaBusqueda[index]);
                }
              : () {
                  _itemPressedCatalogo(context, listaBusqueda[index]);
                },
          onLongPress: pageFrom == 'cotizacion'
              ? () {
                  _itemLongPressedCatalogo(context, listaBusqueda[index]);
                }
              : () {},
        );
      },
    );
  }

  Widget _cardProducto(BuildContext context, Producto producto) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          child: Container(
            width: size.width * 0.45,
            // height: size.width * 0.45,
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
                      producto?.descripcion ?? '',
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      '\$ ${producto?.precio?.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: pageFrom == 'pedido'
              ? () {
                  _itemPressed(context, producto);
                }
              : () {
                  _itemPressedCatalogo(context, producto);
                },
          onLongPress: pageFrom == 'cotizacion'
              ? () {
                  _itemLongPressedCatalogo(context, producto);
                }
              : () {},
        ),
        pageFrom == 'cotizacion' && CatalogoProductosPage.seleccionando
            ? _checkBox(context, producto)
            : SizedBox(
                height: 0.001,
              ),
      ],
    );
  }

  void _itemPressed(BuildContext context, Producto producto) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: producto.descripcion,
            descriptions:
                "\$ ${producto?.precio.toStringAsFixed(2)} - Stock: ${producto?.stock?.toStringAsFixed(2)}",
            textBtn1: "Cancelar",
            textBtn2: "Agregar",
            img: Image.asset('assets/img/ic_launcher_round.png'),
          );
        }).then((value) {
      if (value != null) {
        final cant = value[0];
        final obs = value[1];

        final itemPedido = ItemPedido(
            cantidad: cant,
            observacion: obs,
            detalle: producto.descripcion,
            descuento: 0,
            producto: producto,
            productoID: producto.id,
            precio: producto.precio * 0.79,
            precioTotal: producto.precio,
            fraccion: 0.0,
            id: ItemsPedidoPage.pedido?.items?.last?.id + 1,
            iva: producto.precio * 0.21,
            pedidoID: 23);

        itemsParaPedido.add(itemPedido);
      }
    });
  }

  void _calculadoraPressed(BuildContext context) {
    Navigator.of(context).pushNamed(CalculatorPage.route);
  }

  void _listaPressed() {
    setState(() {
      _vista = 1;
    });
  }

  void _catalogoPressed() {}

  Widget _titleAppBar(BuildContext context) {
    if (_buscando) {
      return TextField(
          controller: _buscadorController,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          onChanged: (query) => updateSearchQuery(query));
    } else {
      return Text(_searchQuery ?? titulo ?? '');
    }
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;

      _filterListaBusqueda();
    });
  }

  void _startSearch(BuildContext context) {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _buscando = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery(null);

    setState(() {
      _buscando = false;
    });
  }

  void _clearSearchQuery(BuildContext context) {
    setState(() {
      _buscadorController.clear();
      updateSearchQuery("");
    });
  }

  _buttonArrowWhileSearch(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => {_stopSearching()});
  }

  void _filterListaBusqueda() {
    listaBusqueda.clear();

    if (primerFiltro == true) primerFiltro = false;

    if (int.parse(idCategoria) > 0) {
      int cant = 0;
      listaCat.clear();
      _getCatHijas(idCategoria, nivelCat);
      print(listaCat?.asMap());

      listaBusqueda.addAll(Productos.productos
          .where((element) => listaCat.contains(element?.categoriaID))
          .toList());
    } else {
      if (_searchQuery != null && _searchQuery != '') {
        listaBusqueda.addAll(Productos.productos
            .where((element) => element?.descripcion
                ?.toUpperCase()
                ?.contains(_searchQuery?.toUpperCase()))
            .toList());
      } else {
        listaBusqueda.addAll(Productos.productos
            .where((element) => element?.descripcion
                ?.toUpperCase()
                ?.contains(titulo?.toUpperCase()))
            .toList());
      }
    }

    var a;
    a = 2;
  }

  _buttonArrowBack(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => {Navigator.of(context).pop(itemsParaPedido)});
  }

  void _itemLongPressedCatalogo(BuildContext context, Producto producto) {
    CatalogoProductosPage.seleccionando = true;
    producto.checked = true;
    if (!CatalogoProductosPage.itemsSelected.contains(producto))
      CatalogoProductosPage.itemsSelected.add(producto);
    setState(() {});
  }

  Widget _checkBox(BuildContext context, Producto producto) {
    return Checkbox(value: producto.checked, onChanged: (value) {});
  }

  void _itemPressedCatalogo(BuildContext context, Producto producto) {
    if (CatalogoProductosPage.seleccionando) {
      if (!producto.checked) {
        producto.checked = true;
        CatalogoProductosPage.itemsSelected.add(producto);
      } else {
        producto.checked = false;
        CatalogoProductosPage.itemsSelected.remove(producto);
      }
      setState(() {});
    }
  }

  List<Widget> _accionesSeleccionando(BuildContext context) {
    return [_confirmSelection(context)];
  }

  Widget _confirmSelection(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red, // background
          onPrimary: Colors.white, // foreground
        ),
        icon: Icon(MdiIcons.check,
            size: MediaQuery.of(context).size.height * 0.045),
        label: Container());
  }

  List<Widget> _acciones(BuildContext context) {
    return [_editarBusqueda(context), _vistaGrid(context), _opciones(context)];
  }

  _getCatHijas(String idCat, int nivel) {
    if (nivel == -1) {
      listaCat.add(idCategoria);
    } else if (nivel >= 0 && nivel < 2) {
      Categorias.categorias.forEach((categoria) {
        if (categoria.nivel == nivel + 1 &&
            categoria.lineaItemParent.toString() == idCat) {
          // print('Pase por categoria intermedia: ${categoria.categoriaID}');
          _getCatHijas(categoria.categoriaID, nivel + 1);
        }
      });
    } else if (nivel == 2) {
      // print('Agregando categoria hoja: $idCat');
      listaCat.add(idCat);
      // Categorias.categorias.forEach((categoria) {
      //   if (categoria.nivel == 2 &&
      //       categoria.lineaItemParent.toString() == idCategoria) {
      //     print('Agregando categoria hoja: ${categoria.categoriaID}');
      //     listaCat.add(categoria.categoriaID);
      //   }
      // });
    }
  }
}
