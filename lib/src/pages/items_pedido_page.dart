import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
import 'package:torres_y_liva/src/pages/buscador_producto_page.dart';

import '../widgets/base_widgets.dart';

// ignore: must_be_immutable
class ItemsPedidoPage extends StatefulWidget {
  static final String route = 'itemsPedido';

  static int cantChecked = 0;

  static Pedido pedido = Pedido(items: List<ItemPedido>.empty(growable: true));

  final Function() notifyParent;

  ItemsPedidoPage({this.notifyParent});

  @override
  _ItemsPedidoPageState createState() => _ItemsPedidoPageState();
}

class _ItemsPedidoPageState extends State<ItemsPedidoPage> {
  final _codController = TextEditingController();
  final _obsController = TextEditingController();
  final _dtoController = TextEditingController();
  final _cantController = TextEditingController();
  final _typeAheadController = TextEditingController();

  String _scanProducto = '';

  Producto _productoSelected;

  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<Producto>>();

  // @override
  // void initState() {
  //   pedido = widget.pedido;
  //   super.initState();
  // }

  @override
  void dispose() {
    ItemsPedidoPage.pedido.items.forEach((element) {
      element.checked = false;
    });
    ItemsPedidoPage.cantChecked = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _gridProductos(context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        totalesVenta(context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        _datosNuevoProducto(context),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
      ],
    );
  }

  Widget _gridProductos(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.55,
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
    ItemsPedidoPage.pedido?.items?.forEach((item) {
      var dataRow = DataRow(cells: [
        DataCell(Row(
            children: [_checkBox(context, item), Text(item.id.toString())])),
        DataCell(Text(item.cantidad.toString())),
        DataCell(Text(item.producto.descripcion)),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            child: _codigoNombreProducto(context), height: size.height * 0.08),
        SizedBox(
          height: size.height * 0.02,
        ),
        _obsDtoCant(context),
      ],
    );
  }

  Widget _codigoNombreProducto(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.03,
        ),
        _inputText('Cód.', _codController, null, TextInputType.number,
            height: size.height * 0.06, width: size.width * 0.18),
        SizedBox(
          width: size.width * 0.02,
        ),
        _buttonCodigoDeBarras(context),
        SizedBox(
          width: size.width * 0.02,
        ),
        _autoCompleteInput2(context),
        SizedBox(
          width: size.width * 0.02,
        ),
        _buttonBuscarProd(context),
        SizedBox(
          width: size.width * 0.03,
        ),
      ],
    );
  }

  Widget _autoCompleteInput2(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.1,
      width: size.width * 0.42,
      alignment: Alignment.center,
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
            controller: this._typeAheadController,
            decoration: InputDecoration(
              labelText: 'Producto',
              labelStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02),
              border: OutlineInputBorder(),
            )),
        suggestionsCallback: (input) {
          return Productos.getSuggestions(input);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.descripcion),
            subtitle: Text(suggestion.getInfoFormatted()),
          );
        },
        hideOnEmpty: true,
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            offsetX: -1 * size.width * 0.3,
            constraints: BoxConstraints(
                minHeight: size.height * 0.05, minWidth: size.width * 0.9)),
        autoFlipDirection: true,
        onSuggestionSelected: (suggestion) {
          _typeAheadController.text = suggestion.descripcion;
          _codController.text = suggestion.id.toString();
          _productoSelected = suggestion;

          //FOCUS A CANTIDAD

          setState(() {});
        },
        validator: (value) {},
        onSaved: (value) => {print(value)},
      ),
    );
  }

  Widget _autoCompleteInput({double height, double width}) {
    return Container(
        height: height,
        width: width,
        child: AutoCompleteTextField<Producto>(
          decoration: new InputDecoration(
              hintText: "", suffixIcon: new Icon(Icons.search)),
          itemSubmitted: (item) => setState(() => _productoSelected = item),
          key: key,
          suggestionsAmount: 10,
          suggestions: Productos.productos,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Container(
                  width: double.infinity, child: Text(suggestion.descripcion)),
            );
          },
          itemSorter: (a, b) {
            return a.descripcion.compareTo(b.descripcion);
          },
          itemFilter: (suggestion, input) {
            return suggestion.descripcion
                .toLowerCase()
                .contains(input.toLowerCase());
          },
        ));
  }

  Widget _inputText(String s, TextEditingController controller, IconData icon,
      TextInputType inputType,
      {double height, double width}) {
    return Expanded(
      child: Container(
        // height: height,
        // width: width,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          onSubmitted: (value) {
            if (controller == _codController) {
              _submittedCod(value);
            } else if (controller == _obsController) {
              _submittedObs();
            } else if (controller == _dtoController) {
              _submittedDto();
            } else if (controller == _cantController) {
              _submittedCant();
            }
          },
          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
          maxLines: 1,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: icon == null ? null : Icon(icon),
              labelText: s,
              labelStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02),
              alignLabelWithHint: true),
        ),
      ),
    );
  }

  Widget _obsDtoCant(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.03,
        ),
        _inputText('Observaciones', _obsController, null, TextInputType.text,
            height: size.height * 0.08, width: size.width * 0.55),
        SizedBox(
          width: size.width * 0.02,
        ),
        _inputText('Dto.', _dtoController, null, TextInputType.number,
            height: size.height * 0.08, width: size.width * 0.16),
        SizedBox(
          width: size.width * 0.02,
        ),
        _inputText('Cant.', _cantController, null, TextInputType.number,
            height: size.height * 0.08, width: size.width * 0.17),
        SizedBox(
          width: size.width * 0.03,
        ),
      ],
    );
  }

  Widget _buttonCodigoDeBarras(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // height: size.height * 0.15 * size.aspectRatio,
      // width: size.width * 0.13,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: IconButton(
          alignment: Alignment.center,
          color: Colors.white,
          onPressed: _leerCodigoBarras,
          icon: Icon(MdiIcons.barcodeScan)),
    );
  }

  Widget _buttonBuscarProd(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      // height: size.height * 0.1,
      // width: size.width * 0.13,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
          ),
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: IconButton(
          alignment: Alignment.center,
          color: Colors.white,
          onPressed: () => _buscarProducto(context),
          icon: Icon(Icons.search)),
    );

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
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

  Future<void> _buscarProducto(BuildContext context) async {
    final itemsNuevos = await Navigator.of(context).pushNamed(
        BuscadorProductoPage.route,
        arguments: [_typeAheadController.text, "-1", 'pedido']);

    if (itemsNuevos != null)
      setState(() {
        ItemsPedidoPage.pedido?.items?.addAll(itemsNuevos);
      });
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

  Widget _checkBox(BuildContext context, ItemPedido itemPedido) {
    //TODO test funcionamiento
    return Checkbox(
        value: itemPedido.checked,
        onChanged: (value) {
          setState(() {
            itemPedido.checked = value;

            ItemsPedidoPage.cantChecked += value == true ? 1 : -1;

            widget.notifyParent();
            setState(() {});
          });
        });
  }

  void _submittedCod(String value) {
    value = value.trim();
    int id = int.parse(value);

    if (id != null) {
      final producto = Productos.productos
          .firstWhere((element) => element.id == int.parse(value));

      _productoSelected = producto;

      if (_productoSelected != null) {
        //FOCUS A CANTIDAD

        setState(() {});
      } else {
        // SNACKBAR producto no encontrado
      }
    }
  }

  void _submittedObs() {
    //FOCUS DESCUENTO
  }

  void _submittedDto() {
    //FOCUS CANTIDAD
  }

  void _submittedCant() {
    // agregar producto
  }
}
