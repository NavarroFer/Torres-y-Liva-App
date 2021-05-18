import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/nuevo_pedido_page.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';

import '../models/cliente_model.dart';
import '../models/producto_model.dart';
import 'nuevo_pedido_page.dart';
import 'utils/calculator_page.dart';

class HomePage extends StatefulWidget {
  static final String route = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _buscando = false;
  TextEditingController _buscadorController = TextEditingController();
  String _searchQuery = "";
  List<Pedido> listaPedidos = List<Pedido>.filled(0, null, growable: true);

  int _cantChecked = 0;

  @override
  void initState() {
    final c1 = Cliente(
        id: 16262,
        nombre: "BAJO JAVIER",
        direccion: "PEHUAJO",
        email: "bajojavier@gmail.com");
    final c2 = Cliente(
        id: 7283,
        nombre: "BARUK S.R.L",
        direccion: "CALLE 59 ENTRE 520 521 LA PLATA",
        email: "baruk@gmail.com",
        telefono: "4673423");

    final c3 =
        Cliente(id: 7284, nombre: "BENITEZ MARCELO", direccion: "RUTA 88");
    final p1 =
        Producto(id: 1, nombre: 'CUCHARON ALUMINIO 1 PIEZA', precio: 354.85);
    final p2 =
        Producto(id: 2, nombre: 'ESPUMADERA ALUM. 1 PIEZA', precio: 336.38);
    final p3 =
        Producto(id: 3, nombre: 'CUCHARON ALUMINIO 16CM HOTEL', precio: 570.05);
    listaPedidos.addAll([
      Pedido(
          id: 1,
          cliente: c1,
          items: List.of([p1, p2]),
          iva: p1.precio * 0.21 + p2.precio * 0.21,
          neto: p1.precio * 0.79 + p2.precio * 0.79,
          total: p1.precio + p2.precio,
          fechaHora: DateTime.now()),
      Pedido(
          id: 2,
          cliente: c2,
          items: List.of([p2, p3]),
          iva: p3.precio * 0.21 + p2.precio * 0.21,
          neto: p3.precio * 0.79 + p2.precio * 0.79,
          total: p3.precio + p2.precio,
          fechaHora: DateTime.now()),
      Pedido(
          id: 3,
          cliente: c3,
          items: List.of([p1, p2, p3]),
          iva: p1.precio * 0.21 + p2.precio * 0.21 + p3.precio * 0.21,
          neto: p1.precio * 0.79 + p2.precio * 0.79 + p3.precio * 0.79,
          total: p1.precio + p2.precio + p3.precio,
          fechaHora: DateTime.now()),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _cantChecked > 0 ? Colors.grey : Colors.red,
        leading: _buscando
            ? _buttonArrowWhileSearch(context)
            : _cantChecked > 0
                ? _buttonCheckedWhileSelecting(context)
                : Container(),
        title: _titleAppBar(context),
        actions: _acciones(context),
      ),
      resizeToAvoidBottomInset: true,
      body: _body(context),
    );
  }

