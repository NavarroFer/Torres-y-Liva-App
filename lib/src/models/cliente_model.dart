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
    return '$nombre $id';
  }

  Cliente.fromJsonMap(jsonItem) {
    this.userId = jsonItem['usuarioWebID'];
    this.domicilioID = jsonItem['domicilioClienteID'];
    this.clientId = jsonItem['clienteID'];
    this.codigoGestion = jsonItem['codigoGestion'];
    this.tipoCuitID = jsonItem['tipoCuitID'];
    this.cuit = jsonItem['cuit'];
    this.formaPago = jsonItem['formaPago'];
    this.razonSocial = jsonItem['razonSocial'];
    this.nombre = jsonItem['nombre'];
    this.domicilio = jsonItem['domicilio'];
    this.ciudad = jsonItem['localidad'];
    this.telefono = jsonItem['telefono'];
    this.telefonoCel = jsonItem['telefonoCel'];
    this.descuento = jsonItem['descuento'];
    this.saldo = jsonItem['saldo'];
    this.credito = jsonItem['credito'];
    this.priceList = jsonItem['lista_precios'];
    this.observaciones = jsonItem['observaciones'];
    this.latitud = jsonItem['latitud'];
    this.longitud = jsonItem['longitud'];
    this.email = jsonItem['email'];
    this.tokenWs = jsonItem['tokenWs'];
    this.reba = jsonItem['reba'];
    this.priceListAux = jsonItem['listaPrecios'];
    this.id = jsonItem['primaryKey'];
    this.geoReferenced = jsonItem['geoReferenciado'];
  }
}
