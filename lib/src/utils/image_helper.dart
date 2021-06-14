import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torres_y_liva/src/models/dataimg_model.dart';
import 'package:torres_y_liva/src/providers/productos_providers.dart';
import 'package:torres_y_liva/src/utils/database_helper.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/utils/shared_pref_helper.dart';

Future<bool> getImages(Function() notifyParent) async {
  String idProduct;
  String url = 'http://fotos.torresyliva.com/fotosapp/$idProduct.jpg';
  final db = DatabaseHelper.instance;

  List<Map<String, dynamic>> rows = [];

  final dbI = await db.database;

  final productosProvider = ProductosProvider();
  //2021-06-01 23:39:54
  await productosProvider.getDataImage(fechaGetDataIMG);

  // aca ya grabo todo en la DB ("a descargar")
  DateTime ahora = DateTime.now();
  fechaGetDataIMG =
      '${ahora.year.toString()}-${ahora.month.toString().padLeft(2, '0')}-${ahora.day.toString().padLeft(2, '0')} ${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}';
  await grabaFechaGetDataIMG();

  print('FECHA GET DATAT IMG: $fechaGetDataIMG');

  //20210601233954 Esta puede ser distina a la de arriba, siempre posterior 2021-03-27 15:42:45
  String where = '${DatabaseHelper.downloaded} = 0';
  if (fechaUpdateIMG != '') {
    String fechaDB = fechaUpdateIMG
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll(':', '');

    where += ' AND ${DatabaseHelper.fechaDescarga} >= $fechaDB';
  }
  print('Where: $where');

  rows = await dbI.query(DatabaseHelper.tableImgProductos, where: where);
  // rows = await dbI.query(DatabaseHelper.tableImgProductos,
  //     where:
  //         '${DatabaseHelper.downloaded} = 0 AND  ${DatabaseHelper.fechaDescarga} >= 20201228233959');

  print('ROWS: ${rows.length}');
  rows = [];

  for (var element in rows) {
    DataImage di = DataImage.fromJsonMap(element);
    idProduct = di.code;
    if (idProduct != null) {
      url = 'http://fotos.torresyliva.com/fotosapp/$idProduct.jpg';

      var imageId = await ImageDownloader.downloadImage(
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
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fechaUpdateIMG', '');

  log('${DateTime.now()} - $cantFotosDescargadas imagenes descargadas',
      time: DateTime.now());

  return true;
}

Future<bool> updatePhoto(int idProduct, bool downloaded, String fechaDescarga,
    String extension) async {
  final db = DatabaseHelper.instance;

  final res = await db.insert({
    DatabaseHelper.idProductoImg: idProduct,
    DatabaseHelper.downloaded: downloaded ? 1 : 0,
    DatabaseHelper.fechaDescarga: fechaDescarga,
    DatabaseHelper.extension: extension
  }, DatabaseHelper.tableImgProductos);

  return res != -1;
}

Future<Image> getImage(
    int idProd, BuildContext context, double scaleWidth) async {
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
        size: size.height * 0.1,
      );
    },
  );

  return img;
}
