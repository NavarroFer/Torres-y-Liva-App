import 'package:torres_y_liva/src/utils/database_helper.dart';

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

  @override
  String toString() {
    return "ItemID: ${this.id} - Detalle: ${this.detalle}";
  }

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
        'itemID': this.id ?? 0,
        'cantidad': this.cantidad ?? 0,
        'fraccion': this.fraccion ?? 0,
        'precio': this.precio ?? 0,
        'descuento': this.descuento ?? 0,
        'precioTotal': this.precioTotal ?? 0,
        // 'detalle': this.detalle ?? '',
        'listaPrecios': this.listaPrecios ?? 1
      };

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.idItemPedido: this.id ?? 0,
      DatabaseHelper.cantidadItemPedido: this.cantidad ?? 0.0,
      DatabaseHelper.precioItemPedido: this.precio ?? 0.0,
      DatabaseHelper.descuentoItemPedido: this.descuento ?? 0.0,
      DatabaseHelper.precioTotalItemPedido: this.precioTotal ?? 0.0,
      DatabaseHelper.obsItemPedido: this.observacion ?? '',
      DatabaseHelper.detalleItemPedido: this.detalle ?? '',
      DatabaseHelper.fraccionItemPedido: this.fraccion ?? 0.0,
      DatabaseHelper.ivaItemPedido: this.iva ?? 0.0,
      DatabaseHelper.listaPreciosItemPedido: this.listaPrecios ?? 0.0,
      DatabaseHelper.productoIDItemPedido:
          this.producto?.id ?? this.productoID ?? 0,
      DatabaseHelper.pedidoIDItemPedido: this.pedidoID ?? 0,
    };
  }

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

  static List<Pedido> fromJson(List<dynamic> jsonList) {
    List<Pedido> lista = [];

    jsonList.forEach((jsonItem) {
      final pedido = new Pedido.fromJsonMap(jsonItem);
      lista?.add(pedido);
    });

    return lista;
  }
}

class Pedido {
  static const ESTADO_SIN_ENVIAR = 0;
  static const ESTADO_ENVIADO = 1;
  static const ESTADO_COTIZADO = 2;
  int estado = ESTADO_SIN_ENVIAR;
  int id;
  int usuarioWebId;
  int clienteID;
  int domicilioClienteID;
  int operadorID;
  Cliente cliente;
  List<ItemPedido> items = List<ItemPedido>.empty(growable: true);
  double totalPedido;
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
  bool enviado;
  int idFormaPago;

  List<ItemPedido> itemsFromJsonList(List<dynamic> jsonList) {
    List<ItemPedido> itemsPedido = [];

    jsonList.forEach((jsonItem) {
      final itemPedido = new ItemPedido.fromJsonMap(jsonItem);
      itemsPedido?.add(itemPedido);
    });

    return itemsPedido;
  }

  String getFormaPago() {
    if (this.idFormaPago != null) {
      switch (this.idFormaPago) {
        case 0:
          return 'Contado';
          break;
        case 1:
          return 'Cuenta corriente';
          break;
        case 2:
          return 'Cheque';
          break;
        default:
          return 'Otro';
      }
    } else
      return 'Otro';
  }

  Pedido copyWith({Pedido pedido}) {
    return Pedido(
        accuracyGps: pedido.accuracyGps,
        checked: false,
        cliente: pedido.cliente,
        clienteID: pedido.clienteID,
        descuento: pedido.descuento,
        domicilioClienteID: pedido.domicilioClienteID,
        domicilioDespacho: pedido.domicilioDespacho,
        enviado: pedido.enviado,
        fechaGps: pedido.fechaGps,
        fechaPedido: pedido.fechaPedido,
        id: 1, //get last id,
        items: pedido.items,
        iva: pedido.iva,
        latitud: pedido.latitud,
        listaPrecios: pedido.listaPrecios,
        longitud: pedido.longitud,
        neto: pedido.neto,
        observaciones: pedido.observaciones,
        operadorID: pedido.operadorID,
        providerGps: pedido.providerGps,
        totalPedido: pedido.totalPedido,
        usuarioWebId: pedido.usuarioWebId);
  }

  @override
  String toString() {
    return "ID: ${this.id?.toString()} - CLIENTE: ${this.cliente?.nombre} - ITEMS: ${this.items.asMap()}";
  }

