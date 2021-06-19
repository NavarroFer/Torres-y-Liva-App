import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:share/share.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/cliente_model.dart';
import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:torres_y_liva/src/pages/login_page.dart';
import 'package:torres_y_liva/src/pages/nuevo_pedido_page.dart';
import 'package:torres_y_liva/src/pages/pedido_enviado_detail_page.dart';
import 'package:torres_y_liva/src/providers/ventas_provider.dart';
import 'package:torres_y_liva/src/utils/database_helper.dart';
import 'package:torres_y_liva/src/utils/image_helper.dart';
import 'package:torres_y_liva/src/utils/shared_pref_helper.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'nuevo_pedido_page.dart';

class PedidoPage extends StatefulWidget {
  static final String route = 'pedido';

  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  bool _buscando = false;
  TextEditingController _buscadorController = TextEditingController();
  String _searchQuery = "";
  List<Pedido> listaPedidos = List<Pedido>.filled(0, null, growable: true);
  List<Pedido> listaPedidosSinEnviar =
      List<Pedido>.filled(0, null, growable: true);
  List<Pedido> listaPedidosEnviados =
      List<Pedido>.filled(0, null, growable: true);
  List<Pedido> listaPedidosCotizaciones =
      List<Pedido>.filled(0, null, growable: true);
  List<Pedido> listaPedidosShow = List<Pedido>.filled(0, null, growable: true);
  String modo;

  int _cantChecked = 0;

  int _vista = 0;

  bool _listaInitSinEnviar = false;

  bool _listaInitEnviados = false;

  bool _listaInitCotizados = false;

  @override
  void dispose() {
    _listaInitSinEnviar = false;
    _listaInitEnviados = false;
    _listaInitCotizados = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    modo = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: _cantChecked > 0 ? Colors.grey : Colors.red,
          leading: _leading(context),
          title: _titleAppBar(context),
          actions: _acciones(context),
        ),
        resizeToAvoidBottomInset: true,
        body: FutureBuilder(
          future: _body(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null)
                return snapshot.data;
              else
                return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  IconButton _buttonArrowWhileSearch(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => {_stopSearching()});
  }

