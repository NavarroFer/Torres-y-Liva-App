import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';

// ignore: must_be_immutable
class PedidoEnviadoDetailPage extends StatelessWidget {
  static final String route = 'pedidoEnviadoDetail';

  Pedido pedido;

  @override
  Widget build(BuildContext context) {
    pedido = ModalRoute.of(context).settings.arguments;
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
              _datosPedidoFijos(context),
              // DatosPedidoPage(pedido),
              _gridItems(context, pedido.items),
            ],
          ),
        ));
  }

  _buttonCopiarPedido(BuildContext context) {
    return action(context,
        icon: Icons.copy_outlined, onPressed: _copiarPedidoPressed);
  }

  void _copiarPedidoPressed(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  _datosPedidoFijos(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.05),
      child: Column(
        children: [
          _datosPedido(context),
          SizedBox(
            height: size.height * 0.05,
          ),
          totalesVenta(context, pedido.neto, pedido.iva, pedido.totalPedido),
        ],
      ),
    );
  }

  _datosPedido(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStlye = TextStyle(fontSize: size.aspectRatio * 35);
    return Container(
      height: size.height * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // height: size.he,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente:',
                    style: textStlye,
                  ),
                  SizedBox(
                    height: size.height * 0.0,
                  ),
                  Text(
                    'Condición de Venta:',
                    style: textStlye,
                  ),
                  Text(
                    'Comentarios:',
                    style: textStlye,
                  ),
                  Text(
                    'Descuento General:',
                    style: textStlye,
                  ),
                  Text(
                    'Observaciones:',
                    style: textStlye,
                  ),
                ]),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: size.height * 0.05,
                width: size.width * 0.4,
                child: AutoSizeText(
                  pedido?.cliente?.nombre ?? '',
                  wrapWords: true,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: (size.width * 0.04).roundToDouble(),
                ),
              ),
              Text(
                pedido.getFormaPago(),
                style: textStlye,
              ),
              Text(
                '',
                style: textStlye,
              ),
              Text(
                '${pedido?.descuento?.toStringAsFixed(2) ?? '0.00'} %',
                style: textStlye,
              ),
              Text(
                pedido?.observaciones ?? '',
                style: textStlye,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _gridItems(BuildContext context, List<ItemPedido> items) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.55,
        width: double.infinity,
        child: SingleChildScrollView(
            // constrained: false,
            child: DataTable(
                columnSpacing: size.width * 0.04,
                columns: [
                  DataColumn(label: Text('CÓDIGO')),
                  DataColumn(label: Text('CANT.')),
                  DataColumn(label: Text('DESCRIPCIÓN')),
                  DataColumn(label: Text('PRECIO'))
                ],
                rows: _rowsItems(
                    context, items)) // cada fila un producto agregado,
            ));
  }

  List<DataRow> _rowsItems(BuildContext context, List<ItemPedido> items) {
    List<DataRow> lista = List<DataRow>.filled(0, null, growable: true);
    items?.forEach((item) {
      var dataRow = DataRow(cells: [
        DataCell(Text(item.id.toString())),
        DataCell(Text(item?.cantidad.toString() ?? '')),
        DataCell(GestureDetector(
          child: Text(item?.detalle ?? ''),
        )),
        DataCell(Text(
          '\$${item.precio.toStringAsFixed(2)}',
          textScaleFactor: MediaQuery.of(context).size.width * 0.003,
        )),
      ]);
      lista.add(dataRow);
    });

    return lista;
  }
}