  Pedido(
      {this.id,
      this.cliente,
      this.items,
      this.neto,
      this.iva,
      this.descuento,
      this.fechaPedido,
      this.checked,
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
        'usuarioWebID': this.usuarioWebId ?? 0,
        'clienteID': this.cliente.id ?? 0,
        'domicilioClienteID': this.cliente?.domicilioID ?? 0,
        'domicilioDespacho': this.cliente.domicilio ?? '',
        'descuento': this.descuento ?? 0,
        'fechaPedido':
            fechaPedido.microsecondsSinceEpoch ?? 0, // Creo que va en segundos
        'fechaAltaMovil': 0,
        'observaciones': this.observaciones ?? '',
        'listaPrecios': this.cliente?.priceList ?? 1,
        'telefonoContacto': this.cliente?.telefonoCel ?? '',
        'itemsPedidos': this.items.map((e) => e.toJson()).toList()
      };

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.idPedido: this.id ?? 0,
      DatabaseHelper.estado: this.estado ?? 0,
      DatabaseHelper.usuarioWebId: this.usuarioWebId ?? 0,
      DatabaseHelper.clienteID: this.cliente?.id ?? this.clienteID ?? 0,
      DatabaseHelper.domicilioClienteID: this.domicilioClienteID ?? 0,
      DatabaseHelper.operadorID: this.operadorID ?? 0,
      DatabaseHelper.totalPedido: this.totalPedido ?? 0.0,
      DatabaseHelper.netoPedido: this.neto ?? 0.0,
      DatabaseHelper.ivaPedido: this.iva ?? 0.0,
      DatabaseHelper.descuentoPedido: this.descuento ?? 0.0,
      DatabaseHelper.fechaPedido: this.fechaPedido ?? 0,
      DatabaseHelper.obsPedido: this.observaciones ?? '',
      DatabaseHelper.domicilioDespacho: this.domicilioDespacho ?? '',
      DatabaseHelper.latitudPedido: this.latitud ?? '',
      DatabaseHelper.longitudPedido: this.longitud ?? '',
      DatabaseHelper.fechaGps: this.fechaGps ?? 0,
      DatabaseHelper.accuracyGps: this.accuracyGps ?? '',
      DatabaseHelper.providerGps: this.providerGps ?? '',
      DatabaseHelper.listaPrecios: this.listaPrecios ?? 0,
      DatabaseHelper.idFormaPago: this.idFormaPago,
    };
  }

  Pedido.fromJsonMap(Map<String, dynamic> json) {
    this.id = int.tryParse(json[DatabaseHelper.idPedido]) ?? -1;
    this.usuarioWebId =
        int.tryParse(json[DatabaseHelper.usuarioWebId]) ?? -1; //
    this.clienteID =
        int.tryParse(json[DatabaseHelper.clienteIDPedido]) ?? -1; //
    this.domicilioClienteID =
        int.tryParse(json[DatabaseHelper.domicilioClienteID]) ?? -1; //
    this.operadorID = int.tryParse(json[DatabaseHelper.operadorID]) ?? -1; //
    this.domicilioDespacho = json[DatabaseHelper.domicilioDespacho]; //
    this.descuento =
        double.tryParse(json[DatabaseHelper.descuentoPedido]) ?? 0.0; //
    this.fechaPedido = json[DatabaseHelper.fechaPedido]; //
    //fechaAltaMovil ??
    this.items = itemsFromJsonList(json['itemsPedidos']);
    this.observaciones = json[DatabaseHelper.obsPedido]; //
    this.latitud = json[DatabaseHelper.latitudPedido]; //
    this.longitud = json[DatabaseHelper.longitudPedido]; //
    this.fechaGps = json[DatabaseHelper.fechaGps]; //
    this.accuracyGps = json[DatabaseHelper.accuracyGps]; //
    this.providerGps = json[DatabaseHelper.providerGps]; //
    this.listaPrecios = int.tryParse(json[DatabaseHelper.listaPrecios]) ?? 1; //
    this.totalPedido =
        double.tryParse(json[DatabaseHelper.totalPedido]) ?? 0.0; //
    this.enviado = json['enviado'] ?? false;
  }

  Future<bool> insertOrUpdate() async {
    if (this.items.length > 0) {
      final dbHelper = DatabaseHelper.instance;
      final existe = await dbHelper.exists(
          DatabaseHelper.tablePedidos, this.id, DatabaseHelper.idPedido);
      if (existe) {
        await dbHelper.update(
            this.toMap(), DatabaseHelper.tablePedidos, DatabaseHelper.idPedido);
      } else {
        await dbHelper.insert(this.toMap(), DatabaseHelper.tablePedidos);
      }

      //borrar items

      await dbHelper.delete(DatabaseHelper.tableItemsPedido,
          id: this.id, nombreColumnId: DatabaseHelper.pedidoIDItemPedido);

      //poner nuevos

      this.items.forEach((element) async {
        await dbHelper.insert(element.toMap(), DatabaseHelper.tableItemsPedido);
      });
      return true;
    } else {
      return false;
    }
  }

  static Future<int> getNextId() async {
    final dbHelper = DatabaseHelper.instance;

    return await dbHelper.getLastID(
          DatabaseHelper.tablePedidos, DatabaseHelper.idPedido, DatabaseHelper.fechaPedido) + 1;

  }
}
