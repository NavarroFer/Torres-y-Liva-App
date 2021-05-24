import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/buscador_producto_page.dart';

import '../widgets/base_widgets.dart';

class ItemsPedidoPage extends StatefulWidget {
  static final String route = 'itemsPedido';

  Pedido pedido;

  ItemsPedidoPage(this.pedido);

  @override
  _ItemsPedidoPageState createState() => _ItemsPedidoPageState();
}

class _ItemsPedidoPageState extends State<ItemsPedidoPage> {
  final _codController = TextEditingController();
  final _nombreProdController = TextEditingController();
  final _obsController = TextEditingController();
  final _dtoController = TextEditingController();
  final _cantController = TextEditingController();
  String _scanProducto = '';

  Pedido pedido;

  @override
  void initState() {
    pedido = widget.pedido;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _gridProductos(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          totalesVenta(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          _datosNuevoProducto(context),
        ],
      ),
    );
  }

  Widget _gridProductos(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.58,
        width: double.infinity,
        child: DataTable(
            columnSpacing: size.width * 0.04,
            columns: [
              DataColumn(label: Text('CÓDIGO')),
              DataColumn(label: Text('CANT.')),
              DataColumn(label: Text('DESCRIPCIÓN')),
              DataColumn(label: Text('PRECIO'))
            ],
            rows: _rowsItems(context)) // cada fila un producto agregado,
        );
  }

  List<DataRow> _rowsItems(BuildContext context) {
    List<DataRow> lista = List<DataRow>.filled(0, null, growable: true);
    pedido?.items?.forEach((item) {
      var dataRow = DataRow(cells: [
        DataCell(Text(item.id.toString())),
        DataCell(Text('1')),
        DataCell(Text(item.producto.nombre)),
        DataCell(Text(
          '\$${item.precio.toStringAsFixed(2)}',
          textScaleFactor: MediaQuery.of(context).size.width * 0.003,
        )),
      ]);
      lista.add(dataRow);
    });

    return lista;
  }

  Widget _datosNuevoProducto(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        _codigoNombreProducto(context),
        SizedBox(
          height: size.height * 0.01,
        ),
        _obsDtoCant(context),
      ],
    );
  }

  Widget _codigoNombreProducto(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.04,
        ),
        _inputText('Cód.', _codController, null, TextInputType.number,
            height: size.height * 0.05, width: size.width * 0.145),
        SizedBox(
          width: size.width * 0.02,
        ),
        _buttonCodigoDeBarras(context),
        SizedBox(
          width: size.width * 0.02,
        ),
        _inputText('Nombre del producto', _nombreProdController, null,
            TextInputType.text,
            height: size.height * 0.05, width: size.width * 0.431),
        SizedBox(
          width: size.width * 0.02,
        ),
        _buttonBuscarProd(context),
      ],
    );
  }

  Widget _inputText(String s, TextEditingController controller, IconData icon,
      TextInputType inputType,
      {double height, double width}) {
    return Container(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLines: 1,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: icon == null ? null : Icon(icon),
            labelText: s,
            labelStyle:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
            alignLabelWithHint: true),
      ),
    );
  }

  Widget _obsDtoCant(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.04,
        ),
        _inputText('Observaciones', _obsController, null, TextInputType.text,
            height: size.height * 0.05, width: size.width * 0.55),
        SizedBox(
          width: size.width * 0.02,
        ),
        _inputText('Dto.', _dtoController, null, TextInputType.number,
            height: size.height * 0.05, width: size.width * 0.16),
        SizedBox(
          width: size.width * 0.02,
        ),
        _inputText('Cant.', _cantController, null, TextInputType.number,
            height: size.height * 0.05, width: size.width * 0.17),
      ],
    );
  }

  Widget _buttonCodigoDeBarras(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red, // background
          onPrimary: Colors.white, // foreground
          minimumSize: Size(size.width * 0.0005, size.height * 0.05)),
      child: Icon(MdiIcons.barcodeScan),
      onPressed: _leerCodigoBarras,
    );
  }

  Widget _buttonBuscarProd(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.red, // background
          onPrimary: Colors.white, // foreground
          minimumSize: Size(size.width * 0.0005, size.height * 0.05)),
      child: Icon(Icons.search),
      onPressed: () => _buscarProducto(context),
    );
  }

  void _leerCodigoBarras() async {
    await scanBarcodeNormal();

    if (_scanProducto != '') {
      setState(() {
        _codController.text = _scanProducto;
      });
    }
  }

  void _buscarProducto(BuildContext context) {
    Navigator.of(context).pushNamed(BuscadorProductoPage.route,
        arguments: _nombreProdController.text);
  }

  Future<void> scanBarcodeNormal() async {
    _scanProducto = '';
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes == '-1') return;
    _scanProducto = barcodeScanRes;
  }
}
