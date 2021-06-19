import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/dataimg_model.dart';
import 'package:torres_y_liva/src/providers/productos_providers.dart';
import 'package:torres_y_liva/src/utils/database_helper.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/utils/shared_pref_helper.dart';
import 'package:torres_y_liva/src/widgets/base_widgets.dart';

int imagenesADescargar = -1;

Future<bool> getImages(Function() notifyParent, BuildContext context) async {
  String idProduct;
  String url = 'http://fotos.torresyliva.com/fotosapp/$idProduct.jpg';
  final db = DatabaseHelper.instance;

  List<Map<String, dynamic>> rows = [];

  final dbI = await db.database;

  final productosProvider = ProductosProvider();
  //2021-06-01 23:39:54
  await productosProvider.getDataImage(fechaGetDataIMG);
  // await productosProvider.getDataImage('');

  // aca ya grabo todo en la DB ("a descargar")
  DateTime ahora = DateTime.now();
  fechaGetDataIMG =
      '${ahora.year.toString()}-${ahora.month.toString().padLeft(2, '0')}-${ahora.day.toString().padLeft(2, '0')} ${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}';
  await grabaFechaGetDataIMG();

  // log('FECHA GET DATA IMG: $fechaGetDataIMG');

  //20210601233954 Esta puede ser distina a la de arriba, siempre posterior 2021-03-27 15:42:45
  String where = '${DatabaseHelper.downloaded} = 0';

  // log('FECHA UPDATE IMG: $fechaUpdateIMG');
  if (fechaUpdateIMG != '') {
    String fechaDB = fechaUpdateIMG
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll(':', '');

    where += ' AND ${DatabaseHelper.fechaDescarga} >= $fechaDB';
  }

  rows = await dbI.query(DatabaseHelper.tableImgProductos, where: where);
  // rows = await dbI.query(DatabaseHelper.tableImgProductos, limit: 100);
  // rows = [];
  if (rows.length > 0) {
    mostrarSnackbar('Se descargarán ${rows.length} imágenes', context);
    imagenesADescargar = rows.length;

    for (var element in rows) {
      DataImage di = DataImage.fromJsonMap(element);
      idProduct = di.code;
      if (idProduct != null) {
        url = 'http://fotos.torresyliva.com/fotosapp/$idProduct.jpg';

        await ImageDownloader.downloadImage(
          url,
          destination: AndroidDestinationType.directoryPictures
            ..inExternalFilesDir()
            ..subDirectory('products/$idProduct.jpg'),
        ).onError((error, stackTrace) => null).then((value) {
          updatePhoto(int.tryParse(idProduct) ?? 1, true, di.dateMod ?? '',
              di.extension ?? '');
          cantFotosDescargadas++;
          notifyParent();
          return value;
        });
      }
    }

    DateTime ahoraUpdate = DateTime.now();
    ahoraUpdate = ahoraUpdate.subtract(Duration(seconds: 60));
    fechaUpdateIMG =
        '${ahoraUpdate.year.toString()}-${ahoraUpdate.month.toString().padLeft(2, '0')}-${ahoraUpdate.day.toString().padLeft(2, '0')} ${ahoraUpdate.hour.toString().padLeft(2, '0')}:${ahoraUpdate.minute.toString().padLeft(2, '0')}:${ahoraUpdate.second.toString().padLeft(2, '0')}';

    await grabaFechaUpdate();

    log('${DateTime.now()} - $cantFotosDescargadas imagenes descargadas',
        time: DateTime.now());
  } else {
    log('${DateTime.now()} - No hay imagenes por descargar',
        time: DateTime.now());
  }

  return true;
}

Future<bool> updatePhoto(int idProduct, bool downloaded, String fechaDescarga,
    String extension) async {
  final db = DatabaseHelper.instance;

  final exists = await db.exists(
      DatabaseHelper.tableProductos, idProduct, DatabaseHelper.idProducto);

  int res = -1;

  if (exists) {
    res = await db.insert({
      DatabaseHelper.idProductoImg: idProduct,
      DatabaseHelper.downloaded: downloaded ? 1 : 0,
      DatabaseHelper.fechaDescarga: fechaDescarga,
      DatabaseHelper.extension: extension
    }, DatabaseHelper.tableImgProductos);
  }

  return res != -1;
}

Future<Widget> getImage(
    int idProd, BuildContext context, double scaleWidth, bool leading) async {
  Image img;

  final size = MediaQuery.of(context).size;

  final String dir = (await getExternalStorageDirectory()).path;
  final String path = '$dir/Pictures/products/$idProd.jpg';

  img = Image.file(
    File(path),
    fit: BoxFit.fitWidth,
    width: size.width * scaleWidth,
    errorBuilder: (context, error, stackTrace) {
      final size = MediaQuery.of(context).size;
      return Icon(
        MdiIcons.cameraOff,
        size: leading
            ? size.height * scaleWidth * 0.5
            : size.height * scaleWidth * 0.43,
      );
    },
  );

  return img;
}

Future<Image> getImageCat(
    Categoria categoria, BuildContext context, double scaleWidth) async {
  final idProd = await _getFirstIdProd(categoria);

  Widget img = await getImage(idProd, context, scaleWidth, false);

  return img;
}

Future<int> _getFirstIdProd(Categoria cat) async {
  int idProd = 0;
  if (cat.nivel == 0) {
    String catIDLevel1 = await _getCatId(cat.categoriaID);
    String catIDLevel2 = await _getCatId(catIDLevel1);
    idProd = await _getIdProd(catIDLevel2);
  } else if (cat.nivel == 1) {
    String catIDLevel2 = await _getCatId(cat.categoriaID);
    idProd = await _getIdProd(catIDLevel2);
  } else {
    idProd = await _getIdProd(cat.categoriaID);
  }

  return idProd;
}

Future<String> _getCatId(String catID) async {
  final db = await DatabaseHelper.instance.database;
  String catId = '';
  final row = await db.query(DatabaseHelper.tableCategorias,
      where: '${DatabaseHelper.lineaItemParent} = ?',
      whereArgs: [int.parse(catID)],
      limit: 1,
      columns: [DatabaseHelper.catID]);

  if (row.isNotEmpty) catId = row[0][DatabaseHelper.catID];
  return catId;
}

Future<int> _getIdProd(String catID) async {
  final db = await DatabaseHelper.instance.database;
  int idProd = 0;
  final row = await db.query(DatabaseHelper.tableProductos,
      where: '${DatabaseHelper.categoriaID} = ?',
      whereArgs: [catID],
      limit: 1,
      columns: [DatabaseHelper.idProducto]);
  if (row.isNotEmpty) idProd = row[0][DatabaseHelper.idProducto];

  return idProd;
}
