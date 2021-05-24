import 'dart:async';
import 'dart:convert';

import 'package:torres_y_liva/src/models/pedido_model.dart';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/utils/globals.dart';

class VentasProvider {
  Future<bool> enviarPedidos(List<Pedido> pedidos) async {
    var enviado = false;
    pedidos.forEach((pedido) async {
      enviado = await enviarPedido(pedido);
    });

    return enviado;
  }

  Future<bool> enviarPedido(Pedido pedido) async {
    String path = '';

    final url = Uri.http(urlServer, path);
    try {
      final resp = await http.get(url).timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      print(decodedData);
      return decodedData['success'] == true;
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }
}
