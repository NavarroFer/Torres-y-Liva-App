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
  int code;
  int domicilioID;
  String nombre;
  String ciudad;
  String cuit;
  String email;
  String domicilio;
  String telefono;
  String telefonoCel;
  String fechaUltimaCompra;
  int priceList;
  int sellerCode;
  String formaPago;

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
