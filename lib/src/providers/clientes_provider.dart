import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/models/cliente_model.dart';

class ClientesProvider {
  Future<List<Cliente>> getClientes() async {
    String path = '/ws/pm/cliente/requestClientesVendedor';

    final url = Uri.http(urlServer, path);
    try {
      final resp = await http.get(url).timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      print(decodedData);
      if (decodedData['success'] == true) {
      } else
        return null;
    } on TimeoutException {
      return null;
    } on Exception {
      return null;
    }
  }
}
