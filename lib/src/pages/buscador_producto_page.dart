import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  List listaBusqueda = List.filled(0, null, growable: true);

  int _vista = 1;

  bool _buscando = false;

  TextEditingController _buscadorController = TextEditingController();

  String _searchQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titulo = ModalRoute.of(context).settings.arguments;
    // _startSearch(context);

    return Scaffold(
      appBar: AppBar(
        leading: _buscando
            ? _buttonArrowWhileSearch(context)
            : _buttonArrowBack(context),
        title: _titleAppBar(context),
        actions: [
          _editarBusqueda(context),
          _vistaGrid(context),
          _opciones(context)
        ],
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

    // listaBusqueda.forEach((producto) {
    //   listaProdGrilla.add(_cardProducto(context, producto));
    // });
    return ListView.builder(
      itemCount: listaBusqueda.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          index < listaBusqueda.length && index > 0
              ? _cardProducto(context, listaBusqueda[index - 1])
              : Container(),
          index < listaBusqueda.length && index > 0
              ? _cardProducto(context, listaBusqueda[index])
              : Container()
        ]);
      },
      // children: [
      //   Wrap(
      //     alignment: WrapAlignment.center,
      //     children: listaProdGrilla,
      //   )
      // ],
    );
  }

  Widget _listaProductos(BuildContext context) {
    return Container();
  }

  Widget _cardProducto(BuildContext context, Producto producto) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        width: size.width * 0.45,
        // height: size.width * 0.45,
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
      onTap: _productoPressed(context, producto),
    );
  }

  void _calculadoraPressed(BuildContext context) {
    Navigator.of(context).pushNamed(CalculatorPage.route);
  }

  void _listaPressed() {}

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
    listaBusqueda.addAll(Productos.productos
        .where((element) => element?.descripcion
            ?.toUpperCase()
            ?.contains(_searchQuery?.toUpperCase()))
        .toList());

    var a;
    a = 2;
  }

  _buttonArrowBack(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => {Navigator.of(context).pop()});
  }

  _productoPressed(BuildContext context, Producto producto) {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return CustomDialogBox(
    //         title: "Custom Dialog Demo",
    //         descriptions:
    //             "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
    //         text: "Yes",
    //       );
    //     });
  }
}
