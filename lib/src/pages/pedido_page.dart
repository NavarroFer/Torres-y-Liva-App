import 'dart:developer';
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

  var numeroFila = 0;

  int cantFilas;

  @override
  void dispose() {
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
      setState(() {});
    });
  }

  void _actualizarPressed(BuildContext context) {
    getImages(() {}, context);
  }

  void _enviarPedidosPressed(BuildContext context) async {
    final ventasProvider = VentasProvider();

    List<Pedido> listaPedidosSinEnviarConItems =
        List<Pedido>.empty(growable: true);

    for (Pedido ped in listaPedidosSinEnviar) {
      final items = await ped.itemsFromDB();
      ped.items = items;
      listaPedidosSinEnviarConItems.add(ped);
    }
    log('cantidad a enviar ${listaPedidosSinEnviarConItems.length}');
    await ventasProvider
        .enviarPedidos(
            tokenEmpresa, usuario.tokenWs, listaPedidosSinEnviarConItems)
        .then((value) async {
      if (value) {
        mostrarSnackbar('Pedidos enviados correctamente', context);
        await _initListaPedidosSinEnviar();
        setState(() {});
      } else {
        mostrarSnackbar('Pedidos no enviados, intente nuevamente', context);
        // mostrarSnackbar('No se han enviados los pedidos', context);
      }
    }).onError((error, stackTrace) {
      print(error);
      mostrarSnackbar('Pedidos no enviados, intente nuevamente', context);
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

    return FutureBuilder(
      future: _getPedidosSegunVista(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _gridPedidos(context, snapshot.data);
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
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
                final pedidoCopiado = await Pedido().copyWith(pedido: pedido);

                log('copiado: ${pedidoCopiado}');
                log('pedido viejo: ${pedido}');

                pedidoCopiado.estado = Pedido.ESTADO_SIN_ENVIAR;

                log('copiado: ${pedidoCopiado}');
                log('pedido viejo: ${pedido}');

                final guardado = await pedidoCopiado.insertOrUpdate();
                print('El pedido fue guardado: $guardado');

                await _updateList();

                setState(() {});
              }
            } else {
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
              NuevoPedidoPage.nuevo = false;
              Navigator.of(context).pushNamed(NuevoPedidoPage.route,
                  arguments: [_vista]).then((value) {
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
          _vista == Pedido.ESTADO_ENVIADO
              ? Container()
              : _checkBox(context, pedido),
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
        icon: MdiIcons.arrowAll, onPressed: _convertirPressed);
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

  void _convertirPressed(BuildContext context) async {
    for (var element in _vista == Pedido.ESTADO_COTIZADO
        ? listaPedidosCotizaciones
        : listaPedidosSinEnviar) {
      if (element.checked) {
        element.estado = _vista == Pedido.ESTADO_COTIZADO
            ? Pedido.ESTADO_SIN_ENVIAR
            : Pedido.ESTADO_COTIZADO;
        print(await element.updateState(_vista == Pedido.ESTADO_COTIZADO
            ? Pedido.ESTADO_SIN_ENVIAR
            : Pedido.ESTADO_COTIZADO));
      }
    }

    await _updateList();
    _unCheckPedidos();
    setState(() {});
  }

  void _eliminarPedidosPressed(BuildContext context) {
    List<Pedido> list;
    if (_vista == Pedido.ESTADO_SIN_ENVIAR) {
      list = listaPedidosSinEnviar;
    } else {
      list = listaPedidosCotizaciones;
    }
    list.forEach((pedido) async {
      if (pedido.checked) {
        log('Eliminado sss: ${pedido.id}');

        final eliminado = await pedido.delete();
        log('Eliminado: $eliminado');
        if (eliminado) {
          switch (_vista) {
            case Pedido.ESTADO_SIN_ENVIAR:
              listaPedidosSinEnviar.remove(pedido);
              break;
            case Pedido.ESTADO_COTIZADO:
              listaPedidosCotizaciones.remove(pedido);
              break;
          }
        }
      }
    });
    _cantChecked = 0;
    setState(() {});
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

  _claveValor(String s, String t) {
    return pdf.Row(children: [
      pdf.Container(
          width: 75,
          child: pdf.Text(s,
              textScaleFactor: 1.2,
              style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold))),
      pdf.Container(
          width: 110,
          child: pdf.Text(
            t,
            textScaleFactor: 1.2,
          )),
    ]);
  }

  void _catalogoPressed(bool share) async {
    //generar PDF catalogo
    final listaChecked = listaPedidosSinEnviar
        .where((element) => element.checked == true)
        .toList();

    final pedido = listaChecked[0];

    List<Pedido> listaPedidosSinEnviarConItems =
        List<Pedido>.empty(growable: true);

    final items = await pedido.itemsFromDB();
    pedido.items = items;
    listaPedidosSinEnviarConItems.add(pedido);

    print(pedido);

    List<pdf.Widget> listaRows = List<pdf.Widget>.empty(growable: true);

    pdf.Widget img;
    img = await getImageLogoPdf();

    DateTime ahora = DateTime.now();
    String hoy = ahora.day.toString().padLeft(2, '0') +
        '-' +
        ahora.month.toString().padLeft(2, '0') +
        '-' +
        ahora.year.toString();

    final datos = pdf.Column(children: [
      _claveValor('Fecha: ', hoy),
    ]);

    listaRows.add(pdf.Row(children: [datos, img]));

    //Recorre los items del pedido
    for (var i = 0; i < pedido.items.length; i++) {
      if (i % 2 == 0) {
        final String dir = (await getExternalStorageDirectory()).path;
        pdf.MemoryImage image;

        //ITEM 1
        String path =
            '$dir/Pictures/products/${pedido.items[i].productoID}.jpg';
        pdf.Widget img1;
        try {
          image = pdf.MemoryImage(
            File(path).readAsBytesSync(),
          );
          img1 = pdf.Image(image, fit: pdf.BoxFit.fitHeight, width: 260); //45
        } catch (e) {
          img1 = pdf.Container(width: 260);
          print(e.toString());
        }
        final item1 = pdf.Column(children: [
          pdf.Container(height: 20),
          pdf.Container(height: 170, child: img1),
          _descripcionItemPdf(pedido.items[i]),
        ]);
        ///////

        //ITEM 2
        pdf.Widget item2;
        if (i + 1 < pedido.items.length) {
          path = '$dir/Pictures/products/${pedido.items[i + 1].productoID}.jpg';
          pdf.Widget img2;
          try {
            image = pdf.MemoryImage(
              File(path).readAsBytesSync(),
            );

            img2 = pdf.Image(image, fit: pdf.BoxFit.fitHeight, width: 260); //45
          } catch (e) {
            img2 = pdf.Container(width: 260);
          }

          item2 = pdf.Column(children: [
            pdf.Container(height: 20),
            pdf.Container(height: 170, child: img2),
            _descripcionItemPdf(pedido.items[i + 1]),
          ]);
        }
        ////////

        pdf.Row rowCatalogo;
        if (i + 1 < pedido.items.length) {
          rowCatalogo = pdf.Row(
              children: [
                pdf.Container(child: item1, color: PdfColors.grey100),
                pdf.Container(child: item2, color: PdfColors.grey100),
              ],
              crossAxisAlignment: pdf.CrossAxisAlignment.center,
              mainAxisAlignment: pdf.MainAxisAlignment.center);
        } else {
          rowCatalogo = pdf.Row(
              children: [pdf.Container(child: item1, color: PdfColors.grey100)],
              crossAxisAlignment: pdf.CrossAxisAlignment.center,
              mainAxisAlignment: pdf.MainAxisAlignment.center);
        }
        listaRows.add(rowCatalogo);
      }
    }

    var multipage = pdf.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pdf.PageOrientation.natural,
      maxPages: 20,
      build: (context) {
        return listaRows;
      },
      header: (context) {
        return pdf.Center(
            child: pdf.Text(
          'Catalogo | Torres y Liva',
        ));
      },
      footer: (context) {
        return pdf.Center(
            child: pdf.Text(
          'Página ${context.pageNumber} de ${context.pagesCount}',
        ));
      },
    );

    final pdf.Document docpdf = pdf.Document();

    docpdf.addPage(multipage);

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/catalogo_${DateTime.now()}.pdf';
    final File file = File(path);
    await file.writeAsBytes(await docpdf.save());

    if (share) {
      Share.shareFiles([path], text: 'Catalogo');
    } else {
      OpenFile.open(path);
    }

    setState(() {
      _unCheckPedidos();
    });
  }

  void _cotizacionPressed(bool share) async {
    final pdf.Document docpdf = pdf.Document();

    List<List<pdf.Widget>> rows = List<List<pdf.Widget>>.empty(growable: true);

    int nroPage = 0;
    int totalProd = 0;

    final listaChecked = listaPedidosSinEnviar
        .where((element) => element.checked == true)
        .toList();

    final pedido = listaChecked[0];
    pedido.items = await pedido.itemsFromDB();
    rows.add(List<pdf.Widget>.empty(growable: true));
    print(pedido.items.length);
    int i = 0;
    while (totalProd < pedido.items.length) {
      // j++;
      cantFilas = 11;

      if (nroPage > 1) {
        cantFilas = 15;
      }
      if ((i % cantFilas) > 0) {
        totalProd++;
        numeroFila = 0;
      }

      if (i % cantFilas == 0) {
        nroPage++;
        print('I: $i');
        print('Cant Filas: $cantFilas');
        rows.add(List<pdf.Widget>.empty(growable: true));
        numeroFila = 0;
      } else {
        final String dir = (await getExternalStorageDirectory()).path;
        final String path =
            '$dir/Pictures/products/${pedido.items[totalProd - 1].productoID}.jpg';
        pdf.MemoryImage image;
        pdf.Widget img;
        try {
          image = pdf.MemoryImage(
            File(path).readAsBytesSync(),
          );

          img = pdf.Image(image, fit: pdf.BoxFit.fitHeight, width: 60); //45
        } catch (e) {
          img = pdf.Container();
        }

        rows[nroPage].add(pdf.Container(
            width: 483,
            height: 40,
            child: pdf.Container(
                decoration: pdf.BoxDecoration(
                    border: pdf.Border.all(color: PdfColors.black)),
                child: pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pdf.CrossAxisAlignment.center,
                    children: [
                      pdf.Container(
                          // decoration: pdf.BoxDecoration(
                          //     border: pdf.Border.all(color: PdfColors.black)),
                          margin: pdf.EdgeInsets.symmetric(vertical: 1),
                          width: 60,
                          child: img),
                      celda(
                          60.0,
                          pedido.items[totalProd - 1].productoID?.toString() ??
                              ''),
                      celda(
                          60.0,
                          pedido.items[totalProd - 1].cantidad?.toString() ??
                              '1'),
                      celda(60.0,
                          '${pedido.items[totalProd - 1].descuento?.toStringAsFixed(2) ?? '0.00'} %'),
                      celda(130.0, pedido.items[totalProd - 1]?.detalle ?? ''),
                      celda(80.0,
                          '\$ ${pedido.items[totalProd - 1].precio?.toStringAsFixed(2) ?? ''}'),
                    ]))));
      }
      i++;
    }

    pdf.Widget img;
    img = await getImageLogoPdf();

    var multipage = pdf.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pdf.PageOrientation.natural,
      maxPages: 20,
      header: (context) {
        return pdf.Center(
            child: pdf.Text(
          'Cotizacion | Torres y Liva',
        ));
      },
      footer: (context) {
        return pdf.Center(
            child: pdf.Text(
          'Página ${context.pageNumber} de ${context.pagesCount}',
        ));
      },
      build: (context) {
        return [
          pdf.Column(children: [
            pdf.Row(mainAxisAlignment: pdf.MainAxisAlignment.start, children: [
              pdf.Container(
                  child: _datosClientePdf(context, pedido),
                  color: PdfColors.red),
              pdf.Container(child: img, width: 300, color: PdfColors.green)
            ]),
            pdf.Container(height: 40),
            pdf.Row(mainAxisSize: pdf.MainAxisSize.max, children: [
              pdf.Container(
                  width: 483,
                  height: 40,
                  color: PdfColors.grey400,
                  child: pdf.Row(
                      mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: pdf.CrossAxisAlignment.center,
                      children: [
                        celda(50.0, 'Imagen', header: true),
                        celda(60.0, 'Código', header: true),
                        celda(60.0, 'Cantidad', header: true),
                        celda(60.0, 'Descuento', header: true),
                        celda(130.0, 'Descripción', header: true),
                        celda(80.0, 'Precio sin IVA', header: true),
                      ]))
            ]),
            rows.length > 0 ? pdf.Column(children: rows[0]) : pdf.Container(),
            rows.length > 1 ? pdf.Column(children: rows[1]) : pdf.Container(),
            rows.length > 2 ? pdf.Column(children: rows[2]) : pdf.Container(),
            rows.length > 3 ? pdf.Column(children: rows[3]) : pdf.Container(),
            rows.length > 4 ? pdf.Column(children: rows[4]) : pdf.Container(),
            rows.length > 5 ? pdf.Column(children: rows[5]) : pdf.Container(),
            rows.length > 6 ? pdf.Column(children: rows[6]) : pdf.Container(),
          ])
        ];
      },
    );

    docpdf.addPage(multipage);

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/cotizacion_${DateTime.now()}.pdf';
    final File file = File(path);
    await file.writeAsBytes(await docpdf.save());

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

    listaPedidosCotizaciones.forEach((pedido) => pedido.checked = false);
    listaPedidosEnviados.forEach((pedido) => pedido.checked = false);
    listaPedidosSinEnviar.forEach((pedido) => pedido.checked = false);
  }

  _datosClientePdf(pdf.Context context, Pedido p) {
    return pdf.Row(
        mainAxisAlignment: pdf.MainAxisAlignment.center,
        crossAxisAlignment: pdf.CrossAxisAlignment.start,
        children: [
          pdf.Container(
              height: 140,
              width: 220,
              color: PdfColors.grey200,
              child: pdf.Column(
                  mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pdf.CrossAxisAlignment.start,
                  children: [
                    _rowTituloYDescripcion('Cliente', p?.cliente?.nombre ?? ''),
                    _rowTituloYDescripcion(
                        'Domicilio', p?.cliente?.domicilio ?? ''),
                    _rowTituloYDescripcion('Condicion de Venta',
                        p?.getFormaPago()?.toUpperCase() ?? ''),
                    _rowTituloYDescripcion('Neto gravado',
                        '\$ ${p?.neto?.toStringAsFixed(2) ?? 0.00}'),
                    _rowTituloYDescripcion('Descuento general',
                        '${p?.descuento?.toStringAsFixed(2) ?? 0.00} %'),
                    _rowTituloYDescripcion(
                        'Iva', '\$ ${p?.iva?.toStringAsFixed(2) ?? 0.00}'),
                    _rowTituloYDescripcion('Total',
                        '\$ ${p?.totalPedido?.toStringAsFixed(2) ?? 0.00}')
                  ])),
        ]);
  }

  _rowTituloYDescripcion(String titulo, String valor) {
    // return titulo + ':' + valor;
    return pdf.Container(
        margin: pdf.EdgeInsets.all(2),
        child: pdf.Row(
            mainAxisSize: pdf.MainAxisSize.max,
            mainAxisAlignment: pdf.MainAxisAlignment.start,
            crossAxisAlignment: pdf.CrossAxisAlignment.center,
            children: [
              pdf.Text(titulo + ':',
                  style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
              pdf.Expanded(child: pdf.SizedBox()),
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
    final dbHelper = DatabaseHelper.instance;

    final listaJson = await dbHelper.queryRows(DatabaseHelper.tablePedidos,
        DatabaseHelper.estado, Pedido.ESTADO_SIN_ENVIAR);

    List<Pedido> listaObjects = Pedidos.fromJson(listaJson);

    listaPedidosSinEnviar
        .removeWhere((element) => element.estado != Pedido.ESTADO_SIN_ENVIAR);

    listaObjects.forEach((element) {
      final ped = listaPedidosSinEnviar.firstWhere(
          (pedSinEnviar) => pedSinEnviar.id == element.id,
          orElse: () => null);
      if (ped == null) {
        listaPedidosSinEnviar.add(element);
      }
    });

    listaPedidosSinEnviar.removeWhere((element) => !_isPedidoFromUser(element));
  }

  Future _initListaPedidosEnviados() async {
    final dbHelper = DatabaseHelper.instance;

    final listaJson = await dbHelper.queryRows(DatabaseHelper.tablePedidos,
        DatabaseHelper.estado, Pedido.ESTADO_ENVIADO);

    List<Pedido> listaObjects = Pedidos.fromJson(listaJson);

    listaPedidosEnviados
        .removeWhere((element) => element.estado != Pedido.ESTADO_ENVIADO);

    listaObjects.forEach((element) {
      final ped = listaPedidosEnviados.firstWhere(
          (pedSinEnviar) => pedSinEnviar.id == element.id,
          orElse: () => null);
      if (ped == null) {
        listaPedidosEnviados.add(element);
      }
    });
  }

  Future<void> _initListaPedidosCotizados() async {
    final dbHelper = DatabaseHelper.instance;

    final listaJson = await dbHelper.queryRows(DatabaseHelper.tablePedidos,
        DatabaseHelper.estado, Pedido.ESTADO_COTIZADO);

    List<Pedido> listaObjects = Pedidos.fromJson(listaJson);

    listaPedidosCotizaciones
        .removeWhere((element) => element.estado != Pedido.ESTADO_COTIZADO);

    listaObjects.forEach((element) {
      final ped = listaPedidosCotizaciones.firstWhere(
          (pedSinEnviar) => pedSinEnviar.id == element.id,
          orElse: () => null);
      if (ped == null) {
        listaPedidosCotizaciones.add(element);
      }
    });
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
        // await _initLista PedidosSinEnviar();
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

  pdf.Widget _descripcionItemPdf(ItemPedido item) {
    final columnDesc =
        pdf.Column(mainAxisAlignment: pdf.MainAxisAlignment.center, children: [
      pdf.Text(item.detalle,
          softWrap: true,
          style: pdf.TextStyle(fontWeight: pdf.FontWeight.bold)),
      pdf.Text('\$ ${item.precio}')
    ]);
    return pdf.Container(width: 200, height: 60, child: columnDesc);
  }

  bool _isPedidoFromUser(Pedido element) {
    bool encontrado = false;

    int i = 0;
    encontrado = false;
    while (encontrado == false && i < clientesDelVendedor.length) {
      encontrado = clientesDelVendedor[i].clientId == element.clienteID;
      i++;
    }
    return encontrado == true;
  }
}
