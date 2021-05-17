import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/datos_pedido_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/pages/utils/calculator_page.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';

class NuevoPedidoPage extends StatelessWidget {
  static final String route = 'nuevoPedido';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Pedido'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'DATOS',),
                Tab(text: 'ITEMS',),
                Tab(text: 'PRODUCTOS',),
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
              DatosPedidoPage(),
              ItemsPedidoPage(),
              CatalogoProductosPage(),
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
