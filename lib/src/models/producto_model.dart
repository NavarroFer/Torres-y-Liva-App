import 'package:torres_y_liva/src/utils/database_helper.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/utils/string_helper.dart';

class Productos {
  static List<Producto> productos = [];

  Productos.fromJsonList(List<dynamic> jsonList) {
    productos = [];

    productosCargados = false;

    jsonList?.forEach((jsonItem) async {
      final producto = new Producto.fromJsonMap(jsonItem);
      productos?.add(producto);
    });

    productosCargados = true;
  }

  static List<Producto> fromJson(List<dynamic> jsonList) {
    List<Producto> lista = [];

    jsonList.forEach((jsonItem) {
      final producto = new Producto.fromJsonMap(jsonItem);
      lista?.add(producto);
    });

    return lista;
  }

  static List<Producto> getSuggestions(String input) {
    List<Producto> prod = [];

    productos.forEach((element) {
      if (element.descripcion.toUpperCase().contains(input.toUpperCase())) {
        prod.add(element);
      }
    });
    return prod;
  }

  static Future<List<Producto>> getSuggesttionsDB(String input) async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> list;
    list = await dbHelper.queryRows(
        DatabaseHelper.tableProductos, DatabaseHelper.descripcion, input,
        descLike: input);
    final listObject = Productos.fromJson(list);

    return listObject;
  }
}

class Producto {
  int id; //
  String code; //
  String categoriaID;
  String descripcion = ''; //
  double stock; //
  double precio = 0; //
  double priceL2; //
  double priceL3; //
  double priceL4; //
  double priceL5; //
  double priceL6; //
  double priceL7; //
  double priceL8; //
  double priceL9; //
  double priceL10; //
  double descuento; //
  double cantidadPack;
  bool ventaFraccionada;
  bool bloqueado;
  String imagenURL;
  bool noPermiteRemito;
  double iva;
  bool disabled;
  int proveedorID;
  String proveedorNombre;
  int marcaID;
  String marcaNombre;
  int presentacion;
  String observacionVentas;
  DateTime fechaUltimaCompraProducto;
  DateTime fechaModificadoProducto;
  int listaPreciosDefault;

  List<String> barCodes;
  bool checked = false;

  Producto(
      {this.id,
      this.precio,
      this.categoriaID,
      this.barCodes,
      this.code,
      this.descripcion,
      this.disabled,
      this.descuento,
      this.iva,
      this.fechaUltimaCompraProducto,
      this.fechaModificadoProducto,
      this.priceL10,
      this.priceL2,
      this.priceL3,
      this.priceL4,
      this.priceL5,
      this.priceL6,
      this.priceL7,
      this.priceL8,
      this.priceL9,
      this.stock,
      this.cantidadPack,
      this.ventaFraccionada,
      this.bloqueado,
      this.imagenURL,
      this.noPermiteRemito});

  String getInfoFormatted() {
    int listaPrecios = 0;

    if (idCliente != null) {
      listaPrecios = clientesDelVendedor
          ?.firstWhere((element) => element.clientId == idCliente)
          ?.priceList;
    }
    return "COD: ${this.id} - STK: ${this.stock} - S/IVA: \$ ${this.getPriceFromList(listaPrecios)}";
  }

