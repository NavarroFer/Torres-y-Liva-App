import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/models/cliente_model.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';
import 'package:torres_y_liva/src/pages/datos_pedido_page.dart';
import 'package:torres_y_liva/src/pages/items_pedido_page.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';
import 'package:torres_y_liva/src/widgets/dialog_box_widget.dart';

class NuevoPedidoPage extends StatefulWidget {
  static final String route = 'nuevoPedido';
  static bool clienteSeleccionado = false;

  static double neto = 0, iva = 0, total = 0;

  static Pedido pedido = Pedido(
      totalPedido: 0,
      neto: 0,
      iva: 0,
      checked: false,
      descuento: 0,
      observaciones: '',
      clienteID: 0,
      cliente: Cliente(),
      items: List<ItemPedido>.empty(growable: true));

  static bool nuevo;

  @override
  _NuevoPedidoPageState createState() => _NuevoPedidoPageState();
}

class _NuevoPedidoPageState extends State<NuevoPedidoPage>
    with TickerProviderStateMixin {
  MaterialColor color = Colors.red;

  List<Widget> acciones;

  List<Object> arguments;

  int vista;

  @override
  void dispose() {
    NuevoPedidoPage.pedido = Pedido(
        totalPedido: 0,
        neto: 0,
        iva: 0,
        checked: false,
        descuento: 0,
        observaciones: '',
        clienteID: 0,
        cliente: Cliente(),
        items: List<ItemPedido>.empty(growable: true));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    vista = arguments[0];

    var tab = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    void _handleTabSelection() {
      setState(() {
        tab.animateTo(2);
      });
    }

    tab.addListener(_handleTabSelection);

    // tab.addListener(_handleTabSelection);
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: vista == 2 ? Text('Cotizacion') : Text('Pedido'),
            backgroundColor: color,
            leading: _botonAtras(context),
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
            // controller: tab,
            physics: NuevoPedidoPage.clienteSeleccionado
                ? AlwaysScrollableScrollPhysics()
                : NeverScrollableScrollPhysics(),
            children: [
              DatosPedidoPage(),
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

  // Widget _abrirCalculadora(BuildContext context) {
  //   return action(context,
  //       size: MediaQuery.of(context).size.width * 0.07,
  //       icon: MdiIcons.calculator,
  //       onPressed: _calculatorPressed);
  // }

  Widget _buscarProductosCliente(BuildContext context) {
    return action(context,
        icon: Icons.search, onPressed: _buscarProductosPressed);
  }

  Widget _guardarPedido(BuildContext context) {
    return action(context,
        icon: Icons.save_rounded, onPressed: _guardarPedidoPressed);
  }

  // void _calculatorPressed(BuildContext context) {
  //   Navigator.pushNamed(context, CalculatorPage.route);
  // }

  void _buscarProductosPressed(BuildContext cotext) {}

  void _guardarPedidoPressed(BuildContext context) async {
    if (NuevoPedidoPage.pedido.cliente.clientId == null) {
      showError('No se ha seleccionado un cliente', context);
    } else if (NuevoPedidoPage.pedido.items.isEmpty) {
      showError('No se han agregado items', context);
    } else {
      int idNuevoPedido;
      if (NuevoPedidoPage.nuevo) {
        idNuevoPedido = await Pedido.getNextId();

        NuevoPedidoPage.pedido.id = idNuevoPedido;
      } else {
        idNuevoPedido = NuevoPedidoPage.pedido.id;
      }

      //Asociamos los items con el pedido
      NuevoPedidoPage.pedido.items.forEach((element) {
        element.pedidoID = idNuevoPedido;
      });
      NuevoPedidoPage.pedido.fechaPedido = DateTime.now();
      NuevoPedidoPage.pedido.estado = vista;
      // NuevoPedidoPage.pedido.estado = Pedido.ESTADO_ENVIADO;

      await NuevoPedidoPage.pedido.insertOrUpdate();

      NuevoPedidoPage.pedido = Pedido(
          totalPedido: 0,
          neto: 0,
          iva: 0,
          checked: false,
          descuento: 0,
          observaciones: '',
          clienteID: 0,
          cliente: Cliente(),
          items: List<ItemPedido>.empty(growable: true));

      Navigator.pop(context);
    }
  }

  _acciones(BuildContext context) {
    return [
      _buscarProductosCliente(context),
      // _abrirCalculadora(context),
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
    NuevoPedidoPage.pedido?.items?.removeWhere((element) => element?.checked);
    setState(() {});
  }

  void showError(String s, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Error',
            descriptions: s ?? '',
            textBtn1: "Aceptar",
            icon: Icons.warning,
            alert: true,
          );
        });
  }

  _botonAtras(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (NuevoPedidoPage.pedido?.cliente.clientId != null ||
              NuevoPedidoPage.pedido?.items?.isNotEmpty) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: 'No ha guardado los datos',
                    descriptions: '¿Desea salir sin guardar?',
                    textBtn1: "Si",
                    textBtn2: "No",
                    icon: Icons.warning,
                    alert: true,
                  );
                }).then((value) {
              if (value == true) {
                Navigator.of(context).pop();
              }
            });
          } else
            Navigator.of(context).pop();
        });
  }
}
