import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/pages/nuevo_pedido_page.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';

class HomePage extends StatelessWidget {
  static final String route = 'home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        actions: [_buscarPedido(), _nuevoPedido(context), _opciones()],
      ),
      body: Container(),
    );
  }

  Widget _buscarPedido() {
    return IconButton(
        icon: Icon(Icons.search), onPressed: _buscarPedidoPressed);
  }

  Widget _nuevoPedido(BuildContext context) {
    return action(context, icon: Icons.add, onPressed: _nuevoPedidoPressed);
  }

  Widget _opciones() {
    return IconButton(
        icon: Icon(MdiIcons.dotsVertical), onPressed: _opcionesPressed);
  }

  void _buscarPedidoPressed() {}

  void _nuevoPedidoPressed(BuildContext context) {
    Navigator.pushNamed(context, NuevoPedidoPage.route);
  }

  void _opcionesPressed() {}
}
