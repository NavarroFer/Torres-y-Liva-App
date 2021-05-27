import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/codigo_barra_model.dart';
import 'package:torres_y_liva/src/models/precio_model.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
import 'package:torres_y_liva/src/utils/globals.dart';

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
      print(decodedData);
      if (respuesta.success) {
        Categorias.fromJsonList(decodedData['data']['objects']);
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
      print(decodedData);
      if (respuesta.success) {
        final prod = Producto.fromJsonMap(decodedData['data']);
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
      print(decodedData);
      if (respuesta.success) {
        return true;
      } else
        return Future.error(respuesta.mensaje);
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
      print(decodedData);
      if (respuesta.success) {
        Productos.fromJsonList(decodedData['data']['objects']);
        await ackUpdateProductos(tokenEmpresa, tokenCliente);
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
      print(decodedData);
      if (respuesta.success) {
        CodigosBarra.fromJsonList(decodedData['data']['objects']);
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
      print(decodedData);
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
}
