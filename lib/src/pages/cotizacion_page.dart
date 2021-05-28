import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:share/share.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: acciones,
        backgroundColor: color,
      ),
      body: CatalogoProductosPage(
        modo: 'cotizacion',
        notifyParent: () {
          if (CatalogoProductosPage.seleccionando) {
            color = Colors.grey;
            acciones = [_toPDF(context), _toPDFShare(context)];
          } else {
            color = Colors.red;
            acciones = [];
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _toPDF(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          _opcionesPDF(context, false);
        },
        icon: Icon(MdiIcons.pdfBox),
        label: Container());
  }

  Widget _toPDFShare(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          _opcionesPDF(context, true);
        },
        icon: Icon(MdiIcons.shareVariant),
        label: Container());
  }

  Future<Widget> _opcionesPDF(BuildContext context, bool share) async {
    //generar PDF cotizacion
    final pdf.Document docpdf = pdf.Document();

    var i = 0; //index pedido

    var page = pdf.Page(
        orientation: pdf.PageOrientation.landscape,
        pageFormat: PdfPageFormat.a4,
        build: (pdf.Context context) {
          return pdf.Center(child: pdf.Text('COTIZACION DE PRODUCTOS'));
        });

    docpdf.addPage(page);

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
}