  Future<int> insertOrUpdate() async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.insert(this.toMap(), DatabaseHelper.tableProductos);
    return 1;
  }

  double getPriceFromList(int clientPriceList) {
    double priceClient;

    switch (clientPriceList) {
      case 2:
        priceClient = priceL2;
        break;
      case 3:
        priceClient = priceL3;
        break;
      case 4:
        priceClient = priceL4;
        break;
      case 5:
        priceClient = priceL5;
        break;
      case 6:
        priceClient = priceL6;
        break;
      case 7:
        priceClient = priceL7;
        break;
      case 8:
        priceClient = priceL8;
        break;
      case 9:
        priceClient = priceL9;
        break;
      case 10:
        priceClient = priceL10;
        break;
      default:
        priceClient = precio;
        break;
    }
    return priceClient;
  }

  double getPriceForClient(
      double generalDiscount, double price, bool includeIva, double iva) {
    double priceClient = price - (price * generalDiscount / 100);
    priceClient = priceClient + (includeIva ? priceClient * iva : 0);
    return priceClient;
  }

  Map<String, dynamic> toMap() {
    var fechaUltCompraString = '';
    var fechaUltModString = '';

    fechaUltCompraString = toDBString(this.fechaUltimaCompraProducto);
    fechaUltModString = toDBString(this.fechaModificadoProducto);

    return {
      DatabaseHelper.idProducto: this.id,
      DatabaseHelper.code: this.code ?? '',
      DatabaseHelper.categoriaID: this.categoriaID ?? '',
      DatabaseHelper.descripcion: this.descripcion ?? '',
      DatabaseHelper.stock: this.stock ?? 0.0,
      DatabaseHelper.precio: this.precio ?? 0.0,
      DatabaseHelper.priceL2: this.priceL2 ?? 0.0,
      DatabaseHelper.priceL3: this.priceL3 ?? 0.0,
      DatabaseHelper.priceL4: this.priceL4 ?? 0.0,
      DatabaseHelper.priceL5: this.priceL5 ?? 0.0,
      DatabaseHelper.priceL6: this.priceL6 ?? 0.0,
      DatabaseHelper.priceL7: this.priceL7 ?? 0.0,
      DatabaseHelper.priceL8: this.priceL8 ?? 0.0,
      DatabaseHelper.priceL9: this.priceL9 ?? 0.0,
      DatabaseHelper.priceL10: this.priceL10 ?? 0.0,
      DatabaseHelper.descuento: this.descuento ?? 0.0,
      DatabaseHelper.cantidadPack: this.cantidadPack ?? 0.0,
      DatabaseHelper.ventaFraccionada: this.ventaFraccionada == null
          ? 0
          : this.ventaFraccionada
              ? 1
              : 0,
      DatabaseHelper.bloqueado: this.bloqueado == null
          ? 0
          : this.bloqueado
              ? 1
              : 0,
      DatabaseHelper.imagenURL: this.imagenURL ?? '',
      DatabaseHelper.noPermiteRemito: this.noPermiteRemito == null
          ? 0
          : this.noPermiteRemito
              ? 1
              : 0,
      DatabaseHelper.iva: this.iva ?? 0.0,
      DatabaseHelper.disabled: this.disabled == null
          ? 0
          : this.disabled
              ? 1
              : 0,
      DatabaseHelper.proveedorID: this.proveedorID ?? 0,
      DatabaseHelper.proveedorNombre: this.proveedorNombre ?? '',
      DatabaseHelper.marcaID: this.marcaID ?? 0,
      DatabaseHelper.marcaNombre: this.marcaNombre ?? '',
      DatabaseHelper.presentacion: this.presentacion ?? 0,
      DatabaseHelper.observacionVentas: this.observacionVentas ?? '',
      DatabaseHelper.fechaUltimaCompraProducto: fechaUltCompraString,
      DatabaseHelper.fechaModificadoProducto: fechaUltModString,
      DatabaseHelper.listaPreciosDefault: this.listaPreciosDefault ?? 0,
    };
  }

  Producto.fromJsonMap(Map<String, dynamic> json) {
    this.id = json[DatabaseHelper.idPedido];
    this.code = json[DatabaseHelper.code];
    this.categoriaID = json[DatabaseHelper.categoriaID];
    this.descripcion = json[DatabaseHelper.descripcion];
    this.stock = json[DatabaseHelper.stock];
    this.precio = json[DatabaseHelper.precio];
    this.priceL2 = json[DatabaseHelper.priceL2];
    this.priceL3 = json[DatabaseHelper.priceL3];
    this.priceL4 = json[DatabaseHelper.priceL4];
    this.priceL5 = json[DatabaseHelper.priceL5];
    this.priceL6 = json[DatabaseHelper.priceL6];
    this.priceL7 = json[DatabaseHelper.priceL7];
    this.priceL8 = json[DatabaseHelper.priceL8];
    this.priceL9 = json[DatabaseHelper.priceL9];
    this.priceL10 = json[DatabaseHelper.priceL10];
    this.descuento = json[DatabaseHelper.descuento];
    this.cantidadPack = json[DatabaseHelper.cantidadPack];
    this.ventaFraccionada = json[DatabaseHelper.ventaFraccionada] == 1 ?? false;
    this.bloqueado = json['bloqueado'] == 1 ?? false;
    this.imagenURL = json[DatabaseHelper.imagenURL] ?? '';
    this.noPermiteRemito = json[DatabaseHelper.noPermiteRemito] == 1 ?? false;
    this.iva = json[DatabaseHelper.iva] ?? 0;
    this.proveedorID = json[DatabaseHelper.proveedorID] ?? 0;
    this.proveedorNombre = json[DatabaseHelper.proveedorNombre] ?? '';
    this.marcaID = json[DatabaseHelper.marcaID] ?? 0;
    this.marcaNombre = json[DatabaseHelper.marcaNombre] ?? '';

    var pres = json[DatabaseHelper.presentacion];
    var presRes;
    if (pres is int) {
      presRes = pres;
    } else if (pres is String) {
      presRes = int.tryParse(json[DatabaseHelper.presentacion] ?? "0") ?? 0;
    } else {
      presRes = 0;
    }
    this.presentacion = presRes;
    this.observacionVentas = json[DatabaseHelper.observacionVentas] ?? '';
    final fechaUltCompra = json[DatabaseHelper.fechaUltimaCompraProducto];
    if (fechaUltCompra != null && fechaUltCompra.toString().trim() != '') {
      DateTime fechaUltCompraDate;
      if (fechaUltCompra.toString().contains('-')) {
        //viene del ws formato 2021-06-22
        fechaUltCompraDate = dateTimeFromWSString(fechaUltCompra);
      } else {
        //viene de la db formato 20210622
        fechaUltCompraDate = datetimeFromDBString(fechaUltCompra.toString());
      }
      this.fechaUltimaCompraProducto = fechaUltCompraDate;
    } else {
      this.fechaUltimaCompraProducto = null;
    }

    var fechaUlttModMicrosec = json[DatabaseHelper.fechaModificadoProducto];
    DateTime fechaUltModDate;

    if (fechaUlttModMicrosec is int) {
      fechaUltModDate =
          DateTime.fromMicrosecondsSinceEpoch(fechaUlttModMicrosec * 1000);
      this.fechaModificadoProducto = fechaUltModDate;
    } else if (fechaUlttModMicrosec is String &&
        fechaUlttModMicrosec.trim() != '') {
      fechaUltModDate = datetimeFromDBString(fechaUlttModMicrosec);
      this.fechaModificadoProducto = fechaUltModDate;
    } else {
      this.fechaModificadoProducto = null;
    }
    this.listaPreciosDefault = json[DatabaseHelper.listaPreciosDefault] ?? 0;
  }

  

  DateTime dateTimeFromWSString(fechaUltCompra) {
    final arrFech = fechaUltCompra.toString().split('-') ?? null;

    return DateTime(
        int.parse(arrFech[0]), int.parse(arrFech[1]), int.parse(arrFech[2]));
  }
}
