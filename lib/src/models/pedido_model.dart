import 'cliente_model.dart';
import 'producto_model.dart';

class ItemPedido {
  int id;
  double cantidad;
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

  bool checked = false;

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
        'detalle': this.detalle?.toString(),
        'listaPrecios': this.listaPrecios?.toString()
      };

  ItemPedido.fromJsonMap(Map<String, dynamic> json) {
    this.id = (json['itemID']) ?? -1;
    this.cantidad = (json['cantidad']) ?? 0;
    this.fraccion = (json['fraccion']) ?? 0.0;
    this.precio = (json['precio']) ?? 0.0;
    this.descuento = (json['descuento']) ?? 0.0;
    this.precioTotal = (json['precioTotal']) ?? 0.0;
    this.observacion = json['observacion'] ?? '';
    this.detalle = json['detalle'] ?? '';
    this.listaPrecios = (json['listaPrecios']) ?? 0;
    this.pedidoID = (json['pedidoid']) ?? 0;
  }
}

class Pedidos {
  static List<Pedido> pedidos;

  Pedidos.fromJsonList(List<dynamic> jsonList) {
    pedidos = [];

    jsonList.forEach((jsonItem) {
      final pedido = new Pedido.fromJsonMap(jsonItem);
      pedidos?.add(pedido);
    });
  }
}

class Pedido {
  int id;
  int usuarioWebId;
  int clienteID;
  int domicilioClienteID;
  int operadorID;
  Cliente cliente;
  List<ItemPedido> items;
  double total;
  double neto;
  double iva;
  double descuento;
  DateTime fechaPedido;
  String observaciones;
  bool checked = false;
  String domicilioDespacho;
  String latitud;
  String longitud;
  String fechaGps;
  String accuracyGps;
  String providerGps;
  int listaPrecios;
  double totalPedido;
  bool enviado;

  List<ItemPedido> itemsFromJsonList(List<dynamic> jsonList) {
    List<ItemPedido> itemsPedido = [];

    jsonList.forEach((jsonItem) {
      final itemPedido = new ItemPedido.fromJsonMap(jsonItem);
      itemsPedido?.add(itemPedido);
    });

    return itemsPedido;
  }

  Pedido(
      {this.id,
      this.cliente,
      this.items,
      this.total,
      this.neto,
      this.iva,
      this.descuento,
      this.fechaPedido,
      this.checked = false,
      this.clienteID,
      this.domicilioClienteID,
      this.observaciones,
      this.operadorID,
      this.usuarioWebId,
      this.domicilioDespacho,
      this.accuracyGps,
      this.enviado,
      this.fechaGps,
      this.latitud,
      this.longitud,
      this.listaPrecios,
      this.providerGps,
      this.totalPedido});

  Map toJson() => {
        'usuarioWebID': this.usuarioWebId?.toString(),
        'clienteID': this.cliente.id?.toString(),
        'domicilioClienteID': this.cliente?.domicilioID?.toString(),
        'domicilioDespacho': this.cliente.domicilio,
        'descuento': this.descuento?.toString(),
        'fechaPedido':
            fechaPedido.microsecondsSinceEpoch, // Creo que va en segundos
        'fechaAltaMovil': 0.toString(),
        'observaciones': this.observaciones,
        'listaPrecios': this.cliente?.priceList?.toString(),
        'telefonoContacto': this.cliente?.telefonoCel?.toString(),
        'itemsPedidos': this.items.map((e) => e.toJson()).toList()
      };

  Pedido.fromJsonMap(Map<String, dynamic> json) {
    this.id = int.tryParse(json['primaryKey']) ?? -1;
    this.usuarioWebId = int.tryParse(json['usuarioWebID']) ?? -1;
    this.clienteID = int.tryParse(json['clienteID']) ?? -1;
    this.domicilioClienteID = int.tryParse(json['domicilioClienteID']) ?? -1;
    this.operadorID = int.tryParse(json['operadorID']) ?? -1;
    this.domicilioDespacho = json['domicilioDespacho'];
    this.descuento = double.tryParse(json['descuento']) ?? 0.0;
    this.fechaPedido = json['fechaPedido'];
    //fechaAltaMovil ??
    this.items = itemsFromJsonList(json['itemsPedidos']);
    this.observaciones = json['observacion'];
    this.latitud = json['latitud'];
    this.longitud = json['longitud'];
    this.fechaGps = json['fechaGps'];
    this.accuracyGps = json['accuracyGps'];
    this.providerGps = json['providerGps'];
    this.listaPrecios = int.tryParse(json['listaPrecios']) ?? 1;
    this.totalPedido = double.tryParse(json['totalPedido']) ?? 0.0;
    this.enviado = json['enviado'];
  }
}
