import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:torres_y_liva/src/models/cliente_model.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/utils/globals.dart';

import 'nuevo_pedido_page.dart';

// ignore: must_be_immutable
class DatosPedidoPage extends StatefulWidget {
  static final String route = 'datosPedido';

  @override
  _DatosPedidoPageState createState() => _DatosPedidoPageState();
}

class _DatosPedidoPageState extends State<DatosPedidoPage> {
  int selectedValueCliente = 0;
  String direccion;
  String telefono;
  String email;
  int _radioValueTipoVenta;
  // Pedido pedido;
  TextEditingController _comentariosController =
      TextEditingController(text: NuevoPedidoPage.pedido.observaciones);
  TextEditingController _descuentoController = TextEditingController(
      text: NuevoPedidoPage.pedido?.descuento?.toString() ?? '');
  TextEditingController _observacionesController =
      TextEditingController(text: NuevoPedidoPage.pedido.observaciones);

  final List<DropdownMenuItem<Cliente>> clientes = [];
  List<Cliente> clientesList = List<Cliente>.filled(0, null, growable: true);

  int idFormaPago;

  @override
  void initState() {
    // pedido = NuevoPedidoPage.pedido;

    selectedValueCliente = NuevoPedidoPage.pedido != null
        ? NuevoPedidoPage.pedido.cliente.clientId
        : 0;

    clientesList = clientesDelVendedor;

    clientesList.forEach((cliente) {
      clientes.add(
        DropdownMenuItem(
            child: ListTile(
              title: Text(cliente.clientId.toString() + ' - ' + cliente.nombre),
              subtitle: Text(cliente.domicilio),
            ),
            value: cliente),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: _inputDatosCompra(context),
          ),
        ));
  }

  List<Widget> _inputDatosCompra(BuildContext context) {
    return [
      _datosCliente(clientes, context),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      _tipoVenta(context),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      _inputsText(context),
      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      totalesVenta(context),
    ];
  }

  Widget _buscadorCliente(
      List<DropdownMenuItem<Cliente>> items, BuildContext c) {
    final size = MediaQuery.of(context).size;
    return SearchableDropdown.single(
      readOnly: !NuevoPedidoPage.nuevo,
      items: items,
      value: items
              .firstWhere(
                (element) => element?.value?.clientId == selectedValueCliente,
                orElse: () => null,
              )
              ?.value ??
          null,
      hint: "Selecciona un cliente",
      searchHint: "Busca un cliente",
      onChanged: (Cliente value) {
        setState(() {
          NuevoPedidoPage.clienteSeleccionado = value != null;
          idCliente = value.clientId ?? -1;
          selectedValueCliente = value?.clientId ?? -1;
          NuevoPedidoPage.pedido.cliente = value;
          direccion = value?.domicilio;
          telefono = value?.telefono;
          email = value?.email;
          switch (value.formaPago) {
            case 'CONTADO':
              idFormaPago = 0;
              break;
            case 'CUENTA CORRIENTE':
              idFormaPago = 1;
              break;
            case 'CHEQUE':
              idFormaPago = 2;
              break;
            default:
              idFormaPago = 3;
          }
          _radioValueTipoVenta = idFormaPago;
          NuevoPedidoPage.pedido.idFormaPago = _radioValueTipoVenta;
        });
      },
      onClear: () {
        setState(() {
          selectedValueCliente = 0;
        });
      },
      isExpanded: true,
      iconSize: size.width * 0.09,
      displayClearIcon: true,
    );
  }

  Widget _datosCliente(
      List<DropdownMenuItem<Cliente>> clientes, BuildContext context) {
    return Column(
      children: [
        _buscadorCliente(clientes, context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        _datos(context),
      ],
    );
  }

  Widget _datos(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (selectedValueCliente != null && selectedValueCliente > 0) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.house),
                SizedBox(
                  width: size.width * 0.05,
                ),
                AutoSizeText(
                  'Dir.: ${direccion == null ? '' : direccion}',
                  wrapWords: true,
                  softWrap: true,
                  minFontSize: (size.width * 0.04).roundToDouble(),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.001,
            ),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(
                  width: size.width * 0.05,
                ),
                AutoSizeText(
                  'Tel.: ${telefono == null ? '' : telefono}',
                  minFontSize: (size.width * 0.04).roundToDouble(),
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.001,
            ),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(
                  width: size.width * 0.05,
                ),
                AutoSizeText(
                  'Email: ${email == null ? '' : email}',
                  minFontSize: (size.width * 0.04).roundToDouble(),
                )
              ],
            ),
          ],
        ),
      );
    } else
      return Container();
  }

  Widget _tipoVenta(BuildContext context) {
    return Wrap(
      children: [
        _opcionRadio(context, 'Contado', 0),
        _opcionRadio(context, 'CC', 1),
        _opcionRadio(context, 'Cheque', 2),
        _opcionRadio(context, 'Otros', 3),
      ],
    );
  }

  Widget _opcionRadio(BuildContext context, String s, int i) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        new Radio(
          value: i,
          groupValue: _radioValueTipoVenta,
          onChanged: !NuevoPedidoPage.nuevo
              ? null
              : (value) {
                  setState(() {
                    _radioValueTipoVenta = value;

                    NuevoPedidoPage.pedido.idFormaPago = value;
                  });
                },
        ),
        new Text(
          s,
          style: new TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget _inputsText(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        _inputText('Comentarios', _comentariosController, Icons.comment,
            TextInputType.text, _onComentarioChange),
        SizedBox(
          height: size.height * 0.01,
        ),
        _inputText('Descuento General', _descuentoController, MdiIcons.sale,
            TextInputType.number, _onDescuentoChange),
        SizedBox(
          height: size.height * 0.01,
        ),
        _inputText('Observaciones', _observacionesController,
            MdiIcons.commentOutline, TextInputType.text, _onObsChange),
      ],
    );
  }

  Widget _columnaTotal(BuildContext context, String titulo, double importe) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(titulo),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          "\$ ${importe.toStringAsFixed(2)}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget totalesVenta(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _columnaTotal(context, 'NETO', NuevoPedidoPage.neto),
        _columnaTotal(context, 'IVA', NuevoPedidoPage.iva),
        _columnaTotal(context, 'TOTAL', NuevoPedidoPage.total),
      ],
    );
  }

  Widget _inputText(String s, TextEditingController controller, IconData icon,
      TextInputType inputType, Function _onInputChange) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: 1,
      onChanged: _onInputChange,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(icon),
        hintText: s,
      ),
    );
  }

  _onComentarioChange(String value) {
    NuevoPedidoPage.pedido.observaciones = value;
  }

  _onDescuentoChange(String value) {
    NuevoPedidoPage.pedido.descuento = double.tryParse(value);
  }

  _onObsChange(String value) {
    NuevoPedidoPage.pedido.observaciones = value;
  }
}
