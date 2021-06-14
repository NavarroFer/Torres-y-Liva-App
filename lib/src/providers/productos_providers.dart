import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/codigo_barra_model.dart';
import 'package:torres_y_liva/src/models/dataimg_model.dart';
import 'package:torres_y_liva/src/models/precio_model.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
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
        log('GET categorias - count: ${Categorias.categorias.length}');
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
        log('GET productos - count: ${Productos.productos.length}');
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

        log('GET CodigosBarra - count: ${CodigosBarra.codigos.length}');
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
  Future<List<DataImage>> getDataImage(String lastUpdate) async {
    final url = Uri.parse(
        'http://fotos.torresyliva.com/fotosapp/actions/getPhotoCodesInfo.php?last_update=$lastUpdate');
    try {
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json'
      }).timeout(Duration(seconds: 20));
      print(resp.body);
      if (resp.statusCode == 200) {
        final decodedData = jsonDecode(resp.body);

        List dataImages = decodedData['result'];
        List<DataImage> result = List<DataImage>.empty(growable: true);
        dataImages.forEach((element) {
          DataImage di = DataImage.fromJsonMap(element);
          //no fue descargada todavia, esto es para que quede en la DB
          String fechaDb = di.dateMod
                  .replaceAll('-', '')
                  .replaceAll(' ', '')
                  .replaceAll(':', '') ??
              '';
          updatePhoto(
              int.tryParse(di.code) ?? 1, false, fechaDb, di.extension ?? '');

          result.add(di);
        });
        return result;
      } else {
        return [];
      }
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }
}
