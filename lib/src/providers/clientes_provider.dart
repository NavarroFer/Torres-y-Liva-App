import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/models/cliente_model.dart';

class ClientesProvider {
  Future<List<Cliente>> getClientes(
      String tokenEmpresa, String tokenCliente, int vendedorID) async {
    String path = '/ws/pm/cliente/requestClientesVendedor';

    final url = Uri.http(urlServer, path);
    try {
      final body = {
        'tokenEmpresa': tokenEmpresa,
        'tokenCliente': tokenCliente,
        'vendedorID': vendedorID?.toString()
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
        Clientes.fromJsonList(decodedData['data']);
        return Clientes.clientes;
      } else
        return null;
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }
}