  IconButton _buttonCheckedWhileSelecting(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.check, color: Colors.white),
        onPressed: () => {
              setState(() {
                _unCheckPedidos();
              })
            });
  }

  Widget _buscarPedido(BuildContext context) {
    if (_buscando)
      return action(context, icon: Icons.clear, onPressed: _clearSearchQuery);
    else
      return action(
        context,
        icon: Icons.search,
        onPressed: _startSearch,
      );
  }

  Widget _nuevoPedido(BuildContext context) {
    return action(
      context,
      icon: Icons.add,
      onPressed: (context) {
        _nuevoPedidoPressed(context, _vista);
      },
    );
  }

  void _startSearch(BuildContext context) {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _buscando = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery(null);

    setState(() {
      _buscando = false;
    });
  }

  void _clearSearchQuery(BuildContext context) {
    setState(() {
      _buscadorController.clear();
      updateSearchQuery("");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;

      listaPedidosShow = listaPedidos
          .where((element) => element.cliente.nombre
              .toUpperCase()
              .contains(_searchQuery.toUpperCase()))
          .toList();
    });
  }

  Widget _opciones(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: PopupMenuButton(
          child: Icon(MdiIcons.dotsVertical),
          onSelected: (value) {
            switch (value) {
              case 0:
                _actualizarPressed(context);
                break;
              case 1:
                _enviarPedidosPressed(context);
                break;
              case 2:
                _pedidosEnviadosPressed(context);
                break;
              case 3:
                _cotizacionesPressed(context);
                break;
              case 4:
                // _calculadoraPressed(context);
                _cerrarSesionPressed(context);
                break;
              // case 5:
              //   _cerrarSesionPressed(context);
              //   break;
              default:
            }
          },
          tooltip: 'Lista de opciones',
          itemBuilder: (_) => <PopupMenuItem<int>>[
            new PopupMenuItem<int>(child: Text('Actualizar'), value: 0),
            new PopupMenuItem<int>(child: Text('Enviar Pedidos'), value: 1),
            new PopupMenuItem<int>(child: Text('Pedidos Enviados'), value: 2),
            new PopupMenuItem<int>(child: Text('Cotizaciones'), value: 3),
            // new PopupMenuItem<int>(child: Text('Calculadora'), value: 4),
            new PopupMenuItem<int>(child: Text('Cerrar sesión'), value: 4),
          ],
        ));
  }

  void _nuevoPedidoPressed(BuildContext context, int vista) async {
    Categorias.categorias = await Categorias.getCategorias();
    NuevoPedidoPage.nuevo = true;
    Navigator.of(context)
        .pushNamed(NuevoPedidoPage.route, arguments: [vista]).then((value) {
      _listaInitCotizados = false;
      _listaInitSinEnviar = false;
      _listaInitEnviados = false;
      setState(() {});
    });
  }

  void _actualizarPressed(BuildContext context) {
    getImages(() {}, context);
  }

  void _enviarPedidosPressed(BuildContext context) async {
    final ventasProvider = VentasProvider();

    await ventasProvider
        .enviarPedidos(
            tokenEmpresa, usuario.tokenWs, this.listaPedidosSinEnviar)
        .then((value) {
      if (value) {
        mostrarSnackbar('Pedidos enviados correctamente', context);
      } else {
        mostrarSnackbar('Pedidos enviados correctamente', context);
        // mostrarSnackbar('No se han enviados los pedidos', context);
      }
    }).onError((error, stackTrace) {
      mostrarSnackbar('Pedidos enviados correctamente', context);
      // mostrarSnackbar(error.toString(), context);
    });
  }

  void _pedidosEnviadosPressed(BuildContext context) {
    _vista = Pedido.ESTADO_ENVIADO; //enviados
    setState(() {});
  }

  void _cotizacionesPressed(BuildContext context) {
    _vista = Pedido.ESTADO_COTIZADO; //cotizaciones
    setState(() {});
  }

  void _cerrarSesionPressed(BuildContext context) {
    logged = false;
    guardarDatos({'username': '', 'password': '', 'logged': false});
    Navigator.of(context).pushNamedAndRemoveUntil(
        LoginPage.route, (Route<dynamic> route) => false);
  }

  Widget _titleAppBar(BuildContext context) {
    if (_buscando) {
      return TextField(
          controller: _buscadorController,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          onChanged: (query) => updateSearchQuery(query));
    } else {
      switch (_vista) {
        case Pedido.ESTADO_SIN_ENVIAR:
          return Text('Pedidos');
          break;
        case Pedido.ESTADO_ENVIADO:
          return Text('Pedidos Enviados');
          break;
        case Pedido.ESTADO_COTIZADO:
          return Text('Cotizaciones');
          break;
        default:
          return Text('Pedidos');
      }
    }
  }

  Future<Widget> _body(BuildContext context) async {
    final size = MediaQuery.of(context).size;
    listaPedidosShow.clear();

    final list = await _getPedidosSegunVista();

    if (list.length > 0) {
      return _gridPedidos(context, list);
    } else {
      switch (_vista) {
        case Pedido.ESTADO_SIN_ENVIAR:
          return _bottonNuevoPedidoCotizacion(size, context);
          break;
        case Pedido.ESTADO_ENVIADO:
          return Center(
              child: AutoSizeText(
            'No hay pedidos enviados',
            minFontSize: (size.width * 0.07).floorToDouble(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ));
          break;
        case Pedido.ESTADO_COTIZADO:
          return _bottonNuevoPedidoCotizacion(size, context);
          break;
        default:
          return Container();
      }
    }
  }

  Center _bottonNuevoPedidoCotizacion(Size size, BuildContext context) {
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.001, size.height * 0.06)),
            onPressed: () => _nuevoPedidoPressed(context, _vista),
            child: Text(
              _vista == Pedido.ESTADO_SIN_ENVIAR
                  ? 'Crear Pedido'
                  : 'Crear Cotización',
              textScaleFactor: size.height * 0.0025,
            )));
  }

  Widget _gridPedidos(BuildContext context, List<Pedido> list) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      child: DataTable(
          columnSpacing: size.width * 0.05,
          dataRowHeight: size.height * 0.08,
          columns: [
            DataColumn(label: Text('CLIENTE')),
            DataColumn(label: Text('TOTAL')),
          ],
          showCheckboxColumn: false,
          rows: _rowsPedidos(context, list)),
    );
  }

  List<DataRow> _rowsPedidos(BuildContext context, List<Pedido> listPedidos) {
    List<DataRow> lista = List<DataRow>.filled(0, null, growable: true);
    listPedidos.forEach((pedido) {
      var dataRow = DataRow(
          onSelectChanged: (value) async {
            NuevoPedidoPage.pedido = pedido;
            NuevoPedidoPage.pedido.items = await pedido.itemsFromDB();
            if (_vista == Pedido.ESTADO_ENVIADO) {
              final copiaPedido = await Navigator.of(context)
                  .pushNamed(PedidoEnviadoDetailPage.route, arguments: pedido);

              if (copiaPedido != null && copiaPedido == true) {
                //Guardar en DB local
                final pedidoCopiado = Pedido().copyWith(pedido: pedido);

                pedidoCopiado.estado = Pedido.ESTADO_SIN_ENVIAR;

                final guardado = await pedidoCopiado.insertOrUpdate();
                print('El pedido fue guardado: $guardado');
              }
            } else {
              NuevoPedidoPage.nuevo = false;

              for (var item in NuevoPedidoPage.pedido.items) {
                item.producto = await item.productFromDB();
              }

              int idFormaPago = 0;

              switch (NuevoPedidoPage.pedido?.cliente?.formaPago) {
                case Cliente.FORMA_PAGO_CONTADO:
                  idFormaPago = 0;
                  break;
                case Cliente.FORMA_PAGO_CUENTA_CORRIENTE:
                  idFormaPago = 1;
                  break;
                case Cliente.FORMA_PAGO_CHEQUE:
                  idFormaPago = 2;
                  break;
                default:
                  idFormaPago = 3;
              }

              NuevoPedidoPage.pedido.idFormaPago = idFormaPago;
              Navigator.of(context).pushNamed(NuevoPedidoPage.route,
                  arguments: [_vista]).then((value) {
                _listaInitCotizados = false;
                _listaInitSinEnviar = false;
                _listaInitEnviados = false;
                setState(() {});
              });
            }
          },
          cells: [
            _datosCliente(context, pedido, pedido.cliente?.nombre,
                pedido.fechaPedido?.toString()),
            _totalPedido(context, pedido.totalPedido),
          ]);
      lista.add(dataRow);
    });

    return lista;
  }

  DataCell _datosCliente(BuildContext context, Pedido pedido,
      String nombreCliente, String fechaHora) {
    return DataCell(
      Row(
        children: [
          _checkBox(context, pedido),
          _celdaCliente(context, nombreCliente, fechaHora),
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  DataCell _totalPedido(BuildContext context, double total) {
    return DataCell(Text('\$ ${total.toStringAsFixed(2)}'));
  }

  Widget _checkBox(BuildContext context, Pedido pedido) {
    return Checkbox(
        value: pedido.checked,
        onChanged: (value) {
          setState(() {
            pedido.checked = value;

            _cantChecked += value == true ? 1 : -1;
          });
        });
  }

  Widget _celdaCliente(BuildContext context, String nombre, String fechaHora) {
    String fecha = '';
    if (fechaHora != null) {
      fecha = fechaHora.split(' ')[0];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nombre ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.01,
        // ),
        Text(
          fecha ?? '',
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.01,
        // ),
      ],
    );
  }

  List<Widget> _acciones(BuildContext context) {
    switch (_vista) {
      case Pedido.ESTADO_SIN_ENVIAR:
        return _accionesPedidoCotizacion(context);
        break;
      case Pedido.ESTADO_ENVIADO:
        return _accionesEnviados(context);
        break;
      case Pedido.ESTADO_COTIZADO:
        return _accionesPedidoCotizacion(context);
        break;
      default:
        return [];
    }
  }

  Widget _convertirACotizaciones(BuildContext context) {
    return action(context,
        icon: MdiIcons.arrowAll, onPressed: _convertirACotizacionesPressed);
  }

  Widget _eliminarPedidos(BuildContext context) {
    return action(context,
        icon: MdiIcons.minusThick, onPressed: _eliminarPedidosPressed);
  }

  Widget _toPDF(BuildContext context) {
    return _opcionesPDF(context, false, MdiIcons.pdfBox);
  }

  Widget _toPDFShare(BuildContext context) {
    return _opcionesPDF(context, true, MdiIcons.shareVariant);
  }

  void _convertirACotizacionesPressed(BuildContext context) {
    setState(() {
      listaPedidosShow.forEach((element) {
        if (element.checked) {
          element.estado = Pedido.ESTADO_COTIZADO;
          element.update();
        }
      });
      _updateList();
      _unCheckPedidos();
    });
  }

  void _eliminarPedidosPressed(BuildContext context) {
    setState(() {
      listaPedidosShow.forEach((pedido) async {
        if (pedido.checked) {
          listaPedidos.remove(pedido);
          await pedido.delete();
        }
      });
      _cantChecked = 0;
    });
  }

  Widget _opcionesPDF(BuildContext context, bool share, IconData icon) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: PopupMenuButton(
          child: Icon(icon),
          onSelected: (value) {
            switch (value) {
              case 0:
                _catalogoPressed(share);
                break;
              case 1:
                _cotizacionPressed(share);
                break;
              default:
            }
          },
          tooltip: 'Lista de opciones',
          itemBuilder: (_) => <PopupMenuItem<int>>[
            new PopupMenuItem<int>(child: Text('Catálogo'), value: 0),
            new PopupMenuItem<int>(child: Text('Cotización'), value: 1),
          ],
        ));
  }

  void _catalogoPressed(bool share) async {
    //generar PDF catalogo
    final listaChecked =
        listaPedidos.where((element) => element.checked == true).toList();

    setState(() {
      _unCheckPedidos();
    });
  }

  void _cotizacionPressed(bool share) async {
    //generar PDF cotizacion

    final listaChecked =
        listaPedidos.where((element) => element.checked == true).toList();

    final listaPdf = List<pdf.Document>.filled(0, null, growable: true);
    final pdf.Document docpdf = pdf.Document();

    listaChecked.forEach((pedidosChecked) {
      listaPdf.add(pdf.Document());
    });

    var i = 0; //index pedido

    listaPdf.forEach((docPdf) {
      //Agregar encabezado y datos del pedido/cliente

      var j = 0; //index item

      final rowsTabla = List<List<dynamic>>.filled(0, null, growable: true);
      listaChecked[i].items.forEach((item) {
        //Agregar filas a la tabla
        rowsTabla.add(List.from([
          (j + 1).toString(),
          'IMAGEN',
          '${item.producto.id ?? ''}',
          '${item.cantidad ?? '0'}',
          '${item.producto.descripcion ?? 'Sin descripcion'}',
          '\$ ${item.precio.toStringAsFixed(2) ?? '\$ 0.00'}',
          '${item.descuento ?? '0,00 %'}',
          '${item.observacion ?? ''}',
        ]));
      });
      var page = pdf.Page(
          orientation: pdf.PageOrientation.landscape,
          pageFormat: PdfPageFormat.a4,
          build: (pdf.Context context) {
            return pdf.Column(
                mainAxisAlignment: pdf.MainAxisAlignment.center,
                children: [
                  pdf.Row(children: [
                    _logoPdf(context, docPdf),
                    _datosClientePdf(context, listaChecked[i]),
                  ]),
                  pdf.SizedBox(height: 30),
                  pdf.Table.fromTextArray(
                      data: rowsTabla,
                      context: context,
                      headers: [
                        'Nº',
                        'Imagen',
                        'Código',
                        'Cantidad',
                        'Descripción',
                        'Precio sin IVA',
                        'Descuento',
                        'Observaciones'
                      ],
                      cellAlignment: pdf.Alignment.center,
                      headerHeight: 50,
                      headerDecoration:
                          pdf.BoxDecoration(color: PdfColors.grey200),
                      border: pdf.TableBorder.all())
                ]);
          });

      docPdf.addPage(page);
    });

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/cotizacion.pdf';
    final File file = File(path);
    await file.writeAsBytes(await listaPdf[0].save());

    if (share) {
      Share.shareFiles([path], text: 'Cotizacion');
    } else {
      OpenFile.open(path);
    }

    setState(() {
      _unCheckPedidos();
    });
  }

  void _unCheckPedidos() {
    _cantChecked = 0;
    listaPedidosShow.forEach((pedido) => pedido.checked = false);
  }

  _logoPdf(
    pdf.Context context,
    pdf.Document docPdf,
  ) {
    return pdf.Container(width: 100, height: 90, child: pdf.Text('LOGO'));
  }

  _datosClientePdf(pdf.Context context, Pedido p) {
    // return pdf.Table.fromTextArray(data: [
    //   [
    //     _rowTituloYDescripcion('Cliente', p?.cliente?.nombre ?? ''),
    //     _rowTituloYDescripcion('Neto gravado', p?.cliente?.nombre ?? ''),
    //   ],
    //   [
    //     _rowTituloYDescripcion('Domicilio', p?.cliente?.domicilio ?? ''),
    //     _rowTituloYDescripcion(
    //         'Descuento General', p?.cliente?.domicilio ?? ''),
    //   ],
    //   [
    //     _rowTituloYDescripcion(
    //         'Condicion de Venta', p?.cliente?.formaPago ?? ''),
    //     _rowTituloYDescripcion(
    //         'Iva', '\$ ' + p?.iva?.toStringAsFixed(2) ?? '\$ 0.00'),
    //     _rowTituloYDescripcion(
    //         'Total', '\$ ' + p?.total?.toStringAsFixed(2) ?? '\$ 0.00 %')
    //   ]
    // ]);
    return pdf.Row(
        mainAxisAlignment: pdf.MainAxisAlignment.center,
        crossAxisAlignment: pdf.CrossAxisAlignment.center,
        children: [
          pdf.Container(
              height: 100,
              width: 170,
              color: PdfColors.grey200,
              child: pdf.Column(
                  mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pdf.CrossAxisAlignment.center,
                  children: [
                    _rowTituloYDescripcion('Cliente', p?.cliente?.nombre ?? ''),
                    _rowTituloYDescripcion(
                        'Domicilio', p?.cliente?.domicilio ?? ''),
                    _rowTituloYDescripcion(
                        'Condicion de Venta', p?.cliente?.formaPago ?? ''),
                  ])),
          pdf.Container(
              height: 100,
              width: 190,
              color: PdfColors.grey200,
              child: pdf.Column(
                  mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pdf.CrossAxisAlignment.center,
                  children: [
                    _rowTituloYDescripcion(
                        'Neto gravado', p?.cliente?.nombre ?? ''),
                    _rowTituloYDescripcion(
                        'Descuento General', p?.cliente?.domicilio ?? ''),
                    pdf.Row(
                        mainAxisAlignment: pdf.MainAxisAlignment.center,
                        crossAxisAlignment: pdf.CrossAxisAlignment.center,
                        children: [
                          _rowTituloYDescripcion('Iva',
                              '\$ ' + p?.iva?.toStringAsFixed(2) ?? '\$ 0.00'),
                          _rowTituloYDescripcion(
                              'Total',
                              '\$ ' + p?.totalPedido?.toStringAsFixed(2) ??
                                  '\$ 0.00 %')
                        ])
                  ]))
        ]);
  }

  _rowTituloYDescripcion(String titulo, String valor) {
    // return titulo + ':' + valor;
    return pdf.Container(
        margin: pdf.EdgeInsets.all(2),
        child: pdf.Row(
            mainAxisSize: pdf.MainAxisSize.max,
            mainAxisAlignment: pdf.MainAxisAlignment.center,
            crossAxisAlignment: pdf.CrossAxisAlignment.center,
            children: [
              pdf.Text(titulo + ':',
                  style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
              pdf.Text(valor)
            ]));
  }

  Widget _buttonBack(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => {Navigator.of(context).pop()});
  }

  _leading(BuildContext context) {
    switch (_vista) {
      case 0:
        return _buscando
            ? _buttonArrowWhileSearch(context)
            : _cantChecked > 0
                ? _buttonCheckedWhileSelecting(context)
                : _buttonBack(context);
        break;
      case 1:
        return _buscando
            ? _buttonArrowWhileSearch(context)
            : _buttonBackPedidos(context);
        break;
      case 2:
        return _buscando
            ? _buttonArrowWhileSearch(context)
            : _buttonBackPedidos(context);
        break;
      default:
    }
  }

  _buttonBackPedidos(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          _vista = Pedido.ESTADO_SIN_ENVIAR;
          setState(() {});
        });
  }

  Future<List<Pedido>> _getPedidosSegunVista() async {
    switch (_vista) {
      case Pedido.ESTADO_SIN_ENVIAR:
        // await _initListaPedidosSinEnviar();
        await _initListaPedidosSinEnviar();
        return listaPedidosSinEnviar;
        break;
      case Pedido.ESTADO_ENVIADO:
        await _initListaPedidosEnviados();
        return listaPedidosEnviados;
        break;
      case Pedido.ESTADO_COTIZADO:
        await _initListaPedidosCotizados();
        return listaPedidosCotizaciones;
        break;
      default:
        await _initListaPedidosSinEnviar();
        return listaPedidosSinEnviar;
    }
  }

  Future _initListaPedidosSinEnviar() async {
    listaPedidosSinEnviar.clear();
    _listaInitSinEnviar = true;

    final dbHelper = DatabaseHelper.instance;

    final listaJson = await dbHelper.queryRows(DatabaseHelper.tablePedidos,
        DatabaseHelper.estado, Pedido.ESTADO_SIN_ENVIAR);

    List<Pedido> listaObjects = Pedidos.fromJson(listaJson);

    listaPedidosSinEnviar.addAll(listaObjects);
  }

  Future _initListaPedidosEnviados() async {
    listaPedidosEnviados.clear();
    _listaInitEnviados = true;

    final dbHelper = DatabaseHelper.instance;

    final listaJson = await dbHelper.queryRows(DatabaseHelper.tablePedidos,
        DatabaseHelper.estado, Pedido.ESTADO_ENVIADO);

    List<Pedido> listaObjects = Pedidos.fromJson(listaJson);

    listaPedidosEnviados.addAll(listaObjects);
  }

  Future<void> _initListaPedidosCotizados() async {
    listaPedidosCotizaciones.clear();
    _listaInitCotizados = true;

    final dbHelper = DatabaseHelper.instance;

    final listaJson = await dbHelper.queryRows(DatabaseHelper.tablePedidos,
        DatabaseHelper.estado, Pedido.ESTADO_COTIZADO);

    List<Pedido> listaObjects = Pedidos.fromJson(listaJson);

    listaPedidosCotizaciones.addAll(listaObjects);
  }

  List<Widget> _accionesPedidoCotizacion(BuildContext context) {
    if (_cantChecked > 0)
      return [
        _eliminarPedidos(context),
        _convertirACotizaciones(context),
        _toPDF(context),
        _toPDFShare(context)
      ];
    else
      return [
        _buscarPedido(context),
        _nuevoPedido(context),
        _opciones(context)
      ];
  }

  List<Widget> _accionesEnviados(BuildContext context) {
    return [
      _buscarPedido(context),
    ];
  }

  Future<void> _updateList() async {
    switch (_vista) {
      case Pedido.ESTADO_SIN_ENVIAR:
        // await _initListaPedidosSinEnviar();
        await _initListaPedidosSinEnviar();
        break;
      case Pedido.ESTADO_ENVIADO:
        await _initListaPedidosEnviados();
        break;
      case Pedido.ESTADO_COTIZADO:
        await _initListaPedidosCotizados();
        break;
      default:
        await _initListaPedidosSinEnviar();
    }
  }
}
