import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:torres_y_liva/src/models/usuario_model.dart';
import 'package:torres_y_liva/src/utils/globals.dart';

class UsuariosProvider {
  Future<bool> login(String user, String password, String tokenEmpresa) async {
    String path = '/ws/pm/usuarios/loginVendedor';

    final url = Uri.http(urlServer, path);
    try {
      final body = {'usuario': user, 'clave': password, 'token': tokenEmpresa};
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      print(url);
      final decodedData = jsonDecode(resp.body);
      print(decodedData);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        usuario = Usuario.fromJsonMap(decodedData['data']);
        //TODO guardar datos del usuario
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
