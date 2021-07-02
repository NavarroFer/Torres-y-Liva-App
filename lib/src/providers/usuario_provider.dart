import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
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
      final decodedData = jsonDecode(resp.body);
      final respuesta = Respuesta.fromJsonMap(decodedData);
      if (respuesta.success) {
        usuario = Usuario.fromJsonMap(decodedData['data']);

        log('${DateTime.now()} - Login correcto del usuario: ${usuario.nombre}');
        return true;
      } else
        return Future.error(respuesta.mensaje);
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }

  Future<bool> sendLocation(Position pos) async {
    final path = '/ws/pm/usuarios/loginVendedor';
    final urlServerLocation = '';

    final url = Uri.http(urlServerLocation, path);
    try {
      final body = {
        'idUsuario': usuario.vendedorID,
        'nombre': password,
        'latitud': pos.latitude,
        'longitud': pos.longitude
      };
      final resp = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: body,
          )
          .timeout(Duration(seconds: 10));
      final decodedData = jsonDecode(resp.body);
      if (true) {
        return true;
      } else
        return Future.error('');
    } on TimeoutException {
      return false;
    } on Exception {
      return false;
    }
  }
}
