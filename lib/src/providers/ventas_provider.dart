import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/utils/globals.dart';

class VentasProvider {
  Future<bool> enviarPedidos(
      String tokenEmpesa, String tokenCliente, List<Pedido> pedidos) async {
    var enviado = false;
    for (var pedido in pedidos) {
      enviado = await enviarPedido(tokenEmpesa, tokenCliente, pedido)
          .onError((error, stackTrace) {
        log(error);
        return false;
      });
    }

    return enviado;
  }

  Future<bool> enviarPedido(
      String tokenEmpresa, String tokenCliente, Pedido pedido) async {
    String path = '/ws/pm/pedido/enviaPedido';

    final url = Uri.http(urlServer, path);
    try {
      final pedidoJSON = pedido.toJson();
      final body = {
        "tokenEmpresa": tokenEmpresa,
        "tokenCliente": tokenCliente,
        "pedido": jsonEncode(pedidoJSON)
      };
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      log(decodedData.toString());

      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        log('${DateTime.now()} - ${DateTime.now()} - Pedido enviado - $pedido');
        pedido.estado = Pedido.ESTADO_ENVIADO;
        await pedido.insertOrUpdate();
        return decodedData['success'] == true;
      } else {
        return false;
      }

      // return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return false;
    } on Exception catch (e) {
      log('Paso este error cuando quise enviar pedido: $e');
      return false;
    }
  }

  Future<List<Pedido>> getPedidosHistoricos(
      String tokenEmpresa, String tokenCliente, bool incluyeDetalle) async {
    String path = '/ws/pm/pedido/requestAll';

    final url = Uri.http(urlServer, path);
    try {
      final body = {
        'tokenEmpresa': tokenEmpresa,
        'tokenCliente': tokenCliente,
        'incluyeDetalle': incluyeDetalle?.toString()
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
        log('${DateTime.now()} - GET pedidos historicos');
        Pedidos.fromJsonList(decodedData['data']['objects']);
        return Pedidos.pedidos;
      } else
        return null;
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  Future<Pedido> getPedido(
      String tokenEmpresa, String tokenCliente, int pedidoID) async {
    String path = '/ws/pm/pedido/requestPedido';

    final url = Uri.http(urlServer, path);
    try {
      final body = {
        'tokenEmpresa': tokenEmpresa,
        'tokenCliente': tokenCliente,
        'pedidoID': pedidoID?.toString()
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
        final pedido = Pedido.fromJsonMap(decodedData['data']);
        log('${DateTime.now()} - GET pedido ID: ${pedido.id}');
        return pedido;
      } else
        return null;
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }

  Future<bool> anularPedido(
      String tokenEmpresa, String tokenCliente, int pedidoID) async {
    String path = '/ws/pm/pedido/anula';

    final url = Uri.http(urlServer, path);
    try {
      final body = {
        'tokenEmpresa': tokenEmpresa,
        'tokenCliente': tokenCliente,
        'pedidoID': pedidoID?.toString()
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
        log('${DateTime.now()} - Pedido anulado ID: $pedidoID');
        return true;
      } else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }
}
