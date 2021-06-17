import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:share/share.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
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

  List<Producto> hijosCat = List<Producto>.empty(growable: true);

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

  _getHijosCat(String idCat, int nivel) {
    if (nivel >= 0 && nivel < 2) {
      Categorias.categorias.forEach((categoria) {
        if (categoria.nivel == nivel + 1 &&
            categoria.lineaItemParent.toString() == idCat) {
          _getHijosCat(categoria.categoriaID, nivel + 1);
        }
      });
    } else if (nivel == 2) {
      hijosCat.addAll(
          Productos.productos.where((element) => element.categoriaID == idCat));
    }
  }

  _opcionesPDF(BuildContext context, bool share) async {
    //generar PDF cotizacion
    final pdf.Document docpdf = pdf.Document();

    CatalogoProductosPage.itemsSelected.forEach((element) {
      if (element.runtimeType == Categoria) {
        //agregar todos los productos hijos
        final cat = element as Categoria;
        hijosCat.clear();
        _getHijosCat(cat.categoriaID, cat.nivel);
      } else {
        // es producto
        hijosCat.add(element);
      }
    });

    List<List<pdf.Widget>> rows = List<List<pdf.Widget>>.empty(growable: true);

    int j = 0;
    int nroPage = 0;
    rows.add(List<pdf.Widget>.empty(growable: true));
    for (var i = 0; i < hijosCat.length; i++) {
      // j++;
      print(i);
      if (i % 16 == 0) {
        nroPage++;
        rows.add(List<pdf.Widget>.empty(growable: true));
      } else {
        final String dir = (await getExternalStorageDirectory()).path;
        final String path = '$dir/Pictures/products/${hijosCat[i].id}.jpg';
        pdf.MemoryImage image;
        pdf.Widget img;
        try {
          image = pdf.MemoryImage(
            File(path).readAsBytesSync(),
          );

          img = pdf.Image(image);
        } catch (e) {
          img = pdf.Container();
        }
        rows[nroPage].add(pdf.Container(
            width: 483,
            height: 40,
            child: pdf.Row(
                mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: pdf.CrossAxisAlignment.center,
                children: [
                  _celda(15.0, i.toString()),
                  pdf.Container(width: 40, child: img),
                  _celda(60.0, hijosCat[i].id.toString() ?? ''),
                  _celda(150.0, hijosCat[i].descripcion ?? ''),
                  _celda(80.0, hijosCat[i].precio.toStringAsFixed(2) ?? ''),
                ])));
      }
    }

    // hijosCat.forEach((item) async {
    //   //Agregar filas a la tabla
    //   j++;
    //   print(j);
    //   if (j % 10 == 0) {
    //     nroPage++;
    //     rows.add(List<pdf.Widget>.empty(growable: true));
    //   } else {
    //     final String dir = (await getExternalStorageDirectory()).path;
    //     final String path = '$dir/Pictures/products/${item.id}.jpg';
    //     pdf.MemoryImage image;
    //     pdf.Widget img;
    //     try {
    //       image = pdf.MemoryImage(
    //         File(path).readAsBytesSync(),
    //       );

    //       img = pdf.Image(image);
    //     } catch (e) {
    //       img = pdf.Container();
    //     }
    //     rows[nroPage].add(pdf.Container(
    //         width: 483,
    //         height: 40,
    //         child: pdf.Row(
    //             mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
    //             crossAxisAlignment: pdf.CrossAxisAlignment.center,
    //             children: [
    //               _celda(15.0, j.toString()),
    //               pdf.Container(width: 40, child: img),
    //               _celda(60.0, item.id.toString() ?? ''),
    //               _celda(150.0, item.descripcion ?? ''),
    //               _celda(80.0, item.precio.toStringAsFixed(2) ?? ''),
    //             ])));
    //   }
    // });

    print(rows.length);
    // print(rows[0].length ?? '0');
    // print(rows[1].length ?? 'a');
    // print(rows[2].length ?? 'b');
    // print(rows[3].length ?? 'c');

    var multipage = pdf.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pdf.PageOrientation.natural,
      maxPages: 20,
      build: (context) {
        return [
          pdf.Column(children: [
            pdf.Column(children: [
              pdf.Text('Ejemplo cotizacion'),
            ]),
            pdf.Row(mainAxisSize: pdf.MainAxisSize.max, children: [
              pdf.Container(
                  width: 483,
                  height: 40,
                  color: PdfColors.cyan300,
                  child: pdf.Row(
                      mainAxisAlignment: pdf.MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: pdf.CrossAxisAlignment.center,
                      children: [
                        _celda(20.0, 'Nº'),
                        _celda(100.0, 'Imagen'),
                        _celda(60.0, 'Código'),
                        _celda(150.0, 'Descripción'),
                        _celda(80.0, 'Precio sin IVA'),
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
    final size = MediaQuery.of(context).size;
    if (CatalogoProductosPage.seleccionando) {
      color = Colors.grey;
      acciones = [_toPDF(context), _toPDFShare(context)];
    } else {
      color = Colors.red;
      acciones = [_cantItems(context), _opciones(context)];
    }
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
              _opcionesPDF(context, false);
              break;
            case 1:
              _opcionesPDF(context, true);
              break;
            default:
          }
        },
        tooltip: 'Lista de opciones',
        itemBuilder: (_) => <PopupMenuItem<int>>[
          new PopupMenuItem<int>(child: Text('Guardar PDF'), value: 0),
          new PopupMenuItem<int>(child: Text('Compartir PDF'), value: 1),
        ],
      ),
    );
  }

  Widget _cantItems(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.3,
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

  _celda(double d, String s) {
    return pdf.Container(
        width: d,
        child: pdf.Center(child: pdf.Text(s, textAlign: pdf.TextAlign.center)));
  }
}
