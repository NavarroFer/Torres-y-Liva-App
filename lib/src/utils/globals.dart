import 'package:torres_y_liva/src/models/cliente_model.dart';
import 'package:torres_y_liva/src/models/usuario_model.dart';

final String urlServer = 'torresyliva.no-ip.info:8181';
final String tokenEmpresa = '745710b2-5133-11ea-9d0e-9ee722880a34';

Usuario usuario;
List<Cliente> clientesDelVendedor;
int idCliente;

String username = '';
String password = '';

bool logged = false;
bool dbInicializada = false;

bool productosCargados = false;

//////////// Constantes respuesta WS ////////////

class Respuesta {
  // ignore: non_constant_identifier_names
  static final int ERROR_INESPERADO = 500;
  // ignore: non_constant_identifier_names
  static final int ERROR_TOKEN_INVALIDO = 501;
  // ignore: non_constant_identifier_names
  static final int ERROR_SERVICIO_INACTIVO = 502;
  // ignore: non_constant_identifier_names
  static final int ERROR_LOGIN_INCORRECTO = 503;
  // ignore: non_constant_identifier_names
  static final int ERROR_TOKEN_CLIENTE_INVALIDO = 509;
  // ignore: non_constant_identifier_names
  static final int ERROR_ENVIO_PEDIDO = 510;
  // ignore: non_constant_identifier_names
  static final int ENVIO_PEDIDO_RECHAZADO = 511;
  // ignore: non_constant_identifier_names
  static final int ERROR_ANULACION_PEDIDO = 512;
  // ignore: non_constant_identifier_names
  static final int ANULACION_PEDIDO_RECHAZADA = 513;
  // ignore: non_constant_identifier_names
  static final int OPERACION_OK = 600;

  bool success;
  int codigo;
  String mensaje;
  //DATA varia segun el metodo

  Respuesta.fromJsonMap(Map<String, dynamic> json) {
    this.success = json['success'];
    this.codigo = json['codigo'];
    this.mensaje = json['mensaje'];
  }
}

//////////////////////////////////////////////
