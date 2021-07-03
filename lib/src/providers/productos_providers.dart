import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/codigo_barra_model.dart';
import 'package:torres_y_liva/src/models/dataimg_model.dart';
import 'package:torres_y_liva/src/models/precio_model.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
import 'package:torres_y_liva/src/utils/database_helper.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/utils/image_helper.dart';

class ProductosProvider {
  Future<List<Categoria>> getCategorias(
      String tokenEmpresa, String tokenCliente) async {
    String path = '/ws/pm/categoriaItem/requestAll';

    final url = Uri.http(urlServer, path);
    try {
      final body = {'tokenEmpresa': tokenEmpresa, 'tokenCliente': tokenCliente};
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        Categorias.fromJsonList(decodedData['data']['objects']);
        log('${DateTime.now()} - GET categorias - count: ${Categorias.categorias.length}');
        return Categorias.categorias;
      } else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  Future<Producto> getProducto(
      int itemID, String tokenEmpresa, String tokenCliente) async {
    String path = '/ws/pm/item/requestItem';

    final url = Uri.http(urlServer, path);
    try {
      final body = {
        'tokenEmpresa': tokenEmpresa,
        'tokenCliente': tokenCliente,
        'itemID': itemID?.toString()
      };
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        final prod = Producto.fromJsonMap(decodedData['data']);
        log('GET item: ${prod?.descripcion ?? ''}');
        return prod;
      } else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  Future<List<Producto>> getProductos(
      String tokenEmpresa, String tokenCliente) async {
    String path = '/ws/pm/item/requestAll';
    return await _getProductos(path, tokenEmpresa, tokenCliente);
  }

  Future<List<Producto>> getProductosActualizados(
      String tokenEmpresa, String tokenCliente) async {
    String path = '/ws/pm/item/requestUpdated';
    return await _getProductos(path, tokenEmpresa, tokenCliente);
  }

  Future<bool> ackUpdateProductos(
      String tokenEmpresa, String tokenCliente) async {
    String path = '/ws/pm/item/ackRequestItemsAll';
    final url = Uri.http(urlServer, path);
    try {
      final body = {'tokenEmpresa': tokenEmpresa, 'tokenCliente': tokenCliente};
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        log('ACK enviado correctamente');
        return true;
      } else {
        log(respuesta.mensaje);
        return Future.error(respuesta.mensaje);
      }
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }

  Future<Object> _getProductos(
      String path, String tokenEmpresa, String tokenCliente) async {
    final url = Uri.http(urlServer, path);
    try {
      final body = {'tokenEmpresa': tokenEmpresa, 'tokenCliente': tokenCliente};
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 20));
      final decodedData = jsonDecode(resp.body);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        Productos.fromJsonList(decodedData['data']['objects']);
        log('${DateTime.now()} - GET productos - count: ${Productos.productos.length}');
        return Productos.productos;
      } else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  Future<List<CodigoBarra>> getCodigosBarra(
      String tokenEmpresa, String tokenCliente) async {
    String path = '/ws/pm/item/requestCodigoBarraAll';

    final url = Uri.http(urlServer, path);
    try {
      final body = {'tokenEmpresa': tokenEmpresa, 'tokenCliente': tokenCliente};
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        CodigosBarra.fromJsonList(decodedData['data']['objects']);

        log('${DateTime.now()} - GET CodigosBarra - count: ${CodigosBarra.codigos.length}');
        return CodigosBarra.codigos;
      } else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  Future<List<Precio>> getPrecios(
      String tokenEmpresa, String tokenCliente) async {
    String path = '/ws/pm/item/requestPreciosAll';

    final url = Uri.http(urlServer, path);
    try {
      final body = {'tokenEmpresa': tokenEmpresa, 'tokenCliente': tokenCliente};
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        Precios.fromJsonList(decodedData['data']['objects']);
        return Precios.precios;
      } else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  /// El parametro [lastUpdate] tiene que ser de la forma 2021-06-01%2023:39:54.
  getDataImage(String lastUpdate) async {
    final url = Uri.parse(
        'http://fotos.torresyliva.com/fotosapp/actions/getPhotoCodesInfo.php?last_update=$lastUpdate');
    try {
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json'
      }).timeout(Duration(seconds: 20));
      if (resp.statusCode == 200) {
        log('En metodo get data img');
        final decodedData = jsonDecode(resp.body);

        List dataImages = decodedData['result'];

        //no fue descargada todavia, esto es para que quede en la DB
        final db = await DatabaseHelper.instance.database;
        var batch = db.batch();

        final idProd = await db.query(DatabaseHelper.tableProductos,
            columns: [DatabaseHelper.idProducto]);

        var idProdValues = idProd.asMap().values;

        final idProdValuesSinPK = List.empty(growable: true);

        idProdValues.forEach((element) {
          idProdValuesSinPK.add(element['primaryKey']);
        });

        for (var dataImage in dataImages) {
          DataImage di = DataImage.fromJsonMap(dataImage);

          String fechaDb = di.dateMod
                  .replaceAll('-', '')
                  .replaceAll(' ', '')
                  .replaceAll(':', '') ??
              '';
          final idProductoImg = int.tryParse(di.code) ?? 1;
          final dataImageMap = {
            DatabaseHelper.idProductoImg: idProductoImg,
            DatabaseHelper.downloaded: di.downloaded,
            DatabaseHelper.fechaDescarga: fechaDb,
            DatabaseHelper.extension: di.extension,
          };

          if (idProdValuesSinPK.contains((idProductoImg))) {
            batch.insert(DatabaseHelper.tableImgProductos, dataImageMap,
                conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }

        try {
          final a = await batch.commit();
          log('Img productos insertados: ${a.length.toString()}');
        } on Exception catch (e) {
          log('ex en commit Img productos $e');
        }
        log('${DateTime.now()} - Tabla img productos actualizada',
            time: DateTime.now());
      }
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }
}
