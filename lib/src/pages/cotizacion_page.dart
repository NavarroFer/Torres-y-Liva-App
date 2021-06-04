import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:share/share.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
import 'package:torres_y_liva/src/pages/buscador_producto_page.dart';
import 'package:torres_y_liva/src/pages/catalogo_productos_page.dart';

class CotizacionPage extends StatefulWidget {
  static final String route = 'cotizacion';
  CotizacionPage({Key key}) : super(key: key);

  @override
  _CotizacionPageState createState() => _CotizacionPageState();
}

class _CotizacionPageState extends State<CotizacionPage> {
  Widget title = Text('Cotizacion');
  MaterialColor color = Colors.red;

  List<Widget> acciones;
  Widget get getTitle => title;

  @override
  void dispose() {
    CatalogoProductosPage.seleccionando = false;
    CatalogoProductosPage.itemsSelected.clear();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: _getAcciones(context),
        backgroundColor: color,
        leading: _arrowBack(context),
      ),
      body: CatalogoProductosPage(
        modo: 'cotizacion',
        notifyParent: () {
          _refresh(context);
        },
      ),
    );
  }

  Widget _toPDF(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          _opcionesPDF(context, false);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.grey, // background
          onPrimary: Colors.white, // foreground
        ),
        icon: Icon(MdiIcons.pdfBox,
            size: MediaQuery.of(context).size.height * 0.045),
        label: Container());
  }

  Widget _toPDFShare(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          _opcionesPDF(context, true);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.grey, // background
          onPrimary: Colors.white, // foreground
        ),
        icon: Icon(MdiIcons.shareVariant,
            size: MediaQuery.of(context).size.height * 0.045),
        label: Container());
  }

  Future<Widget> _opcionesPDF(BuildContext context, bool share) async {
    //generar PDF cotizacion
    final pdf.Document docpdf = pdf.Document();

    var j = 0; //index pedido

    final rowsTabla = List<List<dynamic>>.filled(0, null, growable: true);
    CatalogoProductosPage.itemsSelected.forEach((item) {
      //Agregar filas a la tabla

      if (item.runtimeType == Producto) {
        rowsTabla.add(List.from([
          (j++).toString(),
          'IMAGEN',
          '${item.producto.id ?? ''}',
          '${item.cantidad ?? '0'}',
          '${item.producto.nombre ?? 'Sin descripcion'}',
          '\$ ${item.precio.toStringAsFixed(2) ?? '\$ 0.00'}',
          '${item.descuento ?? '0,00 %'}',
          '${item.observacion ?? ''}',
        ]));
      }
    });

    var multipage = pdf.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pdf.PageOrientation.landscape,
      build: (context) {
        return [
          pdf.Column(children: [
            pdf.Column(children: [
              pdf.Text('Ejemplo cotizacion'),
            ]),
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
                headerDecoration: pdf.BoxDecoration(color: PdfColors.grey200),
                border: pdf.TableBorder.all())
          ])
        ];
      },
    );
    var page = pdf.Page(
        orientation: pdf.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pdf.Context context) {
          return pdf.Center(child: pdf.Text('COTIZACION DE PRODUCTOS'));
        });

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
      _unCheckCategorias();
    });
  }

  void _unCheckCategorias() {}

  Widget _arrowBack(BuildContext context) {
    if (CatalogoProductosPage.seleccionando == false)
      return IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          });
    else
      return IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            CatalogoProductosPage.seleccionando = false;
            _refresh(context);
          });
  }

  void _refresh(BuildContext context) {
    _refreshColorAcciones(context);
    setState(() {});
  }

  void _refreshColorAcciones(BuildContext context) {
    if (CatalogoProductosPage.seleccionando) {
      color = Colors.grey;
      acciones = [_toPDF(context), _toPDFShare(context)];
    } else {
      color = Colors.red;
      acciones = [_cantItems(context)];
    }
  }

  Widget _cantItems(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      height: size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(MdiIcons.formatListBulletedType, size: size.height * 0.045),
          Text(
            CatalogoProductosPage.cantidadItems.toString(),
            textScaleFactor: size.height * 0.0025,
          )
        ],
      ),
    );
  }

  _getAcciones(BuildContext context) {
    _refreshColorAcciones(context);
    return acciones;
  }
}
