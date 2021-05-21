import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  @override
  void initState() {
    listaBusqueda.addAll([
      Producto(id: 1, nombre: 'CUCHARON ALUMINIO 1 PIEZA', precio: 354.85),
      Producto(id: 2, nombre: 'ESPUMADERA ALUM. 1 PIEZA', precio: 336.38),
      Producto(id: 3, nombre: 'CUCHARON ALUMINIO 16CM HOTEL', precio: 570.05),
      Producto(id: 4, nombre: 'CUCHARA CAFE BETINA PX6', precio: 107.73),
      Producto(id: 5, nombre: 'CUCHARA MESA BETINA PX6', precio: 328.47),
      Producto(id: 6, nombre: 'CUCHARA REFRES.CAROL X3', precio: 173.02),
      Producto(id: 7, nombre: 'CUCHARA TE BETINA PX6', precio: 119.07),
      Producto(id: 8, nombre: 'CUCHARA CAFE ATHENA DOCENA', precio: 345.17),
      Producto(id: 9, nombre: 'CUCHARA DESAYUNO T/ATHENA DOC', precio: 482.89),
      Producto(id: 10, nombre: 'CUCHARA MESA T/ATHENA DOC', precio: 790.79),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titulo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        actions: [
          _editarBusqueda(context),
          _vistaGrid(context),
          _opciones(context)
        ],
      ),
      body: _body(context),
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

  void _editarBusquedaPressed(BuildContext context) {}

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

    listaBusqueda.forEach((producto) {
      listaProdGrilla.add(_cardProducto(context, producto));
    });
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: listaProdGrilla,
        )
      ],
    );
  }

  Widget _listaProductos(BuildContext context) {
    return Container();
  }

  Widget _cardProducto(BuildContext context, Producto producto) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.45,
      height: size.width * 0.45,
      child: Card(
        margin: EdgeInsets.all(size.width * 0.02),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                producto.nombre,
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                '\$ ${producto.precio.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculadoraPressed(BuildContext context) {
    Navigator.of(context).pushNamed(CalculatorPage.route);
  }

  void _listaPressed() {}

  void _catalogoPressed() {}
}
