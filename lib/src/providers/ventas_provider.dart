import 'dart:async';
import 'dart:convert';

import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/utils/globals.dart';

class VentasProvider {
  Future<bool> enviarPedidos(
      String tokenEmpesa, String tokenCliente, List<Pedido> pedidos) async {
    var enviado = false;
    pedidos.forEach((pedido) async {
      enviado = await enviarPedido(tokenEmpesa, tokenCliente, pedido);
    });

    return enviado;
  }

  Future<bool> enviarPedido(
      String tokenEmpresa, String tokenCliente, Pedido pedido) async {
    String path = '/ws/pm/pedido/enviaPedido';

    final url = Uri.http(urlServer, path);
    try {
      final body = pedido.toJson();
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
      if (respuesta.success)
        return decodedData['success'] == true;
      else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return false;
    } on Exception {
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
      print(decodedData);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
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
      print(decodedData);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        final pedido = Pedido.fromJsonMap(decodedData['data']);
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
      print(decodedData);
      final respuesta = Respuesta.fromJsonMap(decodedData);
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
}
