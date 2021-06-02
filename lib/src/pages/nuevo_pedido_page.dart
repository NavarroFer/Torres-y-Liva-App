import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/models/cliente_model.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/datos_pedido_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/pages/utils/calculator_page.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';

class NuevoPedidoPage extends StatefulWidget {
  static final String route = 'nuevoPedido';
  static bool clienteSeleccionado = false;

  static double neto = 0, iva = 0, total = 0;

  @override
  _NuevoPedidoPageState createState() => _NuevoPedidoPageState();
}

class _NuevoPedidoPageState extends State<NuevoPedidoPage>
    with TickerProviderStateMixin {
  Pedido pedido;

  MaterialColor color = Colors.red;

  List<Widget> acciones;

  @override
  Widget build(BuildContext context) {
    pedido = ModalRoute.of(context).settings.arguments;
    ItemsPedidoPage.pedido = pedido;
    int _tabIndex = 0;

    var tab = TabController(initialIndex: 0, length: 3, vsync: this);

    void _handleTabSelection() {
      setState(() {
        if (tab.index != 0 && NuevoPedidoPage.clienteSeleccionado == false)
          tab.index = _tabIndex;
        else
          tab.index = tab.index;
      });
    }

    // tab.addListener(_handleTabSelection);
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('Pedido'),
            backgroundColor: color,
            bottom: TabBar(
              // controller: tab,
              tabs: [
                Tab(
                  text: 'DATOS',
                ),
                Tab(
                  text: 'ITEMS',
                ),
                Tab(
                  text: 'PRODUCTOS',
                ),
              ],
            ),
            actions: _getAcciones(context),
          ),
          body: TabBarView(
            children: [
              DatosPedidoPage(pedido),
              SingleChildScrollView(child: ItemsPedidoPage(
                notifyParent: () {
                  _refresh(context);
                },
              )),
              CatalogoProductosPage(
                modo: 'pedido',
              ),
            ],
          ),
        ));
  }

  Widget _abrirCalculadora(BuildContext context) {
    return action(context,
        size: MediaQuery.of(context).size.width * 0.07,
        icon: MdiIcons.calculator,
        onPressed: _calculatorPressed);
  }

  Widget _buscarProductosCliente(BuildContext context) {
    return action(context,
        icon: Icons.search, onPressed: _buscarProductosPressed);
  }

  Widget _guardarPedido(BuildContext context) {
    return action(context,
        icon: Icons.save_rounded, onPressed: _guardarPedidoPressed);
  }

  void _calculatorPressed(BuildContext context) {
    Navigator.pushNamed(context, CalculatorPage.route);
  }

  void _buscarProductosPressed(BuildContext cotext) {}

  void _guardarPedidoPressed(BuildContext context) {
    Navigator.pop(context);
  }

  _acciones(BuildContext context) {
    return [
      _buscarProductosCliente(context),
      _abrirCalculadora(context),
      _guardarPedido(context)
    ];
  }

  void _refresh(BuildContext context) {
    _refreshColorAcciones(context);
    setState(() {});
  }

  void _refreshColorAcciones(BuildContext context) {
    if (ItemsPedidoPage.cantChecked > 0) {
      color = Colors.grey;
      acciones = _accionesItemsChecked(context);
    } else {
      color = Colors.red;
      acciones = _acciones(context);
    }
  }

  List<Widget> _accionesItemsChecked(BuildContext context) {
    return [_buttonEliminarItems(context)];
  }

  _getAcciones(BuildContext context) {
    _refreshColorAcciones(context);
    return acciones;
  }

  _buttonEliminarItems(BuildContext context) {
    return action(context,
        icon: Icons.delete_forever, onPressed: _eliminarItemsPressed);
  }

  void _eliminarItemsPressed(BuildContext context) {
    ItemsPedidoPage.pedido?.items?.removeWhere((element) => element?.checked);
    setState(() {});
  }
}
