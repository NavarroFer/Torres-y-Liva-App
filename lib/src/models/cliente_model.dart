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
  int id; //clienteID
  int code; //usuarioWebID
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

  Cliente({this.id, this.nombre, this.domicilio, this.telefono, this.email});

  Cliente.fromJsonMap(jsonItem) {
    this.id = int.tryParse(jsonItem['clienteID']) ?? -1;
    this.domicilioID = int.tryParse(jsonItem['domicilioClienteID']) ?? -1;
    this.code = int.tryParse(jsonItem['clienteID']) ?? -1;
    this.priceList = int.tryParse(jsonItem['listaPrecios']) ?? -1;
    this.nombre = jsonItem['nombre'];
    this.domicilio = jsonItem['domicilio'];
    this.telefono = jsonItem['telefono'];
    this.telefonoCel = jsonItem['telefonoCel'];
    this.email = jsonItem['email'];
    this.cuit = jsonItem['cuit'];
    this.ciudad = jsonItem['localidad'];
    this.formaPago = jsonItem['formaPago'];
  }
}
