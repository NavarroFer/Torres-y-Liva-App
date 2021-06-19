import 'package:torres_y_liva/src/utils/database_helper.dart';

class Clientes {
  static List<Cliente> clientes;

  Clientes.fromJsonList(List<dynamic> jsonList) {
    clientes = [];

    jsonList.forEach((jsonItem) {
      final cliente = new Cliente.fromJsonMap(jsonItem);
      clientes?.add(cliente);
    });
  }
}

class Cliente {
  int id;
  int clientId; //clienteID
  int userId; //usuarioWebID
  int domicilioID; //domicilioClienteID
  String codigoGestion; //codigoGestion
  String nombre; //nombre fantasia
  String ciudad; //localidad
  int tipoCuitID; //tipoCuitID
  String cuit; //cuit
  String email; //email
  String domicilio; //domicilio
  String telefono; //telefono
  String telefonoCel; //telefonoCel
  String fechaUltimaCompra; // lo tengo que guardar yo????
  int priceList; //lista_precios
  String formaPago; //formaPago
  String razonSocial; //razonSocial
  double descuento; //descuento  default
  double saldo; //saldo deudor total
  double credito; //limite de credito
  String observaciones; //obs comerciales
  String latitud;
  String longitud;
  String tokenWs;
  String reba;
  int priceListAux;
  bool geoReferenced;

  static const FORMA_PAGO_CONTADO = 'CONTADO';

  static const FORMA_PAGO_CHEQUE = 'CHEQUE';

  static const FORMA_PAGO_CUENTA_CORRIENTE = 'CUENTA CORRIENTE';

  Cliente(
      {this.clientId,
      this.nombre,
      this.domicilio,
      this.telefono,
      this.email,
      this.ciudad,
      this.codigoGestion,
      this.credito,
      this.cuit,
      this.descuento,
      this.domicilioID,
      this.fechaUltimaCompra,
      this.formaPago,
      this.geoReferenced,
      this.id,
      this.latitud,
      this.longitud,
      this.observaciones,
      this.priceList,
      this.priceListAux,
      this.razonSocial,
      this.reba,
      this.saldo,
      this.telefonoCel,
      this.tipoCuitID,
      this.tokenWs,
      this.userId});

  @override
  String toString() {
    return '$nombre $clientId $domicilio $telefono $telefonoCel $ciudad';
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.clienteID: this.id,
      'clientId': this.clientId ?? 0,
      'userId': this.userId ?? 0,
      'domicilioID': this.domicilioID ?? 0,
      'codigoGestion': this.codigoGestion ?? '',
      'nombre': this.nombre ?? '',
      'ciudad': this.ciudad ?? '',
      'tipoCuitID': this.tipoCuitID ?? 0,
      'cuit': this.cuit ?? '',
      'email': this.email ?? '',
      'domicilio': this.domicilio ?? '',
      'telefono': this.telefono ?? '',
      'telefonoCel': this.telefonoCel ?? '',
      'fechaUltimaCompra': this.fechaUltimaCompra ?? 0,
      'priceList': this.priceList ?? 0,
      'formaPago': this.formaPago ?? '',
      'razonSocial': this.razonSocial ?? '',
      'clienteDescuento': this.descuento ?? 0,
      'saldo': this.saldo ?? 0,
      'credito': this.credito ?? 0,
      'observaciones': this.observaciones ?? '',
      'latitud': this.latitud ?? '',
      'longitud': this.longitud ?? '',
      'reba': this.reba ?? '',
      'priceListAux': this.priceList ?? 0,
      'geoReferenced': this.geoReferenced == null
          ? 0
          : this.geoReferenced
              ? 1
              : 0,
    };
  }

  Cliente.fromJsonMap(jsonItem) {
    this.userId = jsonItem[DatabaseHelper.userIdCliente]; //
    this.domicilioID = jsonItem[DatabaseHelper.clienteDomicilioID]; //
    this.clientId = jsonItem[DatabaseHelper.cliID]; //
    this.codigoGestion = jsonItem[DatabaseHelper.codigoGestion]; //
    this.tipoCuitID = jsonItem[DatabaseHelper.tipoCuitID]; //
    this.cuit = jsonItem[DatabaseHelper.cuit]; //
    this.formaPago = jsonItem[DatabaseHelper.formaPago]; //
    this.razonSocial = jsonItem[DatabaseHelper.razonSocial]; //
    this.nombre = jsonItem[DatabaseHelper.nombre]; //
    this.domicilio = jsonItem[DatabaseHelper.domicilio]; //
    this.ciudad = jsonItem[DatabaseHelper.ciudad]; //
    this.telefono = jsonItem[DatabaseHelper.telefono]; //
    this.telefonoCel = jsonItem[DatabaseHelper.telefonoCel]; //
    this.descuento = jsonItem[DatabaseHelper.clienteDescuento]; //
    this.saldo = jsonItem[DatabaseHelper.saldo]; //
    this.credito = jsonItem[DatabaseHelper.credito]; //
    this.priceList = jsonItem[DatabaseHelper.listaPrecios]; //
    this.observaciones = jsonItem[DatabaseHelper.clienteObservaciones]; //
    this.latitud = jsonItem[DatabaseHelper.clienteLatitud]; //
    this.longitud = jsonItem[DatabaseHelper.clienteLongitud]; //
    this.email = jsonItem[DatabaseHelper.email]; //
    this.tokenWs = jsonItem['tokenWs'];
    this.reba = jsonItem[DatabaseHelper.reba]; //
    this.priceListAux = jsonItem[DatabaseHelper.priceListAux]; //
    this.id = jsonItem[DatabaseHelper.clienteID]; //
    this.geoReferenced = jsonItem[DatabaseHelper.geoReferenced]; //
  }
}
