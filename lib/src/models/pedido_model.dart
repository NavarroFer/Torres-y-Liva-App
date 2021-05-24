import 'cliente_model.dart';
import 'producto_model.dart';

class ItemPedido {
  int id;
  int cantidad;
  double precio;
  double descuento;
  double precioTotal;
  String observacion;
  String detalle;
  double fraccion;
  double iva;
  int listaPrecios;
  int productoID;
  Producto producto; //no se si va esto, por ahora si
  int pedidoID;

  ItemPedido(
      {this.id,
      this.cantidad,
      this.precio,
      this.descuento,
      this.precioTotal,
      this.observacion,
      this.detalle,
      this.fraccion,
      this.iva,
      this.productoID,
      this.producto,
      this.pedidoID});

  Map toJson() => {
        'itemID': this.id?.toString(),
        'cantidad': this.cantidad?.toString(),
        'fraccion': this.fraccion?.toString(),
        'precio': this.precio?.toString(),
        'descuento': this.descuento?.toString(),
        'precioTotal': this.precioTotal?.toString(),
        'listaPrecios': this.listaPrecios?.toString()
      };

  ItemPedido.fromJsonMap(Map<String, dynamic> json) {
    this.id = int.tryParse(json['itemID']) ?? -1;
    this.cantidad = int.tryParse(json['cantidad']) ?? 0;
    this.fraccion = double.tryParse(json['fraccion']) ?? 0.0;
    this.precio = double.tryParse(json['precio']) ?? 0.0;
    this.descuento = double.tryParse(json['descuento']) ?? 0.0;
    this.precioTotal = double.tryParse(json['precioTotal']) ?? 0.0;
    this.observacion = json['observacion'] ?? '';
    this.detalle = json['detalle'] ?? '';
    this.listaPrecios = int.tryParse(json['listaPrecios']) ?? 0;
    this.pedidoID = int.tryParse(json['pedidoid']) ?? 0;
  }
}

class Pedido {
  int usuarioWebId;
  int id;
  Cliente cliente;
  List<ItemPedido> items;
  double total;
  double neto;
  double iva;
  double descuento;
  DateTime fechaHora;
  String observaciones;
  bool checked = false;

  Pedido(
      {this.id,
      this.cliente,
      this.items,
      this.total,
      this.neto,
      this.iva,
      this.descuento,
      this.fechaHora});

  Map toJson() => {
        'usuarioWebID': this.usuarioWebId?.toString(),
        'clienteID': this.cliente.id?.toString(),
        'domicilioClienteID': this.cliente?.domicilioID?.toString(),
        'domicilioDespacho': this.cliente.domicilio,
        'descuento': this.descuento?.toString(),
        'fechaPedido':
            fechaHora.microsecondsSinceEpoch, // Creo que va en segundos
        'fechaAltaMovil': 0.toString(),
        'observaciones': this.observaciones,
        'listaPrecios': this.cliente?.priceList?.toString(),
        'telefonoContacto': this.cliente?.telefonoCel?.toString(),
        'itemsPedidos': this.items.map((e) => e.toJson()).toList()
      };

  Pedido.fromJsonMap(Map<String, dynamic> json) {}
}
