import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/nuevo_pedido_page.dart';
import 'package:torres_y_liva/src/utils/image_helper.dart';
import 'package:torres_y_liva/src/widgets/dialog_box_widget.dart';

import '../models/producto_model.dart';
import '../widgets/base_widgets.dart';

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
            // case 2:
            //   _calculadoraPressed(context);
            //   break;
            default:
          }
        },
        tooltip: 'Lista de opciones',
        itemBuilder: (_) => <PopupMenuItem<int>>[
          new PopupMenuItem<int>(child: Text('Lista'), value: 0),
          new PopupMenuItem<int>(child: Text('Catalogo'), value: 1),
          // new PopupMenuItem<int>(child: Text('Calculadora'), value: 2),
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
  }

  Widget _gridProductos(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _getProductosShow(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: AutoSizeText(
                'No hay productos para mostrar.',
                textScaleFactor: size.height * 0.002,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      index < snapshot.data.length &&
                              index > 0 &&
                              index % 2 == 1
                          ? _cardProducto(context, snapshot.data[index - 1])
                          : Container(),
                      index < snapshot.data.length &&
                              index > 0 &&
                              index % 2 == 1
                          ? _cardProducto(context, snapshot.data[index])
                          : Container()
                    ]);
              },
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _listaProductos(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _getProductosShow(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: AutoSizeText(
                'No hay productos para mostrar.',
                textScaleFactor: size.height * 0.002,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index].descripcion),
                  leading: FutureBuilder(
                    future:
                        getImage(snapshot.data[index].id, context, 0.15, true),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null)
                          return snapshot.data;
                        else {
                          return Icon(
                            MdiIcons.cameraOff,
                            size: size.height * 0.1,
                          );
                        }
                      } else {
                        return Icon(
                          MdiIcons.cameraOff,
                          size: size.height * 0.1,
                        );
                      }
                    },
                  ),
                  trailing: Text(
                      "\$ ${snapshot.data[index].precio.toStringAsFixed(2)}"),
                  onTap: pageFrom == 'pedido'
                      ? () {
                          _itemPressed(context, snapshot.data[index]);
                        }
                      : () {
                          _itemPressedCatalogo(context, snapshot.data[index]);
                        },
                  onLongPress: pageFrom == 'cotizacion'
                      ? () {
                          _itemLongPressedCatalogo(
                              context, snapshot.data[index]);
                        }
                      : () {},
                );
              },
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
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
            height: size.height * 0.35,
            child: Card(
              margin: EdgeInsets.all(size.width * 0.02),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: getImage(producto.id, context, 0.4, false),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null)
                          return snapshot.data;
                        else {
                          return Icon(
                            MdiIcons.cameraOff,
                            size: size.height * 0.1,
                          );
                        }
                      } else {
                        return Icon(
                          MdiIcons.cameraOff,
                          size: size.height * 0.1,
                        );
                      }
                    },
                  ),
                  ListTile(
                    title: AutoSizeText(
                      producto?.descripcion ?? '',
                      textAlign: TextAlign.center,
                      maxLines: 2,
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
                "\$ ${producto?.precio?.toStringAsFixed(2)} - Stock: ${producto?.stock?.toStringAsFixed(2)}",
            textBtn1: "Cancelar",
            textBtn2: "Agregar",
            alert: false,
            img: Image.asset('assets/img/ic_launcher_round.png'),
          );
        }).then((value) {
      if (value != null) {
        final cant = value[0];
        final obs = value[1];

        if (producto.stock < cant) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: 'Stock insuficiente',
                  descriptions: '¿Desea agregar de todas formas?',
                  textBtn1: "Si",
                  textBtn2: "No",
                  icon: Icons.warning,
                  alert: true,
                );
              }).then((value) {
            if (value == true) {
              _addItem(producto, cant, obs);
            }
          });
        } else {
          _addItem(producto, cant, obs);
        }
      }
    });
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
  }

  _buttonArrowBack(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => {Navigator.of(context).pop()});
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
          _getCatHijas(categoria.categoriaID, nivel + 1);
        }
      });
    } else if (nivel == 2) {
      listaCat.add(idCat);
    }
  }

  void _addItem(Producto producto, double cant, String obs) {
    int newId = 1;

    if (NuevoPedidoPage.pedido?.items?.isNotEmpty) {
      newId = NuevoPedidoPage.pedido?.items?.last?.id + 1;
    }

    var precioTotal = producto.precio * cant;
    final itemPedido = ItemPedido(
        cantidad: cant ?? 1,
        detalle: producto.descripcion ?? '',
        descuento: 0.0,
        id: newId,
        productoID: producto.id,
        precio: producto.precio,
        producto: producto,
        iva: producto.iva,
        observacion: obs ?? '',
        fraccion: 1.0,
        precioTotal: precioTotal);

    if (NuevoPedidoPage.pedido.neto == null) {
      NuevoPedidoPage.pedido.neto = 0;
    }
    if (NuevoPedidoPage.pedido.totalPedido == null) {
      NuevoPedidoPage.pedido.totalPedido = 0;
    }
    if (NuevoPedidoPage.pedido.iva == null) {
      NuevoPedidoPage.pedido.iva = 0;
    }
    NuevoPedidoPage.pedido.neto += precioTotal * (1 - producto.iva / 100);
    NuevoPedidoPage.pedido.totalPedido += precioTotal;
    NuevoPedidoPage.pedido.iva += precioTotal * producto.iva / 100;

    NuevoPedidoPage.pedido?.items?.add(itemPedido);
  }

  Future<List<Producto>> _getProductosShow() async {
    final listProductos = List<Producto>.empty(growable: true);

    int idCat = int.tryParse(idCategoria);

    if (_buscando) {
      if (_searchQuery != null && _searchQuery != '' && _searchQuery.length > 3)
        listProductos
            .addAll(await Producto.getSearch(_searchQuery.toUpperCase()));
      return listProductos;
    }

    if (idCat != null) {
      if (int.parse(idCategoria) > 0) {
        listaCat.clear();
        _getCatHijas(idCategoria, nivelCat);

        listProductos.addAll(Productos.productos
            .where((element) => listaCat.contains(element?.categoriaID))
            .toList());
      } else {
        listProductos.addAll(await Producto.getSearch(titulo?.toUpperCase()));
      }
    } else {
      //CAT especiales
      if (idCategoria == Categoria.ULTIMAS_ENTRADAS) {
        listProductos.addAll(await Producto.getUltimasEntradas());
      } else if (idCategoria == Categoria.ULTIMAS_FOTOS) {
        listProductos.addAll(await Producto.getUltimasFotos());
      } else if (idCategoria == Categoria.IMPORTACION) {
        listProductos.addAll(await Producto.getImportados());
      }
    }

    return listProductos;
  }
}
