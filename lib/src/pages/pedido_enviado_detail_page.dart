import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/datos_pedido_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';

class PedidoEnviadoDetailPage extends StatelessWidget {
  static final String route = 'pedidoEnviadoDetail';

  Pedido pedido;

  @override
  Widget build(BuildContext context) {
    final pedido = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: [_buttonCopiarPedido(context)],
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
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _datosPedidoFijos(),
              // DatosPedidoPage(pedido),
              _gridItems(),
            ],
          ),
        ));
  }

  _buttonCopiarPedido(BuildContext context) {
    return action(context,
        icon: Icons.copy_outlined, onPressed: _copiarPedidoPressed);
  }

  void _copiarPedidoPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  _datosPedidoFijos() {
    return Container();
  }

  _gridItems() {
    return Container();
  }
}
