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

  @override
  Widget build(BuildContext context) {
    pedido = ModalRoute.of(context).settings.arguments;
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
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Pedido'),
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
            actions: [
              _buscarProductosCliente(context),
              _abrirCalculadora(context),
              _guardarPedido(context)
            ],
          ),
          body: TabBarView(
            children: [
              DatosPedidoPage(pedido),
              ItemsPedidoPage(pedido),
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
}