  IconButton _buttonArrowWhileSearch(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => {_stopSearching()});
  }

  IconButton _buttonCheckedWhileSelecting(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.check, color: Colors.white),
        onPressed: () => {
              setState(() {
                _unCheckPedidos();
              })
            });
  }

  Widget _buscarPedido(BuildContext context) {
    if (_buscando)
      return action(context, icon: Icons.clear, onPressed: _clearSearchQuery);
    else
      return action(
        context,
        icon: Icons.search,
        onPressed: _startSearch,
      );
  }

  Widget _nuevoPedido(BuildContext context) {
    return action(context, icon: Icons.add, onPressed: _nuevoPedidoPressed);
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

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
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
                _actualizarPressed();
                break;
              case 1:
                _enviarPedidosPressed();
                break;
              case 2:
                _pedidosEnviadosPressed();
                break;
              case 3:
                _cotizacionesPressed();
                break;
              case 4:
                _calculadoraPressed(context);
                break;
              case 5:
                _cerrarSesionPressed();
                break;
              default:
            }
          },
          tooltip: 'Lista de opciones',
          itemBuilder: (_) => <PopupMenuItem<int>>[
            new PopupMenuItem<int>(child: Text('Actualizar'), value: 0),
            new PopupMenuItem<int>(child: Text('Enviar Pedidos'), value: 1),
            new PopupMenuItem<int>(child: Text('Pedidos Enviados'), value: 2),
            new PopupMenuItem<int>(child: Text('Cotizaciones'), value: 3),
            new PopupMenuItem<int>(child: Text('Calculadora'), value: 4),
            new PopupMenuItem<int>(child: Text('Cerrar sesión'), value: 5),
          ],
        ));
  }

  void _nuevoPedidoPressed(BuildContext context) {
    Navigator.pushNamed(context, NuevoPedidoPage.route);
  }

  void _actualizarPressed() {}

  void _enviarPedidosPressed() {}

  void _pedidosEnviadosPressed() {}

  void _cotizacionesPressed() {}

  void _calculadoraPressed(BuildContext context) {
    Navigator.of(context).pushNamed(CalculatorPage.route);
  }

  void _cerrarSesionPressed() {}

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
      return Text('Pedidos');
    }
  }

  Widget _body(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (listaPedidos.length > 0) {
      return _gridPedidos(context);
    } else {
      return Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.001, size.height * 0.06)),
              onPressed: () => _nuevoPedidoPressed(context),
              child: Text(
                'Crear Pedido',
                textScaleFactor: size.height * 0.0025,
              )));
    }
  }

  Widget _gridPedidos(BuildContext context) {
    return Container(
      width: double.infinity,
      child: DataTable(columns: [
        DataColumn(label: Text('CLIENTE')),
        DataColumn(label: Text('TOTAL')),
      ], showCheckboxColumn: false, rows: _rowsPedidos(context)),
    );
  }

  List<DataRow> _rowsPedidos(BuildContext context) {
    List<DataRow> lista = List<DataRow>.filled(0, null, growable: true);
    listaPedidos.forEach((pedido) {
      var dataRow = DataRow(
          onSelectChanged: (value) {
            Navigator.of(context)
                .pushNamed(NuevoPedidoPage.route, arguments: pedido);
          },
          cells: [
            _datosCliente(context, pedido, pedido.cliente.nombre,
                pedido.fechaHora?.toString()),
            _totalPedido(context, pedido.total),
          ]);
      lista.add(dataRow);
    });

    return lista;
  }

  DataCell _datosCliente(BuildContext context, Pedido pedido,
      String nombreCliente, String fechaHora) {
    return DataCell(
      Row(
        children: [
          _checkBox(context, pedido),
          _celdaCliente(context, nombreCliente, fechaHora),
        ],
      ),
    );
  }

  DataCell _totalPedido(BuildContext context, double total) {
    return DataCell(Text('\$ ${total.toStringAsFixed(2)}'));
  }

  Widget _checkBox(BuildContext context, Pedido pedido) {
    return Checkbox(
        value: pedido.checked,
        onChanged: (value) {
          setState(() {
            pedido.checked = value;

            _cantChecked += value == true ? 1 : -1;
          });
        });
  }

  Widget _celdaCliente(BuildContext context, String nombre, String fechaHora) {
    return Column(
      children: [
        Text(nombre),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.001,
        ),
        Text(fechaHora)
      ],
    );
  }

  List<Widget> _acciones(BuildContext context) {
    if (_cantChecked > 0)
      return [
        _eliminarPedidos(context),
        _convertirACotizaciones(context),
        _toPDF(context),
        _toPDFShare(context)
      ];
    else
      return [
        _buscarPedido(context),
        _nuevoPedido(context),
        _opciones(context)
      ];
  }

  Widget _convertirACotizaciones(BuildContext context) {
    return action(context,
        icon: MdiIcons.arrowAll, onPressed: _convertirACotizacionesPressed);
  }

  Widget _eliminarPedidos(BuildContext context) {
    return action(context,
        icon: MdiIcons.minusThick, onPressed: _eliminarPedidosPressed);
  }

  Widget _toPDF(BuildContext context) {
    return _opcionesPDF(context, false, MdiIcons.pdfBox);
  }

  Widget _toPDFShare(BuildContext context) {
    return _opcionesPDF(context, true, MdiIcons.shareVariant);
  }

  void _convertirACotizacionesPressed(BuildContext context) {
    setState(() {
      _unCheckPedidos();
    });
  }

  void _eliminarPedidosPressed(BuildContext context) {
    setState(() {
      listaPedidos.forEach((pedido) {
        if (pedido.checked) listaPedidos.remove(pedido);
      });
      _cantChecked = 0;
    });
  }

  Widget _opcionesPDF(BuildContext context, bool share, IconData icon) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: PopupMenuButton(
          child: Icon(icon),
          onSelected: (value) {
            switch (value) {
              case 0:
                _catalogoPressed();
                break;
              case 1:
                _cotizacionPressed();
                break;
              default:
            }
          },
          tooltip: 'Lista de opciones',
          itemBuilder: (_) => <PopupMenuItem<int>>[
            new PopupMenuItem<int>(child: Text('Catálogo'), value: 0),
            new PopupMenuItem<int>(child: Text('Cotización'), value: 1),
          ],
        ));
  }

  void _catalogoPressed() async {
    //generar PDF catalogo

    setState(() {
      _unCheckPedidos();
    });
  }

  void _cotizacionPressed() async {
    //generar PDF cotizacion
    setState(() {
      _unCheckPedidos();
    });
  }

  void _unCheckPedidos() {
    _cantChecked = 0;
    listaPedidos.forEach((pedido) => pedido.checked = false);
  }
}
